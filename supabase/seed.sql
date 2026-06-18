-- ============================================================
-- Algo-Patterns-Hub: Seed Data
-- Run after schema.sql to populate starter curriculum content.
-- All text uses plain ASCII characters (no Unicode escapes).
-- ============================================================


-- ============================================================
-- PATTERN: Two Pointers
-- ============================================================

INSERT INTO public.patterns (name, slug, description, order_index)
VALUES (
  'Two Pointers',
  'two-pointers',
  'The Two Pointers pattern uses two index variables that scan a data structure -- typically an array or string -- from different starting positions, moving toward each other or in tandem. By eliminating the need for a nested loop, it reduces time complexity from O(N^2) to O(N) while using only O(1) extra space. Spot this pattern whenever a problem asks you to find a pair, compare endpoints, or partition elements in a sorted or sortable sequence.',
  1
);


-- ============================================================
-- PROBLEM: Valid Palindrome
-- ============================================================

INSERT INTO public.problems (
  pattern_id,
  title,
  slug,
  difficulty,
  importance_context,
  problem_statement,
  starter_code,
  expected_pattern_approach
)
VALUES (
  (SELECT id FROM public.patterns WHERE slug = 'two-pointers' LIMIT 1),
  'Valid Palindrome',
  'valid-palindrome',
  'easy',
  E'Before you write a single line of code, ask yourself: what is the naive approach?\n\nMost developers instinctively reach for string manipulation - filter out non-alphanumeric characters, lowercase everything, reverse the cleaned string, and compare. It works. But it silently allocates O(N) extra memory for that reversed copy, and that cost compounds when strings are large or when this check lives inside a performance-critical loop.\n\nThis is where Two Pointers shines. Instead of building anything new, you collapse boundaries inward. Place one pointer at the very left edge of the string and another at the very right edge. Walk them toward each other. At every step you are comparing the string against its own mirror image - no copy needed, no reversal computed. Two integer variables are all the extra memory you ever use: O(1) space, O(N) time.\n\nLearning to see "compare from both ends simultaneously" as a reusable pattern - rather than a one-off trick - is what separates engineers who consistently write optimal solutions from those who do not.',
  E'## Valid Palindrome\n\nA phrase is a **palindrome** if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, it reads the same forward and backward. Alphanumeric characters include letters and numbers.\n\nGiven a string `s`, return `true` if it is a palindrome, or `false` otherwise.\n\n---\n\n**Example 1:**\n```\nInput:  s = "A man, a plan, a canal: Panama"\nOutput: true\nExplanation: "amanaplanacanalpanama" is a palindrome.\n```\n\n**Example 2:**\n```\nInput:  s = "race a car"\nOutput: false\nExplanation: "raceacar" is not a palindrome.\n```\n\n**Example 3:**\n```\nInput:  s = " "\nOutput: true\nExplanation: After removing all non-alphanumeric characters the string is empty. An empty string reads the same forward and backward, so it is a palindrome.\n```\n\n---\n\n**Constraints:**\n- `1 <= s.length <= 2 * 10^5`\n- `s` consists only of printable ASCII characters.',
  '{"python": "def isPalindrome(s: str) -> bool:\n    # Your solution here\n    pass", "javascript": "/**\n * @param {string} s\n * @return {boolean}\n */\nvar isPalindrome = function(s) {\n    // Your solution here\n};", "java": "class Solution {\n    public boolean isPalindrome(String s) {\n        // Your solution here\n        return false;\n    }\n}", "cpp": "class Solution {\npublic:\n    bool isPalindrome(string s) {\n        // Your solution here\n        return false;\n    }\n};"}',
  E'The correct approach uses two integer pointers: left initialized to 0 and right initialized to len(s) - 1. A while loop continues as long as left < right.\n\nInside the loop:\n1. While left < right and s[left] is NOT alphanumeric, increment left.\n2. While left < right and s[right] is NOT alphanumeric, decrement right.\n3. Once both pointers rest on alphanumeric characters, compare s[left].lower() to s[right].lower().\n4. If they differ, return False immediately.\n5. If they match, advance both pointers inward (left += 1, right -= 1) and continue.\n\nIf the loop exhausts without a mismatch, return True.\n\nThe solution MUST NOT reverse the string, build a cleaned or filtered copy, or use any data structure whose size scales with the input. Time complexity O(N), space complexity O(1).'
);


