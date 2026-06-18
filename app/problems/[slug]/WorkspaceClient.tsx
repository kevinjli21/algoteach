'use client';

import { useState } from 'react';
import dynamic from 'next/dynamic';
import Link from 'next/link';
import LogoutButton from '@/components/LogoutButton';

const AllotmentLayout = dynamic(() => import('./AllotmentLayout'), {
  ssr: false,
  loading: () => <div className="h-full bg-[#0d1117]" />,
});

const MonacoEditor = dynamic(() => import('@monaco-editor/react'), {
  ssr: false,
  loading: () => <div className="flex-1 bg-[#1e1e1e]" />,
});

// ─── Types ────────────────────────────────────────────────────────────────────

export type MCQOption = {
  text: string;
  isCorrect: boolean;
  explanation: string;
};

export type MCQ = {
  question: string;
  options: MCQOption[];
};

export type Problem = {
  slug: string;
  title: string;
  pattern: string;
  difficulty: 'Easy' | 'Medium' | 'Hard';
  concept_text: string;
  problem_text: string;
  starter_code: { python: string; javascript: string; java: string; cpp: string };
  mcqs: MCQ[];
};

type Language = 'python' | 'javascript' | 'java' | 'cpp';

// ─── Minimal Markdown Renderer ────────────────────────────────────────────────

function inline(text: string): React.ReactNode {
  const parts = text.split(/(\*\*[^*]+\*\*|`[^`]+`)/);
  return parts.map((part, i) => {
    if (part.startsWith('**') && part.endsWith('**')) {
      return (
        <strong key={i} className="text-[#e6edf3] font-semibold">
          {part.slice(2, -2)}
        </strong>
      );
    }
    if (part.startsWith('`') && part.endsWith('`') && part.length > 2) {
      return (
        <code
          key={i}
          className="bg-[#161b22] text-[#79c0ff] text-[0.85em] px-1.5 py-0.5 rounded font-mono"
        >
          {part.slice(1, -1)}
        </code>
      );
    }
    return part;
  });
}

function renderMarkdown(source: string): React.ReactNode {
  const lines = source.trim().replace(/\\n/g, '\n').split('\n');
  const output: React.ReactNode[] = [];
  let i = 0;
  let key = 0;

  while (i < lines.length) {
    const line = lines[i];

    if (line.startsWith('```')) {
      const codeLines: string[] = [];
      i++;
      while (i < lines.length && !lines[i].startsWith('```')) {
        codeLines.push(lines[i]);
        i++;
      }
      output.push(
        <pre
          key={key++}
          className="bg-[#161b22] border border-[#30363d] rounded-md p-4 text-sm text-[#e6edf3] font-mono overflow-x-auto my-5 leading-6"
        >
          <code>{codeLines.join('\n')}</code>
        </pre>
      );
      i++;
      continue;
    }

    if (line.trim() === '---') {
      output.push(
        <hr key={key++} className="border-[#30363d] my-5" />
      );
      i++;
      continue;
    }

    if (line.startsWith('## ')) {
      output.push(
        <h2
          key={key++}
          className="text-base font-bold text-[#58a6ff] mt-8 mb-3"
        >
          {inline(line.slice(3))}
        </h2>
      );
      i++;
      continue;
    }

    if (line.startsWith('- ')) {
      const items: React.ReactNode[] = [];
      while (i < lines.length && lines[i].startsWith('- ')) {
        items.push(
          <li key={items.length} className="text-[15px] text-[#c9d1d9] leading-7">
            {inline(lines[i].slice(2))}
          </li>
        );
        i++;
      }
      output.push(
        <ul key={key++} className="list-disc list-inside space-y-1.5 my-3 ml-1">
          {items}
        </ul>
      );
      continue;
    }

    if (line.trim() === '') {
      i++;
      continue;
    }

    const paraLines: string[] = [];
    while (
      i < lines.length &&
      lines[i].trim() !== '' &&
      !lines[i].startsWith('## ') &&
      !lines[i].startsWith('- ') &&
      !lines[i].startsWith('```')
    ) {
      paraLines.push(lines[i]);
      i++;
    }
    output.push(
      <p key={key++} className="text-[15px] text-[#c9d1d9] leading-7 my-4">
        {inline(paraLines.join(' '))}
      </p>
    );
  }

  return <>{output}</>;
}

