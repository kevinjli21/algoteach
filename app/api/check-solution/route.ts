import { GoogleGenAI } from '@google/genai';
import { NextRequest } from 'next/server';

interface CheckSolutionRequest {
  problemSlug: string;
  language: string;
  userCode: string;
  currentMcqScore: number;
}

interface ProblemContext {
  problem_statement: string;
  importance_context: string;
  expected_pattern_approach: string;
}

const PROBLEM_CONTEXTS: Record<string, ProblemContext> = {
  'valid-palindrome': {
    problem_statement:
      'Given a string s, return true if it is a palindrome after converting all uppercase letters to lowercase and removing all non-alphanumeric characters.',
    importance_context:
      'Valid Palindrome is the gateway problem for the Two Pointers pattern. It teaches students to verify a global property (palindrome) locally and incrementally using two synchronized indices — one from each end — rather than allocating a reversed copy. Mastering this builds the spatial intuition needed for harder Two Pointers problems like 3Sum and Container With Most Water.',
    expected_pattern_approach:
      'Two Pointers: initialize left=0 and right=len(s)-1. Use inner while loops to skip non-alphanumeric characters on each side. Compare s[left].lower() to s[right].lower(). If they differ, return false immediately. Otherwise advance both pointers inward. Return true after the outer loop exits. Time O(n), Space O(1). The naive reverse-and-compare approach costs O(n) extra space and is explicitly forbidden as it defeats the learning objective of this module.',
  },
};

const SYSTEM_INSTRUCTIONS = `You are a supportive technical interviewer at a top-tier technology company evaluating a student's code submission.

CRITICAL GUARDRAILS — these override everything else:
1. NEVER output code blocks, inline code snippets, or any code syntax. All feedback must be conversational prose.
2. NEVER restate the user's code back to them.
3. NEVER give away a fix directly — guide with a question if something is wrong.

RESPONSE STRUCTURE — always follow this exact order:

1. VERDICT (one sentence): Start with a clear, unambiguous statement of whether the solution is correct or not. Use "This solution is correct" or "This solution has an issue" — do not hedge or bury the verdict.

2. WHAT THEY DID WELL (one sentence): Briefly confirm the key things they got right.

3. ISSUE (only if one exists): Identify at most ONE meaningful problem — a genuine pattern violation, a missing edge case that would cause a wrong answer, or a significant complexity issue. Raise a single Socratic question to nudge them toward the fix. Do not nitpick style, variable naming, or micro-optimizations on an otherwise correct solution.

WHAT COUNTS AS CORRECT: A solution is correct if it uses two pointers advancing inward (not string reversal or a cleaned copy), handles non-alphanumeric skipping on both sides, normalizes case before comparing, and returns the right answer for all inputs including empty and single-character strings. Inner while loops that guard with the same outer condition (e.g. left < right) to skip non-alphanumeric characters are correct and complete — do not raise pointer-crossing concerns on such code. If all of these hold, the solution is correct — do not invent issues.

ISSUE VERIFICATION RULE: Before raising any issue, you must mentally trace through the student's code on a specific concrete input and confirm step by step that it produces the wrong output. If you cite an example input, you must have completed that trace and confirmed the wrong result. If you cannot identify such an input where the code actually fails, there is no issue — mark the solution correct and do not speculate about theoretical edge cases.

TONE: Warm and direct. Maximum 3 sentences total.`;

export async function POST(request: NextRequest) {
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    return Response.json(
      { error: 'GEMINI_API_KEY environment variable is not configured.' },
      { status: 500 }
    );
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

  const context = PROBLEM_CONTEXTS[problemSlug] ?? PROBLEM_CONTEXTS['valid-palindrome'];

  const userPrompt = `PROBLEM CONTEXT:
Problem Statement: ${context.problem_statement}
Why This Pattern Matters: ${context.importance_context}
Expected Pattern Approach: ${context.expected_pattern_approach}

STUDENT SUBMISSION:
Language: ${language}
MCQ Score So Far: ${currentMcqScore} / 3

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
    return Response.json({ feedback, isCorrect });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Unknown error from Gemini API.';
    return Response.json({ error: `AI service error: ${message}` }, { status: 502 });
  }
}
