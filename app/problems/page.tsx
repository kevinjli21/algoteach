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
  problems: CurriculumProblem[];
};

type RawRow = {
  id: string;
  name: string;
  slug: string;
  order_index: number;
  problems: CurriculumProblem[] | null;
};

export default async function ProblemsPage() {
  const supabase = createServerClient();

  const { data } = await supabase
    .from('patterns')
    .select('id, name, slug, order_index, problems(id, slug, title, difficulty)')
    .order('order_index');

  const patterns: CurriculumPattern[] = ((data ?? []) as unknown as RawRow[]).map((p) => ({
    id: p.id,
    name: p.name,
    slug: p.slug,
    order_index: p.order_index,
    problems: p.problems ?? [],
  }));

  return <RoadmapClient patterns={patterns} />;
}
