# AlgoTeach

**Free, pattern-based algorithm learning for CS students preparing for tech interviews.**

Most platforms hide deep conceptual learning behind paywalls. AlgoTeach is fully open — built around the idea that you should learn *how to think* in patterns, not memorize puzzle solutions.

---

## What it does

- **Pattern-first roadmap** — problems are grouped by recognizable algorithm patterns (Sliding Window, Two Pointers, BFS/DFS, Dynamic Programming, and more). Complete all problems in a pattern to unlock the next.
- **AI interviewer feedback** — submit your code and get Socratic hints from an AI persona modeled after a top-company interviewer. It will never give you the answer or paste code — only guide you toward the right intuition.
- **Conceptual MCQs** — after each problem, short quizzes test time/space complexity and edge cases before you advance.
- **Progress tracking** — your completed problems sync to your account across sessions.

---

## Tech stack

| Layer | Technology |
|---|---|
| Framework | Next.js 16 (App Router) · React 19 |
| Language | TypeScript |
| Styling | Tailwind CSS v4 |
| Database & Auth | Supabase (Postgres + SSR auth) |
| Code editor | Monaco Editor (`@monaco-editor/react`) |
| AI feedback | Google Gemini (`gemini-3.1-flash-lite` via `@google/genai`) |
| Layout | Allotment (resizable split panes) |

---

## Getting started

### Prerequisites

- Node.js 18+
- A [Supabase](https://supabase.com) project
- A [Google AI Studio](https://aistudio.google.com) API key

### 1. Clone and install

```bash
git clone https://github.com/kevinjli21/algoteach.git
cd algoteach
npm install
```

### 2. Environment variables

Create a `.env.local` file at the project root:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
GEMINI_API_KEY=your_google_ai_studio_key
```

### 3. Database schema

In your Supabase SQL editor, create the following tables:

```sql
-- Curriculum
create table patterns (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  order_index int not null,
  prerequisite_pattern_id uuid references patterns(id)
);

create table problems (
  id uuid primary key default gen_random_uuid(),
  pattern_id uuid references patterns(id),
  slug text unique not null,
  title text not null,
  difficulty text not null check (difficulty in ('easy', 'medium', 'hard')),
  importance_context text,
  problem_statement text not null,
  expected_pattern_approach text,
  starter_code jsonb,
  order_index int not null
);

create table mcqs (
  id uuid primary key default gen_random_uuid(),
  problem_id uuid references problems(id),
  question text not null,
  options jsonb not null,
  correct_option_index int not null,
  explanation text
);

-- Progress
create table user_progress (
  user_id uuid references auth.users(id),
  problem_id uuid references problems(id),
  code_passed boolean default false,
  completed_at timestamptz,
  primary key (user_id, problem_id)
);
```

### 4. Run locally

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

---

## How the AI interviewer works

When a user submits code, the `/api/check-solution` route:

1. Authenticates the user via Supabase session.
2. Fetches the problem's expected approach from the database.
3. Sends the code + problem context to Gemini with strict system instructions — the model is constrained to give a clear verdict, highlight what's correct, and raise at most one Socratic question. It cannot output code or reveal the solution.
4. If the response starts with `"This solution is correct"`, the user's progress is upserted in `user_progress` and the next pattern unlocks automatically.

---

## Project structure

```
app/
  page.tsx                    # Landing page
  login/                      # Supabase OAuth login
  problems/
    page.tsx                  # Roadmap data fetching (server component)
    RoadmapClient.tsx         # Interactive roadmap UI
    [slug]/
      page.tsx                # Problem data fetching (server component)
      WorkspaceClient.tsx     # Split-pane editor + MCQ UI
      AllotmentLayout.tsx     # Resizable pane wrapper
  api/
    check-solution/route.ts   # AI feedback endpoint
    complete-problem/route.ts # Manual mark-as-done endpoint
  auth/callback/route.ts      # Supabase OAuth callback
```

---

## Built with Claude Code

This project was built end-to-end using [Claude Code](https://claude.ai/code) — Anthropic's agentic CLI for software engineering. The workflow demonstrated here includes:

- Scaffolding and iterating on a full-stack Next.js app from a high-level spec
- Designing a Supabase schema and writing server-side data-fetching logic in server components
- Wiring up an AI evaluation pipeline with carefully scoped behavioral guardrails
- Building interactive UI (roadmap with unlock gates, Monaco editor, MCQ flow) with real-time progress state

If you want to see how Claude Code handles a real fullstack project — from database schema to React components to API routes — this repo is a practical end-to-end reference.

---

## License

MIT — free forever, use it however you'd like.
