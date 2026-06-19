import { GoogleGenAI } from '@google/genai';
import { createServerClient } from '@/lib/supabase/server';
import { NextRequest } from 'next/server';

interface CheckSolutionRequest {
  problemSlug: string;
  language: string;
  userCode: string;
  currentMcqScore: number;
}

const SYSTEM_INSTRUCTIONS = `You are a supportive technical interviewer at a top-tier technology company evaluating a student's code submission.

CRITICAL GUARDRAILS — these override everything else:
1. NEVER output code blocks, inline code snippets, or any code syntax. All feedback must be conversational prose.
2. NEVER restate the user's code back to them.
3. NEVER give away a fix directly — guide with a question if something is wrong.

RESPONSE STRUCTURE — always follow this exact order:

1. VERDICT (one sentence): Start with a clear, unambiguous statement of whether the solution is correct or not. Use "This solution is correct" or "This solution has an issue" — do not hedge or bury the verdict.

2. WHAT THEY DID WELL (one sentence): Briefly confirm the key things they got right.

3. ISSUE (only if one exists): Identify at most ONE meaningful problem — a genuine pattern violation, a missing edge case that would cause a wrong output, or a significant complexity issue. Raise a single Socratic question to nudge them toward the fix. Do not nitpick style, variable naming, or micro-optimizations on an otherwise correct solution.

CORRECTNESS STANDARD: Use the EXPECTED APPROACH field in the user prompt to determine what a correct solution looks like. Follow the "WHAT COUNTS AS CORRECT" criteria there exactly.

ISSUE VERIFICATION RULE: Before raising any issue, mentally trace through the student's code on a specific concrete input and confirm step by step that it produces the wrong output. If you cannot identify such an input where the code actually fails, there is no issue — mark the solution correct and do not speculate about theoretical edge cases.

TONE: Warm and direct. Maximum 3 sentences total.`;

export async function POST(request: NextRequest) {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    return Response.json(
      { error: 'GEMINI_API_KEY environment variable is not configured.' },
      { status: 500 }
    );
  }

  const supabase = await createServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 });
  }

  let body: CheckSolutionRequest;
  try {
    body = await request.json();
  } catch {
    return Response.json({ error: 'Invalid JSON in request body.' }, { status: 400 });
  }

  const { problemSlug, language, userCode, currentMcqScore } = body;

  if (!problemSlug || !language || !userCode) {
    return Response.json(
      { error: 'Missing required fields: problemSlug, language, userCode.' },
      { status: 400 }
    );
  }

  const { data: problemData, error: dbError } = await supabase
    .from('problems')
    .select('id, problem_statement, importance_context, expected_pattern_approach')
    .eq('slug', problemSlug)
    .single();

  if (dbError || !problemData) {
    return Response.json(
      { error: `Problem "${problemSlug}" not found. Please refresh and try again.` },
      { status: 404 }
    );
  }

  const userPrompt = `PROBLEM CONTEXT:
Problem Statement: ${problemData.problem_statement}
Why This Pattern Matters: ${problemData.importance_context ?? ''}
Expected Approach: ${problemData.expected_pattern_approach ?? ''}

STUDENT SUBMISSION:
Language: ${language}
MCQ Score So Far: ${currentMcqScore}

Code:
${userCode}

Evaluate this submission. Lead with a clear verdict on whether it is correct or not, then follow the response structure in your instructions.`;

  try {
    const ai = new GoogleGenAI({ apiKey });

    const response = await ai.models.generateContent({
      model: 'gemini-3.1-flash-lite',
      contents: userPrompt,
      config: {
        systemInstruction: SYSTEM_INSTRUCTIONS,
        temperature: 0.4,
        thinkingConfig: { thinkingBudget: 1024 },
      },
    });

    const feedback = response.text;

    if (!feedback) {
      return Response.json(
        { error: 'The AI returned an empty response. Please try again.' },
        { status: 502 }
      );
    }

    const isCorrect = feedback.trimStart().startsWith('This solution is correct');

    if (isCorrect) {
      await supabase.from('user_progress').upsert(
        {
          user_id: user.id,
          problem_id: problemData.id,
          code_passed: true,
          completed_at: new Date().toISOString(),
        },
        { onConflict: 'user_id,problem_id' }
      );
    }

    return Response.json({ feedback, isCorrect });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Unknown error from Gemini API.';
    return Response.json({ error: `AI service error: ${message}` }, { status: 502 });
  }
}
