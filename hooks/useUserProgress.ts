'use client';

import { useState, useEffect, useCallback } from 'react';

export function useUserProgress(initialSlugs: string[] = []) {
  const [completedSlugs, setCompletedSlugs] = useState<string[]>(initialSlugs);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  const completeProblem = useCallback((slug: string) => {
    setCompletedSlugs((prev) => {
      if (prev.includes(slug)) return prev;
      return [...prev, slug];
    });
    fetch('/api/complete-problem', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ problemSlug: slug }),
    }).catch(() => {
      // Optimistic update stays; silent network failure is acceptable
    });
  }, []);

  const uncompleteProblem = useCallback((slug: string) => {
    setCompletedSlugs((prev) => prev.filter((s) => s !== slug));
    fetch('/api/complete-problem', {
      method: 'DELETE',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ problemSlug: slug }),
    }).catch(() => {});
  }, []);

  const isProblemCompleted = useCallback(
    (slug: string) => completedSlugs.includes(slug),
    [completedSlugs]
  );

  return { completedSlugs, completeProblem, uncompleteProblem, isProblemCompleted, mounted };
}
