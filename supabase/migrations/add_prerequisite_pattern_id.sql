-- Add self-referencing prerequisite link to patterns.
-- A NULL value means this is a root node (no prerequisite).
-- ON DELETE SET NULL so removing a pattern does not cascade-delete its dependents.

ALTER TABLE public.patterns
  ADD COLUMN IF NOT EXISTS prerequisite_pattern_id UUID
    REFERENCES public.patterns (id)
    ON DELETE SET NULL;
