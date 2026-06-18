import { notFound, redirect } from 'next/navigation';
import { createServerClient } from '@/lib/supabase/server';
import WorkspaceClient, { type Problem } from './WorkspaceClient';

export default async function ProblemPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const supabase = await createServerClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect('/login');
  }

  const { data, error } = await supabase
    .from('problems')
    .select(`
      id,
      slug,
      title,
      difficulty,
      importance_context,
      problem_statement,
      starter_code,
      patterns ( name ),
      mcqs ( question, options, correct_option_index, explanation )
    `)
    .eq('slug', slug)
    .single();

  if (error || !data) {
    notFound();
  }

  const { data: progress } = await supabase
    .from('user_progress')
    .select('completed_at')
    .eq('user_id', user.id)
    .eq('problem_id', data.id)
    .maybeSingle();

  const alreadySolved = progress?.completed_at != null;

  const patternData = data.patterns as { name: string } | { name: string }[] | null;
  const pattern = Array.isArray(patternData)
    ? (patternData[0]?.name ?? '')
    : (patternData?.name ?? '');

  const difficulty = (
    data.difficulty.charAt(0).toUpperCase() + data.difficulty.slice(1)
  ) as Problem['difficulty'];

  const mcqs: Problem['mcqs'] = (
    data.mcqs as Array<{
      question: string;
      options: string[];
      correct_option_index: number;
      explanation: string | null;
    }>
  ).map((row) => ({
    question: row.question,
    options: (row.options as string[]).map((text, i) => ({
      text,
      isCorrect: i === row.correct_option_index,
      explanation: i === row.correct_option_index ? (row.explanation ?? '') : '',
    })),
  }));

  const problem: Problem = {
    slug: data.slug,
    title: data.title,
    pattern,
    difficulty,
    concept_text: data.importance_context ?? '',
    problem_text: data.problem_statement,
    starter_code: data.starter_code as Problem['starter_code'],
    mcqs,
  };

  return <WorkspaceClient problem={problem} alreadySolved={alreadySolved} />;
}
