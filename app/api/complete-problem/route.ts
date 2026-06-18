import { NextRequest } from 'next/server';
import { createServerClient } from '@/lib/supabase/server';

export async function POST(request: NextRequest) {
  const supabase = await createServerClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 });
  }

  let problemSlug: string;
  try {
    const body = await request.json() as { problemSlug?: string };
    if (!body.problemSlug) throw new Error('Missing problemSlug');
    problemSlug = body.problemSlug;
  } catch {
    return Response.json({ error: 'Missing or invalid problemSlug in request body.' }, { status: 400 });
  }

  const { data: problem } = await supabase
    .from('problems')
    .select('id')
    .eq('slug', problemSlug)
    .single();

  if (!problem) {
    return Response.json({ error: 'Problem not found.' }, { status: 404 });
  }

  const { error } = await supabase.from('user_progress').upsert(
    {
      user_id: user.id,
      problem_id: problem.id,
      code_passed: true,
      completed_at: new Date().toISOString(),
    },
    { onConflict: 'user_id,problem_id' }
  );

  if (error) {
    return Response.json({ error: error.message }, { status: 500 });
  }

  return Response.json({ success: true });
}

export async function DELETE(request: NextRequest) {
  const supabase = await createServerClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 });
  }

  let problemSlug: string;
  try {
    const body = await request.json() as { problemSlug?: string };
    if (!body.problemSlug) throw new Error('Missing problemSlug');
    problemSlug = body.problemSlug;
  } catch {
    return Response.json({ error: 'Missing or invalid problemSlug in request body.' }, { status: 400 });
  }

  const { data: problem } = await supabase
    .from('problems')
    .select('id')
    .eq('slug', problemSlug)
    .single();

  if (!problem) {
    return Response.json({ error: 'Problem not found.' }, { status: 404 });
  }

  const { error } = await supabase
    .from('user_progress')
    .update({ code_passed: false, completed_at: null })
    .eq('user_id', user.id)
    .eq('problem_id', problem.id);

  if (error) {
    return Response.json({ error: error.message }, { status: 500 });
  }

  return Response.json({ success: true });
}
