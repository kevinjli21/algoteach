-- ============================================================
-- Algo-Patterns-Hub: Supabase Database Schema
-- ============================================================

-- ============================================================
-- PROFILES
-- Mirrors auth.users; auto-populated by trigger on signup.
-- ============================================================

create table if not exists public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  username    text,
  created_at  timestamptz not null default now()
);

-- Trigger function: create a profile row whenever a user signs up.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'username', split_part(new.email, '@', 1))
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- ============================================================
-- PATTERNS
-- Top-level curriculum nodes (e.g. "Sliding Window", "BFS").
-- ============================================================

create table if not exists public.patterns (
  id           uuid primary key default gen_random_uuid(),
  name         text        not null,
  slug         text        not null unique,
  description  text,
  order_index  integer     not null default 0
);


-- ============================================================
-- PROBLEMS
-- One or more problems per pattern; drives the lesson flow.
-- ============================================================

create table if not exists public.problems (
  id                        uuid primary key default gen_random_uuid(),
  pattern_id                uuid not null references public.patterns (id) on delete cascade,
  title                     text not null,
  slug                      text not null unique,
  difficulty                text not null check (difficulty in ('easy', 'medium', 'hard')),
  -- Why the pattern matters; shown before the problem to frame thinking.
  importance_context        text,
  problem_statement         text not null,
  -- e.g. {"python": "def solve(...):\n    pass", "javascript": "function solve(...) {}"}
  starter_code              jsonb not null default '{}',
  -- Describes the correct pattern approach; used by the AI agent to validate submissions.
  expected_pattern_approach text
);


-- ============================================================
-- MCQS
-- Conceptual multiple-choice questions attached to a problem.
-- ============================================================

create table if not exists public.mcqs (
  id                   uuid primary key default gen_random_uuid(),
  problem_id           uuid not null references public.problems (id) on delete cascade,
  question             text not null,
  -- e.g. ["O(n)", "O(n log n)", "O(n²)", "O(1)"]
  options              jsonb not null default '[]',
  correct_option_index integer not null,
  explanation          text
);


-- ============================================================
-- USER_PROGRESS
-- Tracks each user's submission and quiz state per problem.
-- ============================================================

create table if not exists public.user_progress (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references public.profiles (id) on delete cascade,
  problem_id      uuid not null references public.problems (id) on delete cascade,
  code_submission text,
  code_passed     boolean not null default false,
  quiz_passed     boolean not null default false,
  updated_at      timestamptz not null default now(),
  unique (user_id, problem_id)
);

-- Keep updated_at current on every write.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_user_progress_updated_at on public.user_progress;
create trigger set_user_progress_updated_at
  before update on public.user_progress
  for each row execute procedure public.set_updated_at();


-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

-- Curriculum tables: readable by everyone (including anon), immutable by users.
alter table public.patterns      enable row level security;
alter table public.problems      enable row level security;
alter table public.mcqs          enable row level security;

create policy "Anyone can read patterns"
  on public.patterns for select using (true);

create policy "Anyone can read problems"
  on public.problems for select using (true);

create policy "Anyone can read mcqs"
  on public.mcqs for select using (true);

-- Profiles: users can read any profile but only update their own.
alter table public.profiles enable row level security;

create policy "Profiles are publicly readable"
  on public.profiles for select using (true);

create policy "Users can update their own profile"
  on public.profiles for update using (auth.uid() = id);

-- User progress: strictly scoped to the owning user.
alter table public.user_progress enable row level security;

create policy "Users can read their own progress"
  on public.user_progress for select using (auth.uid() = user_id);

create policy "Users can insert their own progress"
  on public.user_progress for insert with check (auth.uid() = user_id);

create policy "Users can update their own progress"
  on public.user_progress for update using (auth.uid() = user_id);
