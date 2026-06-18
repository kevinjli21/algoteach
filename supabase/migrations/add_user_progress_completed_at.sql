-- Add completed_at timestamp to user_progress to mark when a problem
-- was successfully verified by the AI reviewer.
ALTER TABLE public.user_progress
  ADD COLUMN IF NOT EXISTS completed_at timestamptz;
