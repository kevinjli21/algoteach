import { redirect } from 'next/navigation';
import { createServerClient } from '@/lib/supabase/server';
import RoadmapClient from './RoadmapClient';

export type CurriculumProblem = {
  id: string;
  slug: string;
  title: string;
  difficulty: string;
};

export type CurriculumPattern = {
  id: string;
  name: string;
  slug: string;
  order_index: number;
  prerequisite_pattern_id: string | null;
  problems: CurriculumProblem[];
};

type RawRow = {
  id: string;
  name: string;
  slug: string;
  order_index: number;
  prerequisite_pattern_id: string | null;
  problems: CurriculumProblem[] | null;
};

type ProgressRow = {
  problem_id: string;
};

export default async function ProblemsPage() {
  const supabase = await createServerClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect('/login');
  }

  const [{ data: patternsData }, { data: progressData }] = await Promise.all([
    supabase
      .from('patterns')
      .select('id, name, slug, order_index, prerequisite_pattern_id, problems(id, slug, title, difficulty)')
      .order('order_index'),
    supabase
      .from('user_progress')
      .select('problem_id')
      .eq('user_id', user.id)
      .not('completed_at', 'is', null),
  ]);

  const patterns: CurriculumPattern[] = ((patternsData ?? []) as unknown as RawRow[]).map((p) => ({
    id: p.id,
    name: p.name,
    slug: p.slug,
    order_index: p.order_index,
    prerequisite_pattern_id: p.prerequisite_pattern_id ?? null,
    problems: p.problems ?? [],
  }));

  const completedProblemIds = new Set(
    ((progressData ?? []) as ProgressRow[]).map((r) => r.problem_id)
  );

  const completedSlugs = patterns
    .flatMap((p) => p.problems)
    .filter((prob) => completedProblemIds.has(prob.id))
    .map((prob) => prob.slug);

  return <RoadmapClient patterns={patterns} completedSlugs={completedSlugs} />;
}
