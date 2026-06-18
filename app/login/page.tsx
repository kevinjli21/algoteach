import { redirect } from 'next/navigation';
import { createServerClient } from '@/lib/supabase/server';
import LoginButton from './LoginButton';

export default async function LoginPage() {
  const supabase = await createServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (user) {
    redirect('/problems');
  }

  return (
    <div className="min-h-screen bg-[#0d1117] text-[#e6edf3] flex flex-col">
      {/* Header */}
      <header className="h-11 flex items-center px-5 border-b border-[#30363d] bg-[#161b22] flex-shrink-0">
        <span className="text-sm font-bold text-[#58a6ff] tracking-wide">ALGOTEACH</span>
      </header>

      {/* Main */}
      <main className="flex-1 flex items-center justify-center px-4">
        <div className="w-full max-w-sm">
          <div className="bg-[#161b22] border border-[#30363d] rounded-xl p-8 shadow-2xl">
            {/* Icon */}
            <div className="flex justify-center mb-6">
              <div className="w-12 h-12 rounded-xl bg-[#1f6feb] flex items-center justify-center">
                <svg
                  className="w-6 h-6 text-white"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  strokeWidth={2}
                  aria-hidden="true"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                  />
                </svg>
              </div>
            </div>

            <h1 className="text-center text-xl font-bold text-[#e6edf3] mb-1.5">
              Welcome to AlgoTeach
            </h1>
            <p className="text-center text-sm text-[#8b949e] leading-relaxed mb-8">
              Sign in to track your progress through algorithmic patterns and unlock the full
              curriculum.
            </p>

            <div className="flex justify-center">
              <LoginButton />
            </div>

            <p className="text-center text-xs text-[#484f58] mt-6">
              Free forever. No credit card required.
            </p>
          </div>
        </div>
      </main>
    </div>
  );
}