// ─── Sub-components ───────────────────────────────────────────────────────────

function TabBar({
  tabs,
  active,
  onChange,
}: {
  tabs: { id: string; label: string }[];
  active: string;
  onChange: (id: string) => void;
}) {
  return (
    <div className="flex border-b border-[#30363d] bg-[#161b22] flex-shrink-0 overflow-x-auto">
      {tabs.map((tab) => (
        <button
          key={tab.id}
          onClick={() => onChange(tab.id)}
          className={`px-4 py-2.5 text-xs font-medium transition-colors whitespace-nowrap ${
            active === tab.id
              ? 'text-[#e6edf3] border-b-2 border-[#58a6ff] -mb-px bg-[#0d1117]'
              : 'text-[#8b949e] hover:text-[#c9d1d9] hover:bg-[#21262d]'
          }`}
        >
          {tab.label}
        </button>
      ))}
    </div>
  );
}

function EditorPane({
  language,
  code,
  onLanguageChange,
  onCodeChange,
  onSubmit,
  isSubmitting,
}: {
  language: Language;
  code: string;
  onLanguageChange: (lang: Language) => void;
  onCodeChange: (code: string) => void;
  onSubmit: () => void;
  isSubmitting: boolean;
}) {
  return (
    <div className="flex-1 flex flex-col overflow-hidden">
      {/* Toolbar */}
      <div className="px-4 py-2 border-b border-[#30363d] flex items-center gap-3 flex-shrink-0 bg-[#0d1117]">
        <span className="text-xs text-[#484f58] select-none">Language</span>
        <select
          value={language}
          onChange={(e) => onLanguageChange(e.target.value as Language)}
          className="bg-[#21262d] border border-[#30363d] text-[#c9d1d9] text-xs rounded px-2.5 py-1 focus:outline-none focus:border-[#58a6ff] cursor-pointer"
        >
          <option value="python">Python</option>
          <option value="javascript">JavaScript</option>
          <option value="java">Java</option>
          <option value="cpp">C++</option>
        </select>
      </div>

      {/* Code area */}
      <div className="flex-1 overflow-hidden">
        <MonacoEditor
          height="100%"
          language={language === 'cpp' ? 'cpp' : language}
          value={code}
          theme="vs-dark"
          onChange={(value) => onCodeChange(value ?? '')}
          options={{
            minimap: { enabled: false },
            fontSize: 13,
            lineHeight: 22,
            padding: { top: 16, bottom: 16 },
            scrollBeyondLastLine: false,
            fontFamily: 'Consolas, "Courier New", monospace',
            tabSize: 2,
            wordWrap: 'on',
            overviewRulerLanes: 0,
            renderLineHighlight: 'line',
          }}
        />
      </div>

      {/* Submit */}
      <div className="px-4 py-3 border-t border-[#30363d] bg-[#161b22] flex items-center gap-4 flex-shrink-0">
        <button
          onClick={onSubmit}
          disabled={isSubmitting}
          className="bg-[#1f6feb] hover:bg-[#388bfd] active:bg-[#1158c7] disabled:opacity-50 disabled:cursor-not-allowed text-white text-sm font-semibold px-5 py-2 rounded-md transition-colors focus:outline-none focus:ring-2 focus:ring-[#58a6ff] focus:ring-offset-2 focus:ring-offset-[#161b22]"
        >
          {isSubmitting ? 'Analyzing Code...' : 'Submit Solution'}
        </button>
        <span className="text-xs text-[#484f58]">Reviewed by the AI Interviewer</span>
      </div>
    </div>
  );
}

