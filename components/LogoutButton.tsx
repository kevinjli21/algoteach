'use client';

import { createBrowserSupabaseClient } from '@/lib/supabase/client';
import { useRouter } from 'next/navigation';

export default function LogoutButton() {
  const router = useRouter();

  async function handleSignOut() {
    const supabase = createBrowserSupabaseClient();
    await supabase.auth.signOut();
    router.push('/');
  }

  return (
    <button
      onClick={handleSignOut}
      className="text-xs text-[#8b949e] hover:text-[#e6edf3] transition-colors ml-auto"
    >
      Sign out
    </button>
  );
}
