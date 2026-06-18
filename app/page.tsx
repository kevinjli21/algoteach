import Link from 'next/link';
import { createServerClient } from '@/lib/supabase/server';
import LogoutButton from '@/components/LogoutButton';

export default async function Home() {
  const supabase = await createServerClient();
  const { data: { user } } = await supabase.auth.getUser();

  return (
    <div className="min-h-screen bg-[#0d1117] text-[#e6edf3] flex flex-col">
      {/* Header */}
      <header className="h-11 flex items-center px-5 border-b border-[#30363d] bg-[#161b22] flex-shrink-0">
        <span className="text-sm font-bold text-[#58a6ff] tracking-wide">ALGOTEACH</span>
        {user && <LogoutButton />}
      </header>

      {/* Hero */}
      <main className="flex-1 flex flex-col items-center justify-center px-4 text-center">
        <div className="max-w-2xl">
          <div className="inline-flex items-center gap-2 bg-[#161b22] border border-[#30363d] rounded-full px-4 py-1.5 mb-6 text-xs text-[#58a6ff]">
            <span className="w-1.5 h-1.5 rounded-full bg-[#3fb950] inline-block"></span>
            Free forever · No credit card required
          </div>

          <h1 className="text-4xl sm:text-5xl font-bold text-[#e6edf3] leading-tight mb-4">
            Learn algorithms by{' '}
            <span className="text-[#58a6ff]">pattern</span>,<br className="hidden sm:block" /> not by memorization.
          </h1>

          <p className="text-[#8b949e] text-lg leading-relaxed mb-10 max-w-xl mx-auto">
            A free, open curriculum for CS students preparing for tech interviews. Master sliding
            windows, two pointers, graphs, dynamic programming, and more — with AI-guided feedback
            on every submission.
          </p>

          <div className="flex items-center justify-center">
            <Link
              href={user ? '/problems' : '/login'}
              className="inline-flex items-center gap-2 bg-[#1f6feb] hover:bg-[#388bfd] text-white font-semibold px-6 py-3 rounded-lg transition-colors text-sm"
            >
              {user ? 'Go to problems' : 'Get started free'}
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2} aria-hidden="true">
                <path strokeLinecap="round" strokeLinejoin="round" d="M13 7l5 5m0 0l-5 5m5-5H6" />
              </svg>
            </Link>
          </div>
        </div>

        {/* Feature grid */}
        <div className="mt-20 grid grid-cols-1 sm:grid-cols-3 gap-4 max-w-3xl w-full">
          {[
            {
              title: 'Pattern-first learning',
              body: 'Each problem is grouped into a recognizable pattern so you build intuition, not just solutions.',
            },
            {
              title: 'AI interviewer feedback',
              body: 'Submit code and get hints — never answers — from an AI persona modeled after top-company interviewers.',
            },
            {
              title: 'Conceptual MCQs',
              body: 'After each pattern, short quizzes test time/space complexity and edge cases before you move on.',
            },
          ].map((f) => (
            <div
              key={f.title}
              className="bg-[#161b22] border border-[#30363d] rounded-xl p-6 text-left"
            >
              <h2 className="text-sm font-semibold text-[#e6edf3] mb-2">{f.title}</h2>
              <p className="text-xs text-[#8b949e] leading-relaxed">{f.body}</p>
            </div>
          ))}
        </div>
      </main>

      <footer className="py-6 text-center text-xs text-[#484f58] border-t border-[#21262d]">
        AlgoTeach — open &amp; free for everyone
      </footer>
    </div>
  );
}