function QuizQuestion({
  mcq,
  qIdx,
  selectedIdx,
  onSelect,
}: {
  mcq: MCQ;
  qIdx: number;
  selectedIdx: number | undefined;
  onSelect: (oIdx: number) => void;
}) {
  const answered = selectedIdx !== undefined;

  return (
    <div className="bg-[#161b22] border border-[#30363d] rounded-lg p-5">
      <div className="flex items-start gap-3 mb-4">
        <span className="flex-shrink-0 w-6 h-6 rounded-full bg-[#21262d] text-[#8b949e] text-[11px] flex items-center justify-center font-bold mt-px">
          {qIdx + 1}
        </span>
        <p className="text-sm text-[#e6edf3] leading-relaxed">{mcq.question}</p>
      </div>

      <div className="space-y-2 ml-9">
        {mcq.options.map((option, oIdx) => {
          let rowCls =
            'rounded-md p-3 text-sm border transition-colors flex items-start gap-2.5 ';
          let badge = '';

          if (!answered) {
            rowCls +=
              'border-[#30363d] bg-[#0d1117] text-[#8b949e] hover:border-[#58a6ff] hover:text-[#c9d1d9] cursor-pointer';
          } else if (oIdx === selectedIdx) {
            if (option.isCorrect) {
              rowCls += 'border-[#3fb950] bg-[#0d2318] text-[#56d364]';
              badge = '✓';
            } else {
              rowCls += 'border-[#f85149] bg-[#2d0f0e] text-[#ff7b72]';
              badge = '✗';
            }
          } else if (option.isCorrect) {
            rowCls += 'border-[#3fb950] bg-[#0d2318] text-[#56d364]';
            badge = '✓';
          } else {
            rowCls += 'border-[#21262d] bg-[#0d1117] text-[#484f58] opacity-50';
          }

          return (
            <div
              key={oIdx}
              role={answered ? undefined : 'button'}
              tabIndex={answered ? undefined : 0}
              onClick={() => !answered && onSelect(oIdx)}
              onKeyDown={(e) => {
                if (!answered && (e.key === 'Enter' || e.key === ' ')) {
                  e.preventDefault();
                  onSelect(oIdx);
                }
              }}
              className={rowCls}
            >
              <span className="flex-shrink-0 w-5 h-5 rounded-full border border-current flex items-center justify-center text-[10px] font-bold mt-px">
                {String.fromCharCode(65 + oIdx)}
              </span>
              <span className="flex-1 leading-relaxed">{option.text}</span>
              {badge && (
                <span className="flex-shrink-0 font-bold text-base leading-none ml-1">
                  {badge}
                </span>
              )}
            </div>
          );
        })}
      </div>

      {answered && (
        <div
          className={`mt-4 ml-9 p-3 rounded-md text-xs leading-relaxed whitespace-pre-wrap ${
            mcq.options[selectedIdx].isCorrect
              ? 'bg-[#0d2318] border border-[#3fb950] text-[#56d364]'
              : 'bg-[#2d0f0e] border border-[#f85149] text-[#ff7b72]'
          }`}
        >
          <span className="font-semibold">
            {mcq.options[selectedIdx].isCorrect ? 'Correct! ' : 'Not quite. '}
          </span>
          {mcq.options[selectedIdx].explanation.replace(/\\n/g, '\n')}
        </div>
      )}
    </div>
  );
}

function FeedbackPanel({
  feedback,
  isSubmitting,
  justSolved,
}: {
  feedback: string | null;
  isSubmitting: boolean;
  justSolved: boolean;
}) {
  return (
    <div className="flex-shrink-0 border-t-2 border-[#1f6feb] bg-[#0d1117]">
      <div className="px-5 pt-3 pb-1 flex items-center gap-2">
        <span className="text-[11px] font-bold text-[#58a6ff] uppercase tracking-widest">
          AI Interviewer
        </span>
      </div>
      <div className="px-5 pt-1 pb-5 max-h-[220px] overflow-y-auto">
        {isSubmitting ? (
          <p className="text-[15px] text-[#58a6ff] animate-pulse leading-7">Analyzing your code...</p>
        ) : (
          <>
            {justSolved && (
              <div className="mb-3 flex items-center gap-2 px-3 py-2 rounded-md bg-[#0d2318] border border-[#3fb950]">
                <svg className="w-4 h-4 text-[#3fb950] flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                </svg>
                <span className="text-sm font-semibold text-[#3fb950]">Problem solved! Progress saved.</span>
              </div>
            )}
            {feedback ? (
              <p className="text-[15px] text-[#e6edf3] leading-7 whitespace-pre-wrap">{feedback}</p>
            ) : (
              <p className="text-[15px] text-[#484f58] leading-7">
                Submit your solution for a conceptual review from the AI Interviewer.
              </p>
            )}
          </>
        )}
      </div>
    </div>
  );
}

