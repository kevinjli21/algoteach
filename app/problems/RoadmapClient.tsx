'use client';

import Link from 'next/link';
import type { CurriculumPattern, CurriculumProblem } from './page';
import LogoutButton from '@/components/LogoutButton';
import { useUserProgress } from '@/hooks/useUserProgress';

const DIFFICULTY_STYLE: Record<string, string> = {
  easy: 'text-[#3fb950] bg-[#0d2318] border-[#238636]',
  medium: 'text-[#e3b341] bg-[#2d2009] border-[#9e6a03]',
  hard: 'text-[#f85149] bg-[#2d0f0e] border-[#b62324]',
};

function CheckIcon() {
  return (
    <svg className="w-4 h-4 text-[#3fb950]" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
    </svg>
  );
}

function LockIcon({ className }: { className: string }) {
  return (
    <svg className={className} fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
    </svg>
  );
}

function Connector({ height }: { height: number }) {
  return (
    <svg
      width="2"
      height={height}
      xmlns="http://www.w3.org/2000/svg"
      className="flex-shrink-0"
      aria-hidden="true"
    >
      <line x1="1" y1="0" x2="1" y2={height} stroke="#30363d" strokeWidth="2" />
    </svg>
  );
}

export default function RoadmapClient({
  patterns,
  completedSlugs,
}: {
  patterns: CurriculumPattern[];
  completedSlugs: string[];
}) {
  const { completeProblem, uncompleteProblem, isProblemCompleted, mounted } =
    useUserProgress(completedSlugs);

  const sections = patterns.map((pattern) => ({
    ...pattern,
    nodes: pattern.problems as CurriculumProblem[],
  }));

  const patternById = new Map(sections.map((s) => [s.id, s]));

  function isPatternUnlocked(patternId: string): boolean {
    const pattern = patternById.get(patternId);
    if (!pattern) return false;
    if (!pattern.prerequisite_pattern_id) return true;
    const prereq = patternById.get(pattern.prerequisite_pattern_id);
    if (!prereq) return true;
    return prereq.nodes.every((node) => isProblemCompleted(node.slug));
  }

  const allNodes = sections.flatMap((s) => s.nodes);
  const totalProblems = allNodes.length;
  const completedCount = mounted ? allNodes.filter((n) => isProblemCompleted(n.slug)).length : 0;
  const progressPct = totalProblems > 0 ? (completedCount / totalProblems) * 100 : 0;

  function toggle(slug: string) {
    if (isProblemCompleted(slug)) {
      uncompleteProblem(slug);
    } else {
      completeProblem(slug);
    }
  }

  return (
    <div className="min-h-screen bg-[#0d1117] text-[#e6edf3] flex flex-col">
      {/* Header */}
      <header className="h-11 flex items-center px-5 border-b border-[#30363d] bg-[#161b22] flex-shrink-0 gap-2">
        <Link
          href="/"
          className="text-sm font-bold text-[#58a6ff] tracking-wide hover:text-[#79c0ff] transition-colors"
        >
          ALGOTEACH
        </Link>
        <span className="text-[#484f58] text-xs select-none">/</span>
        <span className="text-xs text-[#8b949e]">Learning Roadmap</span>
        <LogoutButton />
      </header>

      <main className="flex-1 overflow-y-auto">
        <div className="max-w-2xl mx-auto py-12 px-4">
          {/* Page heading + progress */}
          <div className="mb-10">
            <h1 className="text-xl font-bold text-[#e6edf3] mb-1.5">Learning Roadmap</h1>
            <p className="text-sm text-[#8b949e] leading-relaxed">
              Master algorithmic patterns from the ground up. Complete all problems in a pattern to unlock the next.
            </p>
            {mounted && totalProblems > 0 && (
              <div className="mt-5">
                <div className="flex items-center justify-between mb-1.5">
                  <span className="text-xs text-[#8b949e]">Overall progress</span>
                  <span className="text-xs font-semibold text-[#58a6ff]">
                    {completedCount} / {totalProblems} completed
                  </span>
                </div>
                <div className="h-1.5 bg-[#21262d] rounded-full overflow-hidden">
                  <div
                    className="h-full bg-gradient-to-r from-[#1f6feb] to-[#58a6ff] rounded-full transition-all duration-500"
                    style={{ width: `${progressPct}%` }}
                  />
                </div>
              </div>
            )}
          </div>

          {/* Roadmap */}
          {sections.map((section, sIdx) => {
            const isLastSection = sIdx === sections.length - 1;
            const patternUnlocked = isPatternUnlocked(section.id);
            const sectionCompleted = mounted
              ? section.nodes.filter((n) => isProblemCompleted(n.slug)).length
              : 0;

            // Find the prerequisite pattern name for the locked message
            const prereqPattern = section.prerequisite_pattern_id
              ? patternById.get(section.prerequisite_pattern_id)
              : null;

            return (
              <div key={section.id}>
                {/* Pattern section header */}
                <div className="flex items-center gap-3 mb-2">
                  <div
                    className={`flex items-center justify-center w-8 h-8 rounded-full flex-shrink-0 ${
                      patternUnlocked ? 'bg-[#1f6feb]' : 'bg-[#21262d]'
                    }`}
                  >
                    {patternUnlocked ? (
                      <svg className="w-4 h-4 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                        <path strokeLinecap="round" strokeLinejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                      </svg>
                    ) : (
                      <LockIcon className="w-4 h-4 text-[#484f58]" />
                    )}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="text-[10px] font-bold text-[#484f58] uppercase tracking-widest mb-0.5">
                      Pattern {sIdx + 1}
                    </div>
                    <div className={`text-sm font-bold truncate ${patternUnlocked ? 'text-[#58a6ff]' : 'text-[#484f58]'}`}>
                      {section.name}
                    </div>
                  </div>
                  {mounted && patternUnlocked && (
                    <span className="flex-shrink-0 text-xs text-[#8b949e] tabular-nums">
                      {sectionCompleted}/{section.nodes.length}
                    </span>
                  )}
                  {!patternUnlocked && prereqPattern && (
                    <span className="flex-shrink-0 text-[10px] text-[#484f58] bg-[#161b22] border border-[#30363d] px-2 py-0.5 rounded-full">
                      Locked
                    </span>
                  )}
                </div>

                {/* SVG connector from pattern header to first problem */}
                <div className="flex">
                  <div className="flex justify-center w-8 flex-shrink-0">
                    <Connector height={24} />
                  </div>
                </div>

                {/* Problem nodes */}
                {section.nodes.map((node, nIdx) => {
                  const isLastNode = nIdx === section.nodes.length - 1;
                  const isLastOverall = isLastSection && isLastNode;
                  const isDone = mounted && isProblemCompleted(node.slug);

                  return (
                    <div key={node.slug}>
                      <div className="flex gap-4">
                        {/* Left track: status dot + connector */}
                        <div className="flex flex-col items-center w-8 flex-shrink-0">
                          <div
                            className={`w-8 h-8 rounded-full border-2 flex items-center justify-center flex-shrink-0 transition-all duration-300 ${
                              isDone
                                ? 'border-[#3fb950] bg-[#0d2318]'
                                : patternUnlocked
                                ? 'border-[#1f6feb] bg-[#0c1e38]'
                                : 'border-[#30363d] bg-[#161b22]'
                            }`}
                          >
                            {isDone ? (
                              <CheckIcon />
                            ) : !patternUnlocked ? (
                              <LockIcon className="w-3.5 h-3.5 text-[#484f58]" />
                            ) : (
                              <div className="w-2 h-2 rounded-full bg-[#1f6feb]" />
                            )}
                          </div>
                          {!isLastOverall && (
                            <Connector height={isLastNode ? 32 : 60} />
                          )}
                        </div>

                        {/* Problem card */}
                        <div className="flex-1 mb-3">
                          <div
                            className={`rounded-lg border transition-all duration-200 ${
                              isDone
                                ? 'border-[#238636] bg-[#0d1f14]'
                                : patternUnlocked
                                ? 'border-[#30363d] bg-[#161b22] hover:border-[#58a6ff]/40'
                                : 'border-[#21262d] bg-[#0d1117] opacity-40 pointer-events-none select-none'
                            }`}
                          >
                            <div className="px-4 py-3.5 flex items-center gap-3">
                              <div className="flex-1 min-w-0">
                                <div className="flex items-center gap-2 flex-wrap">
                                  {patternUnlocked ? (
                                    <Link
                                      href={`/problems/${node.slug}`}
                                      className={`text-sm font-semibold hover:underline underline-offset-2 ${
                                        isDone ? 'text-[#3fb950]' : 'text-[#e6edf3]'
                                      }`}
                                    >
                                      {node.title}
                                    </Link>
                                  ) : (
                                    <span className="text-sm font-semibold text-[#484f58] flex items-center gap-1.5">
                                      <LockIcon className="w-3.5 h-3.5" />
                                      {node.title}
                                    </span>
                                  )}
                                  <span
                                    className={`text-[10px] font-bold px-2 py-0.5 rounded-full border uppercase tracking-wide flex-shrink-0 ${
                                      DIFFICULTY_STYLE[node.difficulty] ?? DIFFICULTY_STYLE.easy
                                    }`}
                                  >
                                    {node.difficulty}
                                  </span>
                                </div>
                                {!patternUnlocked && prereqPattern && (
                                  <p className="text-xs text-[#484f58] mt-1">
                                    Complete {prereqPattern.name} to unlock this section
                                  </p>
                                )}
                              </div>

                              {mounted && patternUnlocked && (
                                <button
                                  onClick={() => toggle(node.slug)}
                                  className={`flex-shrink-0 text-xs font-medium px-2.5 py-1 rounded-md border transition-colors ${
                                    isDone
                                      ? 'border-[#238636] text-[#3fb950] bg-[#0d2318] hover:bg-[#1a3a20]'
                                      : 'border-[#30363d] text-[#8b949e] hover:border-[#58a6ff] hover:text-[#c9d1d9]'
                                  }`}
                                >
                                  {isDone ? '✓ Done' : 'Mark done'}
                                </button>
                              )}
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            );
          })}

          {patterns.length === 0 && (
            <div className="text-center py-20 text-[#484f58] text-sm">
              No curriculum content yet. Check back soon.
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