-- ============================================================
-- MCQS: Valid Palindrome
-- ============================================================

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
VALUES

-- Q1: Space complexity -- Two Pointers vs. string reversal
(
  (SELECT id FROM public.problems WHERE slug = 'valid-palindrome' LIMIT 1),
  'When checking for a palindrome, a common beginner approach is to reverse the string and compare it to the original. What is the primary space-complexity advantage of the Two Pointers technique over this reversal approach?',
  '["Two Pointers runs in O(N) time while string reversal runs in O(N^2) time, making Two Pointers faster overall.", "Two Pointers uses O(1) extra space, while string reversal requires allocating an O(N) auxiliary string.", "Two Pointers uses O(log N) space because the pointers progressively narrow the search space in half.", "Both approaches use O(1) space because modern language runtimes optimize away unnecessary string copies at compile time."]',
  1,
  E'Two Pointers uses O(1) extra space; string reversal allocates O(N).\n\nReversing a string creates a brand-new string of length N in memory - every character must be copied. This is O(N) auxiliary space, and it shows up in your profiler when strings are large or when this check is called in a tight loop.\n\nThe Two Pointers technique never builds anything new. It only ever needs two integer variables (left and right) to track positions, regardless of how long the input is. That is the textbook definition of O(1) auxiliary space.\n\nThis distinction matters most in memory-constrained environments and is a common follow-up probe in real interviews: "Can you solve this without allocating extra space?"'
),

-- Q2: Handling non-alphanumeric characters
(
  (SELECT id FROM public.problems WHERE slug = 'valid-palindrome' LIMIT 1),
  'While scanning inward with left and right pointers, the left pointer lands on a comma character. What is the correct action?',
  '["Compare the comma to the character at right and advance both pointers inward, since every character must be considered.", "Return false immediately -- encountering punctuation means the string cannot be a palindrome.", "Advance left forward by one position without making a comparison, then re-evaluate the character at the new position.", "Stop the Two Pointers approach, preprocess the entire string to remove all punctuation, and restart from the beginning."]',
  2,
  E'Advance left forward without comparing, then re-evaluate.\n\nThe problem states that non-alphanumeric characters -- spaces, punctuation, symbols -- are to be ignored, not treated as mismatches. The palindrome check applies only to letters and digits.\n\nWhen a pointer lands on a non-alphanumeric character, move it one step in its natural direction (left += 1 or right -= 1) and loop back to check the new character. Perform a comparison only once both pointers are positioned on alphanumeric characters.\n\nReturning false would produce wrong answers on inputs like "A man, a plan, a canal: Panama". Preprocessing and restarting works conceptually but defeats the O(1)-space goal entirely, since you would need an O(N) cleaned copy of the string.'
),

-- Q3: Loop termination condition
(
  (SELECT id FROM public.problems WHERE slug = 'valid-palindrome' LIMIT 1),
  'Your while loop uses the condition left < right. A classmate suggests changing it to left <= right to ensure the middle character is also checked. Which condition is correct, and why?',
  '["left <= right is correct -- we must explicitly compare the middle character to itself to confirm it is valid.", "left < right is correct -- when both pointers reference the same index, comparing a character to itself is always equal and contributes no useful information.", "left <= right handles odd-length strings correctly while left < right only works for even-length strings.", "The termination condition does not matter because a return statement inside the loop will always fire before the pointers can meet."]',
  1,
  E'left < right is the semantically precise condition.\n\nWhen left == right, both pointers are pointing at the exact same character -- the center element of an odd-length string. Comparing that character to itself will always yield equality; it can never reveal a mismatch. It is a logically vacuous operation.\n\nleft < right is precise because the loop invariant is: there is a pair of distinct positions left to compare. The moment the pointers meet or cross, all meaningful pairs have been examined and the loop should stop.\n\nleft <= right would not produce a wrong answer for this specific problem, but it is conceptually imprecise -- it implies you are doing something useful when the pointers meet, which you are not. In more complex Two Pointers problems, off-by-one errors in loop conditions are a frequent source of subtle bugs. Building the habit of using the strictly correct condition from the start is worth it.'
);