// ─── Main Component ───────────────────────────────────────────────────────────

export default function WorkspaceClient({
  problem,
  alreadySolved,
}: {
  problem: Problem;
  alreadySolved: boolean;
}) {
  const [conceptExpanded, setConceptExpanded] = useState(false);
  const [rightTab, setRightTab] = useState<'editor' | 'quiz'>('quiz');
  const [language, setLanguage] = useState<Language>('python');
  const [code, setCode] = useState(problem.starter_code.python);
  const [quizAnswers, setQuizAnswers] = useState<Record<number, number>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [interviewerFeedback, setInterviewerFeedback] = useState<string | null>(null);
  const [justSolved, setJustSolved] = useState(false);

  const allMcqsAnswered =
    problem.mcqs.length > 0 && problem.mcqs.every((_, i) => quizAnswers[i] !== undefined);

  function handleLanguageChange(lang: Language) {
    setLanguage(lang);
    setCode(problem.starter_code[lang]);
  }

  function handleOptionSelect(qIdx: number, oIdx: number) {
    if (quizAnswers[qIdx] !== undefined) return;
    setQuizAnswers((prev) => ({ ...prev, [qIdx]: oIdx }));
  }

  async function handleSubmit() {
    setIsSubmitting(true);
    try {
      const mcqScore = Object.entries(quizAnswers).filter(([qIdxStr, oIdx]) => {
        const qIdx = Number(qIdxStr);
        return problem.mcqs[qIdx]?.options[oIdx]?.isCorrect === true;
      }).length;

      const res = await fetch('/api/check-solution', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          problemSlug: problem.slug,
          language,
          userCode: code,
          currentMcqScore: mcqScore,
        }),
      });

      const data = await res.json() as { feedback?: string; error?: string; isCorrect?: boolean };
      setInterviewerFeedback(data.feedback ?? data.error ?? 'Something went wrong. Please try again.');
      if (data.isCorrect) {
        setJustSolved(true);
        fetch('/api/complete-problem', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ problemSlug: problem.slug }),
        }).catch(() => {});
      }
    } catch {
      setInterviewerFeedback('Network error. Please check your connection and try again.');
    } finally {
      setIsSubmitting(false);
    }
  }

  const difficultyColors: Record<Problem['difficulty'], string> = {
    Easy: 'text-[#3fb950] bg-[#0d2318]',
    Medium: 'text-[#e3b341] bg-[#2d2009]',
    Hard: 'text-[#f85149] bg-[#2d0f0e]',
  };

  const leftPane = (
    <div className="h-full flex flex-col bg-[#0d1117]">
      <div className="flex-1 overflow-y-auto">
        {/* Collapsible pattern insight */}
        <div className="mx-5 mt-5 mb-1 rounded-lg border border-[#1f6feb] bg-[#0c1e38] overflow-hidden">
          <button
            onClick={() => setConceptExpanded((e) => !e)}
            className="w-full px-5 py-4 flex items-center justify-between gap-3 hover:bg-[#0f2647] transition-colors group"
          >
            <div className="flex items-center gap-3">
              <svg className="w-4 h-4 text-[#58a6ff] flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
              </svg>
              <div className="text-left">
                <span className="block text-sm font-bold text-[#58a6ff]">Pattern Insight</span>
                <span className="block text-xs text-[#79c0ff] mt-0.5">{problem.pattern} — why this pattern, and when to spot it</span>
              </div>
            </div>
            <svg
              className={`w-4 h-4 text-[#58a6ff] flex-shrink-0 transition-transform duration-200 ${conceptExpanded ? 'rotate-180' : ''}`}
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth={2}
            >
              <path strokeLinecap="round" strokeLinejoin="round" d="M19 9l-7 7-7-7" />
            </svg>
          </button>
          {conceptExpanded && (
            <div className="px-5 pb-6 pt-1 border-t border-[#1f6feb]/40">
              {renderMarkdown(problem.concept_text)}
            </div>
          )}
        </div>

        {/* Pattern tag */}
        <div className="px-5 pt-3 pb-1 flex flex-wrap gap-2">
          <span className="inline-flex items-center gap-1.5 text-xs font-medium text-[#79c0ff] bg-[#0c1e38] border border-[#1f6feb]/50 px-3 py-1 rounded-full">
            <svg className="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M7 20l4-16m2 16l4-16M6 9h14M4 15h14" />
            </svg>
            {problem.pattern}
          </span>
        </div>

        {/* Problem statement */}
        <div className="px-6 py-5">
          {renderMarkdown(problem.problem_text)}
        </div>
      </div>
    </div>
  );

  const rightPane = (
    <div className="h-full flex flex-col bg-[#0d1117]">
      <TabBar
        tabs={[
          { id: 'quiz', label: 'Concept Check' },
          { id: 'editor', label: 'Code Editor' },
        ]}
        active={rightTab}
        onChange={(id) => setRightTab(id as 'editor' | 'quiz')}
      />
      {rightTab === 'quiz' ? (
        <div className="flex-1 overflow-y-auto p-4 space-y-4">
          {problem.mcqs.map((mcq, qIdx) => (
            <QuizQuestion
              key={qIdx}
              mcq={mcq}
              qIdx={qIdx}
              selectedIdx={quizAnswers[qIdx]}
              onSelect={(oIdx) => handleOptionSelect(qIdx, oIdx)}
            />
          ))}
          {allMcqsAnswered && (
            <div className="pt-2 pb-4">
              <button
                onClick={() => setRightTab('editor')}
                className="w-full bg-[#1f6feb] hover:bg-[#388bfd] text-white text-sm font-semibold py-3 rounded-md transition-colors flex items-center justify-center gap-2"
              >
                Continue to Code Editor
                <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                </svg>
              </button>
            </div>
          )}
        </div>
      ) : (
        <div className="flex-1 flex flex-col overflow-hidden">
          <EditorPane
            language={language}
            code={code}
            onLanguageChange={handleLanguageChange}
            onCodeChange={setCode}
            onSubmit={handleSubmit}
            isSubmitting={isSubmitting}
          />
          <FeedbackPanel feedback={interviewerFeedback} isSubmitting={isSubmitting} justSolved={justSolved} />
        </div>
      )}
    </div>
  );

  return (
    <div className="fixed inset-0 flex flex-col bg-[#0d1117] text-[#e6edf3]">
      {/* Header */}
      <header className="h-11 flex items-center px-5 border-b border-[#30363d] bg-[#161b22] flex-shrink-0 gap-3">
        <Link
          href="/problems"
          className="flex items-center gap-1.5 text-sm font-bold text-[#58a6ff] hover:text-[#79c0ff] transition-colors tracking-wide flex-shrink-0"
        >
          ALGOTEACH
        </Link>
        <span className="text-[#30363d] select-none">/</span>
        <span className="text-xs text-[#8b949e] flex-shrink-0">{problem.pattern}</span>
        <span className="text-[#30363d] select-none">·</span>
        <h1 className="text-sm font-semibold text-[#e6edf3] truncate">{problem.title}</h1>
        <span
          className={`text-xs font-semibold px-2.5 py-0.5 rounded-full flex-shrink-0 ${difficultyColors[problem.difficulty]}`}
        >
          {problem.difficulty}
        </span>
        {(alreadySolved || justSolved) && (
          <span className="flex items-center gap-1 text-xs font-semibold px-2.5 py-0.5 rounded-full text-[#3fb950] bg-[#0d2318] border border-[#238636] flex-shrink-0">
            <svg className="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
            </svg>
            Solved
          </span>
        )}
        <LogoutButton />
      </header>

      {/* Split workspace */}
      <div className="flex-1 min-h-0">
        <AllotmentLayout leftPane={leftPane} rightPane={rightPane} />
      </div>
    </div>
  );
}
