-- ============================================================
-- Algo-Patterns-Hub: Full Curriculum Seed
-- Run AFTER schema.sql AND add_prerequisite_pattern_id.sql
-- WARNING: Truncates all curriculum + progress data.
-- ============================================================

TRUNCATE public.patterns CASCADE;


-- ============================================================
-- PATTERNS (roots first, then dependents)
-- ============================================================

INSERT INTO public.patterns (name, slug, description, order_index)
VALUES (
  'Arrays & Hashing',
  'arrays-hashing',
  'The Arrays & Hashing pattern solves membership, frequency, and grouping problems in O(N) time by trading a small amount of space for speed. A hash map or hash set converts an O(N) inner-loop lookup into an O(1) direct lookup, eliminating brute-force nested iteration. Spot this pattern whenever a problem asks you to detect duplicates, find a complement, or count occurrences in a single pass.',
  1
);

INSERT INTO public.patterns (name, slug, description, order_index, prerequisite_pattern_id)
SELECT
  'Two Pointers & Stack',
  'two-pointers-stack',
  'Two Pointers collapses boundary comparisons from O(N^2) to O(N) by using two synchronized index variables that move inward or in tandem across a data structure. Stack adds LIFO memory to problems involving nesting, matching, or monotonically tracking the most recent relevant element. Together these two techniques cover a huge class of sequence and bracket problems that naive loops handle badly.',
  2,
  id
FROM public.patterns WHERE slug = 'arrays-hashing';

INSERT INTO public.patterns (name, slug, description, order_index, prerequisite_pattern_id)
SELECT
  'Binary Search & Sliding Window',
  'binary-search-sliding-window',
  'Binary Search cuts the search space in half on every step, delivering O(log N) lookups on sorted data or on any monotone predicate. Sliding Window maintains a dynamic subarray of interest by advancing the right boundary to expand and the left boundary to contract, processing each element at most twice for O(N) total. Both patterns replace brute-force O(N^2) scans with elegant linear or logarithmic solutions.',
  3,
  id
FROM public.patterns WHERE slug = 'two-pointers-stack';

INSERT INTO public.patterns (name, slug, description, order_index, prerequisite_pattern_id)
SELECT
  'Linked List',
  'linked-list',
  'Linked List problems exploit direct pointer manipulation — reversals, merges, and cycle detection — to achieve O(1) extra space where array-based approaches would need O(N). The runner technique (a fast pointer advancing twice as fast as a slow pointer) is a cornerstone that detects cycles and finds midpoints in a single pass without knowing the list length in advance.',
  4,
  id
FROM public.patterns WHERE slug = 'two-pointers-stack';

INSERT INTO public.patterns (name, slug, description, order_index, prerequisite_pattern_id)
SELECT
  'Trees',
  'trees',
  'Tree problems map to one of two traversal strategies: depth-first search (DFS) for path-based or structural reasoning, and breadth-first search (BFS) for level-order or shortest-path reasoning. Recognizing which strategy to apply — and whether to implement it recursively or iteratively with a stack or queue — is the core skill this module builds.',
  5,
  id
FROM public.patterns WHERE slug = 'binary-search-sliding-window';

INSERT INTO public.patterns (name, slug, description, order_index, prerequisite_pattern_id)
SELECT
  'Tries',
  'tries',
  'A Trie (prefix tree) is a specialized tree where each node represents a single character, and a root-to-node path spells out a prefix. Insert, search, and prefix-lookup all run in O(K) time where K is the word length — independent of how many words are stored. This makes Tries far superior to hash maps when prefix queries are needed.',
  6,
  id
FROM public.patterns WHERE slug = 'trees';

INSERT INTO public.patterns (name, slug, description, order_index, prerequisite_pattern_id)
SELECT
  'Heap / Priority Queue',
  'heap-priority-queue',
  'A Heap is a complete binary tree that guarantees O(1) access to the minimum (min-heap) or maximum (max-heap) element, with O(log N) insertion and deletion. Priority Queues expose this interface at a higher level. The pattern shines on "find the K-th element", "merge K sorted lists", and streaming top-K problems where sorting the full dataset would be unnecessarily expensive.',
  7,
  id
FROM public.patterns WHERE slug = 'trees';

INSERT INTO public.patterns (name, slug, description, order_index, prerequisite_pattern_id)
SELECT
  'Backtracking',
  'backtracking',
  'Backtracking explores all candidates by incrementally building a partial solution and abandoning it the moment it cannot be completed into a valid answer — this pruning is what separates it from brute-force enumeration. The canonical structure is a recursive function that makes a choice, recurses, then undoes the choice (backtrack) before trying the next option. Master this pattern to solve subsets, permutations, combinations, and constraint-satisfaction problems.',
  8,
  id
FROM public.patterns WHERE slug = 'trees';

INSERT INTO public.patterns (name, slug, description, order_index, prerequisite_pattern_id)
SELECT
  'Graphs',
  'graphs',
  'Graph problems require choosing between BFS (unweighted shortest paths, level-order exploration) and DFS (connectivity, cycle detection, topological sort). Both run in O(V + E) time. The key skill is translating a real-world scenario — grids, social networks, dependency chains — into a graph representation and then selecting the right traversal.',
  9,
  id
FROM public.patterns WHERE slug = 'backtracking';

INSERT INTO public.patterns (name, slug, description, order_index, prerequisite_pattern_id)
SELECT
  '1-D Dynamic Programming',
  'one-d-dp',
  '1-D Dynamic Programming solves problems with overlapping subproblems by storing previously computed results in a one-dimensional array, converting exponential recursion into O(N) iteration. The two foundational skills are recognizing the recurrence relation and identifying the base cases. Once those two things are clear, the implementation almost writes itself.',
  10,
  id
FROM public.patterns WHERE slug = 'backtracking';


-- ============================================================
-- PATTERN: Arrays & Hashing
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Contains Duplicate',
  'contains-duplicate',
  'easy',
  'The naive solution to "does this list contain a duplicate?" is two nested loops: for every element, scan the rest of the array looking for a match. That is O(N^2) time — catastrophically slow for large inputs.\n\nThe Arrays & Hashing insight is this: a hash set answers "have I seen this value before?" in O(1) time. Replace the inner loop with a single hash-set lookup and the whole problem collapses to a single O(N) pass. You pay O(N) extra space for the set, but that is an excellent trade.\n\nThis problem is the entry point for all hash-based pattern recognition. Learning to reach for a hash set the moment you see "detect a duplicate" or "have I seen this before?" is the most frequently recurring micro-skill in technical interviews.',
  '## Contains Duplicate\n\nGiven an integer array `nums`, return `true` if any value appears **at least twice** in the array, and return `false` if every element is distinct.\n\n---\n\n**Example 1:**\n```\nInput:  nums = [1,2,3,1]\nOutput: true\n```\n\n**Example 2:**\n```\nInput:  nums = [1,2,3,4]\nOutput: false\n```\n\n**Example 3:**\n```\nInput:  nums = [1,1,1,3,3,4,3,2,4,2]\nOutput: true\n```\n\n---\n\n**Constraints:**\n- `1 <= nums.length <= 10^5`\n- `-10^9 <= nums[i] <= 10^9`',
  '{"python": "from typing import List\n\nclass Solution:\n    def containsDuplicate(self, nums: List[int]) -> bool:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} nums\n * @return {boolean}\n */\nvar containsDuplicate = function(nums) {\n    // Your solution here\n};" , "java": "import java.util.*;\n\nclass Solution {\n    public boolean containsDuplicate(int[] nums) {\n        // Your solution here\n        return false;\n    }\n}", "cpp": "class Solution {\npublic:\n    bool containsDuplicate(vector<int>& nums) {\n        // Your solution here\n        return false;\n    }\n};"}',
  'CORRECT APPROACH: Initialize an empty hash set. Iterate through nums one element at a time. Before inserting, check if the element is already in the set — if it is, return true immediately. If it is not, add it to the set and continue. After the loop, return false.\n\nWHAT COUNTS AS CORRECT: The solution must use a hash set (or equivalent O(1) lookup structure). It must make a single O(N) pass. It must return true as soon as a duplicate is found (early exit is ideal but not required). Time complexity must be O(N) and space complexity O(N).\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Nested loops (O(N^2)) — tell the student their approach works but scales poorly and ask them what data structure gives O(1) lookup.\n- Sorting then comparing adjacent elements (O(N log N)) — valid correctness-wise but does not demonstrate the hashing pattern; ask them how to get to O(N).\n- Any solution that modifies the input array in place without justification.\n\nGUARDRAILS: Never output code. Never give the answer directly. Ask one Socratic question per issue.'
FROM public.patterns WHERE slug = 'arrays-hashing' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What is the time complexity of the naive nested-loop approach to detecting a duplicate, and what does the hash-set approach reduce it to?',
  '["O(N log N) reduced to O(N) — sorting lets you find adjacent duplicates in a single pass.", "O(N^2) reduced to O(N) — a hash set answers ''have I seen this?'' in O(1), removing the inner loop.", "O(N^2) reduced to O(log N) — a hash set uses binary search internally.", "O(N) reduced to O(1) — hash sets do the work upfront during construction."]',
  1,
  'The nested-loop approach compares every pair of elements: for each of the N elements you scan up to N others, yielding O(N^2). A hash set stores elements as they are seen, and the ''in set?'' check is O(1) average. So one pass through the array with a set check at each step gives O(N) total. The space cost is O(N) for the set — a worthwhile trade in virtually all practical scenarios.'
FROM public.problems WHERE slug = 'contains-duplicate' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'A classmate solves Contains Duplicate by first sorting the array and then checking every adjacent pair. Is this approach correct, and how does it compare to the hash-set solution?',
  '["Incorrect — sorting changes the original values and may alter whether duplicates exist.", "Correct and equally optimal — both run in O(N) time.", "Correct but suboptimal — sorting is O(N log N) while the hash-set approach is O(N).", "Correct and superior — sorting uses O(1) space while the hash set requires O(N) extra space, and the time difference is negligible."]',
  2,
  'Sorting and comparing adjacent elements is logically correct — if a duplicate exists it will end up next to itself after sorting. But sorting costs O(N log N) time, whereas a single hash-set pass costs O(N). The sorting approach also mutates the array, which may be unacceptable if the caller needs the original order. The hash-set approach is strictly faster and non-destructive. The space trade-off (O(1) for in-place sort vs O(N) for a set) is real but rarely the bottleneck at interview scale.'
FROM public.problems WHERE slug = 'contains-duplicate' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'In your hash-set solution you return true the moment you find a duplicate instead of finishing the loop. Why is this early-exit important?',
  '["It is not important — the final answer is the same either way and modern CPUs make the difference negligible.", "It guarantees the set never holds more than one element, keeping space complexity at O(1).", "It reduces the best-case and average-case runtime — the algorithm can terminate after just two elements if a duplicate appears early.", "It is required for correctness — without early exit the set could lose track of the first occurrence before the loop ends."]',
  2,
  'Early exit does not change worst-case O(N) time or O(N) space (both occur when there are no duplicates and the entire array is processed). What it improves is best-case and average-case performance. If the very first element repeats at index 1, the loop exits after two iterations instead of N. For large real-world datasets where duplicates are common this matters. Correctness does not require early exit — you could collect all elements and check at the end — but early exit is the idiomatic and efficient form.'
FROM public.problems WHERE slug = 'contains-duplicate' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Two Sum',
  'two-sum',
  'easy',
  'Two Sum is the definitive hash-map problem. The brute-force approach — for each element, scan the rest of the array for a matching complement — is O(N^2). The hash-map insight flips the question: instead of "find the other number that adds up to target," ask "is the complement I need already in my map?"\n\nAs you iterate, you store each value alongside its index. At every new element, you compute `complement = target - current` and check the map in O(1). If the complement is there, you have your answer immediately. If not, you store the current element and move on.\n\nThis two-pass idea — build a lookup structure on the way through the data — is the template for dozens of harder interview problems. Nail the pattern here and you will recognize it instantly under pressure.',
  '## Two Sum\n\nGiven an array of integers `nums` and an integer `target`, return the **indices** of the two numbers such that they add up to `target`.\n\nYou may assume that each input would have **exactly one solution**, and you may not use the same element twice.\n\nYou can return the answer in any order.\n\n---\n\n**Example 1:**\n```\nInput:  nums = [2,7,11,15], target = 9\nOutput: [0,1]\nExplanation: nums[0] + nums[1] == 9\n```\n\n**Example 2:**\n```\nInput:  nums = [3,2,4], target = 6\nOutput: [1,2]\n```\n\n**Example 3:**\n```\nInput:  nums = [3,3], target = 6\nOutput: [0,1]\n```\n\n---\n\n**Constraints:**\n- `2 <= nums.length <= 10^4`\n- `-10^9 <= nums[i] <= 10^9`\n- Only one valid answer exists.',
  '{"python": "from typing import List\n\nclass Solution:\n    def twoSum(self, nums: List[int], target: int) -> List[int]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} nums\n * @param {number} target\n * @return {number[]}\n */\nvar twoSum = function(nums, target) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public int[] twoSum(int[] nums, int target) {\n        // Your solution here\n        return new int[]{};\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<int> twoSum(vector<int>& nums, int target) {\n        // Your solution here\n        return {};\n    }\n};"}',
  'CORRECT APPROACH: Initialize an empty hash map (value -> index). Iterate through nums with index i. Compute complement = target - nums[i]. If complement exists in the map, return [map[complement], i]. Otherwise, store map[nums[i]] = i and continue.\n\nWHAT COUNTS AS CORRECT: Single-pass O(N) time with O(N) space. Returns two valid indices (not values). Handles the case where the same element is used twice correctly — since we check before inserting, nums[i] cannot match itself.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Nested loops: correct but O(N^2). Ask the student what data structure would let them look up the complement in O(1).\n- Two-pass solution (first build map, then search): correct and O(N), but can be fused into one pass — worth noting as a minor follow-up.\n- Returning values instead of indices: wrong per the problem spec.\n\nGUARDRAILS: Never output code. Guide with one Socratic question per issue.'
FROM public.patterns WHERE slug = 'arrays-hashing' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'In the hash-map approach to Two Sum, why do we store the element''s index in the map rather than just its value?',
  '["Because hash maps cannot store plain integer values, only key-value pairs.", "Because the problem asks us to return indices, not values — storing the index lets us retrieve it in O(1) when we find a complement.", "Because storing values would create collisions that corrupt the map.", "Because we need the index to compute the complement: complement = index - target."]',
  1,
  'The problem statement explicitly asks for the indices of the two numbers, not the numbers themselves. By mapping value -> index as we iterate, we can return both indices the moment a complement is found: the current index i and map[complement]. If we only stored values we would know a solution exists but not where in the array it lives.'
FROM public.problems WHERE slug = 'two-sum' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The input [3,3] with target 6 should return [0,1]. If your code inserts nums[i] into the map before checking for the complement, it incorrectly returns [0,0]. What is the fix?',
  '["Use two separate maps — one for even-indexed elements and one for odd-indexed elements.", "Check for the complement first; only insert nums[i] into the map if the complement is not found.", "Sort the array before building the map so duplicates end up adjacent.", "Skip elements where nums[i] == target / 2 to avoid self-matching."]',
  1,
  'The ordering within each loop iteration matters. Check map.get(complement) before inserting nums[i]. This way, when i=0 (value 3), the map is empty — no complement found — so we insert 3->0. When i=1 (value 3 again), complement is 3, which is already in the map at index 0. We return [0,1]. Inserting first would make index 0 overwrite itself and incorrectly suggest nums[0] + nums[0] == target.'
FROM public.problems WHERE slug = 'two-sum' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What are the time and space complexities of the single-pass hash-map solution?',
  '["O(N log N) time, O(1) space — the map is sorted internally.", "O(N) time, O(N) space — one pass through the array, map grows up to N entries.", "O(N) time, O(1) space — hash maps use constant space regardless of input size.", "O(N^2) time, O(N) space — each insertion requires scanning the map for collisions."]',
  1,
  'We iterate through the array exactly once: O(N) time. In the worst case (no solution until the last pair) the map holds N-1 entries: O(N) space. Hash map operations (get, put) are O(1) average due to hashing. The map does not sort its keys, so no log factor appears. This O(N) / O(N) profile is optimal for this problem — you cannot do better than O(N) time since you must at minimum read every element.'
FROM public.problems WHERE slug = 'two-sum' LIMIT 1;


-- ============================================================
-- PATTERN: Two Pointers & Stack
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Valid Palindrome',
  'valid-palindrome',
  'easy',
  'Before you write a single line of code, ask yourself: what is the naive approach?\n\nMost developers instinctively reach for string manipulation — filter out non-alphanumeric characters, lowercase everything, reverse the cleaned string, and compare. It works. But it silently allocates O(N) extra memory for that reversed copy, and that cost compounds when strings are large or when this check lives inside a performance-critical loop.\n\nThis is where Two Pointers shines. Instead of building anything new, you collapse boundaries inward. Place one pointer at the very left edge of the string and another at the very right edge. Walk them toward each other. At every step you are comparing the string against its own mirror image — no copy needed, no reversal computed. Two integer variables are all the extra memory you ever use: O(1) space, O(N) time.\n\nLearning to see "compare from both ends simultaneously" as a reusable pattern — rather than a one-off trick — is what separates engineers who consistently write optimal solutions from those who do not.',
  '## Valid Palindrome\n\nA phrase is a **palindrome** if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, it reads the same forward and backward.\n\nGiven a string `s`, return `true` if it is a palindrome, or `false` otherwise.\n\n---\n\n**Example 1:**\n```\nInput:  s = "A man, a plan, a canal: Panama"\nOutput: true\n```\n\n**Example 2:**\n```\nInput:  s = "race a car"\nOutput: false\n```\n\n**Example 3:**\n```\nInput:  s = " "\nOutput: true\nExplanation: After removing non-alphanumeric characters the string is empty, which is a palindrome.\n```\n\n---\n\n**Constraints:**\n- `1 <= s.length <= 2 * 10^5`\n- `s` consists only of printable ASCII characters.',
  '{"python": "def isPalindrome(s: str) -> bool:\n    # Your solution here\n    pass", "javascript": "/**\n * @param {string} s\n * @return {boolean}\n */\nvar isPalindrome = function(s) {\n    // Your solution here\n};", "java": "class Solution {\n    public boolean isPalindrome(String s) {\n        // Your solution here\n        return false;\n    }\n}", "cpp": "class Solution {\npublic:\n    bool isPalindrome(string s) {\n        // Your solution here\n        return false;\n    }\n};"}',
  'CORRECT APPROACH: Initialize left=0 and right=len(s)-1. While left < right: advance left past non-alphanumeric characters, advance right past non-alphanumeric characters, compare s[left].lower() to s[right].lower(). If they differ, return False. Otherwise advance both inward. Return True after the loop.\n\nWHAT COUNTS AS CORRECT: Uses two integer pointers advancing inward. Skips non-alphanumeric characters on both sides. Normalizes case before comparing. Returns the correct answer for empty strings and single characters. Time O(N), space O(1). Does NOT reverse the string or build a cleaned copy.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Reversing the string / building a cleaned copy: correct but O(N) space — violates the pattern lesson.\n- Forgetting to skip non-alphanumeric on both sides (only skipping on one side).\n- Using left <= right instead of left < right: technically harmless here but conceptually imprecise.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'two-pointers-stack' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'When checking for a palindrome, a common beginner approach is to reverse the string and compare it to the original. What is the primary space-complexity advantage of the Two Pointers technique over this reversal approach?',
  '["Two Pointers runs in O(N) time while string reversal runs in O(N^2) time, making Two Pointers faster overall.", "Two Pointers uses O(1) extra space, while string reversal requires allocating an O(N) auxiliary string.", "Two Pointers uses O(log N) space because the pointers progressively narrow the search space.", "Both approaches use O(1) space because modern runtimes optimize away unnecessary string copies."]',
  1,
  'Reversing a string creates a brand-new string of length N in memory — every character must be copied. This is O(N) auxiliary space. The Two Pointers technique never builds anything new; it only ever needs two integer variables regardless of input length. That is the textbook definition of O(1) auxiliary space. This distinction matters most in memory-constrained environments and is a common follow-up probe in real interviews: "Can you solve this without allocating extra space?"'
FROM public.problems WHERE slug = 'valid-palindrome' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'While scanning inward with left and right pointers, the left pointer lands on a comma. What is the correct action?',
  '["Compare the comma to the character at right and advance both pointers inward, since every character must be considered.", "Return false immediately — encountering punctuation means the string cannot be a palindrome.", "Advance left forward by one without making a comparison, then re-evaluate the character at the new position.", "Stop, preprocess the entire string to remove all punctuation, and restart from the beginning."]',
  2,
  'Non-alphanumeric characters are to be ignored, not treated as mismatches. When a pointer lands on one, move it one step in its natural direction (left += 1 or right -= 1) and loop back to check the new character. Perform a comparison only once both pointers rest on alphanumeric characters. Returning false would break inputs like "A man, a plan, a canal: Panama". Preprocessing and restarting works conceptually but defeats the O(1)-space goal, since it requires an O(N) cleaned copy.'
FROM public.problems WHERE slug = 'valid-palindrome' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Your while loop uses the condition left < right. A classmate suggests changing it to left <= right to ensure the middle character is also checked. Which condition is correct, and why?',
  '["left <= right is correct — we must explicitly compare the middle character to itself to confirm it is valid.", "left < right is correct — when both pointers reference the same index, comparing a character to itself is always equal and contributes no useful information.", "left <= right handles odd-length strings while left < right only works for even-length strings.", "The termination condition does not matter because a return statement inside the loop always fires before the pointers can meet."]',
  1,
  'When left == right, both pointers point at the exact same character — the center of an odd-length string. Comparing it to itself always yields equality; it can never reveal a mismatch. left < right is precise: the loop invariant is "there is a pair of distinct positions left to compare." left <= right would not produce a wrong answer for this specific problem, but it is conceptually imprecise and in more complex Two Pointers problems off-by-one conditions cause subtle bugs.'
FROM public.problems WHERE slug = 'valid-palindrome' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Valid Parentheses',
  'valid-parentheses',
  'easy',
  'At first glance "are these brackets balanced?" looks like a counting problem — just count opens and closes. But counting fails the moment you mix bracket types: "(]" has one open and one close yet is clearly invalid.\n\nThe real requirement is a matching requirement: every closing bracket must match the most recently seen unmatched opening bracket. "Most recently seen" is a last-in-first-out (LIFO) relationship — the textbook case for a stack.\n\nThe algorithm is elegant: push every opening bracket onto a stack. When you encounter a closing bracket, check the top of the stack. If it is the matching opener, pop it and continue. If it is not — or the stack is empty — the string is invalid. At the end, a valid string has an empty stack (every opener was matched).\n\nThis problem is the canonical introduction to the Stack pattern and the idea of using a data structure to "remember context" while scanning left-to-right.',
  '## Valid Parentheses\n\nGiven a string `s` containing just the characters `(`, `)`, `{`, `}`, `[` and `]`, determine if the input string is valid.\n\nAn input string is valid if:\n1. Open brackets must be closed by the same type of brackets.\n2. Open brackets must be closed in the correct order.\n3. Every close bracket has a corresponding open bracket of the same type.\n\n---\n\n**Example 1:**\n```\nInput:  s = "()"\nOutput: true\n```\n\n**Example 2:**\n```\nInput:  s = "()[]{}"\nOutput: true\n```\n\n**Example 3:**\n```\nInput:  s = "(]"\nOutput: false\n```\n\n**Example 4:**\n```\nInput:  s = "([])"\nOutput: true\n```\n\n---\n\n**Constraints:**\n- `1 <= s.length <= 10^4`\n- `s` consists of parentheses only: `()[]{}`',
  '{"python": "def isValid(s: str) -> bool:\n    # Your solution here\n    pass", "javascript": "/**\n * @param {string} s\n * @return {boolean}\n */\nvar isValid = function(s) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public boolean isValid(String s) {\n        // Your solution here\n        return false;\n    }\n}", "cpp": "class Solution {\npublic:\n    bool isValid(string s) {\n        // Your solution here\n        return false;\n    }\n};"}',
  'CORRECT APPROACH: Initialize an empty stack and a map of closing -> opening brackets: {")": "(", "]": "[", "}": "{"}. Iterate through each character. If it is an opening bracket push it. If it is a closing bracket: if the stack is empty or the top of the stack is not the matching opener, return False; otherwise pop the stack. After the loop, return True only if the stack is empty (all openers were matched).\n\nWHAT COUNTS AS CORRECT: Handles all three bracket types correctly. Returns False for an empty stack on close encounter. Returns False at the end if unmatched openers remain (e.g. "((" returns false). Time O(N), space O(N).\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Simple counter approach (count opens vs closes): fails for "(]" — ask the student what happens when bracket types are mixed.\n- Forgetting to check that the stack is empty at the end: "((" would incorrectly return True.\n- Forgetting the empty-stack check before popping: ")" would cause a runtime error.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'two-pointers-stack' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why does a simple counter (increment on ''('' and decrement on '')'') fail for this problem when the input contains multiple bracket types?',
  '["It does not fail — a counter correctly handles mixed bracket types by treating all openers and closers as equivalent.", "It fails because a counter cannot track the order in which brackets appear, so it would accept ''(]'' as valid even though the types do not match.", "It fails because the counter would overflow for long inputs.", "It fails only for inputs with an odd number of characters."]',
  1,
  '"(]" has one opener and one closer — a counter reaches zero and incorrectly reports valid. The counter approach treats all opening brackets as interchangeable and all closing brackets as interchangeable, which is wrong: a ] can only close a [, not a (. The stack approach stores the actual character of each unmatched opener so that when a closer is encountered the type can be verified.'
FROM public.problems WHERE slug = 'valid-parentheses' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'After processing all characters in "((", your stack contains two unpopped openers. What should your function return, and why?',
  '["true — we never encountered a mismatch, so the string is valid.", "false — a non-empty stack at the end means there are unmatched opening brackets.", "true — trailing unmatched openers are allowed as long as no closer was mismatched.", "An exception — you should have detected this case and thrown an error earlier."]',
  1,
  'A non-empty stack at the end of the loop means there are opening brackets that were never closed. That violates the problem''s requirements (every open bracket must be closed). The return condition is: return stack.isEmpty() (or equivalent). If the stack is empty, every opener was matched; return true. If not, return false. This is the second most common off-by-one mistake after forgetting the empty-stack check before popping.'
FROM public.problems WHERE slug = 'valid-parentheses' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What happens if you try to pop from the stack when a closing bracket is encountered but the stack is already empty — and why must you guard against this?',
  '["Nothing — popping an empty stack returns null in all languages, which you can then safely compare.", "A runtime error or exception in most languages, causing the program to crash rather than return false.", "The function silently returns the wrong answer because null compares as equal to any bracket.", "It is impossible for the stack to be empty when a closing bracket is encountered if the input is well-formed."]',
  1,
  'Inputs like ")" or "](){" present a closing bracket before any opener has been pushed, leaving the stack empty at the point of the pop. In Python this raises an IndexError; in Java it throws EmptyStackException; in C++ it is undefined behavior. You must check if the stack is empty before attempting to pop or peek. The guard is: if the stack is empty OR the top does not match, return False immediately. This case is not rare — it is tested explicitly in most interview scenarios.'
FROM public.problems WHERE slug = 'valid-parentheses' LIMIT 1;


-- ============================================================
-- PATTERN: Binary Search & Sliding Window
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Binary Search',
  'binary-search',
  'easy',
  'Linear search scans every element: O(N). If the array is sorted, that is a colossal waste — you can eliminate half the remaining search space with every single comparison.\n\nBinary Search exploits sortedness. At each step, compare the target to the middle element. If it matches, you are done. If the target is smaller, the entire right half is irrelevant — shrink the window. If it is larger, the entire left half is irrelevant — expand the window. Each step halves the problem, yielding O(log N) time and O(1) space.\n\nThis is the foundational binary search problem: a clean sorted array with a single target. Get this template absolutely right — the exact boundary conditions, the termination clause, the mid calculation — before moving on to harder variants like "find first/last position" or "search in rotated array".',
  '## Binary Search\n\nGiven an array of integers `nums` sorted in ascending order, and an integer `target`, write a function to search for `target` in `nums`. If `target` exists, return its index. Otherwise return `-1`.\n\nYou must write an algorithm with `O(log n)` runtime complexity.\n\n---\n\n**Example 1:**\n```\nInput:  nums = [-1,0,3,5,9,12], target = 9\nOutput: 4\n```\n\n**Example 2:**\n```\nInput:  nums = [-1,0,3,5,9,12], target = 2\nOutput: -1\n```\n\n---\n\n**Constraints:**\n- `1 <= nums.length <= 10^4`\n- `-10^4 <= nums[i], target <= 10^4`\n- All integers in `nums` are unique.\n- `nums` is sorted in ascending order.',
  '{"python": "from typing import List\n\nclass Solution:\n    def search(self, nums: List[int], target: int) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} nums\n * @param {number} target\n * @return {number}\n */\nvar search = function(nums, target) {\n    // Your solution here\n};", "java": "class Solution {\n    public int search(int[] nums, int target) {\n        // Your solution here\n        return -1;\n    }\n}", "cpp": "class Solution {\npublic:\n    int search(vector<int>& nums, int target) {\n        // Your solution here\n        return -1;\n    }\n};"}',
  'CORRECT APPROACH: Initialize lo=0, hi=len(nums)-1. While lo <= hi: compute mid = lo + (hi - lo) // 2 (prevents integer overflow). If nums[mid] == target return mid. If nums[mid] < target set lo = mid + 1. Else set hi = mid - 1. After the loop return -1.\n\nWHAT COUNTS AS CORRECT: Uses binary search (O(log N)). Correctly handles target not found (-1 return). Handles single-element arrays. Uses lo <= hi (not lo < hi) as the termination condition. Time O(log N), space O(1).\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Linear scan (O(N)): ask the student how they can use the sorted property to skip half the work.\n- Off-by-one in boundaries: lo = mid instead of lo = mid + 1 (or hi = mid instead of hi = mid - 1) causes infinite loops — trace a specific example.\n- mid = (lo + hi) // 2: technically works in Python due to big integers, but note the overflow risk in Java/C++.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'binary-search-sliding-window' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why is mid = lo + (hi - lo) // 2 preferred over mid = (lo + hi) // 2 in languages like Java or C++?',
  '["It is not preferred — both expressions produce identical results in all languages and contexts.", "It prevents integer overflow: if lo and hi are both near INT_MAX, lo + hi overflows a 32-bit integer, but hi - lo does not.", "It ensures mid always rounds toward the right boundary, which is required for the algorithm to terminate.", "It avoids floating-point arithmetic that (lo + hi) // 2 would otherwise trigger."]',
  1,
  'In Java and C++, int is 32-bit with a maximum value of about 2.1 billion. If lo = 1,000,000,000 and hi = 1,500,000,000, lo + hi = 2,500,000,000 which overflows and produces a negative number, breaking the algorithm. hi - lo = 500,000,000 which is safe. Python integers have arbitrary precision so this is not an issue there, but writing the safe form is a good habit that shows interview-level awareness of low-level constraints.'
FROM public.problems WHERE slug = 'binary-search' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'If you use while lo < hi instead of while lo <= hi as the loop condition, what goes wrong?',
  '["Nothing — lo < hi is the conventional termination condition and is identical in behavior.", "The algorithm terminates one step early, missing the case where the target is the final remaining element when lo == hi.", "The algorithm runs one extra iteration, causing an index-out-of-bounds error.", "The algorithm only breaks for even-length arrays; it works correctly for odd-length arrays."]',
  1,
  'When the search space narrows to a single element, lo == hi. With lo < hi the loop exits before checking that element, so if it is the target the function incorrectly returns -1. With lo <= hi the loop runs one more time, evaluates that element, and either returns its index or exits cleanly. The correct condition is lo <= hi.'
FROM public.problems WHERE slug = 'binary-search' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'After computing mid and finding nums[mid] < target, you set lo = mid. Why is this incorrect, and what should you do instead?',
  '["It is correct — lo = mid keeps mid in the search window in case it is the target.", "It is incorrect — setting lo = mid can cause an infinite loop when hi = lo + 1, because mid always equals lo and the window never shrinks.", "It is incorrect because lo must always move to the right boundary hi, not the midpoint.", "It is correct for even-length arrays but incorrect for odd-length ones."]',
  1,
  'If lo = 2 and hi = 3, mid = 2. nums[mid] < target, so you set lo = mid = 2. On the next iteration lo = 2, hi = 3 again — mid = 2 again — infinite loop. The correct update is lo = mid + 1, which guarantees the search window shrinks by at least one element on every iteration, ensuring termination. The same reasoning applies to hi: when nums[mid] > target, set hi = mid - 1 (not hi = mid).'
FROM public.problems WHERE slug = 'binary-search' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Best Time to Buy and Sell Stock',
  'best-time-to-buy-sell-stock',
  'easy',
  'The brute-force approach — try every pair (buy on day i, sell on day j where j > i) and track the maximum profit — is O(N^2). With 100,000 prices, that is 10 billion comparisons.\n\nThe Sliding Window insight is to recognize that the optimal buy price is simply the minimum price seen so far. You do not need to look back at all previous days. You need exactly one variable: the running minimum. At each new price, compute the profit if you sold today (current price minus the running minimum), update the global maximum profit, then update the running minimum if the current price is lower.\n\nThis is a one-pass O(N) solution with O(1) space. The "window" conceptually slides forward: you are always considering the best possible buy point to the left and the current price as the sell point to the right. When a new minimum is found, the left boundary of your window shifts.',
  '## Best Time to Buy and Sell Stock\n\nYou are given an array `prices` where `prices[i]` is the price of a given stock on the `i`th day.\n\nYou want to maximize your profit by choosing a **single day** to buy one stock and choosing a **different day in the future** to sell that stock.\n\nReturn the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return `0`.\n\n---\n\n**Example 1:**\n```\nInput:  prices = [7,1,5,3,6,4]\nOutput: 5\nExplanation: Buy on day 2 (price = 1), sell on day 5 (price = 6). Profit = 6 - 1 = 5.\n```\n\n**Example 2:**\n```\nInput:  prices = [7,6,4,3,1]\nOutput: 0\nExplanation: Prices only decrease. No transaction yields profit.\n```\n\n---\n\n**Constraints:**\n- `1 <= prices.length <= 10^5`\n- `0 <= prices[i] <= 10^4`',
  '{"python": "from typing import List\n\nclass Solution:\n    def maxProfit(self, prices: List[int]) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} prices\n * @return {number}\n */\nvar maxProfit = function(prices) {\n    // Your solution here\n};", "java": "class Solution {\n    public int maxProfit(int[] prices) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class Solution {\npublic:\n    int maxProfit(vector<int>& prices) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Initialize min_price = prices[0] (or infinity) and max_profit = 0. Iterate through prices. At each price: compute profit = price - min_price, update max_profit = max(max_profit, profit), update min_price = min(min_price, price). Return max_profit.\n\nWHAT COUNTS AS CORRECT: Single pass O(N), space O(1). Returns 0 when prices strictly decrease (no profitable transaction). Correctly identifies the minimum price is always updated before or after (both orderings are correct — explain if asked). Never sells before buying (the minimum is always to the left).\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Nested loops: O(N^2). Ask: "Do you need to look at all previous days to know the best buy price, or just one number?"\n- Forgetting to return 0 when no profit is possible (returning a negative number).\n- Updating min_price after computing profit on the same iteration is fine — trace through to show correctness.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'binary-search-sliding-window' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'At each step of the one-pass solution you track the running minimum price seen so far. Why is this sufficient — why don''t you need to remember all previous prices?',
  '["It is not sufficient — you need all previous prices to correctly handle cases where the minimum price appears multiple times.", "The optimal buy price for any future sell day is always the global minimum seen so far. Tracking one number captures exactly the information needed.", "You only need the previous price, not all of them — the running minimum is an unnecessary optimization.", "You need the two smallest prices seen so far in case the minimum price appears after the best sell day."]',
  1,
  'Profit = sell_price - buy_price. To maximize profit for a given sell day, you want the smallest possible buy price that occurred before that day. That is exactly the running minimum. There is never a scenario where using a non-minimum buy price yields higher profit. One variable captures the globally optimal buy candidate at every point in the scan.'
FROM public.problems WHERE slug = 'best-time-to-buy-sell-stock' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For the input [7,6,4,3,1], all prices decrease. What should your function return, and how does the algorithm produce it?',
  '["Return -6 — the best achievable transaction is buying at 7 and selling at 1.", "Return 0 — max_profit is initialized to 0 and never updated because no computed profit is positive.", "Return 1 — the last price in the array.", "Return 7 — the first price, representing the potential buy value."]',
  1,
  'Since prices strictly decrease, every profit = price - min_price is negative or zero (the current price is always <= min_price after the first element). max_profit = max(0, negative_number) stays at 0 throughout. This handles the "no transaction" case correctly because max_profit is initialized to 0, representing the profit from doing nothing. Never return a negative value for this problem.'
FROM public.problems WHERE slug = 'best-time-to-buy-sell-stock' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What are the time and space complexities of the one-pass solution?',
  '["O(N log N) time, O(1) space — internally it performs implicit sorting.", "O(N) time, O(N) space — the running minimum requires storing all previous prices.", "O(N) time, O(1) space — one pass, two scalar variables (min_price and max_profit).", "O(N^2) time, O(1) space — for each price we conceptually compare against all previous prices via min_price."]',
  2,
  'Exactly one pass through the array of N prices: O(N) time. Two scalar variables (min_price and max_profit) regardless of input size: O(1) space. The running minimum conceptually replaces the inner loop of the brute-force approach — it is not performing N comparisons per step; it is updating a single variable in O(1). This is why the overall complexity is O(N), not O(N^2).'
FROM public.problems WHERE slug = 'best-time-to-buy-sell-stock' LIMIT 1;


-- ============================================================
-- PATTERN: Linked List
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Reverse Linked List',
  'reverse-linked-list',
  'easy',
  'Reversing a linked list is the foundational pointer-manipulation exercise. Every node currently points forward; you need it to point backward. The trick is doing this in-place with O(1) extra space rather than collecting all values into an array and building a new list.\n\nThe key insight: you need three pointers at all times — prev, curr, and next. At each step you save curr.next (so you do not lose the rest of the list), redirect curr.next to prev (the reversal step), then advance both pointers one step forward. When curr falls off the end, prev is the new head.\n\nThis three-pointer dance appears in dozens of harder linked-list problems: reversing a sublist, reversing in k-groups, and palindrome linked list. Get it automatic here.',
  '## Reverse Linked List\n\nGiven the head of a singly linked list, reverse the list, and return the reversed list''s head.\n\n---\n\n**Example 1:**\n```\nInput:  head = [1,2,3,4,5]\nOutput: [5,4,3,2,1]\n```\n\n**Example 2:**\n```\nInput:  head = [1,2]\nOutput: [2,1]\n```\n\n**Example 3:**\n```\nInput:  head = []\nOutput: []\n```\n\n---\n\n**Constraints:**\n- The number of nodes in the list is in the range `[0, 5000]`.\n- `-5000 <= Node.val <= 5000`',
  '{"python": "# Definition for singly-linked list.\n# class ListNode:\n#     def __init__(self, val=0, next=None):\n#         self.val = val\n#         self.next = next\n\nfrom typing import Optional\n\nclass Solution:\n    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:\n        # Your solution here\n        pass", "javascript": "/**\n * Definition for singly-linked list.\n * function ListNode(val, next) {\n *     this.val = (val===undefined ? 0 : val)\n *     this.next = (next===undefined ? null : next)\n * }\n */\n/**\n * @param {ListNode} head\n * @return {ListNode}\n */\nvar reverseList = function(head) {\n    // Your solution here\n};", "java": "/**\n * Definition for singly-linked list.\n * public class ListNode {\n *     int val;\n *     ListNode next;\n *     ListNode() {}\n *     ListNode(int val) { this.val = val; }\n *     ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n * }\n */\nclass Solution {\n    public ListNode reverseList(ListNode head) {\n        // Your solution here\n        return null;\n    }\n}", "cpp": "/**\n * struct ListNode {\n *     int val;\n *     ListNode *next;\n *     ListNode() : val(0), next(nullptr) {}\n *     ListNode(int x) : val(x), next(nullptr) {}\n *     ListNode(int x, ListNode *next) : val(x), next(next) {}\n * };\n */\nclass Solution {\npublic:\n    ListNode* reverseList(ListNode* head) {\n        // Your solution here\n        return nullptr;\n    }\n};"}',
  'CORRECT APPROACH: Iterative three-pointer method. Initialize prev = None, curr = head. While curr is not None: save next_node = curr.next, set curr.next = prev, advance prev = curr, advance curr = next_node. Return prev (the new head).\n\nWHAT COUNTS AS CORRECT: Operates in-place. O(N) time, O(1) space. Handles empty list (returns None/null). Handles single-node list. Returns the correct new head (prev after the loop).\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Collecting values into an array and building a new list: O(N) extra space — misses the pattern lesson. Ask: "Can you do this without any extra data structure?"\n- Losing the reference to curr.next before redirecting (causes the list to be cut): ask the student to trace through what happens to the rest of the list.\n- Returning curr (null) instead of prev after the loop.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'linked-list' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Before redirecting curr.next to prev, why must you first save a reference to curr.next in a temporary variable?',
  '["You do not need to save it — the original curr.next is still accessible via prev.next after the redirect.", "If you redirect curr.next before saving it, you lose the only pointer to the rest of the list and cannot advance curr forward.", "You need to save it only for lists with more than two nodes; single-node and two-node lists do not require this step.", "You save it so you can restore the original list if the reversal needs to be undone later."]',
  1,
  'Once you execute curr.next = prev, the pointer to the rest of the list is overwritten. There is no other reference to what used to be curr.next — the remainder of the original list becomes unreachable. Saving curr.next = next_node before the redirect preserves that reference so you can advance curr = next_node in the next line. Forgetting this step silently truncates the list after the first reversal step.'
FROM public.problems WHERE slug = 'reverse-linked-list' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'After the while loop terminates (curr is None), which pointer holds the new head of the reversed list — prev or curr?',
  '["curr — it points to the last node processed, which is now the first node.", "prev — it holds the last non-null node encountered, which becomes the new head after reversal.", "head — the original head pointer automatically updates to the new head.", "next_node — the temporary pointer ends up at the new head position."]',
  1,
  'The loop exits when curr becomes None (we have passed the end of the original list). At that point prev is pointing to what was the last node of the original list — which is the first node of the reversed list — the new head. curr is None and is useless as a return value. Returning curr (None) is a common bug that makes the function appear to return an empty list.'
FROM public.problems WHERE slug = 'reverse-linked-list' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What is the space complexity of the iterative reversal, and why is it superior to collecting node values into an array?',
  '["Both approaches use O(N) space — the iterative approach stores N pointer values during execution.", "The iterative approach uses O(1) space (three pointer variables); the array approach uses O(N) space to store all node values.", "The iterative approach uses O(log N) space due to the implicit recursion stack.", "Space complexity is the same, but the array approach is faster because array writes are cheaper than pointer updates."]',
  1,
  'The iterative approach uses exactly three pointer variables (prev, curr, next_node) regardless of list length: O(1) extra space. The array approach copies all N values out of the list and stores them, then potentially allocates a new list: O(N) space. For a linked list with millions of nodes, O(1) vs O(N) space is a meaningful practical difference, and the in-place approach is the expected solution in a systems-level interview context.'
FROM public.problems WHERE slug = 'reverse-linked-list' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Linked List Cycle',
  'linked-list-cycle',
  'easy',
  'The naive approach to cycle detection is to store every visited node in a hash set and check for revisits. That works, but it requires O(N) extra space.\n\nFloyd''s Cycle Detection algorithm (the "tortoise and hare") solves the problem in O(1) space by using two pointers at different speeds. A slow pointer advances one step at a time; a fast pointer advances two. If there is a cycle, the fast pointer will eventually lap the slow pointer and they will meet. If there is no cycle, the fast pointer will fall off the end of the list.\n\nThis is the canonical linked-list "runner technique" problem. The two-speed pointer pattern also finds the middle of a linked list and is the first step in palindrome-linked-list detection. Learn it by understanding why two pointers at different speeds must meet inside a cycle.',
  '## Linked List Cycle\n\nGiven the head of a linked list, determine if the linked list has a cycle in it.\n\nThere is a cycle in a linked list if there is some node in the list that can be reached again by continuously following the `next` pointer.\n\nReturn `true` if there is a cycle, `false` otherwise.\n\n---\n\n**Example 1:**\n```\nInput:  head = [3,2,0,-4], pos = 1\nOutput: true\nExplanation: The tail connects back to node at index 1.\n```\n\n**Example 2:**\n```\nInput:  head = [1,2], pos = 0\nOutput: true\n```\n\n**Example 3:**\n```\nInput:  head = [1], pos = -1\nOutput: false\n```\n\n---\n\n**Constraints:**\n- The number of nodes in the list is in the range `[0, 10^4]`.\n- `-10^5 <= Node.val <= 10^5`\n- `pos` is -1 or a valid index (not passed to your function — it only appears in examples).',
  '{"python": "from typing import Optional\n\n# class ListNode:\n#     def __init__(self, x):\n#         self.val = x\n#         self.next = None\n\nclass Solution:\n    def hasCycle(self, head: Optional[ListNode]) -> bool:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {ListNode} head\n * @return {boolean}\n */\nvar hasCycle = function(head) {\n    // Your solution here\n};", "java": "public class Solution {\n    public boolean hasCycle(ListNode head) {\n        // Your solution here\n        return false;\n    }\n}", "cpp": "class Solution {\npublic:\n    bool hasCycle(ListNode *head) {\n        // Your solution here\n        return false;\n    }\n};"}',
  'CORRECT APPROACH (Floyd''s algorithm): Initialize slow = head, fast = head. While fast is not None and fast.next is not None: advance slow = slow.next, advance fast = fast.next.next. If slow == fast, return True. Return False after the loop.\n\nWHAT COUNTS AS CORRECT: Uses two pointers at different speeds (slow 1x, fast 2x). Checks fast and fast.next before advancing to prevent null pointer errors. Returns True when they meet inside a cycle. Returns False when fast reaches the end. Time O(N), space O(1).\n\nACCEPTABLE ALTERNATIVE (hash set): correct and O(N) time but O(N) space — acknowledge it works, then ask if they can solve it with O(1) space to steer toward Floyd''s.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Checking only fast (not fast.next) before the double advance — causes null pointer dereference.\n- Initializing slow and fast at different starting positions unnecessarily.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'linked-list' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'In Floyd''s algorithm the loop condition checks both fast != None and fast.next != None. Why must you check fast.next in addition to fast?',
  '["You don''t need to — checking fast != None is sufficient because fast.next is always valid when fast is valid.", "fast.next.next is the next position of the fast pointer; if fast.next is None then fast.next.next would cause a null pointer dereference.", "You check fast.next to verify the fast pointer hasn''t lapped the slow pointer yet.", "fast.next is checked to confirm the list has at least two nodes before starting."]',
  1,
  'The fast pointer advances as fast = fast.next.next. If fast.next is None, then fast.next.next is a null dereference — a runtime crash in Java/C++ or an AttributeError in Python. Checking fast.next != None before performing the double advance prevents this. The list ends when either fast is None (even-length acyclic list) or fast.next is None (odd-length acyclic list); you must handle both termination cases.'
FROM public.problems WHERE slug = 'linked-list-cycle' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why does the fast pointer inevitably catch the slow pointer if a cycle exists?',
  '["It doesn''t — there are cycle configurations where the fast pointer overtakes the slow pointer without ever equaling it.", "Inside the cycle, the fast pointer gains one node on the slow pointer per iteration; the gap closes to zero after at most cycle-length iterations.", "The fast pointer moves at exactly double the speed, so it reaches the cycle entry before the slow pointer and waits there.", "The pointers meet only if the cycle length is even; odd-length cycles are not detected by this algorithm."]',
  1,
  'Consider the relative motion inside the cycle. Each iteration, slow moves +1 and fast moves +2, so the gap between them changes by +1 per iteration (fast gains on slow). Whether the gap starts at 1 or at cycle_length-1, it reaches 0 after at most cycle_length steps. The fast pointer never "jumps over" the slow pointer from behind because the gap decreases by exactly 1 each step — it must pass through 0. This guarantees they meet inside the cycle.'
FROM public.problems WHERE slug = 'linked-list-cycle' LIMIT 1;


-- ============================================================
-- PATTERN: Trees
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Invert Binary Tree',
  'invert-binary-tree',
  'easy',
  'Inverting a binary tree means swapping the left and right child of every node — producing a mirror image. At first this sounds complex, but the recursive structure of the tree makes it remarkably clean.\n\nThe key insight: if you recursively invert the left subtree and recursively invert the right subtree, all you have left to do at the current node is swap the two subtree roots. The recursion handles the rest. Base case: a null node is already "inverted" — return immediately.\n\nThis problem demonstrates the power of trusting your recursive definition. You do not need to think about the entire tree at once; you only need to define what the function does for one node. The rest follows automatically from the recursive structure.\n\nThis is also a perfect problem for comparing DFS (recursive or iterative with a stack) versus BFS (iterative with a queue) — both produce correct results.',
  '## Invert Binary Tree\n\nGiven the root of a binary tree, invert the tree, and return its root.\n\n---\n\n**Example 1:**\n```\nInput:  root = [4,2,7,1,3,6,9]\nOutput: [4,7,2,9,6,3,1]\n```\n\n**Example 2:**\n```\nInput:  root = [2,1,3]\nOutput: [2,3,1]\n```\n\n**Example 3:**\n```\nInput:  root = []\nOutput: []\n```\n\n---\n\n**Constraints:**\n- The number of nodes in the tree is in the range `[0, 100]`.\n- `-100 <= Node.val <= 100`',
  '{"python": "from typing import Optional\n\n# class TreeNode:\n#     def __init__(self, val=0, left=None, right=None):\n#         self.val = val\n#         self.left = left\n#         self.right = right\n\nclass Solution:\n    def invertTree(self, root: Optional[TreeNode]) -> Optional[TreeNode]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {TreeNode} root\n * @return {TreeNode}\n */\nvar invertTree = function(root) {\n    // Your solution here\n};", "java": "class Solution {\n    public TreeNode invertTree(TreeNode root) {\n        // Your solution here\n        return null;\n    }\n}", "cpp": "class Solution {\npublic:\n    TreeNode* invertTree(TreeNode* root) {\n        // Your solution here\n        return nullptr;\n    }\n};"}',
  'CORRECT APPROACH: Recursive DFS. Base case: if root is None, return None. Recursive case: swap root.left and root.right (in any order, including simultaneous swap). Recursively call invertTree on root.left. Recursively call invertTree on root.right. Return root.\n\nWHAT COUNTS AS CORRECT: Every node has its children swapped. Returns the root. Handles empty tree (null input). Time O(N) — visits every node once. Space O(H) where H is the height of the tree (recursion stack).\n\nALTERNATIVE: BFS with a queue — also correct and O(N) time/space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Only swapping the top-level children without recursing — produces incorrect partial inversion.\n- Forgetting the base case — causes a null pointer dereference.\n- Swapping values instead of child pointers — works for this problem but is not the canonical structural inversion.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'trees' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'A student writes a solution that swaps root.left and root.right but does NOT recursively invert the subtrees. What output does this produce for the tree [4,2,7,1,3,6,9]?',
  '["The fully correct mirror image [4,7,2,9,6,3,1].", "A partially inverted tree: [4,7,2,...] where the top-level children are swapped but the grandchildren remain in their original positions.", "An error — swapping without recursion causes a null pointer exception.", "The original tree unchanged — swapping without recursion is a no-op."]',
  1,
  'Swapping only at the root produces [4,7,2,...] — nodes 7 and 2 are correctly exchanged. But node 7 still has children 6 (left) and 9 (right) in original order, and node 2 still has children 1 (left) and 3 (right) in original order. The correct mirror has 7 with children 9 (left) and 6 (right). Only by recursing into each subtree do you ensure every level is inverted.'
FROM public.problems WHERE slug = 'invert-binary-tree' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What is the space complexity of the recursive inversion, and what determines it?',
  '["O(1) — no extra data structures are allocated during recursion.", "O(N) in all cases — the recursion stack always holds N frames simultaneously.", "O(H) where H is the height of the tree — the recursion stack depth equals the deepest path from root to leaf.", "O(log N) — binary trees always have logarithmic height."]',
  2,
  'Each recursive call adds one frame to the call stack. The maximum number of simultaneous frames is equal to the depth of the deepest path — the height H of the tree. For a balanced tree H = O(log N), giving O(log N) space. For a skewed (degenerate) tree H = O(N), giving O(N) space. The correct answer expresses both: O(H). "O(N) in all cases" is too pessimistic for balanced trees; "O(log N) always" is too optimistic for skewed trees.'
FROM public.problems WHERE slug = 'invert-binary-tree' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What is the base case for the recursive invertTree function, and what happens if you omit it?',
  '["The base case is when both children are null leaves; omitting it only affects leaf nodes.", "The base case is when root is null; omitting it causes the function to dereference null when it tries to access root.left or root.right on a null node.", "There is no base case needed — the recursion terminates naturally when it runs out of nodes.", "The base case is when the tree has exactly one node; omitting it only affects single-node trees."]',
  1,
  'The base case is: if root is None (null), return None immediately. Every recursive call eventually reaches a null child (leaf nodes have null children). Without this check, the recursive call on a null node would attempt to access null.left — crashing with a NullPointerException or AttributeError. The base case is not optional; it is what prevents infinite recursion and null dereferences at the boundary of the tree.'
FROM public.problems WHERE slug = 'invert-binary-tree' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Maximum Depth of Binary Tree',
  'maximum-depth-binary-tree',
  'easy',
  'Maximum depth (also called height) of a binary tree is the number of nodes along the longest path from root to leaf. This is a pure tree recursion problem and the ideal second exercise after Invert Binary Tree.\n\nThe recursive insight: the depth of any tree is 1 (for the current node) plus the maximum depth of its left or right subtree — whichever is deeper. Base case: an empty tree (null node) has depth 0.\n\nThis recurrence maps almost directly to code. You do not need to think about how traversal works internally; trust that the recursive call returns the correct depth for each subtree and simply combine the results.\n\nUnderstanding this pattern is a prerequisite for problems like Balanced Binary Tree, Diameter of Binary Tree, and any problem that requires bottom-up aggregation of per-subtree information.',
  '## Maximum Depth of Binary Tree\n\nGiven the root of a binary tree, return its **maximum depth**.\n\nA binary tree''s maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.\n\n---\n\n**Example 1:**\n```\nInput:  root = [3,9,20,null,null,15,7]\nOutput: 3\n```\n\n**Example 2:**\n```\nInput:  root = [1,null,2]\nOutput: 2\n```\n\n---\n\n**Constraints:**\n- The number of nodes in the tree is in the range `[0, 10^4]`.\n- `-100 <= Node.val <= 100`',
  '{"python": "from typing import Optional\n\nclass Solution:\n    def maxDepth(self, root: Optional[TreeNode]) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {TreeNode} root\n * @return {number}\n */\nvar maxDepth = function(root) {\n    // Your solution here\n};", "java": "class Solution {\n    public int maxDepth(TreeNode root) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class Solution {\npublic:\n    int maxDepth(TreeNode* root) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Base case: if root is None, return 0. Recursive case: return 1 + max(maxDepth(root.left), maxDepth(root.right)).\n\nWHAT COUNTS AS CORRECT: Returns 0 for empty tree. Returns 1 for a single node. Correctly adds 1 for the current level. Uses max() to select the deeper subtree. Time O(N), space O(H).\n\nALTERNATIVE: BFS with level counting (iterative, O(N) time, O(W) space where W is max width) — also correct.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Returning max(left, right) without the +1: forgets to count the current node, returns 0 for single-node trees.\n- Using + instead of max: adds both depths instead of taking the larger one.\n- Returning max(left, right) + 1 where left/right are the child nodes rather than their depths: type error.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'trees' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'A student writes return max(maxDepth(root.left), maxDepth(root.right)) without adding 1. What does this return for a tree containing only the root node?',
  '["1 — correct, because the root is a leaf and max of two zeros is zero then plus one is one. Wait, no: there is no plus one.", "0 — both recursive calls return 0 (null children), max(0,0) is 0. The root node itself is not counted.", "2 — the function double-counts the root''s contributions from both subtrees.", "-1 — null nodes return -1 as a sentinel, and max(-1,-1) = -1."]',
  1,
  'For a single-node tree, root.left and root.right are both null. maxDepth(null) returns 0 (base case). max(0, 0) = 0. Without the +1, the root node itself is never counted. The correct formula is 1 + max(maxDepth(root.left), maxDepth(root.right)) — the 1 accounts for the current level. Missing +1 gives a depth of 0 for a single node and N-1 for a tree of depth N.'
FROM public.problems WHERE slug = 'maximum-depth-binary-tree' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why does the recursive solution use max() to combine the depths of the left and right subtrees rather than, say, sum()?',
  '["Using max() is just a convention; sum() would produce the same result because one of the two subtrees is always empty.", "The depth of a tree is the length of the longest root-to-leaf path. At each node you follow either left or right — not both — so you take the maximum of the two options, not their sum.", "max() is used because sum() would overflow for large trees.", "sum() is used for counting all nodes; max() is used only when the tree is balanced."]',
  1,
  'The depth question asks: what is the longest single path from root to leaf? At any given node, that path goes either left or right. The depth of the subtree in that direction determines the local contribution to the total depth. You want the larger of the two options, not the total of both. sum() would combine depths from distinct paths that are never actually traversed together — producing a meaningless aggregate.'
FROM public.problems WHERE slug = 'maximum-depth-binary-tree' LIMIT 1;


-- ============================================================
-- PATTERN: Tries
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Implement Trie',
  'implement-trie',
  'medium',
  'A hash map can tell you if a word is in a set in O(K) time, but it cannot efficiently answer "does any word start with this prefix?" without scanning all stored words.\n\nA Trie (prefix tree) is designed exactly for this. Each node represents a character in a path from the root. The path from root to any node spells out a prefix. A boolean flag (is_end) marks nodes that complete a full word.\n\nInsert: walk the character path, creating new nodes as needed. Set is_end = True on the last character.\nSearch: walk the character path. If any character is missing, return False. Return is_end at the final node.\nStartsWith: walk the character path. Return True if the full prefix path exists — is_end does not matter.\n\nThis data structure is the foundation for autocomplete, spell checkers, and IP routing tables. Understanding it cold opens up a significant subset of string-heavy interview problems.',
  '## Implement Trie (Prefix Tree)\n\nA **trie** (pronounced as "try") or **prefix tree** is a tree data structure used to efficiently store and retrieve keys in a dataset of strings.\n\nImplement the `Trie` class:\n- `Trie()` initializes the trie object.\n- `void insert(String word)` inserts the string `word` into the trie.\n- `boolean search(String word)` returns `true` if the string `word` is in the trie (i.e., was inserted before), and `false` otherwise.\n- `boolean startsWith(String prefix)` returns `true` if there is a previously inserted string that has the prefix `prefix`, and `false` otherwise.\n\n---\n\n**Example:**\n```\nInput:\n["Trie", "insert", "search", "search", "startsWith", "insert", "search"]\n[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["app"]]\n\nOutput: [null, null, true, false, true, null, true]\n```\n\n---\n\n**Constraints:**\n- `1 <= word.length, prefix.length <= 2000`\n- `word` and `prefix` consist only of lowercase English letters.\n- At most `3 * 10^4` calls total to `insert`, `search`, and `startsWith`.',
  '{"python": "class TrieNode:\n    def __init__(self):\n        self.children = {}\n        self.is_end = False\n\nclass Trie:\n\n    def __init__(self):\n        # Your solution here\n        pass\n\n    def insert(self, word: str) -> None:\n        # Your solution here\n        pass\n\n    def search(self, word: str) -> bool:\n        # Your solution here\n        pass\n\n    def startsWith(self, prefix: str) -> bool:\n        # Your solution here\n        pass", "javascript": "class TrieNode {\n    constructor() {\n        this.children = {};\n        this.isEnd = false;\n    }\n}\n\nclass Trie {\n    constructor() {\n        // Your solution here\n    }\n\n    insert(word) {\n        // Your solution here\n    }\n\n    search(word) {\n        // Your solution here\n    }\n\n    startsWith(prefix) {\n        // Your solution here\n    }\n}", "java": "import java.util.*;\n\nclass Trie {\n    // Your solution here\n    public Trie() {}\n    public void insert(String word) {}\n    public boolean search(String word) { return false; }\n    public boolean startsWith(String prefix) { return false; }\n}", "cpp": "class Trie {\npublic:\n    Trie() {}\n    void insert(string word) {}\n    bool search(string word) { return false; }\n    bool startsWith(string prefix) { return false; }\n};"}',
  'CORRECT APPROACH: TrieNode has a children map (char -> TrieNode) and an is_end boolean. Trie has a root TrieNode.\n\ninsert(word): start at root, walk each character. If the character is not in current.children create a new TrieNode for it. Advance current = current.children[char]. After the loop set current.is_end = True.\n\nsearch(word): start at root, walk each character. If any character is missing return False. Return current.is_end after the loop.\n\nstartsWith(prefix): same walk as search, but return True after the loop (do not check is_end).\n\nWHAT COUNTS AS CORRECT: All three methods implemented correctly. search correctly requires is_end. startsWith does NOT require is_end. insert creates missing nodes. Time O(K) per operation where K = word/prefix length.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- startsWith checking is_end (incorrectly rejecting valid prefixes that are not full words).\n- search not checking is_end (accepting prefixes as full words).\n- Using an array of size 26 instead of a dict is also correct for lowercase letters — acknowledge it.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'tries' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The Trie contains only "apple". search("app") should return false but startsWith("app") should return true. What distinguishes these two operations at the node level?',
  '["Nothing — both operations traverse the same path and return the same boolean.", "search checks the is_end flag on the final node; startsWith returns true as soon as the path exists without checking is_end.", "startsWith checks is_end and search does not — the reverse of what most people expect.", "search returns the number of words with that prefix; startsWith returns a boolean."]',
  1,
  'Both operations walk the character path "a" -> "p" -> "p". The node at the final "p" of "app" has is_end = False (because "app" was never inserted; only "apple" was). search("app") returns is_end at that node = False. startsWith("app") simply checks that the path "a"->"p"->"p" exists in the trie and returns True — the is_end flag is irrelevant for a prefix query.'
FROM public.problems WHERE slug = 'implement-trie' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Each TrieNode stores a children map from character to TrieNode. What is the time complexity of insert, search, and startsWith in terms of the word or prefix length K?',
  '["O(N) where N is the total number of words inserted — each operation must search through all stored words.", "O(K) for each operation — you traverse exactly K nodes regardless of how many words are stored.", "O(K log N) — the children map uses a balanced BST internally, adding a log factor.", "O(K * 26) — each node has 26 potential children that must be checked."]',
  1,
  'Each operation takes exactly one step per character in the word or prefix. Whether the trie stores 10 words or 10 million, searching for "apple" takes exactly 5 steps — one per character. This is the core advantage of a Trie over a hash set for prefix queries: O(K) per operation independent of the dataset size N. The children map lookup is O(1) average (hash map), not O(log 26) — so no log factor appears.'
FROM public.problems WHERE slug = 'implement-trie' LIMIT 1;


-- ============================================================
-- PATTERN: Heap / Priority Queue
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Kth Largest Element in a Stream',
  'kth-largest-element-stream',
  'easy',
  'Maintaining the K-th largest element in a data stream is the textbook min-heap problem. The naive approach — sort after every insertion — is O(N log N) per add. That is prohibitively expensive for a stream.\n\nThe key insight: you do not need to track all elements. You only need to track the top K. A min-heap of exactly size K does exactly this. The smallest element in the heap is the K-th largest overall (everything larger is in the heap; everything smaller has been evicted).\n\nOn each add: push the new element, then if the heap exceeds size K, pop the minimum. The heap top is always the K-th largest. Each add operation is O(log K), not O(N log N).\n\nThis pattern generalizes to any "find K-th" or "maintain top K" streaming problem, which appear frequently in system design and algorithm rounds at major companies.',
  '## Kth Largest Element in a Stream\n\nDesign a class to find the `k`th largest element in a stream. Note that it is the `k`th largest element in the sorted order, not the `k`th distinct element.\n\nImplement `KthLargest` class:\n- `KthLargest(int k, int[] nums)` initializes the object with the integer `k` and the stream of integers `nums`.\n- `int add(int val)` appends the integer `val` to the stream and returns the element representing the `k`th largest element in the stream.\n\n---\n\n**Example:**\n```\nInput:\n["KthLargest", "add", "add", "add", "add", "add"]\n[[3, [4,5,8,2]], [3], [5], [10], [9], [4]]\n\nOutput: [null, 4, 5, 5, 8, 8]\n```\n\n---\n\n**Constraints:**\n- `1 <= k <= 10^4`\n- `0 <= nums.length <= 10^4`\n- `-10^4 <= nums[i] <= 10^4`\n- `-10^4 <= val <= 10^4`\n- At most `10^4` calls to `add`.\n- It is guaranteed that there will always be at least `k` elements when `add` is called.',
  '{"python": "import heapq\nfrom typing import List\n\nclass KthLargest:\n\n    def __init__(self, k: int, nums: List[int]):\n        # Your solution here\n        pass\n\n    def add(self, val: int) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number} k\n * @param {number[]} nums\n */\nvar KthLargest = function(k, nums) {\n    // Your solution here (use a min-heap library or implement manually)\n};\n\n/**\n * @param {number} val\n * @return {number}\n */\nKthLargest.prototype.add = function(val) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass KthLargest {\n    public KthLargest(int k, int[] nums) {\n        // Your solution here\n    }\n    public int add(int val) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class KthLargest {\npublic:\n    KthLargest(int k, vector<int>& nums) {\n        // Your solution here\n    }\n    int add(int val) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Store k and initialize a min-heap. In __init__, call add() for each element in nums (or push and trim directly). In add(val): push val onto the heap. If len(heap) > k, pop the minimum. Return heap[0] (the K-th largest).\n\nWHAT COUNTS AS CORRECT: Uses a min-heap of size at most k. Returns heap[0] after each add. Handles initialization by processing nums through add or directly trimming to k. Each add is O(log k). Space O(k).\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Using a max-heap of all elements: correct but O(N) space and O(log N) per add instead of O(log K).\n- Sorting after each add: O(N log N) per add — not scalable for a stream.\n- Forgetting to trim the heap after push: heap grows unboundedly and heap[0] is not the K-th largest.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'heap-priority-queue' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The solution uses a min-heap of exactly size k and returns heap[0] as the answer. Why does the minimum of a size-k min-heap equal the k-th largest element overall?',
  '["It doesn''t — the minimum of the heap is the smallest element seen, not the k-th largest.", "The heap contains the k largest elements seen so far. The smallest of those k elements is the k-th largest overall — everything outside the heap is smaller.", "The heap contains the k smallest elements; the minimum is therefore the overall minimum.", "heap[0] is the k-th largest because Python''s heapq internally sorts by rank."]',
  1,
  'The heap invariant: after each add + trim, the heap holds exactly the k largest elements seen so far. The minimum of those k elements is the k-th largest globally — by definition, exactly k elements are >= it (itself and the k-1 larger heap members), and everything evicted was smaller. heap[0] in a min-heap is the smallest element in the heap, which is the k-th largest element overall.'
FROM public.problems WHERE slug = 'kth-largest-element-stream' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Each call to add() pushes one element and may pop one element. What is the time complexity of add(), and why is it better than sorting after each insertion?',
  '["O(N) per add — the heap must re-examine all stored elements after each push.", "O(log k) per add — heap push and pop each take O(log k) where k is the fixed heap size.", "O(k) per add — trimming the heap requires scanning all k elements.", "O(1) per add — the heap[0] access dominates and is O(1)."]',
  1,
  'A min-heap of size k maintains its heap property via bubble-up on push and bubble-down on pop, both O(log k). Since k is a fixed constant relative to the stream, this is O(log k) per add regardless of how many total elements have been processed. Sorting all seen elements after each insertion is O(N log N) where N grows with the stream — far worse for large or infinite streams.'
FROM public.problems WHERE slug = 'kth-largest-element-stream' LIMIT 1;


-- ============================================================
-- PATTERN: Backtracking
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Subsets',
  'subsets',
  'medium',
  'Generating all subsets of a set is the purest introduction to backtracking. There are 2^N subsets — you cannot avoid visiting all of them — but backtracking gives you a systematic, recursive way to do it without duplication.\n\nThe key insight: for each element, you make a binary choice — include it or exclude it. Backtracking encodes this by exploring both branches: (1) add the element, recurse, then (2) remove the element (backtrack) and recurse without it. At every recursive call you record the current partial subset as a valid result.\n\nCompared to iterative bit manipulation (also valid), backtracking generalizes directly to harder problems — Subsets II (with duplicates), Combination Sum, Permutations — where bit manipulation breaks down. Master the backtracking template here so you can adapt it later.',
  '## Subsets\n\nGiven an integer array `nums` of **unique** elements, return all possible subsets (the power set).\n\nThe solution set must **not** contain duplicate subsets. Return the solution in **any order**.\n\n---\n\n**Example 1:**\n```\nInput:  nums = [1,2,3]\nOutput: [[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]\n```\n\n**Example 2:**\n```\nInput:  nums = [0]\nOutput: [[],[0]]\n```\n\n---\n\n**Constraints:**\n- `1 <= nums.length <= 10`\n- `-10 <= nums[i] <= 10`\n- All elements of `nums` are unique.',
  '{"python": "from typing import List\n\nclass Solution:\n    def subsets(self, nums: List[int]) -> List[List[int]]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} nums\n * @return {number[][]}\n */\nvar subsets = function(nums) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public List<List<Integer>> subsets(int[] nums) {\n        // Your solution here\n        return new ArrayList<>();\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<vector<int>> subsets(vector<int>& nums) {\n        // Your solution here\n        return {};\n    }\n};"}',
  'CORRECT APPROACH: Define a recursive helper backtrack(start, current) where start is the next index to consider and current is the partial subset. At the start of each call, add a copy of current to the result. Then for each index i from start to end: append nums[i] to current, recurse with backtrack(i+1, current), then pop nums[i] (the backtrack step).\n\nWHAT COUNTS AS CORRECT: Produces all 2^N subsets including the empty set. No duplicate subsets. Each recursive call appends a copy of current (not a reference). The backtrack (pop) step is present. Time O(N * 2^N) to generate all subsets, Space O(N) for the recursion depth.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Appending current directly without copying: all entries in the result will point to the same mutated list, producing wrong output. Ask: "What is the state of ''current'' by the time the recursion unwinds?"\n- Missing the backtrack (pop) step: elements accumulate incorrectly across branches.\n- Not including the empty subset: the base case should record current even before iterating.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'backtracking' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'In the backtracking template, after the recursive call you pop the last element from current. Why is this "undo" step essential?',
  '["It is not essential — the pop is an optimization that prevents memory buildup, but the algorithm produces correct output without it.", "Without the pop, the element added before the recursive call remains in current for the next branch, incorrectly combining elements from different choices.", "The pop is needed to ensure the recursion terminates; without it the function runs indefinitely.", "The pop keeps the result list sorted; without it subsets appear in a different order."]',
  1,
  'Consider generating subsets of [1,2,3]. After recursing with 1 in current, you backtrack to try the branch without 1. If you do not pop 1, the "without-1" branch starts with 1 already in current and generates subsets like [1,2] instead of [2]. The pop literally undoes the choice made before the recursion, restoring current to the state it was in before this branch, enabling the correct exploration of the alternative branch.'
FROM public.problems WHERE slug = 'subsets' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Your backtracking function appends current (the list object) to the result directly instead of appending a copy. What bug does this introduce?',
  '["No bug — lists are immutable in Python so appending current is safe.", "All entries in the result end up pointing to the same list object. As current is mutated during backtracking all previously recorded subsets reflect its final state — the empty list — at the end of execution.", "The result will contain duplicate subsets because the same object is added multiple times.", "The function raises a RecursionError because the result grows faster than the recursion stack can handle."]',
  1,
  'In Python (and Java ArrayList, etc.), appending a mutable list to a result list stores a reference to that list, not a snapshot. As the backtracking function continues to mutate current, every previously appended entry reflects the mutations too. By the time execution finishes, current is empty (all elements have been popped), and every entry in result points to the same empty list. The fix is result.append(current[:]) or result.append(list(current)) — a fresh copy at the moment of recording.'
FROM public.problems WHERE slug = 'subsets' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For an input of N unique elements, how many subsets does your function produce, and what is the overall time complexity?',
  '["N subsets, O(N^2) time — the double loop structure creates quadratic work.", "2^N subsets, O(N * 2^N) time — each of the 2^N subsets takes O(N) time to copy into the result.", "N! subsets, O(N!) time — backtracking explores all orderings.", "2^N subsets, O(2^N) time — subset generation is O(1) per subset."]',
  1,
  'Each of the N elements is either included or excluded independently: 2^N total subsets. Recording each subset requires copying the current list, which takes O(N) time in the worst case (a subset of length N). Summing over all 2^N subsets gives O(N * 2^N) total time. This is optimal — you cannot generate 2^N distinct subsets faster than O(2^N) since you must output them all.'
FROM public.problems WHERE slug = 'subsets' LIMIT 1;


-- ============================================================
-- PATTERN: Graphs
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Number of Islands',
  'number-of-islands',
  'medium',
  'Number of Islands is the definitive graph connectivity problem. The grid is an implicit graph: each cell is a node, and two adjacent cells (up, down, left, right) are connected by an edge. An "island" is a connected component of ''1'' cells.\n\nCounting connected components is a textbook DFS or BFS application. For each unvisited ''1'' cell, launch a DFS/BFS that visits every reachable ''1'' cell in the same island and marks them so they are not counted again. Each new DFS/BFS launch corresponds to a new island. Count the launches.\n\nThis problem teaches the universal connected-components template: iterate over all nodes, skip visited ones, and launch a traversal for each unvisited node you care about. That template directly transfers to problems on explicit graphs (adjacency lists) later in the curriculum.',
  '## Number of Islands\n\nGiven an `m x n` 2D binary grid `grid` which represents a map of `''1''`s (land) and `''0''`s (water), return the number of islands.\n\nAn **island** is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. You may assume all four edges of the grid are surrounded by water.\n\n---\n\n**Example 1:**\n```\nInput:\ngrid = [\n  ["1","1","1","1","0"],\n  ["1","1","0","1","0"],\n  ["1","1","0","0","0"],\n  ["0","0","0","0","0"]\n]\nOutput: 1\n```\n\n**Example 2:**\n```\nInput:\ngrid = [\n  ["1","1","0","0","0"],\n  ["1","1","0","0","0"],\n  ["0","0","1","0","0"],\n  ["0","0","0","1","1"]\n]\nOutput: 3\n```\n\n---\n\n**Constraints:**\n- `m == grid.length`, `n == grid[i].length`\n- `1 <= m, n <= 300`\n- `grid[i][j]` is `''0''` or `''1''`.',
  '{"python": "from typing import List\n\nclass Solution:\n    def numIslands(self, grid: List[List[str]]) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {character[][]} grid\n * @return {number}\n */\nvar numIslands = function(grid) {\n    // Your solution here\n};", "java": "class Solution {\n    public int numIslands(char[][] grid) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class Solution {\npublic:\n    int numIslands(vector<vector<char>>& grid) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Iterate over every cell (i, j). If grid[i][j] == "1", increment island count and launch a DFS: mark grid[i][j] = "0" (visited in-place), then recursively visit all four neighbors that are in bounds and equal to "1".\n\nWHAT COUNTS AS CORRECT: Counts the correct number of connected components. Marks visited cells (either by mutating the grid to "0" or by using a separate visited set). Handles the 4-directional adjacency correctly (not 8-directional). Time O(M*N), space O(M*N) in the worst case for the recursion stack.\n\nALTERNATIVE: BFS with a queue is also correct — same complexity.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Not marking cells as visited before recursing: causes infinite recursion (cycle between two adjacent ''1'' cells).\n- Using 8-directional adjacency (including diagonals): changes what counts as connected — the problem specifies 4-directional.\n- Forgetting bounds checking before accessing grid[i][j].\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'graphs' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'In the DFS approach you mark grid[i][j] = "0" before recursing into neighbors. What happens if you forget this step?',
  '["Nothing — the outer loop skips already-processed cells anyway.", "The DFS enters an infinite loop (or hits a recursion limit): cell A visits cell B, which visits cell A, which visits cell B, indefinitely.", "The island count is doubled because each cell is counted from both directions.", "The grid is left unmodified, which is required by the problem constraints."]',
  1,
  'Consider two adjacent land cells A and B. DFS from A visits B. B then tries to visit A — which is still "1" because it was not marked. A visits B again. This mutual visitation cycle continues until the call stack overflows. Marking grid[i][j] = "0" (or recording in a visited set) before recursing breaks the cycle: when B tries to visit A, it finds "0" and stops. This is the "mark before recurse" invariant for graph DFS.'
FROM public.problems WHERE slug = 'number-of-islands' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What are the time and space complexities of the DFS solution for a grid of M rows and N columns?',
  '["O(M + N) time and O(1) space — only the grid boundaries are processed.", "O(M * N) time and O(M * N) space — every cell is visited at most once; the recursion stack can hold up to M*N frames for a fully connected grid.", "O((M * N)^2) time — each DFS call re-scans the entire grid.", "O(M * N) time and O(min(M,N)) space — the recursion depth is bounded by the shorter dimension."]',
  1,
  'Each cell is visited at most once (marked on first visit). Total work across all DFS calls is O(M*N). For space: the recursion stack depth equals the length of the current DFS path. In the worst case (a single snake-shaped island covering the entire grid), the stack holds O(M*N) frames simultaneously. O(min(M,N)) would be true only for a specific grid shape — O(M*N) is the correct worst-case bound.'
FROM public.problems WHERE slug = 'number-of-islands' LIMIT 1;


-- ============================================================
-- PATTERN: 1-D Dynamic Programming
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Climbing Stairs',
  'climbing-stairs',
  'easy',
  'You can climb 1 or 2 steps at a time. How many distinct ways can you reach step N?\n\nThe naive recursive approach tries every combination: from step 0, either go to step 1 or step 2, then recurse. This gives 2^N calls — exponential. But the call tree is full of redundant work: the number of ways to reach step 5 is computed over and over.\n\nDynamic Programming eliminates this redundancy by memoizing (or bottom-up tabulating) results. The recurrence is simple: ways(n) = ways(n-1) + ways(n-2). To reach step n you either came from n-1 (took one step) or from n-2 (took two steps). This is exactly the Fibonacci recurrence.\n\nWith DP, the O(2^N) brute force becomes O(N) time. With two variables instead of an array, it becomes O(1) space. This is the gateway 1-D DP problem — nail the recurrence + base cases template before moving to harder variants.',
  '## Climbing Stairs\n\nYou are climbing a staircase. It takes `n` steps to reach the top.\n\nEach time you can either climb `1` or `2` steps. In how many distinct ways can you climb to the top?\n\n---\n\n**Example 1:**\n```\nInput:  n = 2\nOutput: 2\nExplanation: Two ways: (1,1) or (2).\n```\n\n**Example 2:**\n```\nInput:  n = 3\nOutput: 3\nExplanation: Three ways: (1,1,1), (1,2), (2,1).\n```\n\n---\n\n**Constraints:**\n- `1 <= n <= 45`',
  '{"python": "class Solution:\n    def climbStairs(self, n: int) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number} n\n * @return {number}\n */\nvar climbStairs = function(n) {\n    // Your solution here\n};", "java": "class Solution {\n    public int climbStairs(int n) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class Solution {\npublic:\n    int climbStairs(int n) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Bottom-up DP. Base cases: dp[1] = 1, dp[2] = 2. For i from 3 to n: dp[i] = dp[i-1] + dp[i-2]. Return dp[n]. Space-optimized version: maintain two variables prev2 = 1, prev1 = 2 and compute curr = prev1 + prev2 in a loop.\n\nWHAT COUNTS AS CORRECT: Correct for n=1 (return 1) and n=2 (return 2). Uses the recurrence dp[i] = dp[i-1] + dp[i-2]. O(N) time. O(1) space with rolling variables or O(N) space with full array — both acceptable.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Pure recursion without memoization: correct but O(2^N) time — ask about overlapping subproblems and what they could cache.\n- Wrong base cases: dp[0]=1, dp[1]=1 is also valid (Fibonacci shift) as long as the final answer for n is correct — trace through to verify.\n- Off-by-one: returning dp[n-1] instead of dp[n].\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'one-d-dp' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The recurrence dp[i] = dp[i-1] + dp[i-2] mirrors the Fibonacci sequence. Why is this the correct recurrence for Climbing Stairs?',
  '["Because climbing stairs is mathematically equivalent to sorting, and both reduce to Fibonacci.", "To reach step i you must have come from step i-1 (one-step) or step i-2 (two-step). The number of ways to reach i equals the sum of ways to reach each of those two predecessor steps.", "The recurrence is an approximation — the exact formula involves factorials but Fibonacci is used because it is simpler to implement.", "dp[i] = dp[i-1] + dp[i-2] only holds for i >= 4; the first three values are special-cased."]',
  1,
  'At step i, you can only arrive from step i-1 (you took one step) or from step i-2 (you took a two-step). Every valid path to step i-1 can be extended by one step to reach i; every valid path to step i-2 can be extended by a two-step. The total distinct paths to i is therefore dp[i-1] + dp[i-2]. This is exact, not an approximation, and it holds for all i >= 3.'
FROM public.problems WHERE slug = 'climbing-stairs' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'A plain recursive solution (without memoization) has O(2^N) time complexity. Where does this exponential factor come from?',
  '["Each recursive call makes two sub-calls, and the sub-problems do not overlap — so all 2^N branches are independent.", "Each recursive call makes two sub-calls, but the same sub-problem (e.g. climbStairs(5)) is recomputed many times across different branches — the total call count grows exponentially.", "The recursion depth is N, and 2^N comes from the 2 choices per depth level.", "The exponential factor only applies to even values of N; odd N runs in O(N) time."]',
  1,
  'climbStairs(n) calls climbStairs(n-1) and climbStairs(n-2). Both of those call their own pair of sub-problems, etc. Crucially, climbStairs(n-3) is reached via climbStairs(n-1)->climbStairs(n-3) AND via climbStairs(n-2)->climbStairs(n-3) — it is computed twice. This redundancy compounds: the total number of calls is O(2^N). Memoization stores each result the first time it is computed; subsequent calls return in O(1), reducing the total to O(N).'
FROM public.problems WHERE slug = 'climbing-stairs' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Instead of a full dp array, you can solve this with two integer variables (prev2 and prev1). What space complexity does this achieve and why?',
  '["O(N) — you still visit N values so N units of space are consumed.", "O(1) — at any point you only need the two immediately preceding values; all earlier values can be discarded.", "O(log N) — the rolling variables compress the array logarithmically.", "O(N) in the worst case because Python integers grow in memory as N increases."]',
  1,
  'The recurrence dp[i] = dp[i-1] + dp[i-2] only looks back two positions. Once dp[i] is computed, dp[i-2] is never needed again. Instead of storing all N values, you maintain exactly two variables — the previous two results — and update them in a rolling fashion. This reduces space from O(N) to O(2) = O(1). Python large-integer growth is a real but negligible constant-factor concern, not an asymptotic one.'
FROM public.problems WHERE slug = 'climbing-stairs' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'House Robber',
  'house-robber',
  'medium',
  'House Robber is the first 1-D DP problem with a constraint that makes the recurrence non-trivial: you cannot rob two adjacent houses. This forces you to think carefully about what state to carry forward.\n\nThe key insight: for each house i, you have two choices — rob it (taking nums[i] plus the best loot from houses 0..i-2) or skip it (taking whatever the best loot from houses 0..i-1 was). The recurrence is dp[i] = max(dp[i-1], nums[i] + dp[i-2]).\n\nLike Climbing Stairs, this only looks back two positions, so you can use two variables instead of an array. Unlike Climbing Stairs, the recurrence includes the current element''s value, not just a count — this is the key step that makes it a genuine optimization problem rather than a counting problem.',
  '## House Robber\n\nYou are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed. The only constraint stopping you from robbing all of them is that **adjacent houses have security systems connected**, and it will automatically contact the police if two adjacent houses are broken into on the same night.\n\nGiven an integer array `nums` representing the amount of money in each house, return the **maximum amount of money you can rob** without alerting the police.\n\n---\n\n**Example 1:**\n```\nInput:  nums = [1,2,3,1]\nOutput: 4\nExplanation: Rob house 1 (money = 1) then house 3 (money = 3). Total = 4.\n```\n\n**Example 2:**\n```\nInput:  nums = [2,7,9,3,1]\nOutput: 12\nExplanation: Rob houses 1, 3, 5 (money = 2 + 9 + 1 = 12).\n```\n\n---\n\n**Constraints:**\n- `1 <= nums.length <= 100`\n- `0 <= nums[i] <= 400`',
  '{"python": "from typing import List\n\nclass Solution:\n    def rob(self, nums: List[int]) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} nums\n * @return {number}\n */\nvar rob = function(nums) {\n    // Your solution here\n};", "java": "class Solution {\n    public int rob(int[] nums) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class Solution {\npublic:\n    int rob(vector<int>& nums) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Two-variable rolling DP. Initialize prev2 = 0, prev1 = 0. For each num in nums: curr = max(prev1, prev2 + num), then prev2 = prev1, prev1 = curr. Return prev1.\n\nEquivalently with a dp array: dp[0] = nums[0], dp[1] = max(nums[0], nums[1]). For i >= 2: dp[i] = max(dp[i-1], nums[i] + dp[i-2]). Return dp[n-1].\n\nWHAT COUNTS AS CORRECT: Handles single-element array (return nums[0]). Handles two-element array (return max of the two). Recurrence is max(dp[i-1], nums[i] + dp[i-2]). Time O(N), space O(1) or O(N).\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Greedy (always rob the largest non-adjacent house): does not work. Ask the student to find a counterexample like [2,1,1,2].\n- dp[i] = max(dp[i-1], nums[i] + dp[i-1]): adds nums[i] to the PREVIOUS total instead of the i-2 total — violates the adjacency constraint.\n- Off-by-one in base cases.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'one-d-dp' LIMIT 1;


INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For the input [2,1,1,2], a greedy approach of always picking the highest available non-adjacent house picks 2 (index 0), skips 1 (index 1), picks 1 (index 2), and cannot pick 2 (index 3 — adjacent to index 2). Total = 3. The DP solution returns 4. What does this reveal about greedy for this problem?',
  '["The greedy approach is correct; 3 is the right answer for [2,1,1,2].", "Greedy local optimality does not guarantee global optimality here. Picking the first 2 prevents picking the last 2, which would have yielded a higher total of 4.", "The greedy approach works for all inputs except those with repeated values at the boundaries.", "DP and greedy always produce the same result; the discrepancy is a calculation error."]',
  1,
  'The optimal strategy for [2,1,1,2] is to rob index 0 and index 3 for a total of 4. Greedy picks index 0 first (value 2), then the best available non-adjacent option, which is index 2 (value 1). At that point index 3 is adjacent to index 2 and cannot be robbed. Greedy locked in a suboptimal early choice. DP considers all future consequences before committing, which is why it finds the global optimum.'
FROM public.problems WHERE slug = 'house-robber' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'In the recurrence dp[i] = max(dp[i-1], nums[i] + dp[i-2]), what does dp[i-1] represent and what does nums[i] + dp[i-2] represent?',
  '["dp[i-1] is the value of the previous house; nums[i] + dp[i-2] is the sum of the current and previous houses.", "dp[i-1] is the maximum loot achievable through house i-1 without robbing house i; nums[i] + dp[i-2] is the loot from robbing house i plus the best loot achievable through house i-2.", "dp[i-1] is the maximum loot if house i-1 was robbed; nums[i] + dp[i-2] is the sum skipping the current house.", "dp[i-1] counts how many houses were robbed up to i-1; nums[i] + dp[i-2] counts houses including the current one."]',
  1,
  'dp[i] represents the maximum loot achievable considering houses 0 through i. When you are at house i you face two mutually exclusive choices: skip house i and carry forward dp[i-1] (the best total without any constraint on house i-1), or rob house i and add nums[i] to dp[i-2] (you must skip house i-1 to legally rob house i, so the best prior total is from house i-2). The max of these two is the optimal decision at house i.'
FROM public.problems WHERE slug = 'house-robber' LIMIT 1;


-- ============================================================
-- ADDITIONAL PROBLEMS: Arrays & Hashing
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Valid Anagram',
  'valid-anagram',
  'easy',
  'An anagram check is a frequency comparison: do both strings use exactly the same characters the same number of times? The brute-force approach — sort both strings and compare — is O(N log N). The hash-map approach counts character frequencies in one pass and compares in a second pass: O(N) time, O(1) space (bounded by the 26-letter alphabet).\n\nThis problem is the bridge between "have I seen this element?" (Contains Duplicate) and "what is the frequency of each element?" (Top K Frequent). Character frequency maps are a recurring sub-technique in string problems at every difficulty level.',
  '## Valid Anagram\n\nGiven two strings `s` and `t`, return `true` if `t` is an anagram of `s`, and `false` otherwise.\n\nAn **anagram** is a word or phrase formed by rearranging the letters of a different word or phrase, using all the original letters exactly once.\n\n---\n\n**Example 1:**\n```\nInput:  s = "anagram", t = "nagaram"\nOutput: true\n```\n\n**Example 2:**\n```\nInput:  s = "rat", t = "car"\nOutput: false\n```\n\n---\n\n**Constraints:**\n- `1 <= s.length, t.length <= 5 * 10^4`\n- `s` and `t` consist of lowercase English letters.',
  '{"python": "class Solution:\n    def isAnagram(self, s: str, t: str) -> bool:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {string} s\n * @param {string} t\n * @return {boolean}\n */\nvar isAnagram = function(s, t) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public boolean isAnagram(String s, String t) {\n        // Your solution here\n        return false;\n    }\n}", "cpp": "class Solution {\npublic:\n    bool isAnagram(string s, string t) {\n        // Your solution here\n        return false;\n    }\n};"}',
  'CORRECT APPROACH: If lengths differ, return False immediately. Build a frequency map for s (increment) and t (decrement). Return True if all counts are zero. Alternatively use two separate maps and compare.\n\nWHAT COUNTS AS CORRECT: Early-exit on length mismatch. Correct frequency counting. O(N) time, O(1) space (alphabet is fixed size). Returns correct result for identical strings, empty strings, and single characters.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Sorting both strings: correct but O(N log N) — ask whether you can do it in O(N).\n- Forgetting the length check: leads to false positives if only checking one direction.\n- Using a map when an array of size 26 suffices: not wrong, but worth noting the constant-space property.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'arrays-hashing' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why is checking that len(s) == len(t) a valuable early exit before building any frequency map?',
  '["It is not useful — the frequency map comparison at the end catches length mismatches anyway.", "Two strings of different lengths cannot be anagrams, so we can return false in O(1) before doing any O(N) work.", "It is required for correctness — the frequency map algorithm is undefined for strings of unequal length.", "It reduces space complexity from O(N) to O(1) by avoiding map construction."]',
  1,
  'An anagram uses every character exactly once — so the two strings must have the same length. If len(s) != len(t) we can return False immediately in O(1), before allocating any data structures or scanning either string. This is a cheap guard that eliminates a common class of inputs with no extra cost. The map comparison alone would also catch this, but doing extra O(N) work when a O(1) check suffices is wasteful.'
FROM public.problems WHERE slug = 'valid-anagram' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'A one-map approach increments counts for characters in s and decrements counts for characters in t, then checks that all values are zero. Why does a non-zero value indicate a non-anagram?',
  '["A non-zero value means the map has too many keys, indicating duplicate characters.", "A positive count means s has more occurrences of that character than t; a negative count means t has more. Either way the distributions differ.", "A non-zero value is a hash collision artifact and should be ignored.", "Non-zero values only appear for characters not present in the English alphabet."]',
  1,
  'Each character starts at count 0. Iterating s increments its characters; iterating t decrements them. If s and t are anagrams, every increment from s is exactly cancelled by a decrement from t — all counts return to 0. If any character appears more in s than t (or vice versa), its count ends positive or negative. Checking all-zeros is equivalent to verifying that both frequency distributions are identical.'
FROM public.problems WHERE slug = 'valid-anagram' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What is the space complexity of the frequency-map approach when the input consists only of lowercase English letters, and why?',
  '["O(N) — the map grows proportionally with the length of the input strings.", "O(1) — the map holds at most 26 entries regardless of how long the strings are.", "O(log N) — the map uses a balanced BST internally.", "O(N^2) — checking all character pairs requires quadratic space."]',
  1,
  'The alphabet is fixed at 26 lowercase letters. No matter how long s and t are, the frequency map holds at most 26 entries. Adding more characters does not add new keys — it only increments existing ones. O(26) = O(1). This is an important distinction: when the key space is bounded by a constant (alphabet size, digit count, etc.), hash-map space is O(1), not O(N).'
FROM public.problems WHERE slug = 'valid-anagram' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Group Anagrams',
  'group-anagrams',
  'medium',
  'Group Anagrams extends Valid Anagram from a yes/no question to a grouping problem: cluster all strings that are anagrams of each other.\n\nThe key insight: every anagram of a word has the same sorted form. "eat", "tea", and "ate" all sort to "aet". Use the sorted form as a hash-map key; strings sharing a key belong in the same group.\n\nAn alternative key: a tuple of 26 character counts. This avoids the O(K log K) sort cost per word, reducing to O(K) per word at the cost of a slightly larger (but still constant-size) key.\n\nThis problem is a template for any "find equivalent elements" problem where two objects are equivalent not by value but by some derived property. Learning to design the right hash key is the core skill.',
  '## Group Anagrams\n\nGiven an array of strings `strs`, group the anagrams together. You can return the answer in **any order**.\n\n---\n\n**Example 1:**\n```\nInput:  strs = ["eat","tea","tan","ate","nat","bat"]\nOutput: [["bat"],["nat","tan"],["ate","eat","tea"]]\n```\n\n**Example 2:**\n```\nInput:  strs = [""]\nOutput: [[""]] \n```\n\n**Example 3:**\n```\nInput:  strs = ["a"]\nOutput: [["a"]]\n```\n\n---\n\n**Constraints:**\n- `1 <= strs.length <= 10^4`\n- `0 <= strs[i].length <= 100`\n- `strs[i]` consists of lowercase English letters.',
  '{"python": "from typing import List\nfrom collections import defaultdict\n\nclass Solution:\n    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {string[]} strs\n * @return {string[][]}\n */\nvar groupAnagrams = function(strs) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public List<List<String>> groupAnagrams(String[] strs) {\n        // Your solution here\n        return new ArrayList<>();\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<vector<string>> groupAnagrams(vector<string>& strs) {\n        // Your solution here\n        return {};\n    }\n};"}',
  'CORRECT APPROACH: Initialize a defaultdict(list). For each string, compute its sorted version as the key. Append the original string to map[key]. Return list(map.values()).\n\nWHAT COUNTS AS CORRECT: Groups all anagrams correctly. Handles empty strings (they group together). Handles single-character strings. Returns all groups. Time O(N * K log K) where K is max string length; space O(N * K).\n\nFASTER ALTERNATIVE: Use a tuple of 26 character counts as the key — O(N * K) time, same space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Comparing every pair of strings: O(N^2 * K) — ask what a good hash key looks like.\n- Using the original string as key: different anagrams get different keys, breaking the grouping.\n- Forgetting to return values (returning keys instead of grouped lists).\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'arrays-hashing' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why is the sorted form of a string (e.g., sorted("eat") == "aet") a valid and sufficient hash-map key for grouping anagrams?',
  '["It is not sufficient — two non-anagram strings could sort to the same value.", "Two strings are anagrams if and only if they have the same sorted form. Sorting canonicalizes the character multiset, making equal sorted forms equivalent to equal character distributions.", "Sorting is used only as a fallback; the primary key is the string length.", "The sorted form is valid only for strings without repeated characters."]',
  1,
  'Anagrams are rearrangements of the same multiset of characters. Sorting maps every permutation of a multiset to the same canonical string — "eat", "tea", and "ate" all become "aet". Two strings produce the same sorted form if and only if they contain exactly the same characters with the same frequencies. This bijection makes the sorted form a perfect grouping key with no false positives or negatives.'
FROM public.problems WHERE slug = 'group-anagrams' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The sorted-key approach costs O(K log K) per string (K = string length). An alternative uses a tuple of 26 character counts as the key, costing O(K) per string. When does the count-tuple approach become meaningfully faster?',
  '["Never — O(K log K) and O(K) differ by only a log factor, which is negligible in practice.", "When K is large (long strings), the log K factor compounds across N strings, making O(N*K) vs O(N*K log K) a real practical difference.", "When the number of strings N is small, because the key computation dominates over map operations.", "The count-tuple approach is always slower because tuples are more expensive to hash than strings."]',
  1,
  'For short strings (K <= 100 as in the constraints) the difference is negligible. But if strings were very long — e.g., DNA sequences of length 10^6 — sorting each one costs 10^6 * 20 operations while counting characters costs just 10^6 operations. Understanding when a log factor matters separates routine O-notation knowledge from practical algorithmic thinking. Both approaches are correct here; the count-tuple is the theoretically optimal variant.'
FROM public.problems WHERE slug = 'group-anagrams' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What is the overall time complexity of the sorted-key approach for N strings each of length at most K?',
  '["O(N log N) — sorting the list of strings dominates.", "O(N * K log K) — sorting each of the N strings costs O(K log K), and we do this N times.", "O(N * K) — string comparison dominates, not sorting.", "O(N^2 * K) — each string is compared against every other string."]',
  1,
  'We iterate through all N strings. For each string of length K, we sort it in O(K log K) and perform an O(1) map lookup/insert. Total: N * O(K log K) = O(N * K log K). This is far better than the naive O(N^2 * K) pairwise comparison approach. The space complexity is O(N * K) to store all strings in the output groups.'
FROM public.problems WHERE slug = 'group-anagrams' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Top K Frequent Elements',
  'top-k-frequent-elements',
  'medium',
  'Given an array, find the K most frequent elements. The direct approach — count frequencies with a hash map, sort by frequency — is O(N log N). But the problem only asks for the top K, not a full ranking.\n\nA min-heap of size K reduces this to O(N log K): maintain a heap of the K most frequent elements seen so far. When the heap exceeds K, evict the least frequent. The heap top is always the K-th most frequent.\n\nAn even faster approach is bucket sort: since frequency is bounded by N, create N+1 buckets indexed by frequency and scan from high to low, collecting K elements in O(N) time.\n\nThis problem synthesizes hash maps and heaps — or hash maps and bucket sort — making it a natural step up from the introductory problems.',
  '## Top K Frequent Elements\n\nGiven an integer array `nums` and an integer `k`, return the `k` most frequent elements. You may return the answer in **any order**.\n\n---\n\n**Example 1:**\n```\nInput:  nums = [1,1,1,2,2,3], k = 2\nOutput: [1,2]\n```\n\n**Example 2:**\n```\nInput:  nums = [1], k = 1\nOutput: [1]\n```\n\n---\n\n**Constraints:**\n- `1 <= nums.length <= 10^5`\n- `-10^4 <= nums[i] <= 10^4`\n- `k` is in the range `[1, the number of unique elements in the array]`.\n- It is guaranteed that the answer is unique.',
  '{"python": "from typing import List\n\nclass Solution:\n    def topKFrequent(self, nums: List[int], k: int) -> List[int]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} nums\n * @param {number} k\n * @return {number[]}\n */\nvar topKFrequent = function(nums, k) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public int[] topKFrequent(int[] nums, int k) {\n        // Your solution here\n        return new int[]{};\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<int> topKFrequent(vector<int>& nums, int k) {\n        // Your solution here\n        return {};\n    }\n};"}',
  'CORRECT APPROACH (bucket sort, O(N)): Count frequencies with a hash map. Create a list of N+1 empty buckets where bucket[i] holds elements with frequency i. Fill buckets. Iterate from bucket[N] down to bucket[0], collecting elements until K are gathered. Return them.\n\nALTERNATIVE (min-heap, O(N log K)): Build frequency map. Use a min-heap of size K keyed by frequency. For each element, push to heap; if heap exceeds K, pop the minimum. Return heap contents.\n\nWHAT COUNTS AS CORRECT: Returns exactly K elements with the highest frequencies. Handles ties. Time O(N log K) for heap or O(N) for bucket sort.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Full sort of frequency map: O(N log N) — ask if you need to sort everything to find just K elements.\n- Returning frequencies instead of elements.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'arrays-hashing' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The bucket sort approach creates N+1 buckets where bucket[i] holds all elements that appear exactly i times. Why is N the maximum useful index?',
  '["Because there are at most N elements in the array, so no element can appear more than N times.", "Because bucket indices are capped at N by the problem constraints.", "Because bucket sort only works when the frequency range equals the array length.", "Because elements appearing more than N times are considered outliers and excluded."]',
  0,
  'An element in an array of length N can appear at most N times (if every element is the same value). So frequency ranges from 1 to N. Bucket index i represents frequency i. We need indices 0 through N, giving N+1 buckets. This bounds the auxiliary space at O(N), and the scan from high to low frequency is O(N) regardless of how many buckets exist — making the entire algorithm O(N).'
FROM public.problems WHERE slug = 'top-k-frequent-elements' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'A heap-based approach maintains a min-heap of size K throughout. Why a MIN-heap rather than a MAX-heap for finding the top K most frequent elements?',
  '["A max-heap would give you the bottom K elements, not the top K.", "A min-heap of size K keeps the K largest frequencies seen so far. The minimum of those K is the K-th largest overall, and evicting it when a larger candidate arrives maintains the invariant.", "A min-heap is used because Python''s heapq only supports min-heaps.", "A max-heap would need to store all N elements; a min-heap only needs K."]',
  1,
  'The invariant: the heap always holds the K elements with the highest frequencies seen so far. When a new element has higher frequency than the heap minimum, it deserves a spot in the top K — evict the current minimum (K-th largest) and insert the new element. A max-heap would give you the single most frequent element at the top but cannot efficiently evict the K-th most frequent. The min-heap''s minimum is exactly the eviction candidate.'
FROM public.problems WHERE slug = 'top-k-frequent-elements' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Sorting the entire frequency map takes O(N log N). The heap approach takes O(N log K). For K = 3 and N = 100,000, how different are these in practice?',
  '["They are identical — log N and log K differ only by a constant when K is fixed.", "Significantly different: log(100000) is about 17 while log(3) is about 1.6 — the heap approach does roughly 10x less work per heap operation.", "The sort is faster because sorting benefits from hardware prefetching while heaps have poor cache behavior.", "There is no difference because both are dominated by the O(N) frequency-counting step."]',
  1,
  'log(100000) is approximately 17; log(3) is approximately 1.6. The heap does about 10x fewer comparisons per heap operation than a full sort. For small K (top 3, top 5, top 10) this is a meaningful constant-factor win in streaming or real-time contexts. The O(N) bucket sort is even better in theory, though its cache behavior sometimes makes the heap approach faster in practice for moderate N.'
FROM public.problems WHERE slug = 'top-k-frequent-elements' LIMIT 1;


-- ============================================================
-- ADDITIONAL PROBLEMS: Two Pointers & Stack
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Container With Most Water',
  'container-with-most-water',
  'medium',
  'You have N vertical lines. Choosing two lines forms a container; the amount of water is (right_index - left_index) * min(height[left], height[right]). Find the maximum.\n\nThe brute-force tries every pair: O(N^2). The Two Pointers insight: start with the widest possible container (pointers at both ends). The width is maximized; the only way to potentially increase volume is to increase the height. Since volume is limited by the shorter line, move the pointer at the shorter line inward — you cannot gain anything by moving the taller one (it would only decrease width with no possible height gain).\n\nThis greedy argument — at each step make the only move that could possibly improve the answer — is the core reasoning skill this problem builds.',
  '## Container With Most Water\n\nYou are given an integer array `height` of length `n`. There are `n` vertical lines drawn such that the two endpoints of the `i`th line are `(i, 0)` and `(i, height[i])`.\n\nFind two lines that together with the x-axis form a container that holds the most water.\n\nReturn the maximum amount of water a container can store.\n\n---\n\n**Example 1:**\n```\nInput:  height = [1,8,6,2,5,4,8,3,7]\nOutput: 49\nExplanation: Lines at index 1 (height 8) and index 8 (height 7). Width = 7, height = min(8,7) = 7. Water = 49.\n```\n\n**Example 2:**\n```\nInput:  height = [1,1]\nOutput: 1\n```\n\n---\n\n**Constraints:**\n- `n == height.length`\n- `2 <= n <= 10^5`\n- `0 <= height[i] <= 10^4`',
  '{"python": "from typing import List\n\nclass Solution:\n    def maxArea(self, height: List[int]) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} height\n * @return {number}\n */\nvar maxArea = function(height) {\n    // Your solution here\n};", "java": "class Solution {\n    public int maxArea(int[] height) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class Solution {\npublic:\n    int maxArea(vector<int>& height) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Initialize left=0, right=len(height)-1, max_water=0. While left < right: compute water = (right - left) * min(height[left], height[right]). Update max_water. If height[left] < height[right], advance left += 1. Else advance right -= 1. Return max_water.\n\nWHAT COUNTS AS CORRECT: Uses two inward-moving pointers. Moves the shorter side inward (or either side when equal). Correctly computes area at each step. O(N) time, O(1) space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Nested loops: O(N^2). Ask: "If you start with the widest container and width can only decrease, which pointer should you move to have any chance of increasing volume?"\n- Moving the taller pointer inward: can never increase volume.\n- Using max() instead of min() for height: water overflows the shorter line.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'two-pointers-stack' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'When the left pointer''s height is less than the right pointer''s height, the algorithm moves the left pointer inward. Why is moving the right pointer inward instead guaranteed to not improve the answer?',
  '["Moving either pointer is equally valid — the algorithm picks left by convention only.", "Moving the right pointer inward decreases width. The height is already capped at height[left] (the shorter side). A smaller width with the same or smaller height cap cannot improve the area.", "Moving the right pointer would cause the pointers to cross, terminating the loop prematurely.", "Moving the right pointer inward would increase the height cap, making that choice better."]',
  1,
  'Current area = width * min(height[left], height[right]) = width * height[left] (since height[left] < height[right]). If we move right inward: width decreases. The height cap remains height[left] at best (the bottleneck has not changed). So area can only decrease or stay the same. There is zero upside to moving the taller pointer. Moving the shorter pointer at least opens the possibility of finding a taller line that raises the height cap — the only lever left after width has decreased.'
FROM public.problems WHERE slug = 'container-with-most-water' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The two-pointer approach starts with pointers at the outermost positions. What property of the problem makes starting at the extremes the right initialization?',
  '["The outermost lines are always the tallest, so they give the maximum possible area.", "Starting at the extremes maximizes width — since width can only shrink as we move pointers inward, we capture every possible width value exactly once during the scan.", "The problem guarantees the optimal container uses the first and last lines.", "Starting at the extremes avoids the need to check invalid containers."]',
  1,
  'Width = right_index - left_index. This is maximized when left = 0 and right = n-1. As we move pointers inward the width strictly decreases. By starting at the extremes, we consider the maximum-width container first and then systematically explore narrower containers that might compensate with taller heights. Every pair (i, j) with i < j is considered through a pointer state we visit — we never skip the optimal pair. This is the correctness argument for the greedy choice.'
FROM public.problems WHERE slug = 'container-with-most-water' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What is the time and space complexity of the two-pointer solution?',
  '["O(N^2) time, O(1) space — each pointer traverses the array once for each position of the other.", "O(N) time, O(1) space — each pointer moves inward at most N times total; no extra data structures.", "O(N log N) time, O(1) space — the greedy choice requires implicit sorting.", "O(N) time, O(N) space — the visited pairs must be stored to avoid rechecking."]',
  1,
  'Each pointer starts at one end and moves strictly inward. Together they take at most N-1 steps before meeting. Each step does O(1) work (compute area, update max, advance one pointer). Total: O(N) time. Only a constant number of variables are used (left, right, max_water): O(1) space. No pair is ever revisited — the two-pointer scan visits each pointer position at most once.'
FROM public.problems WHERE slug = 'container-with-most-water' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Remove Duplicates from Sorted Array',
  'remove-duplicates-sorted-array',
  'easy',
  'This is the classic in-place two-pointer array problem. You cannot use extra space for a new array. Instead, use a "slow" pointer to track where the next unique element should be written, and a "fast" pointer to scan the input.\n\nThe invariant: everything at indices 0..slow-1 is already a unique sorted sequence. When fast finds an element different from its predecessor, copy it to the slow position and advance both. When fast finds a duplicate, skip it (advance fast only).\n\nThis "read/write pointer" pattern is a fundamental building block used in partition steps, Dutch national flag, and other problems that modify arrays without extra space.',
  '## Remove Duplicates from Sorted Array\n\nGiven an integer array `nums` sorted in non-decreasing order, remove the duplicates **in-place** such that each unique element appears only once. The relative order of the elements should be kept the same. Then return the number of unique elements in `nums`.\n\nConsider the number of unique elements of `nums` to be `k`. To get accepted, you need to:\n- Change the array `nums` such that the first `k` elements of `nums` contain the unique elements in the order they were present in `nums` initially.\n- Return `k`.\n\n---\n\n**Example 1:**\n```\nInput:  nums = [1,1,2]\nOutput: 2, nums = [1,2,_]\n```\n\n**Example 2:**\n```\nInput:  nums = [0,0,1,1,1,2,2,3,3,4]\nOutput: 5, nums = [0,1,2,3,4,_,_,_,_,_]\n```\n\n---\n\n**Constraints:**\n- `1 <= nums.length <= 3 * 10^4`\n- `-100 <= nums[i] <= 100`\n- `nums` is sorted in non-decreasing order.',
  '{"python": "from typing import List\n\nclass Solution:\n    def removeDuplicates(self, nums: List[int]) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} nums\n * @return {number}\n */\nvar removeDuplicates = function(nums) {\n    // Your solution here\n};", "java": "class Solution {\n    public int removeDuplicates(int[] nums) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class Solution {\npublic:\n    int removeDuplicates(vector<int>& nums) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Initialize slow = 1. For fast in range(1, len(nums)): if nums[fast] != nums[fast-1]: set nums[slow] = nums[fast], increment slow. Return slow.\n\nWHAT COUNTS AS CORRECT: Modifies nums in-place. Returns the correct count of unique elements. Handles all-same array (returns 1). Handles already-distinct array (returns len(nums)). O(N) time, O(1) space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Building a new list: violates the in-place constraint.\n- Using a set: O(N) space and loses sorted order.\n- Comparing nums[fast] to nums[slow] instead of nums[slow-1]: off-by-one that causes incorrect writes.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'two-pointers-stack' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why does the slow pointer start at index 1 (not 0), and what invariant does it maintain throughout the scan?',
  '["It starts at 1 to skip the first element, which is always a duplicate.", "It starts at 1 because the first element is always unique in a sorted array. The slow pointer marks the next write position; everything before it is the unique prefix built so far.", "It starts at 1 to avoid an index-out-of-bounds error when checking nums[slow-1].", "The starting position is arbitrary — the algorithm works correctly starting from 0 as well."]',
  1,
  'In a sorted array, the first element is trivially unique (nothing before it can duplicate it). So we initialize the unique prefix as [nums[0]] and set slow = 1, meaning "the next unique element goes at index 1." The invariant: nums[0..slow-1] contains the unique elements written so far in their original order. The fast pointer scans ahead; when it finds a new unique value, it writes it to nums[slow] and increments slow.'
FROM public.problems WHERE slug = 'remove-duplicates-sorted-array' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why does the sorted order of the input make this problem easier than if the array were unsorted?',
  '["It does not help — the algorithm works the same way regardless of order.", "In a sorted array, all duplicates of a value are contiguous. A single comparison (current vs. previous) is sufficient to detect a new unique value — no hash set or multi-position lookahead needed.", "Sorted order allows binary search, reducing the time complexity to O(log N).", "Sorted order means the slow pointer never needs to backtrack, saving pointer-reset overhead."]',
  1,
  'If the array were unsorted, a value like 3 might appear at indices 0, 5, and 12 — non-contiguous. Detecting "have I seen 3 before?" would require a hash set (O(N) space). In a sorted array, duplicate occurrences are always adjacent. Checking nums[fast] != nums[fast-1] is sufficient to detect a new unique element — O(1) space, no set needed. Sortedness is the property that makes in-place deduplication possible with two pointers.'
FROM public.problems WHERE slug = 'remove-duplicates-sorted-array' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'After the algorithm runs on [0,0,1,1,2], the array becomes [0,1,2,1,2] and the function returns 3. Why is the content at indices 3 and 4 irrelevant to correctness?',
  '["It is not irrelevant — the judge checks the entire array for correctness.", "The problem only requires the first k elements to be correct, where k is the returned count. Elements beyond index k-1 are ignored by the judge.", "The leftover values at indices 3 and 4 are automatically zeroed out by the runtime.", "The problem guarantees that in-place modification always leaves the tail unchanged."]',
  1,
  'The problem statement explicitly says: the judge checks only the first k elements of nums (where k is your return value). Elements at indices k through n-1 can be anything — they are not evaluated. This is the standard in-place modification contract: you report how many valid elements there are, and the caller trusts you to have placed them in the first k positions. This design lets in-place algorithms avoid clearing the tail, saving unnecessary writes.'
FROM public.problems WHERE slug = 'remove-duplicates-sorted-array' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Daily Temperatures',
  'daily-temperatures',
  'medium',
  'For each day, find how many days until a warmer temperature. The brute-force scans forward from each day: O(N^2). The key insight: you need the "next greater element" for each position — the canonical monotonic stack problem.\n\nA monotonic stack maintains a stack of indices whose temperatures are in decreasing order. When a new temperature is warmer than the stack top, it is the "next warmer day" for the stack top. Pop the top, record the answer, and continue until the stack top is no longer colder.\n\nThis pattern — using a stack to efficiently find the next element satisfying a condition — appears in Largest Rectangle in Histogram, Next Greater Element, and Trapping Rain Water. Learning the monotonic stack template here is the entry point for that entire problem family.',
  '## Daily Temperatures\n\nGiven an array of integers `temperatures` representing the daily temperatures, return an array `answer` such that `answer[i]` is the number of days you have to wait after the `i`th day to get a warmer temperature. If there is no future day with a warmer temperature, keep `answer[i] == 0`.\n\n---\n\n**Example 1:**\n```\nInput:  temperatures = [73,74,75,71,69,72,76,73]\nOutput: [1,1,4,2,1,1,0,0]\n```\n\n**Example 2:**\n```\nInput:  temperatures = [30,40,50,60]\nOutput: [1,1,1,0]\n```\n\n**Example 3:**\n```\nInput:  temperatures = [30,60,90]\nOutput: [1,1,0]\n```\n\n---\n\n**Constraints:**\n- `1 <= temperatures.length <= 10^5`\n- `30 <= temperatures[i] <= 100`',
  '{"python": "from typing import List\n\nclass Solution:\n    def dailyTemperatures(self, temperatures: List[int]) -> List[int]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} temperatures\n * @return {number[]}\n */\nvar dailyTemperatures = function(temperatures) {\n    // Your solution here\n};", "java": "class Solution {\n    public int[] dailyTemperatures(int[] temperatures) {\n        // Your solution here\n        return new int[]{};\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<int> dailyTemperatures(vector<int>& temperatures) {\n        // Your solution here\n        return {};\n    }\n};"}',
  'CORRECT APPROACH: Initialize answer array of zeros and an empty stack (stores indices). For each i in range(len(temperatures)): while stack is not empty AND temperatures[i] > temperatures[stack[-1]]: pop index j from stack, set answer[j] = i - j. Push i onto the stack. Return answer.\n\nWHAT COUNTS AS CORRECT: Stack stores indices (not values). Correctly computes i - j for the wait time. Unresolved indices remain 0. O(N) time — each index is pushed and popped at most once. O(N) space for stack and answer.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Nested loops: O(N^2). Ask: "What data structure lets you track days that have not yet found a warmer day, so you can resolve them in O(1) when a warm day arrives?"\n- Storing temperatures on the stack instead of indices: cannot compute the day difference without the index.\n- Using if instead of while: misses the case where one warm day resolves multiple waiting days.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'two-pointers-stack' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The stack stores indices, not temperature values. Why is storing the index necessary?',
  '["Indices are smaller integers and take less memory than temperature values.", "The answer for each day is the number of days elapsed (i - j), which requires knowing j — the original index of the day waiting for warmth. The temperature value alone cannot tell you when that day was.", "Storing indices avoids hash collisions that would occur with temperature values.", "The stack must be sorted; storing indices maintains sorted order automatically."]',
  1,
  'answer[j] = i - j: we need both the current day i (known from the outer loop) and the waiting day j (from the stack). If we stored temperatures instead of indices, we would know the temperature of the waiting day but not when it occurred. We cannot compute the elapsed days without the index. Always ask: "what information will I need when I pop this element?" — that determines what to push.'
FROM public.problems WHERE slug = 'daily-temperatures' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For temperatures = [73,74,75,71,69,72,76,73], when we reach index 6 (temperature 76), we pop multiple indices from the stack. Why does one element resolve multiple waiting days?',
  '["It does not — each element resolves at most one waiting day; the while loop is just defensive coding.", "76 is warmer than all currently waiting days (indices 3,4,5 with temps 71,69,72). Each of them was waiting for any day warmer than themselves, and 76 satisfies all of them simultaneously.", "The while loop is needed only for equal temperatures, not for the strictly-greater case.", "Multiple pops only occur when the stack contains duplicate temperature values."]',
  1,
  'When we arrive at 76, the stack holds indices 3 (71 degrees), 4 (69 degrees), 5 (72 degrees) — days that have not yet found a warmer day. 76 > 72 so we pop 5, record answer[5] = 6-5 = 1. 76 > 69 so we pop 4, record answer[4] = 6-4 = 2. 76 > 71 so we pop 3, record answer[3] = 6-3 = 3. Each day waiting for any warmer temperature gets resolved. This is why the stack approach is O(N) overall — each index is pushed once and popped once.'
FROM public.problems WHERE slug = 'daily-temperatures' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why is the overall time complexity O(N) even though there is a while loop nested inside the for loop?',
  '["It is not O(N) — the while loop makes it O(N^2) in the worst case.", "Each index is pushed onto the stack exactly once and popped at most once. The total number of push+pop operations across the entire algorithm is at most 2N, giving O(N) amortized.", "The while loop always runs at most a constant number of times per iteration.", "The while loop is O(log N) per iteration because the stack is internally sorted."]',
  1,
  'Amortized analysis: each of the N indices is pushed exactly once (when first encountered) and popped at most once (when a warmer day resolves it). Total push operations: N. Total pop operations: at most N. All other work per iteration is O(1). Grand total: O(2N) = O(N). The while loop does not add a multiplicative factor — it distributes the N pops unevenly across iterations. This is the same reasoning as dynamic array amortized O(1) push.'
FROM public.problems WHERE slug = 'daily-temperatures' LIMIT 1;


-- ============================================================
-- ADDITIONAL PROBLEMS: Binary Search & Sliding Window
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Search a 2D Matrix',
  'search-2d-matrix',
  'medium',
  'The matrix has two key properties: each row is sorted, and the first element of each row is greater than the last element of the previous row. This means the entire matrix, read row by row, forms one globally sorted sequence.\n\nThe direct approach is to binary search within this virtual sorted sequence. Treat flat index mid as row = mid // n_cols, col = mid % n_cols. Binary search runs in O(log(M*N)) time.\n\nThis problem builds the skill of recognizing implicit structure (two sorted properties → one virtual sorted sequence) and applying binary search to non-array data.',
  '## Search a 2D Matrix\n\nYou are given an `m x n` integer matrix `matrix` with the following properties:\n- Each row is sorted in non-decreasing order.\n- The first integer of each row is greater than the last integer of the previous row.\n\nGiven an integer `target`, return `true` if `target` is in `matrix` or `false` otherwise.\n\nYou must write a solution in `O(log(m * n))` time complexity.\n\n---\n\n**Example 1:**\n```\nInput:  matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 3\nOutput: true\n```\n\n**Example 2:**\n```\nInput:  matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 13\nOutput: false\n```\n\n---\n\n**Constraints:**\n- `m == matrix.length`, `n == matrix[0].length`\n- `1 <= m, n <= 100`\n- `-10^4 <= matrix[i][j], target <= 10^4`',
  '{"python": "from typing import List\n\nclass Solution:\n    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[][]} matrix\n * @param {number} target\n * @return {boolean}\n */\nvar searchMatrix = function(matrix, target) {\n    // Your solution here\n};", "java": "class Solution {\n    public boolean searchMatrix(int[][] matrix, int target) {\n        // Your solution here\n        return false;\n    }\n}", "cpp": "class Solution {\npublic:\n    bool searchMatrix(vector<vector<int>>& matrix, int target) {\n        // Your solution here\n        return false;\n    }\n};"}',
  'CORRECT APPROACH: Treat the matrix as a flattened sorted array of M*N elements. Set lo=0, hi=M*N-1. While lo <= hi: mid = lo + (hi-lo)//2. Compute row = mid // N, col = mid % N. If matrix[row][col] == target return True. If < target set lo = mid+1. Else set hi = mid-1. Return False.\n\nALTERNATIVE: Binary search first to identify which row (first element <= target AND last element >= target), then binary search within that row. Same overall complexity.\n\nWHAT COUNTS AS CORRECT: O(log(M*N)) time. Correct index mapping. Handles 1x1 matrix, single-row, single-column. Returns correct boolean.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Linear scan: O(M*N) — ask how the two sorted properties could help halve the search space.\n- Binary searching each row independently without skipping rows: O(M + log N) — the inter-row ordering lets you skip entire rows via binary search.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'binary-search-sliding-window' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Given a matrix with M rows and N columns, how do you convert a flat index mid into a (row, col) pair?',
  '["row = mid % M, col = mid // M", "row = mid // N, col = mid % N", "row = mid // M, col = mid % N", "row = mid % N, col = mid // N"]',
  1,
  'Each row has N elements. Dividing mid by N gives the row index (integer division: how many complete rows fit before position mid). The remainder gives the column within that row. For example, in a 3x4 matrix (N=4): mid=6 gives row=6//4=1, col=6%4=2, i.e. matrix[1][2]. This is the standard row-major index decomposition.'
FROM public.problems WHERE slug = 'search-2d-matrix' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The problem requires O(log(m * n)) time. Why does treating the matrix as a flattened array and running one binary search achieve this?',
  '["It does not — binary search on a 2D matrix requires two separate passes, giving O(log m + log n).", "The flattened array has M*N elements. Binary search on M*N elements takes O(log(M*N)) = O(log M + log N). One pass achieves the required bound.", "O(log(M*N)) is an approximation; the actual complexity is O(M * log N).", "Binary search on the flattened array takes O(M*N) because each comparison requires reconstructing the 2D index."]',
  1,
  'A binary search on an array of K elements takes O(log K). The flattened matrix has K = M*N elements. So the search takes O(log(M*N)) time. Note: log(M*N) = log M + log N, so this is equivalent to two separate binary searches (one per dimension) in terms of asymptotic complexity. The index conversion (row = mid//N, col = mid%N) is O(1) per step.'
FROM public.problems WHERE slug = 'search-2d-matrix' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'If the matrix only guaranteed that each row is sorted (but NOT that each row''s first element exceeds the previous row''s last element), could you still use the single-pass flattened binary search?',
  '["Yes — row-sorted matrices always form a globally sorted sequence.", "No — without the inter-row ordering property, the flattened sequence is not globally sorted and binary search would produce incorrect results.", "Yes — binary search works on any matrix regardless of its ordering properties.", "No — but you could sort the entire matrix first and then apply binary search."]',
  1,
  'The single-pass binary search relies on the flattened matrix being a globally sorted sequence. This requires BOTH properties: each row sorted (intra-row) AND each row''s first element greater than the previous row''s last element (inter-row). Without the second property, the flattened sequence can jump up and down between rows — e.g., row 1 ends at 100 but row 2 starts at 5. Binary search on an unsorted sequence produces incorrect results.'
FROM public.problems WHERE slug = 'search-2d-matrix' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Longest Substring Without Repeating Characters',
  'longest-substring-no-repeating',
  'medium',
  'Finding the longest substring without repeating characters looks like an O(N^2) problem: for each starting position, scan forward until a repeat is found. But the Sliding Window pattern reduces this to O(N).\n\nThe insight: maintain a window [left, right] where no character repeats. As right advances, add the character to a hash set. If it is already in the set (a repeat), shrink the window by advancing left until the repeat is removed. At each step, record the window size.\n\nThis is the "dynamic sliding window" template — the window contracts as well as expands, based on a validity condition. It is used in dozens of medium and hard substring problems.',
  '## Longest Substring Without Repeating Characters\n\nGiven a string `s`, find the length of the **longest substring** without repeating characters.\n\n---\n\n**Example 1:**\n```\nInput:  s = "abcabcbb"\nOutput: 3\nExplanation: "abc" is the longest valid substring.\n```\n\n**Example 2:**\n```\nInput:  s = "bbbbb"\nOutput: 1\n```\n\n**Example 3:**\n```\nInput:  s = "pwwkew"\nOutput: 3\nExplanation: "wke" is the longest valid substring.\n```\n\n---\n\n**Constraints:**\n- `0 <= s.length <= 5 * 10^4`\n- `s` consists of English letters, digits, symbols, and spaces.',
  '{"python": "class Solution:\n    def lengthOfLongestSubstring(self, s: str) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {string} s\n * @return {number}\n */\nvar lengthOfLongestSubstring = function(s) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public int lengthOfLongestSubstring(String s) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class Solution {\npublic:\n    int lengthOfLongestSubstring(string s) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Initialize left=0, max_len=0, char_set=empty set. For right in range(len(s)): while s[right] in char_set: remove s[left] from char_set, increment left. Add s[right] to char_set. Update max_len = max(max_len, right - left + 1). Return max_len.\n\nFASTER ALTERNATIVE: Use a hash map from character to its last-seen index. When a repeat is found, jump left directly to max(left, last_seen[char] + 1). Still O(N) but fewer iterations in practice.\n\nWHAT COUNTS AS CORRECT: Handles empty string (return 0). Handles all-same string (return 1). Correctly contracts window on repeat. O(N) time, O(min(N, alphabet_size)) space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Nested loops: O(N^2). Ask: "When you find a repeat at position right, do you need to restart from scratch or just shrink the window?"\n- Not updating left correctly in the map variant: left must never move backwards.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'binary-search-sliding-window' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'In the sliding window approach, why do we shrink from the LEFT when a duplicate is found on the RIGHT, rather than starting the window over from the right?',
  '["Starting over from the right is more correct — shrinking from the left may leave duplicates in the window.", "All characters between left and the previous occurrence of the duplicate are still valid (no repeats among them). We only need to remove the duplicate''s earlier occurrence, not discard the entire window.", "We shrink from the left to maintain alphabetical order within the window.", "We shrink from the left because the right pointer cannot move backwards."]',
  1,
  'Suppose the window is "abcde" and the next character is "c". The duplicate is the "c" at some earlier position. Characters "de" (between the old "c" and the new "c") are still unique and can be part of the new valid window. If we restarted from the new "c", we would throw away valid characters and potentially miss longer valid substrings. Shrinking from the left until the old "c" is removed gives us the longest valid window containing the new "c".'
FROM public.problems WHERE slug = 'longest-substring-no-repeating' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why is the overall time complexity O(N) even though the while loop can run multiple times per right-pointer step?',
  '["It is not O(N) — the nested while loop makes it O(N^2) in the worst case.", "Each character is added to the set exactly once (when right passes it) and removed at most once (when left passes it). Total add+remove operations: at most 2N = O(N).", "The while loop runs at most once per right-pointer step, making each step O(1).", "O(N) is an approximation; the actual complexity is O(N * alphabet_size)."]',
  1,
  'Amortized analysis: the left pointer only ever moves right, from 0 to at most N-1. Each position is "removed" from the set at most once. The right pointer also only moves right. Each position is "added" to the set exactly once. Total set operations: at most 2N. Each operation is O(1). Grand total: O(N). The while loop distributes the N removals unevenly but the total is still bounded by N.'
FROM public.problems WHERE slug = 'longest-substring-no-repeating' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'An optimized approach stores the last-seen index of each character in a hash map and jumps left to max(left, last_seen[char] + 1). Why the max() call?',
  '["To ensure left never exceeds right, preventing the window from inverting.", "To prevent left from moving backwards. If the last occurrence of the duplicate is before the current left (already outside the window), we should not move left back to that stale position.", "To handle the case where the character has never been seen before.", "To maintain the sorted order of characters in the window."]',
  1,
  'Consider s = "abba". When right=3 (second ''a''), last_seen[''a''] = 0. Without max(), we would set left = 0 + 1 = 1. But left is already at 2 (we moved it past the first ''b''). Setting left back to 1 would reintroduce ''b'' into the window, creating a new duplicate. The max() ensures left only moves forward: left = max(current_left, last_seen[char] + 1). This is a subtle but critical guard against backwards movement.'
FROM public.problems WHERE slug = 'longest-substring-no-repeating' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Permutation in String',
  'permutation-in-string',
  'medium',
  'Check whether any permutation of string s1 appears as a substring of s2. A permutation has the same character counts as s1 — so this reduces to: does s2 contain a window of length len(s1) with exactly the same character frequencies?\n\nThis is a fixed-size sliding window problem. Maintain a frequency map of s1 and a frequency map of the current window in s2. As the window slides one step, update the map in O(1) by removing the outgoing character and adding the incoming character. Check equality after each slide.\n\nThis "fixed-size window with frequency comparison" pattern is the template for Anagram Detection in a String, Find All Anagrams in a String, and similar substring search problems.',
  '## Permutation in String\n\nGiven two strings `s1` and `s2`, return `true` if `s2` contains a permutation of `s1`, or `false` otherwise.\n\nIn other words, return `true` if one of `s1`''s permutations is the substring of `s2`.\n\n---\n\n**Example 1:**\n```\nInput:  s1 = "ab", s2 = "eidbaooo"\nOutput: true\nExplanation: s2 contains one permutation of s1 ("ba").\n```\n\n**Example 2:**\n```\nInput:  s1 = "ab", s2 = "eidboaoo"\nOutput: false\n```\n\n---\n\n**Constraints:**\n- `1 <= s1.length, s2.length <= 10^4`\n- `s1` and `s2` consist of lowercase English letters.',
  '{"python": "class Solution:\n    def checkInclusion(self, s1: str, s2: str) -> bool:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {string} s1\n * @param {string} s2\n * @return {boolean}\n */\nvar checkInclusion = function(s1, s2) {\n    // Your solution here\n};", "java": "class Solution {\n    public boolean checkInclusion(String s1, String s2) {\n        // Your solution here\n        return false;\n    }\n}", "cpp": "class Solution {\npublic:\n    bool checkInclusion(string s1, string s2) {\n        // Your solution here\n        return false;\n    }\n};"}',
  'CORRECT APPROACH: If len(s1) > len(s2), return False. Build count_s1 (frequency map of s1) and count_window (frequency map of first window s2[0..len(s1)-1]). If equal, return True. Slide from index len(s1) to len(s2)-1: add s2[i] to count_window, remove s2[i - len(s1)] (decrement; remove key if 0). If count_window == count_s1, return True. Return False.\n\nOPTIMIZATION: Track a "matches" counter (number of characters whose counts match) instead of comparing full maps on every slide — reduces comparison from O(26) to O(1) per slide.\n\nWHAT COUNTS AS CORRECT: Fixed-size window of length len(s1). O(26) or O(1) per slide step. O(len(s1) + len(s2)) total time. Handles len(s1) > len(s2) gracefully.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Generating all permutations of s1 and checking each: O(N! * M) — exponential.\n- Variable-size window: the window must always be exactly len(s1) characters.\n- Comparing maps on every slide without removing zero-count keys: map sizes differ and equality check fails.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'binary-search-sliding-window' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why is a FIXED-size sliding window (always length len(s1)) the correct structure for this problem, rather than a variable-size window?',
  '["A variable-size window is also correct — you just need to stop when the window contains all characters of s1.", "A permutation of s1 has the same length as s1. We are looking for a substring of s2 that has exactly len(s1) characters with the same frequencies. The window size is fixed at len(s1) — it cannot be shorter (missing characters) or longer (extra characters).", "A fixed-size window is only needed when s1 has no repeated characters.", "Variable-size windows are used for minimization problems; fixed-size windows are used for existence checks."]',
  1,
  'A permutation of s1 rearranges exactly the len(s1) characters of s1 — no more, no less. A valid window in s2 must contain exactly those characters and no others. If the window were shorter, it would be missing characters. If it were longer, it would contain extra characters not in s1. Therefore the window must be exactly len(s1) wide. This fixed-size constraint is what distinguishes this problem from dynamic-window problems like Longest Substring Without Repeating Characters.'
FROM public.problems WHERE slug = 'permutation-in-string' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'When sliding the window one step right (adding s2[i] and removing s2[i - len(s1)]), why must you remove the count-zero key from the window map rather than leaving it at 0?',
  '["Leaving zero-count keys does not affect correctness — zero is equivalent to absence.", "If zero-count keys remain in count_window but not in count_s1, the two dictionaries have different key sets and equality fails even when the character frequencies genuinely match.", "Removing zero-count keys is an optimization that reduces memory usage but does not affect correctness.", "You must remove zero-count keys to avoid integer overflow when counts go negative."]',
  1,
  'Suppose count_s1 = {''a'': 1, ''b'': 1} and count_window = {''a'': 1, ''b'': 0, ''c'': 1}. Even if ''b'' and ''c'' happen to cancel out, the maps are not equal because count_window has a ''b'' key (value 0) and a ''c'' key not in count_s1. Python dict equality compares both keys and values. Removing zero-count keys keeps count_window''s structure parallel to count_s1, making equality meaningful. Alternatively, compare each of the 26 letter counts individually to avoid this pitfall.'
FROM public.problems WHERE slug = 'permutation-in-string' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'An optimized approach tracks a "matches" variable (number of characters whose window count equals s1 count) instead of comparing full maps. How does this reduce per-slide work from O(26) to O(1)?',
  '["It does not reduce work — you still need to check all 26 characters after each slide.", "Each slide changes exactly two characters (one added, one removed). Only those two characters'' match status needs updating. All other characters'' counts are unchanged. So matches changes by at most 2 per slide: O(1) per slide.", "The matches variable allows early termination when matches > 13, making average case O(1).", "Tracking matches only works when s1 has no repeated characters."]',
  1,
  'Full map comparison checks all 26 entries every slide: O(26) = O(1) technically, but 26x slower in practice. With the matches counter: when we add character c_in, if count_window[c_in] now equals count_s1[c_in], increment matches; if it now exceeds count_s1[c_in], decrement matches. Similarly for c_out. At most 4 increments/decrements per slide. Return True when matches == 26 (or the number of distinct characters in s1). This reduces constant factors from 26 to 4 — meaningful when N is 10^4 and we slide 10^4 times.'
FROM public.problems WHERE slug = 'permutation-in-string' LIMIT 1;


-- ============================================================
-- ADDITIONAL PROBLEMS: Linked List
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Merge Two Sorted Lists',
  'merge-two-sorted-lists',
  'easy',
  'Merging two sorted linked lists is the foundational multi-pointer linked list problem. Unlike array merging, you cannot index into a linked list — you must rebuild the merged list by choosing one node at a time from whichever list has the smaller current value.\n\nThe key technique: use a dummy head node to avoid special-casing the empty result. A dummy node gives you a stable starting point; the merged list begins at dummy.next. A current pointer tracks the tail of the merged list as you build it.\n\nThis merge subroutine is also the core of Merge Sort and appears inside Merge K Sorted Lists. Getting the pointer manipulation exact here — especially handling the remaining tail when one list is exhausted — is essential.',
  '## Merge Two Sorted Lists\n\nYou are given the heads of two sorted linked lists `list1` and `list2`.\n\nMerge the two lists into one **sorted** list. The list should be made by splicing together the nodes of the first two lists.\n\nReturn the head of the merged linked list.\n\n---\n\n**Example 1:**\n```\nInput:  list1 = [1,2,4], list2 = [1,3,4]\nOutput: [1,1,2,3,4,4]\n```\n\n**Example 2:**\n```\nInput:  list1 = [], list2 = []\nOutput: []\n```\n\n**Example 3:**\n```\nInput:  list1 = [], list2 = [0]\nOutput: [0]\n```\n\n---\n\n**Constraints:**\n- The number of nodes in both lists is in the range `[0, 50]`.\n- `-100 <= Node.val <= 100`\n- Both `list1` and `list2` are sorted in non-decreasing order.',
  '{"python": "from typing import Optional\n\n# class ListNode:\n#     def __init__(self, val=0, next=None):\n#         self.val = val\n#         self.next = next\n\nclass Solution:\n    def mergeTwoLists(self, list1: Optional[ListNode], list2: Optional[ListNode]) -> Optional[ListNode]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {ListNode} list1\n * @param {ListNode} list2\n * @return {ListNode}\n */\nvar mergeTwoLists = function(list1, list2) {\n    // Your solution here\n};", "java": "class Solution {\n    public ListNode mergeTwoLists(ListNode list1, ListNode list2) {\n        // Your solution here\n        return null;\n    }\n}", "cpp": "class Solution {\npublic:\n    ListNode* mergeTwoLists(ListNode* list1, ListNode* list2) {\n        // Your solution here\n        return nullptr;\n    }\n};"}',
  'CORRECT APPROACH: Create a dummy node and a current pointer starting at dummy. While both lists are non-null: if list1.val <= list2.val, attach list1 to current.next and advance list1; else attach list2 and advance list2. Advance current. After the loop, attach whichever list is non-null directly to current.next (no need to iterate — it is already sorted). Return dummy.next.\n\nWHAT COUNTS AS CORRECT: Uses a dummy head. Correctly handles one or both lists being empty. Attaches the remaining tail directly (does not iterate element-by-element over the remainder). O(M+N) time, O(1) space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Not using a dummy node: results in complex special-casing for the first node.\n- Iterating the remaining tail node-by-node instead of attaching it wholesale: correct but unnecessarily verbose.\n- Returning dummy instead of dummy.next: returns a list starting with the dummy 0-value node.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'linked-list' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why does the standard merge solution use a dummy head node, and what does it eliminate?',
  '["The dummy node pre-allocates memory for the merged list, improving cache performance.", "The dummy node provides a stable starting point so the first append does not require special-casing. The merged list head is always dummy.next, regardless of which value is smallest.", "The dummy node is required by the ListNode definition and has no algorithmic purpose.", "The dummy node acts as a sentinel to detect when both input lists are exhausted."]',
  1,
  'Without a dummy node, you would need to initialize the result head as the smaller of the two first elements — a separate if/else before the loop. With a dummy node (value 0 or any value), the first append is identical to every subsequent append: current.next = whichever_node, advance current, advance that list. The code is uniform throughout the loop. This "dummy head" or "sentinel" pattern appears in any problem that builds a linked list from scratch.'
FROM public.problems WHERE slug = 'merge-two-sorted-lists' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'When one list is exhausted before the other, the solution attaches the remaining list directly: current.next = list1 (or list2). Why is this safe instead of iterating the remainder node by node?',
  '["It is not safe — the remaining list might contain nodes that need reordering.", "The remaining list is already sorted, so it can be appended as-is. Iterating it node by node would produce the same result but waste O(remaining_length) extra steps.", "It is only safe if the remaining list has exactly one node.", "It saves space by reusing the existing nodes rather than copying them."]',
  1,
  'Both input lists are sorted. Once one list is empty, the remaining list is guaranteed to be sorted AND all its values are >= the last value appended to the merged list (because we always appended the smaller value). Attaching the remaining list in O(1) with current.next = remaining is both correct and optimal — no reordering is needed. This is the key optimization that makes the merge O(M+N) rather than O((M+N)^2).'
FROM public.problems WHERE slug = 'merge-two-sorted-lists' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What is the time complexity of merging two lists of lengths M and N, and why?',
  '["O(M * N) — each node from list1 must be compared against every node from list2.", "O(M + N) — each node from both lists is visited exactly once during the merge.", "O(max(M, N)) — the shorter list is consumed first and then the longer list is attached in O(1).", "O(M + N) time if M == N, O(max(M,N)) otherwise."]',
  1,
  'Each node from list1 is visited at most once (when it is compared and appended). Each node from list2 is visited at most once. Total comparisons and pointer updates: at most M + N. The final tail attachment (current.next = remaining) is O(1), not O(remaining). Total: O(M+N) time, O(1) extra space (only a constant number of pointer variables are used — the merged list reuses the original nodes).'
FROM public.problems WHERE slug = 'merge-two-sorted-lists' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Remove Nth Node From End of List',
  'remove-nth-node-end-list',
  'medium',
  'Removing the Nth node from the end requires knowing the length of the list — but you do not know it upfront, and traversing twice is less elegant. The two-pointer (fast/slow) technique solves this in a single pass.\n\nThe insight: advance a fast pointer N steps ahead of a slow pointer. Then advance both together until fast reaches the tail. At that point, slow is exactly at the node just before the one to remove. Redirect slow.next to slow.next.next.\n\nA dummy head simplifies the case where you need to remove the head node (N == list length). With a dummy, slow never needs special-casing — it always has a valid predecessor.\n\nThis problem reinforces the "runner" technique first seen in Linked List Cycle, now applied to positional arithmetic.',
  '## Remove Nth Node From End of List\n\nGiven the head of a linked list, remove the `n`th node from the end of the list and return its head.\n\n---\n\n**Example 1:**\n```\nInput:  head = [1,2,3,4,5], n = 2\nOutput: [1,2,3,5]\n```\n\n**Example 2:**\n```\nInput:  head = [1], n = 1\nOutput: []\n```\n\n**Example 3:**\n```\nInput:  head = [1,2], n = 1\nOutput: [1]\n```\n\n---\n\n**Constraints:**\n- The number of nodes in the list is `sz`.\n- `1 <= sz <= 30`\n- `0 <= Node.val <= 100`\n- `1 <= n <= sz`',
  '{"python": "from typing import Optional\n\n# class ListNode:\n#     def __init__(self, val=0, next=None):\n#         self.val = val\n#         self.next = next\n\nclass Solution:\n    def removeNthFromEnd(self, head: Optional[ListNode], n: int) -> Optional[ListNode]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {ListNode} head\n * @param {number} n\n * @return {ListNode}\n */\nvar removeNthFromEnd = function(head, n) {\n    // Your solution here\n};", "java": "class Solution {\n    public ListNode removeNthFromEnd(ListNode head, int n) {\n        // Your solution here\n        return null;\n    }\n}", "cpp": "class Solution {\npublic:\n    ListNode* removeNthFromEnd(ListNode* head, int n) {\n        // Your solution here\n        return nullptr;\n    }\n};"}',
  'CORRECT APPROACH: Create a dummy node pointing to head. Initialize fast = dummy, slow = dummy. Advance fast n+1 times (so the gap between slow and fast is n+1, placing slow at the predecessor of the target). Then advance both until fast is null. Set slow.next = slow.next.next. Return dummy.next.\n\nWHY n+1 STEPS: We want slow to stop at the node BEFORE the target. After advancing n+1 steps and then walking together until fast=null, slow is exactly one step before the target.\n\nWHAT COUNTS AS CORRECT: Single pass O(L) time, O(1) space. Uses dummy head to handle removing the head node uniformly. Correctly removes the target and relinks.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Two-pass (measure length then remove): correct but misses the elegance of the one-pass approach.\n- Advancing fast only n steps instead of n+1: slow ends up AT the target, not before it, making removal impossible without backtracking.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'linked-list' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The fast pointer is advanced n+1 steps before both pointers start moving together. Why n+1 rather than n?',
  '["n+1 accounts for the dummy node added at the front, which adds one to all distances.", "We want slow to stop at the node BEFORE the target so we can redirect slow.next. A gap of n+1 between slow and fast means when fast reaches null, slow is exactly one position before the n-th-from-end node.", "n+1 handles the edge case where n equals the list length, which would otherwise cause fast to overshoot.", "n+1 is needed only when removing the head node; in all other cases n steps suffice."]',
  1,
  'After the initial n+1 advance, there are n+1 nodes between slow and fast (inclusive of fast). When both advance together until fast = null, slow has moved (length - n - 1) steps from dummy. That places slow at position length - n - 1 from the dummy, which is the node just before the n-th from the end. slow.next is the target. Without the dummy and with only n steps, slow would land on the target itself — and you cannot remove a node you are pointing at without a reference to its predecessor.'
FROM public.problems WHERE slug = 'remove-nth-node-end-list' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For the input [1] with n=1, the correct output is []. How does the dummy-head approach handle this without special-casing the head removal?',
  '["It cannot handle it — removing the head always requires a special case.", "The dummy node acts as the predecessor of the real head. slow starts at dummy; after the traversal slow.next is the head node. Setting slow.next = slow.next.next (null) removes the head uniformly.", "The algorithm detects n == list length and returns null directly.", "It handles it by checking if head.next is null before starting the traversal."]',
  1,
  'Without a dummy, slow would have to start at head, and removing head would require returning head.next — a special case outside the main logic. With a dummy: slow starts at dummy (the predecessor of the real head). When n = list_length, the traversal leaves slow at dummy and fast at null, so slow.next is the real head. Setting slow.next = slow.next.next = null detaches the head. The algorithm returns dummy.next = null, which is correct. The dummy absorbs all head-removal cases into the uniform loop.'
FROM public.problems WHERE slug = 'remove-nth-node-end-list' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'To remove a node from a singly linked list you need a reference to its PREDECESSOR (the node before it). Why can you not remove a node given only a reference to the node itself?',
  '["You can — set node.val = node.next.val and node.next = node.next.next to copy the successor into the current node and delete the successor instead.", "You cannot — in a singly linked list each node only has a next pointer. To remove node X you must redirect the previous node''s next pointer, which requires holding a reference to the previous node.", "You can — setting node = null removes it from the list.", "You cannot — the garbage collector requires explicit predecessor unlinking in all languages."]',
  1,
  'In a singly linked list, to remove node X you need to execute: predecessor.next = X.next. This requires knowing predecessor. Node X itself has no back-pointer. The trick in (a) — copying successor''s value into X and deleting the successor — does work and is used in "Delete Node in a Linked List" (a different problem where you are given only the node). But it does not work for the tail node, which has no successor to copy. The standard approach requires the predecessor, which is why the two-pointer technique is designed to stop one node early.'
FROM public.problems WHERE slug = 'remove-nth-node-end-list' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Reorder List',
  'reorder-list',
  'medium',
  'Reorder List combines three fundamental linked list techniques in sequence: find the middle (slow/fast pointers), reverse the second half (iterative three-pointer reversal), and merge two lists in alternating order.\n\nNo single trick solves this problem alone. You must decompose the problem into its sub-problems and apply the exact techniques from Reverse Linked List and Linked List Cycle Detection. This is the canonical "composition" problem in the Linked List module.\n\nThe challenge is executing all three phases correctly without losing any node references between them — especially when splitting the list at the midpoint (the first half''s tail must be set to null).',
  '## Reorder List\n\nYou are given the head of a singly linked-list: `L0 -> L1 -> ... -> Ln-1 -> Ln`.\n\nReorder it to: `L0 -> Ln -> L1 -> Ln-1 -> L2 -> Ln-2 -> ...`\n\nYou may not modify the values in the list''s nodes. Only nodes themselves may be changed.\n\n---\n\n**Example 1:**\n```\nInput:  head = [1,2,3,4]\nOutput: [1,4,2,3]\n```\n\n**Example 2:**\n```\nInput:  head = [1,2,3,4,5]\nOutput: [1,5,2,4,3]\n```\n\n---\n\n**Constraints:**\n- The number of nodes in the list is in the range `[1, 5 * 10^4]`.\n- `1 <= Node.val <= 1000`',
  '{"python": "from typing import Optional\n\n# class ListNode:\n#     def __init__(self, val=0, next=None):\n#         self.val = val\n#         self.next = next\n\nclass Solution:\n    def reorderList(self, head: Optional[ListNode]) -> None:\n        # Modify in-place; do not return anything\n        pass", "javascript": "/**\n * @param {ListNode} head\n * @return {void} Do not return anything, modify head in-place instead.\n */\nvar reorderList = function(head) {\n    // Your solution here\n};", "java": "class Solution {\n    public void reorderList(ListNode head) {\n        // Your solution here\n    }\n}", "cpp": "class Solution {\npublic:\n    void reorderList(ListNode* head) {\n        // Your solution here\n    }\n};"}',
  'CORRECT APPROACH (three phases):\n1. Find the middle using slow/fast pointers. When fast reaches the end, slow is at the middle.\n2. Reverse the second half starting from slow.next. Detach the first half by setting slow.next = null.\n3. Merge: alternate nodes from the first half (head) and the reversed second half. Keep two pointers; insert each second-half node after the current first-half node.\n\nWHAT COUNTS AS CORRECT: In-place modification (no values changed, no extra list). Correct for odd and even length lists. Correctly detaches the two halves before reversing. O(N) time, O(1) space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Collecting all values into an array and rebuilding: O(N) space — ask how to do it with pointer manipulation only.\n- Forgetting to set slow.next = null before reversing: the second half remains linked back to the first, causing cycles.\n- Not saving next pointers before relinking during the merge phase.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'linked-list' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'After finding the midpoint with slow/fast pointers, why must you set slow.next = null before reversing the second half?',
  '["To free memory — null-terminating the first half releases the second half for garbage collection.", "If you do not null-terminate the first half, the last node of the first half still points into the second half. After reversing, the reversed second half''s tail points back into the first half, creating a cycle.", "slow.next = null is only needed when the list has odd length.", "It is optional — the merge phase handles any lingering cross-links automatically."]',
  1,
  'Suppose the list is 1->2->3->4->5. After finding mid at node 3, slow.next = 4. If you reverse the second half (4->5 becomes 5->4), node 4''s next is set to null by the reversal — but node 3 (the tail of the first half) still points to 4. During the merge you would follow 3.next and find 4 (now in the middle of the reversed half), creating incorrect linkage. Setting slow.next = null gives the first half a clean null terminator before the reversal begins.'
FROM public.problems WHERE slug = 'reorder-list' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'During the interleaving merge phase, for each pair of nodes (one from each half) you must save certain next pointers before relinking. Why?',
  '["To allow backtracking if the merge produces an incorrect order.", "Relinking a node''s next pointer overwrites your only reference to what comes after it. Without saving those references first, you lose access to the rest of each list.", "Only the first-half pointers need saving; the second-half pointers are already null after reversal.", "Next pointers never need saving because linked list operations are inherently reversible."]',
  1,
  'Suppose first points to node A (next = B) and second points to node X (next = Y). To interleave: A.next = X, X.next = B. But if you set A.next = X first, you lose B (the rest of the first half). If you then set X.next = A.next you get X.next = X, a self-loop. You must save: first_next = first.next and second_next = second.next BEFORE any relinking, then use those saved references to advance both pointers. This "save before overwrite" discipline is essential in any pointer-manipulation sequence.'
FROM public.problems WHERE slug = 'reorder-list' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For the list [1,2,3,4,5], after finding the midpoint and reversing the second half, what are the two sublists you merge?',
  '["First half: [1,2,3,4], Second half (reversed): [5]", "First half: [1,2,3], Second half (reversed): [5,4]", "First half: [1,2], Second half (reversed): [5,4,3]", "First half: [1,2,3,4,5], Second half (reversed): []"]',
  1,
  'With slow/fast pointers on [1,2,3,4,5]: fast takes steps 1->3->5, slow takes steps 1->2->3. Slow stops at node 3 (the middle). The first half is [1,2,3] (null-terminated at 3). The second half starts at slow.next = node 4: [4,5]. Reversed: [5,4]. Merging [1,2,3] and [5,4] alternately gives 1->5->2->4->3, which matches the expected output. Note that for odd-length lists the middle node stays in the first half.'
FROM public.problems WHERE slug = 'reorder-list' LIMIT 1;


-- ============================================================
-- ADDITIONAL PROBLEMS: Trees
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Same Tree',
  'same-tree',
  'easy',
  'Checking whether two binary trees are identical is the simplest recursive tree comparison problem. At each node you have three things to verify: the values match, the left subtrees are identical, and the right subtrees are identical. All three must hold simultaneously.\n\nThe base cases matter most: two null nodes are identical (return True); one null and one non-null are not (return False); two non-null nodes with different values are not (return False). If all base cases pass, recurse.\n\nThis problem sharpens the habit of enumerating all null/non-null combinations at the start of a recursive function — a discipline that prevents null pointer errors in harder tree problems like Symmetric Tree and Subtree of Another Tree.',
  '## Same Tree\n\nGiven the roots of two binary trees `p` and `q`, write a function to check if they are the same or not.\n\nTwo binary trees are considered the same if they are structurally identical, and the nodes have the same value.\n\n---\n\n**Example 1:**\n```\nInput:  p = [1,2,3], q = [1,2,3]\nOutput: true\n```\n\n**Example 2:**\n```\nInput:  p = [1,2], q = [1,null,2]\nOutput: false\n```\n\n**Example 3:**\n```\nInput:  p = [1,2,1], q = [1,1,2]\nOutput: false\n```\n\n---\n\n**Constraints:**\n- The number of nodes in both trees is in the range `[0, 100]`.\n- `-10^4 <= Node.val <= 10^4`',
  '{"python": "from typing import Optional\n\n# class TreeNode:\n#     def __init__(self, val=0, left=None, right=None):\n#         self.val = val\n#         self.left = left\n#         self.right = right\n\nclass Solution:\n    def isSameTree(self, p: Optional[TreeNode], q: Optional[TreeNode]) -> bool:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {TreeNode} p\n * @param {TreeNode} q\n * @return {boolean}\n */\nvar isSameTree = function(p, q) {\n    // Your solution here\n};", "java": "class Solution {\n    public boolean isSameTree(TreeNode p, TreeNode q) {\n        // Your solution here\n        return false;\n    }\n}", "cpp": "class Solution {\npublic:\n    bool isSameTree(TreeNode* p, TreeNode* q) {\n        // Your solution here\n        return false;\n    }\n};"}',
  'CORRECT APPROACH: Base cases: if both p and q are null, return True. If exactly one is null, return False. If p.val != q.val, return False. Recursive case: return isSameTree(p.left, q.left) AND isSameTree(p.right, q.right).\n\nWHAT COUNTS AS CORRECT: All four combinations of null/non-null handled. Values compared before recursing. Returns True for two empty trees. O(N) time where N is the number of nodes in the smaller tree; O(H) space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Checking only values without checking structure: [1,2] and [1,null,2] would incorrectly return True.\n- Using OR instead of AND for the recursive call: returns True even if one subtree differs.\n- Not short-circuiting when values differ before recursing.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'trees' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The base cases check (1) both null → True, (2) one null → False, (3) values differ → False. In what order should these checks appear, and why?',
  '["Values differ first, then one null, then both null — value comparison is the most common case.", "Both null first, then one null, then values differ — checking both-null avoids a null dereference when accessing .val on a null node.", "Both null and one null can be combined into a single check, then values differ.", "The order does not matter — all three checks are always evaluated regardless."]',
  1,
  'If you check p.val != q.val before checking for null, you will dereference a null pointer on inputs where one or both nodes are null — crashing with a NullPointerException or AttributeError. The both-null check (return True) must come first to handle the valid base case where both subtrees are empty. The one-null check (return False) must come second to handle structural mismatch. Only then is it safe to access p.val and q.val.'
FROM public.problems WHERE slug = 'same-tree' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The recursive call is: return isSameTree(p.left, q.left) AND isSameTree(p.right, q.right). What happens if you use OR instead of AND?',
  '["No change — OR and AND produce the same result for symmetric trees.", "The function returns True if EITHER subtree pair matches, incorrectly accepting trees that differ in one subtree.", "The function returns False for all non-trivial trees, making it too strict.", "OR is actually correct — you only need one matching subtree for the trees to be the same."]',
  1,
  'Two trees are identical only if ALL corresponding subtrees are identical. AND enforces this: both left subtrees must match AND both right subtrees must match. OR would return True if at least one pair of subtrees matches — e.g., [1,2,99] and [1,2,3] would be considered identical because their left subtrees ([2] and [2]) match, even though their right subtrees (99 vs 3) differ. This is a logic error that misrepresents the "same tree" condition.'
FROM public.problems WHERE slug = 'same-tree' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What is the time complexity of isSameTree for two trees with M and N nodes respectively?',
  '["O(M * N) — every node in p must be compared with every node in q.", "O(min(M, N)) — recursion stops as soon as a mismatch is found or the smaller tree is exhausted.", "O(M + N) — every node in both trees is visited once.", "O(max(M, N)) — the larger tree determines the recursion depth."]',
  1,
  'The recursion visits a node pair only if both are non-null and their values match. As soon as any mismatch is found (null vs non-null, or differing values), that branch returns False without recursing further. In the worst case (identical trees), every corresponding pair is visited: O(min(M, N)) pairs total. If the trees have equal size that is O(N). We never visit more nodes than the smaller tree has — once one tree is exhausted the recursion stops.'
FROM public.problems WHERE slug = 'same-tree' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Binary Tree Level Order Traversal',
  'binary-tree-level-order',
  'medium',
  'Level order traversal visits all nodes on level 0, then all on level 1, then level 2, and so on — breadth-first search on a tree. Unlike DFS (which goes deep before wide), BFS uses a queue to process nodes level by level.\n\nThe key technique for capturing each level separately: track the queue size at the start of each level. Process exactly that many nodes, adding their children for the next iteration. This "snapshot the level size" pattern is reused in dozens of BFS problems: Minimum Depth of Binary Tree, Right Side View, Zigzag Level Order, and more.\n\nUnderstanding BFS on trees is the prerequisite for BFS on graphs (Number of Islands, Clone Graph, Word Ladder) since the traversal pattern is identical.',
  '## Binary Tree Level Order Traversal\n\nGiven the `root` of a binary tree, return the level order traversal of its nodes'' values (i.e., from left to right, level by level).\n\n---\n\n**Example 1:**\n```\nInput:  root = [3,9,20,null,null,15,7]\nOutput: [[3],[9,20],[15,7]]\n```\n\n**Example 2:**\n```\nInput:  root = [1]\nOutput: [[1]]\n```\n\n**Example 3:**\n```\nInput:  root = []\nOutput: []\n```\n\n---\n\n**Constraints:**\n- The number of nodes in the tree is in the range `[0, 2000]`.\n- `-1000 <= Node.val <= 1000`',
  '{"python": "from typing import Optional, List\nfrom collections import deque\n\nclass Solution:\n    def levelOrder(self, root: Optional[TreeNode]) -> List[List[int]]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {TreeNode} root\n * @return {number[][]}\n */\nvar levelOrder = function(root) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public List<List<Integer>> levelOrder(TreeNode root) {\n        // Your solution here\n        return new ArrayList<>();\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<vector<int>> levelOrder(TreeNode* root) {\n        // Your solution here\n        return {};\n    }\n};"}',
  'CORRECT APPROACH: If root is null return []. Initialize queue with root. While queue is non-empty: snapshot level_size = len(queue). Collect level_size nodes into a level list (popleft each, add non-null children). Append level list to result. Return result.\n\nWHAT COUNTS AS CORRECT: Returns a list of lists (each inner list is one level). Handles empty tree (return []). Handles single node. Correctly groups nodes by level using the level_size snapshot. O(N) time, O(W) space where W is the max width of the tree.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Using a stack instead of a queue: produces DFS order, not level order.\n- Not snapshotting level_size before the inner loop: the queue grows as children are added, so the inner loop cannot rely on real-time queue length.\n- Returning a flat list instead of a list of lists.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'trees' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why must you snapshot the queue size at the START of processing each level, rather than checking the queue size dynamically during the inner loop?',
  '["The queue is immutable and cannot be read mid-loop.", "As you process nodes you add their children to the same queue. If you check queue size dynamically, the loop continues into the next level''s nodes, mixing levels together.", "Snapshotting is only needed for the first level; subsequent levels can be processed dynamically.", "Dynamic size checking would give the correct answer but runs in O(N^2) time instead of O(N)."]',
  1,
  'Suppose level 1 has 2 nodes. You start processing them and add their children (level 2 nodes) to the queue. After processing both level-1 nodes the queue now has the level-2 nodes. If you checked queue.size() dynamically, your inner loop would continue into level-2 nodes. The snapshot (level_size = queue.size() taken BEFORE the inner loop) records exactly how many nodes belong to the current level, ensuring the inner loop processes only those nodes and stops before consuming level-2 nodes.'
FROM public.problems WHERE slug = 'binary-tree-level-order' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'BFS uses a queue while DFS uses a stack (or recursion). What property of a queue makes it produce level-order (breadth-first) output?',
  '["Queues are faster than stacks for tree traversal, which is why they produce a different output order.", "A queue is FIFO: nodes are processed in the order they were discovered. Since children are discovered left-to-right and processed before grandchildren (which are added later), nodes at the same depth are naturally grouped together.", "Queues automatically sort nodes by value, which happens to align with level order for typical binary trees.", "BFS and DFS produce the same output order; only the data structure used differs."]',
  1,
  'FIFO (first-in, first-out) is the key property. When you enqueue a node''s children, they go to the back of the queue behind all other nodes of the same level. By the time you reach them, all same-level nodes have been processed. A stack (LIFO) does the opposite: the most recently added child is processed next, plunging deep into the tree before exploring siblings. Queue → BFS (level-by-level). Stack → DFS (depth-first).'
FROM public.problems WHERE slug = 'binary-tree-level-order' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What is the space complexity of BFS level order traversal, and what determines the worst case?',
  '["O(N) in all cases — the queue always holds all N nodes at some point.", "O(W) where W is the maximum width of the tree — at any moment the queue holds at most one full level.", "O(H) where H is the height — the queue depth mirrors the recursion depth.", "O(1) — the queue reuses slots as nodes are dequeued."]',
  1,
  'At any point in the BFS the queue holds the nodes of the current level plus the children of nodes already processed in that level. The maximum queue size is bounded by the widest level of the tree. For a complete binary tree the bottom level has N/2 nodes, so W = O(N) — making the worst-case space O(N). For a skewed tree (each level has one node) W = 1 and space is O(1). The correct answer is O(W), which ranges from O(1) to O(N) depending on tree shape.'
FROM public.problems WHERE slug = 'binary-tree-level-order' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Validate Binary Search Tree',
  'validate-bst',
  'medium',
  'A common mistake in validating a BST is checking only that each node''s value is greater than its left child and less than its right child. This local check misses the global BST property: every node in the left subtree must be less than the current node, and every node in the right subtree must be greater.\n\nThe correct approach passes a valid range [min_val, max_val] down the recursion. Each node must fall strictly within its inherited range. When you go left, the max shrinks to the parent''s value. When you go right, the min grows to the parent''s value.\n\nThis "bounds propagation" technique appears in many tree problems involving global constraints, such as recovering BSTs and constructing BSTs from traversals.',
  '## Validate Binary Search Tree\n\nGiven the `root` of a binary tree, determine if it is a valid binary search tree (BST).\n\nA valid BST is defined as follows:\n- The left subtree of a node contains only nodes with keys **less than** the node''s key.\n- The right subtree of a node contains only nodes with keys **greater than** the node''s key.\n- Both the left and right subtrees must also be binary search trees.\n\n---\n\n**Example 1:**\n```\nInput:  root = [2,1,3]\nOutput: true\n```\n\n**Example 2:**\n```\nInput:  root = [5,1,4,null,null,3,6]\nOutput: false\nExplanation: The root''s right child is 4, but 4 < 5 violates the BST property.\n```\n\n---\n\n**Constraints:**\n- The number of nodes in the tree is in the range `[1, 10^4]`.\n- `-2^31 <= Node.val <= 2^31 - 1`',
  '{"python": "from typing import Optional\n\nclass Solution:\n    def isValidBST(self, root: Optional[TreeNode]) -> bool:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {TreeNode} root\n * @return {boolean}\n */\nvar isValidBST = function(root) {\n    // Your solution here\n};", "java": "class Solution {\n    public boolean isValidBST(TreeNode root) {\n        // Your solution here\n        return false;\n    }\n}", "cpp": "class Solution {\npublic:\n    bool isValidBST(TreeNode* root) {\n        // Your solution here\n        return false;\n    }\n};"}',
  'CORRECT APPROACH: Define a helper validate(node, min_val, max_val). Base case: if node is null, return True. If node.val <= min_val or node.val >= max_val, return False. Recurse: validate(node.left, min_val, node.val) AND validate(node.right, node.val, max_val). Initial call: validate(root, -infinity, +infinity).\n\nWHAT COUNTS AS CORRECT: Propagates bounds correctly. Uses strict inequalities (< and >, not <= and >=). Handles INT_MIN/INT_MAX edge cases by using -infinity and +infinity as initial bounds (not integer limits). O(N) time, O(H) space.\n\nALTERNATIVE: Inorder traversal produces a sorted sequence for a valid BST — check that each element is strictly greater than the previous.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Local check only (node.val > node.left.val AND node.val < node.right.val): fails for [5,4,6,null,null,3,7] where 3 is in the right subtree but less than 5.\n- Using integer limits (-2^31 and 2^31 - 1) as initial bounds: fails on edge-case inputs where node values equal those limits.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'trees' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The tree [5,1,4,null,null,3,6] is not a valid BST. A local check (each node''s value vs. its direct children) passes here. Why does it fail to detect the violation?',
  '["A local check is always sufficient for BST validation — the example tree is actually a valid BST.", "The local check validates only parent-child pairs. Node 3 is in the right subtree of the root (5) but is less than 5 — a violation only detectable by propagating the root''s value as a lower bound down the right subtree.", "A local check fails only when duplicate values appear in the tree.", "The local check works for all trees up to depth 3; it only fails for deeper trees."]',
  1,
  'The root is 5. Its right child is 4 (which is caught by the local check — 4 < 5). But suppose the root were 5, with right child 6, and 6''s left child were 3. The local check: 6 > 5 (ok), 3 < 6 (ok locally). But 3 < 5 — it is in the right subtree of 5, which violates the global BST property. The local check cannot catch this because it never compares 3 against the root''s value 5. Bounds propagation carries the root''s constraint all the way down.'
FROM public.problems WHERE slug = 'validate-bst' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'When recursing left, you pass (node.left, min_val, node.val). When recursing right, you pass (node.right, node.val, max_val). Why does the max shrink going left and the min grow going right?',
  '["To reduce the range and eventually force the recursion to terminate.", "Going left means every node in the left subtree must be LESS THAN the current node''s value — so node.val becomes the new upper bound. Going right means every node must be GREATER THAN the current value — so node.val becomes the new lower bound.", "The bounds are swapped going left vs. right to handle negative values correctly.", "The bounds only need updating at the root; at all other levels they remain -infinity and +infinity."]',
  1,
  'BST definition: left subtree contains values strictly less than the node, right subtree contains values strictly greater. When recursing left to validate node.left: all values there must be < node.val (the current node is the upper bound) AND > min_val (inherited from above). When recursing right to validate node.right: all values must be > node.val (the current node is the new lower bound) AND < max_val (inherited). This is exactly what the bounds update encodes.'
FROM public.problems WHERE slug = 'validate-bst' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why should the initial bounds be -infinity and +infinity rather than the minimum and maximum integer values (e.g., Integer.MIN_VALUE and Integer.MAX_VALUE in Java)?',
  '["Using -infinity is slower because floating-point comparisons are more expensive than integer comparisons.", "If a node''s value equals Integer.MIN_VALUE, the check node.val > min_val would fail even though that value is valid. Using true infinity avoids this false rejection.", "Integer limits work correctly; the infinity approach is just a stylistic preference.", "The BST property uses strict inequality, so the boundary values must be representable as valid node values."]',
  1,
  'The problem states node values can range from -2^31 to 2^31 - 1. If Integer.MIN_VALUE is used as the initial lower bound and a node has value Integer.MIN_VALUE, then node.val > Integer.MIN_VALUE is False (they are equal), and the function incorrectly returns False for a valid BST. Using negative infinity (float(''- inf'') in Python, Long.MIN_VALUE in Java, etc.) ensures the initial bounds are never equal to any valid node value. This edge case appears frequently in interview test cases.'
FROM public.problems WHERE slug = 'validate-bst' LIMIT 1;


-- ============================================================
-- ADDITIONAL PROBLEMS: Tries
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Design Add and Search Words Data Structure',
  'add-search-words',
  'medium',
  'This problem extends Implement Trie with one twist: the search query can contain a wildcard ''.'' that matches any single character. This makes search more complex — for a wildcard, you must explore all possible branches at that depth.\n\nThe key insight: for regular characters, traverse the trie exactly as before. For a dot character, recursively search ALL children at the current node and return True if any branch finds a match. This DFS-on-Trie approach is efficient because the trie prunes entire subtrees when a non-wildcard character does not match.\n\nThis problem is the gateway to pattern-matching problems on tries — a family that includes regular expression matching and word dictionaries with wildcards.',
  '## Design Add and Search Words Data Structure\n\nDesign a data structure that supports adding new words and finding if a string matches any previously added string.\n\nImplement the `WordDictionary` class:\n- `WordDictionary()` initializes the object.\n- `void addWord(word)` adds `word` to the data structure.\n- `bool search(word)` returns `true` if there is any string in the data structure that matches `word` or `false` otherwise. `word` may contain dots `''.''` where dots can be matched with any letter.\n\n---\n\n**Example:**\n```\nWordDictionary wd = new WordDictionary();\nwd.addWord("bad");\nwd.addWord("dad");\nwd.addWord("mad");\nwd.search("pad"); // false\nwd.search("bad"); // true\nwd.search(".ad"); // true\nwd.search("b.."); // true\n```\n\n---\n\n**Constraints:**\n- `1 <= word.length <= 25`\n- `word` in `addWord` consists of lowercase English letters.\n- `word` in `search` consists of `''.''` or lowercase English letters.\n- At most `10^4` calls total to `addWord` and `search`.',
  '{"python": "class TrieNode:\n    def __init__(self):\n        self.children = {}\n        self.is_end = False\n\nclass WordDictionary:\n\n    def __init__(self):\n        # Your solution here\n        pass\n\n    def addWord(self, word: str) -> None:\n        # Your solution here\n        pass\n\n    def search(self, word: str) -> bool:\n        # Your solution here\n        pass", "javascript": "class WordDictionary {\n    constructor() {\n        // Your solution here\n    }\n\n    addWord(word) {\n        // Your solution here\n    }\n\n    search(word) {\n        // Your solution here\n    }\n}", "java": "import java.util.*;\n\nclass WordDictionary {\n    public WordDictionary() {}\n    public void addWord(String word) {}\n    public boolean search(String word) { return false; }\n}", "cpp": "class WordDictionary {\npublic:\n    WordDictionary() {}\n    void addWord(string word) {}\n    bool search(string word) { return false; }\n};"}',
  'CORRECT APPROACH: addWord is identical to Trie insert. search uses a recursive DFS helper dfs(node, index): base case index == len(word): return node.is_end. For a regular character c: if c not in node.children return False; else return dfs(node.children[c], index+1). For a dot: return any(dfs(child, index+1) for child in node.children.values()).\n\nWHAT COUNTS AS CORRECT: addWord uses standard trie insertion. search handles both regular characters (exact match) and dots (branch over all children). Returns correct boolean. O(M) time for addWord, O(M) average for search without wildcards, O(26^N) worst case for all-wildcard queries.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Using a list of strings and linear scan for search: O(N*M) per search — ask how the trie prunes unnecessary comparisons.\n- Not iterating all children for a dot (only checking one): misses valid matches.\n- Forgetting is_end check at the base case: accepts prefixes as full matches.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'tries' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'When the search query encounters a dot character, the algorithm explores ALL children of the current trie node. Why must it explore all children rather than just the most likely one?',
  '["A dot represents the most frequent character, so only the most common child needs checking.", "A dot matches ANY single character. Without knowing which character was intended, every possible branch must be explored — the correct path could be under any child.", "The trie only has children for characters that appear in inserted words, so exploring all children is guaranteed to be fast.", "Exploring all children is only needed for the first dot in the query; subsequent dots can be resolved by backtracking."]',
  1,
  'A dot is a wildcard: it could match ''a'', ''b'', ''c'', ... ''z'' — any of the up to 26 children of the current node. Since we do not know which character was originally intended, we must check if any child leads to a valid match. If the first child we explore returns False, we try the next, and so on. This exhaustive branch exploration is what makes wildcard search O(26^W) in the worst case (W all-dot query) rather than O(W) for a literal query.'
FROM public.problems WHERE slug = 'add-search-words' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'How does the trie reduce search time compared to a naive list-of-words approach, even when wildcards are present?',
  '["The trie does not help with wildcard searches — both approaches are equally slow.", "The trie prunes entire subtrees when a non-wildcard character does not match any child. Only when a dot is encountered must multiple branches be explored.", "The trie is faster only when the query contains no wildcards.", "The trie stores words in sorted order, enabling binary search."]',
  1,
  'For a query like "b.." the trie immediately rules out all words not starting with ''b'' — only the ''b'' subtree is explored. The dot at position 1 then branches into all children of the ''b'' node, but only those. The dot at position 2 branches further. Compared to scanning every stored word and matching character by character, the trie prunes at the first mismatch. The advantage grows with the size of the dictionary — the trie''s branching is bounded by the actual stored words, not the full alphabet.'
FROM public.problems WHERE slug = 'add-search-words' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'A search for "..." with three dots against a dictionary containing "bat", "cat", "dog" should return true. Why does the recursive DFS correctly find a match even though all three characters are wildcards?',
  '["It does not work for all-wildcard queries — the algorithm returns false when every character is a dot.", "At the root, the dot branches into all root children (b, c, d). For each, the second dot branches into their children (a, a, o). For each of those, the third dot branches into their children (t, t, g). The base case checks is_end — and finds True for bat, cat, or dog.", "The algorithm short-circuits after the first dot since all words have the same length.", "All-wildcard queries bypass the trie and use a length check instead."]',
  1,
  'The DFS explores: root -> b -> a -> t (is_end=True, return True). The any() call at the root level returns True as soon as the b-subtree succeeds, without exploring c or d. If bat were not in the dictionary, the b-branch would return False, and the algorithm would continue to c -> a -> t (is_end=True, return True). The recursion correctly handles all-wildcard queries by exhaustively branching at each level until a terminal match is found or all options are exhausted.'
FROM public.problems WHERE slug = 'add-search-words' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Longest Common Prefix',
  'longest-common-prefix',
  'easy',
  'Finding the longest common prefix of an array of strings is a string reduction problem. The simplest approach uses vertical scanning: compare the first character of all strings, then the second, and so on. Stop as soon as any string differs at the current position or any string is exhausted.\n\nA trie-based approach inserts all words and follows the trie from the root as long as each node has exactly one child and is not a word end — this path is the common prefix. Both approaches are valid, but vertical scanning is O(S) time and O(1) space (S = total characters), making it the preferred interview answer for its simplicity.\n\nThis problem reinforces systematic multi-string comparison and the "stop at first failure" pattern.',
  '## Longest Common Prefix\n\nWrite a function to find the longest common prefix string amongst an array of strings.\n\nIf there is no common prefix, return an empty string `""`.\n\n---\n\n**Example 1:**\n```\nInput:  strs = ["flower","flow","flight"]\nOutput: "fl"\n```\n\n**Example 2:**\n```\nInput:  strs = ["dog","racecar","car"]\nOutput: ""\nExplanation: There is no common prefix among the input strings.\n```\n\n---\n\n**Constraints:**\n- `1 <= strs.length <= 200`\n- `0 <= strs[i].length <= 200`\n- `strs[i]` consists of only lowercase English letters.',
  '{"python": "from typing import List\n\nclass Solution:\n    def longestCommonPrefix(self, strs: List[str]) -> str:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {string[]} strs\n * @return {string}\n */\nvar longestCommonPrefix = function(strs) {\n    // Your solution here\n};", "java": "class Solution {\n    public String longestCommonPrefix(String[] strs) {\n        // Your solution here\n        return \"\";\n    }\n}", "cpp": "class Solution {\npublic:\n    string longestCommonPrefix(vector<string>& strs) {\n        // Your solution here\n        return \"\";\n    }\n};"}',
  'CORRECT APPROACH (vertical scan): Take the first string as the reference. For each character position i in the reference string: if i >= len(s) for any other string s, or s[i] != reference[i] for any string, return reference[:i]. If the loop completes, return the full reference string.\n\nALTERNATIVE: Horizontal scan — use the first string as prefix, then iteratively shorten it by comparing with each subsequent string.\n\nWHAT COUNTS AS CORRECT: Returns correct prefix. Returns "" for no common prefix. Handles single string (return itself). Handles all-same strings. O(S) time where S = sum of all character counts. O(1) extra space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Not handling the case where any string is shorter than the current prefix length: causes index out of bounds.\n- Comparing only consecutive pairs: fails to find the global minimum common prefix.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'tries' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The vertical scan approach uses the first string as the reference and compares column by column across all strings. What is the termination condition and why must you check EVERY string at each column?',
  '["Only the shortest string needs to be checked at each column — it defines the maximum possible prefix length.", "At column i, ALL strings must have character i equal to reference[i]. A single mismatch anywhere — or any string being shorter than i — ends the prefix. Checking every string ensures no mismatch is missed.", "Only adjacent pairs need comparison — if A matches B and B matches C, then A matches C by transitivity.", "The termination condition is when two consecutive strings differ, not when any string differs."]',
  1,
  'The common prefix must hold for ALL strings simultaneously. If string 3 out of 5 has a different character at column i, then no prefix of length > i can be shared by all 5 strings — even if strings 1, 2, 4, 5 all agree at column i. Checking only adjacent pairs or only the shortest string would miss cases like ["abc", "abd", "abz"] where the prefix is "ab" but only revealed by comparing all three at column 2.'
FROM public.problems WHERE slug = 'longest-common-prefix' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For ["flower","flow","flight"], the correct output is "fl". The vertical scan returns "fl" after finding a mismatch at column 2 (''o'' vs ''i''). What is the time complexity of this scan?',
  '["O(N * M) where N is the number of strings and M is the length of the longest string — every character in every string is potentially examined.", "O(S) where S is the total number of characters across all strings — in the worst case (all strings identical) every character is examined exactly once.", "O(N log N) — the vertical scan implicitly sorts the strings.", "O(N * P) where P is the length of the common prefix — only prefix characters are examined."]',
  1,
  'In the best case (first characters differ) only N characters are examined. In the worst case (all strings are identical) every character in every string is examined: S total. On average, the scan stops at the first column where any string diverges. Expressing complexity as O(S) accurately captures the total work: at most one comparison per character in the entire input. O(N * M) is technically an upper bound but O(S) is tighter since S = sum of lengths (not N * max_length).'
FROM public.problems WHERE slug = 'longest-common-prefix' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'An alternative approach sorts the array of strings and then compares only the first and last strings. Why does this work?',
  '["It does not work — sorting can change character positions and break the prefix relationship.", "After sorting lexicographically, the first and last strings are the most different. Any prefix shared by both is guaranteed to be shared by all strings in between.", "This only works when all strings have the same length.", "After sorting, the common prefix equals the entire first string."]',
  1,
  'Lexicographic sorting places the lexicographically smallest string first and largest string last. These two extremes are the most "different" strings in the array. Any character position where they agree is a position where ALL strings in between must also agree (since intermediate strings are lexicographically between the first and last). So comparing only the first and last strings after sorting gives the correct common prefix. This is O(N log N) for the sort plus O(M) for the comparison — often not the intended solution but a valid one.'
FROM public.problems WHERE slug = 'longest-common-prefix' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Replace Words',
  'replace-words',
  'medium',
  'Given a dictionary of root words and a sentence, replace each word in the sentence with the shortest matching root from the dictionary. If multiple roots match, use the shortest one.\n\nThe naive approach checks every word against every dictionary entry: O(W * D * L) where W = words in sentence, D = dictionary size, L = average word length. A trie over the dictionary roots reduces each lookup to O(L): traverse the trie until you hit a root marker (is_end). The first root found (shallowest is_end) is the shortest matching root.\n\nThis is a direct real-world application of tries: the trie stores root words, and sentence words are looked up as prefix queries. It also reinforces why O(K) per lookup independent of dictionary size is a key trie advantage.',
  '## Replace Words\n\nIn English, we have a concept called **root**, which can be followed by some other word to form another longer word — let''s call this word **derivative**. For example, when the root `"help"` is followed by the word `"ful"`, we can form the derivative `"helpful"`.\n\nGiven a dictionary consisting of many roots and a sentence consisting of words separated by spaces, replace all the derivatives in the sentence with the root forming it. If a derivative can be replaced by more than one root, replace it with the root that has **the shortest length**.\n\nReturn the sentence after the replacement.\n\n---\n\n**Example 1:**\n```\nInput:  dictionary = ["cat","bat","rat"], sentence = "the cattle was rattled by the battery"\nOutput: "the cat was rat by the bat"\n```\n\n**Example 2:**\n```\nInput:  dictionary = ["a","b","c"], sentence = "aadsfasf absbs bbab cadsfafs"\nOutput: "a a b c"\n```\n\n---\n\n**Constraints:**\n- `1 <= dictionary.length <= 1000`\n- `1 <= dictionary[i].length <= 100`\n- `1 <= sentence.length <= 10^6`\n- `sentence` consists of only lowercase English letters and spaces.',
  '{"python": "from typing import List\n\nclass Solution:\n    def replaceWords(self, dictionary: List[str], sentence: str) -> str:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {string[]} dictionary\n * @param {string} sentence\n * @return {string}\n */\nvar replaceWords = function(dictionary, sentence) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public String replaceWords(List<String> dictionary, String sentence) {\n        // Your solution here\n        return \"\";\n    }\n}", "cpp": "class Solution {\npublic:\n    string replaceWords(vector<string>& dictionary, string sentence) {\n        // Your solution here\n        return \"\";\n    }\n};"}',
  'CORRECT APPROACH: Build a trie from dictionary roots. For each word in the sentence, traverse the trie character by character. If you reach a node with is_end = True, replace the word with the prefix so far (it is the shortest matching root). If no root prefix is found, keep the original word. Join results.\n\nWHAT COUNTS AS CORRECT: Correctly finds the SHORTEST matching root (trie traversal naturally finds the shallowest is_end). Handles words with no matching root (keep original). Splits sentence correctly. O(D*L) to build trie, O(W*L) to process sentence. Total O((D+W)*L).\n\nALTERNATIVE: Use a hash set of roots. For each word, try all prefixes of length 1, 2, ..., len(word) and return the shortest that exists in the set. O(W * L^2) time — correct but slower.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Checking all dictionary entries per word: O(W * D * L) — ask how a trie changes the cost of lookup.\n- Returning the longest matching root instead of the shortest: misses the is_end-first guarantee of trie traversal.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'tries' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why does traversing the trie and stopping at the FIRST is_end node guarantee finding the SHORTEST matching root?',
  '["Trie traversal visits nodes in alphabetical order, and shorter words appear earlier alphabetically.", "The trie is traversed from the root outward — shallower nodes represent shorter words. The first is_end encountered on a traversal path corresponds to the shallowest (shortest) matching root.", "The trie stores roots sorted by length, so the shortest root is always found first.", "is_end nodes are only set for the shortest roots; longer roots are not marked."]',
  1,
  'Trie traversal proceeds character by character from the root. Depth equals word length. A root of length 3 is marked at depth 3; a root of length 5 is marked at depth 5. Traversing a word character by character, you encounter shallower (shorter) roots before deeper (longer) ones. The first is_end flag hit during traversal is at the minimum depth — the shortest root. If you continued past it you might find a longer root, but the problem asks for the shortest, so you stop immediately.'
FROM public.problems WHERE slug = 'replace-words' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Compare the trie approach O((D+W)*L) with a hash-set approach that tries all prefixes of each word O(W * L^2). For D=1000, W=50000, L=10, which is faster and by how much?',
  '["The hash-set approach is faster because hash lookups are O(1) while trie traversal is O(L).", "Trie: (1000 + 50000) * 10 = 510,000 operations. Hash set: 50000 * 100 = 5,000,000 operations. The trie is about 10x faster.", "Both approaches have the same complexity when L is small.", "The trie is slower because it requires building the trie upfront, which the hash set avoids."]',
  1,
  'Trie: building costs D*L = 10,000; processing costs W*L = 500,000; total ~510,000. Hash set: for each of W=50,000 words, check up to L=10 prefixes, each lookup is O(prefix_length) = O(L). Total: W * L * L = 50,000 * 10 * 10 = 5,000,000. The trie is approximately 10x faster here. The advantage grows when L is larger or when many words share common prefixes (the trie avoids reprocessing shared prefix nodes).'
FROM public.problems WHERE slug = 'replace-words' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For the word "cattle" and dictionary ["cat","cattle"], the expected output is "cat" (the shorter root). What happens in the trie traversal that produces this result?',
  '["Both roots are found and the algorithm picks the shorter one by comparing lengths.", "At depth 3 (after traversing c->a->t) the node has is_end=True (marking ''cat''). Traversal stops immediately and returns ''cat''. The longer root ''cattle'' is never reached.", "The trie is searched in reverse, finding ''cattle'' first and then backtracking to ''cat''.", "The trie finds both roots and returns the one with the higher priority in the dictionary ordering."]',
  1,
  'Traversal of "cattle": c (depth 1) -> a (depth 2) -> t (depth 3, is_end=True). We have found the root "cat". The traversal stops here and returns "cat" without examining t->l->e. Even though "cattle" is also in the dictionary, we never reach its is_end marker at depth 6 because we exited at depth 3. This early exit is the core behavior that makes trie prefix matching find the shortest root.'
FROM public.problems WHERE slug = 'replace-words' LIMIT 1;


-- ============================================================
-- ADDITIONAL PROBLEMS: Heap / Priority Queue
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Last Stone Weight',
  'last-stone-weight',
  'easy',
  'Each round you smash the two heaviest stones together. You always need the two largest elements quickly, which is the textbook max-heap use case.\n\nIn Python, heapq is a min-heap. To simulate a max-heap, negate values on push and negate again on pop. This negation trick is a standard interview pattern.\n\nThis problem is simpler than Kth Largest in a Stream but introduces the max-heap need — most heap interview problems want the maximum, not the minimum. Recognizing "I need the largest k elements efficiently" as a max-heap signal is the core skill.',
  '## Last Stone Weight\n\nYou are given an array of integers `stones` where `stones[i]` is the weight of the `i`th stone.\n\nWe are playing a game with the stones. On each turn, we smash together the two **heaviest** stones. Suppose the heaviest stones have weights `x` and `y` with `x <= y`. The result of this smash is:\n- If `x == y`, both stones are destroyed.\n- If `x != y`, the stone of weight `x` is destroyed, and the stone of weight `y` has new weight `y - x`.\n\nAt the end of the game, there is **at most one** stone left. Return the weight of the last remaining stone. If there are no stones remaining, return `0`.\n\n---\n\n**Example 1:**\n```\nInput:  stones = [2,7,4,1,8,1]\nOutput: 1\n```\n\n**Example 2:**\n```\nInput:  stones = [1]\nOutput: 1\n```\n\n---\n\n**Constraints:**\n- `1 <= stones.length <= 30`\n- `1 <= stones[i] <= 1000`',
  '{"python": "import heapq\nfrom typing import List\n\nclass Solution:\n    def lastStoneWeight(self, stones: List[int]) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} stones\n * @return {number}\n */\nvar lastStoneWeight = function(stones) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public int lastStoneWeight(int[] stones) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class Solution {\npublic:\n    int lastStoneWeight(vector<int>& stones) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Build a max-heap from stones (negate in Python). While heap has more than one element: pop two largest (y and x, y >= x). If y != x, push y - x back. After the loop, return heap[0] if non-empty, else 0.\n\nWHAT COUNTS AS CORRECT: Uses a max-heap (not sorting after each round). Correctly handles equal weights (both destroyed, do not push 0). Returns 0 if all stones are destroyed. O(N log N) time, O(N) space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Sorting the array after each round: O(N^2 log N) — ask which data structure gives the two largest elements in O(log N).\n- Pushing 0 when both weights are equal: causes extra no-op elements in the heap.\n- Using min-heap and finding the two smallest: gives wrong stones.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'heap-priority-queue' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Python''s heapq module provides a min-heap. How do you simulate a max-heap using it?',
  '["Use heapq.nlargest() instead of heappush/heappop.", "Negate all values before pushing and negate again after popping. The min-heap ordering on negative values is equivalent to max-heap ordering on positive values.", "Reverse the list before heapifying.", "Use a sorted list with bisect instead of heapq."]',
  1,
  'If you push -7, -4, -2 into a min-heap, the minimum is -7 — which corresponds to the maximum positive value 7. When you pop -7 and negate it, you get 7: the correct maximum. This negation trick works for any numeric heap and is the standard Python interview pattern for max-heap behavior. In Java you pass a comparator (Comparator.reverseOrder()); in C++ you use priority_queue which is max-heap by default.'
FROM public.problems WHERE slug = 'last-stone-weight' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'When the two heaviest stones have equal weight (x == y), both are destroyed. Why should you NOT push 0 back onto the heap?',
  '["You should push 0 — it represents the destroyed stone and is needed to track the count.", "Pushing 0 is harmless — a stone of weight 0 can never be the last stone.", "Pushing 0 adds a dead-weight element to the heap. It can be popped as the ''heaviest'' stone in a subsequent round if all real stones have been destroyed, incorrectly returning 0 when the heap should be empty.", "You should push 0 only when the list has an even number of stones."]',
  2,
  'If you push 0 when two equal stones cancel, the heap gains a phantom element. In a subsequent round, if only real stone X remains, the algorithm pops X and 0, computes X - 0 = X, and pushes X back — entering an infinite loop (or returning X correctly only by coincidence). Not pushing anything when y - x == 0 keeps the heap accurate. At the end, if the heap is empty, return 0 explicitly; otherwise return the last element.'
FROM public.problems WHERE slug = 'last-stone-weight' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What is the time complexity of the heap-based solution for N initial stones?',
  '["O(N^2) — each of the N rounds may require scanning all remaining stones.", "O(N log N) — heapify is O(N), and each of at most N rounds requires two O(log N) pops and one O(log N) push.", "O(N) — heap operations are O(1) amortized.", "O(N^2 log N) — sorting is needed after each round to restore heap order."]',
  1,
  'Heapifying all N stones is O(N). Each round: two pops (O(log N) each) and possibly one push (O(log N)). At most N-1 rounds occur (each round reduces the stone count by at least 1). Total: O(N) + O(N * log N) = O(N log N). Sorting the array after each round would be O(N * N log N) = O(N^2 log N) — far worse. The heap maintains sorted-order access in O(log N) per operation, which is its core advantage here.'
FROM public.problems WHERE slug = 'last-stone-weight' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'K Closest Points to Origin',
  'k-closest-points-origin',
  'medium',
  'Find the K points closest to the origin (0,0). Distance is measured by Euclidean distance, but you do not need to compute the square root — comparing squared distances is sufficient and avoids floating-point issues.\n\nThe sorting approach — sort all points by distance, return the first K — is O(N log N). The heap approach is O(N log K): maintain a max-heap of size K. When the heap exceeds K, evict the farthest point. The heap always holds the K closest seen so far.\n\nThis problem reinforces the "top K by a custom key" pattern. Any "find K closest / K smallest / K largest" problem by some metric maps directly to this approach. The distance formula is the custom key; the pattern is identical to Top K Frequent Elements.',
  '## K Closest Points to Origin\n\nGiven an array of `points` where `points[i] = [xi, yi]` represents a point on the X-Y plane and an integer `k`, return the `k` closest points to the origin `(0, 0)`.\n\nThe distance between two points on the X-Y plane is the Euclidean distance: `sqrt((x1 - x2)^2 + (y1 - y2)^2)`.\n\nYou may return the answer in **any order**. The answer is **guaranteed** to be unique (except for the order that it is in).\n\n---\n\n**Example 1:**\n```\nInput:  points = [[1,3],[-2,2]], k = 1\nOutput: [[-2,2]]\nExplanation: Distance of [1,3] from origin = sqrt(10). Distance of [-2,2] = sqrt(8). [-2,2] is closer.\n```\n\n**Example 2:**\n```\nInput:  points = [[3,3],[5,-1],[-2,4]], k = 2\nOutput: [[3,3],[-2,4]]\n```\n\n---\n\n**Constraints:**\n- `1 <= k <= points.length <= 10^4`\n- `-10^4 <= xi, yi <= 10^4`',
  '{"python": "import heapq\nfrom typing import List\n\nclass Solution:\n    def kClosest(self, points: List[List[int]], k: int) -> List[List[int]]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[][]} points\n * @param {number} k\n * @return {number[][]}\n */\nvar kClosest = function(points, k) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public int[][] kClosest(int[][] points, int k) {\n        // Your solution here\n        return new int[][]{};\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<vector<int>> kClosest(vector<vector<int>>& points, int k) {\n        // Your solution here\n        return {};\n    }\n};"}',
  'CORRECT APPROACH (max-heap, O(N log K)): Maintain a max-heap of size K keyed by squared distance. For each point: push (-dist_sq, point) onto the heap (negated for max-heap simulation in Python). If heap size > K, pop the farthest. After all points, return the K points remaining in the heap.\n\nALTERNATIVE (sort, O(N log N)): Sort points by squared distance, return first K. Simpler to code but slower.\n\nWHAT COUNTS AS CORRECT: Uses squared distance (avoids sqrt). Returns exactly K points. Does not need to be in sorted order. O(N log K) or O(N log N) are both acceptable.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Computing sqrt: unnecessary and introduces floating-point imprecision. Point out that comparing x^2 + y^2 preserves the same ordering as comparing sqrt(x^2 + y^2).\n- Using a min-heap of all N points: O(N log N) space and time — same as sorting.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'heap-priority-queue' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why is it valid to compare squared distances (x^2 + y^2) instead of actual Euclidean distances (sqrt(x^2 + y^2)) when finding the K closest points?',
  '["It is only valid when all coordinates are non-negative.", "The square root function is monotonically increasing: if A^2 < B^2 and both are non-negative, then A < B. So comparing squared distances gives the same ordering as comparing actual distances.", "Squared distances are always smaller than actual distances, which biases the comparison in favor of closer points.", "It is a valid approximation for large distances but inaccurate for small distances."]',
  1,
  'For non-negative values, sqrt is strictly increasing. This means sqrt(a) < sqrt(b) if and only if a < b (when a, b >= 0). Since x^2 + y^2 is always non-negative, comparing x1^2 + y1^2 vs x2^2 + y2^2 produces exactly the same ordering as comparing sqrt(x1^2+y1^2) vs sqrt(x2^2+y2^2). Skipping the sqrt saves computation and avoids floating-point rounding errors. This monotone-transform trick is applicable whenever the comparison key is a monotone function of a simpler expression.'
FROM public.problems WHERE slug = 'k-closest-points-origin' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The max-heap approach uses a max-heap (largest distance at the top) rather than a min-heap. Why does tracking the K closest points require a max-heap?',
  '["A min-heap would give the single closest point; a max-heap gives the K closest.", "The heap holds the K closest candidates. When a new point arrives, if it is closer than the current farthest in the heap, we replace the farthest. The heap top (the farthest of the K candidates) must be quickly accessible and removable — which is what a max-heap provides.", "A max-heap is used because the K closest points are the K largest by distance.", "Max-heap is only used when K > N/2; for small K a min-heap is preferred."]',
  1,
  'Invariant: the heap holds the K closest points seen so far. When a new point arrives, we compare it to the farthest point in our current K candidates. If the new point is closer than that farthest, we swap them. We need O(1) access to the farthest of the K candidates (to compare) and O(log K) removal (to evict it). A max-heap satisfies both: the maximum (farthest) is at the top in O(1); removal is O(log K). A min-heap would give us the closest of the K candidates, which is not the one we want to evict.'
FROM public.problems WHERE slug = 'k-closest-points-origin' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For N = 10^4 points and K = 3, compare the sort approach (O(N log N)) and the heap approach (O(N log K)). How much faster is the heap in terms of operations?',
  '["The heap is about the same speed — N dominates both expressions.", "Sort: N * log(N) = 10000 * 14 = 140,000 operations. Heap: N * log(K) = 10000 * log(3) ≈ 10000 * 1.6 = 16,000 operations. The heap is about 9x faster.", "The sort is faster because modern sorting algorithms have better cache performance.", "The heap is O(1) for K=3 because the heap size is constant."]',
  1,
  'log(10000) ≈ 14; log(3) ≈ 1.6. The heap does about 9x fewer operations per point than the sort. For K=3 the heap is dramatically faster, and this gap grows as N increases. The heap advantage is greatest when K is much smaller than N — the "find K out of N" scenario. When K approaches N, the sort is comparable or better due to cache efficiency. Choosing between them based on the K/N ratio is a practical algorithm selection skill.'
FROM public.problems WHERE slug = 'k-closest-points-origin' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Find Median from Data Stream',
  'find-median-data-stream',
  'hard',
  'Finding the median of a static sorted array is trivial: return the middle element. But the median of a dynamic stream — where new elements arrive one at a time — requires maintaining a structure that can efficiently retrieve the median after each insertion.\n\nThe two-heap approach: maintain a max-heap for the lower half and a min-heap for the upper half. The max-heap''s top is the largest in the lower half; the min-heap''s top is the smallest in the upper half. The median is either the top of the larger heap (odd total) or the average of both tops (even total).\n\nBalance the heaps after each insertion so they differ in size by at most 1. Each add is O(log N); each findMedian is O(1).\n\nThis is the most sophisticated heap problem in this module — it requires reasoning about two heaps simultaneously and maintaining their invariant.',
  '## Find Median from Data Stream\n\nThe **median** is the middle value in an ordered integer list. If the size of the list is even, there is no middle value, and the median is the mean of the two middle values.\n\nImplement the `MedianFinder` class:\n- `MedianFinder()` initializes the `MedianFinder` object.\n- `void addNum(int num)` adds the integer `num` from the data stream to the data structure.\n- `double findMedian()` returns the median of all elements so far.\n\n---\n\n**Example:**\n```\nMedianFinder mf = new MedianFinder();\nmf.addNum(1);    // arr = [1]\nmf.findMedian(); // 1.0\nmf.addNum(2);    // arr = [1, 2]\nmf.findMedian(); // 1.5\nmf.addNum(3);    // arr = [1, 2, 3]\nmf.findMedian(); // 2.0\n```\n\n---\n\n**Constraints:**\n- `-10^5 <= num <= 10^5`\n- At most `5 * 10^4` calls to `addNum` and `findMedian`.',
  '{"python": "import heapq\n\nclass MedianFinder:\n\n    def __init__(self):\n        # Your solution here\n        pass\n\n    def addNum(self, num: int) -> None:\n        # Your solution here\n        pass\n\n    def findMedian(self) -> float:\n        # Your solution here\n        pass", "javascript": "var MedianFinder = function() {\n    // Your solution here\n};\n\nMedianFinder.prototype.addNum = function(num) {\n    // Your solution here\n};\n\nMedianFinder.prototype.findMedian = function() {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass MedianFinder {\n    public MedianFinder() {}\n    public void addNum(int num) {}\n    public double findMedian() { return 0.0; }\n}", "cpp": "class MedianFinder {\npublic:\n    MedianFinder() {}\n    void addNum(int num) {}\n    double findMedian() { return 0.0; }\n};"}',
  'CORRECT APPROACH: Maintain small (max-heap, lower half) and large (min-heap, upper half). For addNum: push to small. Then push small''s max to large. If len(large) > len(small), push large''s min back to small. This keeps len(small) >= len(large) with at most 1 difference.\n\nFor findMedian: if len(small) > len(large), return small[0] (the max). Else return (small[0] + large[0]) / 2.0.\n\nWHAT COUNTS AS CORRECT: Maintains the two-heap invariant after every add. Correctly returns median for odd and even totals. O(log N) addNum, O(1) findMedian.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Using a sorted list and resorting: O(N log N) per add.\n- Not rebalancing after each add: heaps can become unequal in size, breaking findMedian.\n- Returning integer division instead of float division: wrong for even-count medians.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'heap-priority-queue' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The solution maintains two heaps: a max-heap (small) for the lower half and a min-heap (large) for the upper half. What invariant must always hold between these two heaps?',
  '["Both heaps must always have the same size.", "small.max <= large.min (every element in the lower half is <= every element in the upper half), AND the sizes differ by at most 1 so the median is always the top of the larger heap or the average of both tops.", "large must always be larger than small by exactly 1 element.", "The heaps can be any size as long as the total count is correct."]',
  1,
  'Two invariants must hold simultaneously. First, ordering: max(small) <= min(large) — otherwise we would have a lower-half element larger than an upper-half element, violating the partition. Second, balance: |len(small) - len(large)| <= 1 — this ensures the median is accessible in O(1). If the heaps were arbitrarily sized, the median could be deep inside one of them and we would need O(log N) to retrieve it. Maintaining both invariants after every add is the central challenge of this problem.'
FROM public.problems WHERE slug = 'find-median-data-stream' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why must you always push the new element to small first (then rebalance to large), rather than directly comparing it to small.max and inserting into the appropriate heap?',
  '["Directly comparing is equally correct and simpler — the approach described is just a matter of implementation style.", "Direct comparison only works for positive numbers. Pushing to small first handles negative numbers correctly.", "Pushing to small first then moving the max to large guarantees the ordering invariant (max(small) <= min(large)) with minimal conditional logic. Direct insertion requires checking the new element against the heap tops and handling multiple cases.", "Pushing to small first is only correct when the two heaps are the same size."]',
  2,
  'The push-to-small-then-rebalance approach maintains both invariants (ordering and balance) with a fixed two-step procedure: push to small, move small''s max to large, then if large is bigger move large''s min back to small. This always produces a valid state. Direct insertion requires at least two comparisons and multiple branches: is the new element <= small.max? Is len(small) > len(large) after? Edge cases multiply. The push-to-small approach is simpler to reason about and less error-prone in interviews.'
FROM public.problems WHERE slug = 'find-median-data-stream' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'After inserting 5 elements, small has 3 elements and large has 2. findMedian() should return small[0] (the max of the lower half). Why?',
  '["Because 5 is odd, the median is the middle element — the 3rd element in sorted order, which is small''s maximum (the largest of the lower 3).", "Because small is always the larger heap, its max is always the median.", "The median is large[0] (the min of the upper half) when sizes differ by 1.", "The median is always the average of small[0] and large[0] regardless of sizes."]',
  0,
  'With 5 elements, the median is the 3rd element in sorted order (1-indexed). The lower half (small) holds the 3 smallest elements; the upper half (large) holds the 2 largest. The 3rd element is the maximum of the lower half — small[0] (a max-heap''s top). When sizes are equal (even total), the median is the average of the largest lower-half element (small[0]) and the smallest upper-half element (large[0]). The size comparison determines which case applies.'
FROM public.problems WHERE slug = 'find-median-data-stream' LIMIT 1;


-- ============================================================
-- ADDITIONAL PROBLEMS: Backtracking
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Combinations',
  'combinations',
  'medium',
  'Combinations is Subsets with a constraint: only subsets of exactly size K are valid. This requires a small modification to the backtracking template: record the current path only when it reaches exactly K elements, and stop recursing once the path is full.\n\nAn important pruning optimization: if the remaining elements in [start, n] are fewer than K - len(current), there is no way to complete a valid combination. You can skip recursion in this case. This pruning can dramatically reduce the search space for small K with large n.\n\nCombinations is the generalization of the "choose K from N" combinatorial structure, which appears in combination sum problems, card game simulations, and any problem that requires choosing a fixed-size subset.',
  '## Combinations\n\nGiven two integers `n` and `k`, return all possible combinations of `k` numbers chosen from the range `[1, n]`.\n\nYou may return the answer in any order.\n\n---\n\n**Example 1:**\n```\nInput:  n = 4, k = 2\nOutput: [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]\n```\n\n**Example 2:**\n```\nInput:  n = 1, k = 1\nOutput: [[1]]\n```\n\n---\n\n**Constraints:**\n- `1 <= n <= 20`\n- `1 <= k <= n`',
  '{"python": "from typing import List\n\nclass Solution:\n    def combine(self, n: int, k: int) -> List[List[int]]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number} n\n * @param {number} k\n * @return {number[][]}\n */\nvar combine = function(n, k) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public List<List<Integer>> combine(int n, int k) {\n        // Your solution here\n        return new ArrayList<>();\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<vector<int>> combine(int n, int k) {\n        // Your solution here\n        return {};\n    }\n};"}',
  'CORRECT APPROACH: Define backtrack(start, current). If len(current) == k, append a copy to result and return. For i from start to n (inclusive): append i, recurse with backtrack(i+1, current), pop i.\n\nPRUNING: Only iterate i up to n - (k - len(current)) + 1 — there must be enough remaining numbers to complete the combination.\n\nWHAT COUNTS AS CORRECT: Produces exactly C(n, k) combinations. No duplicates. Records only when len(current) == k. Appends a copy (not reference). O(k * C(n,k)) time.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Recording all paths (not just k-length ones): produces subsets, not combinations of size k.\n- Starting recursive loop from 1 instead of start: produces duplicate combinations with elements in different orders.\n- Missing the backtrack (pop) step.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'backtracking' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The recursive call uses backtrack(i+1, current) — starting the next level from i+1, not from i or from 1. Why?',
  '["Starting from i+1 skips i, ensuring i is not repeated in the current combination.", "Starting from i+1 prevents using i again in the same combination (no repetition) AND ensures combinations are generated in sorted order (no duplicates due to ordering).", "Starting from i+1 is an optimization that reduces but does not affect correctness.", "Starting from 1 each time would produce permutations rather than combinations."]',
  1,
  'Two reasons in one: starting from i+1 ensures (1) no element is used twice within a combination (i itself is already in current) and (2) all combinations are generated with elements in increasing order, preventing duplicates like [2,1] and [1,2] from both appearing. If you started from 1 each time, [1,2] and [2,1] would both be generated. Starting from i+1 encodes the "choose from remaining elements only" contract that defines combinations (unordered selection).'
FROM public.problems WHERE slug = 'combinations' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'An optimized loop runs i from start to n - (k - len(current)) + 1 instead of start to n. What is this pruning doing?',
  '["It limits the loop to only even or only odd numbers depending on k.", "If there are fewer remaining numbers than needed to complete a combination of size k, no valid combination can be formed from i onwards. The loop stops early to avoid futile recursion.", "It ensures the last element added is always the largest, keeping combinations sorted.", "This pruning only applies when n > 20; for smaller n it has no effect."]',
  1,
  'Suppose n=10, k=4, and current already has 2 elements. We need 2 more. If we are at i=9, there is only one remaining number (10), but we need 2. No valid combination can be completed from i=9. The pruned upper bound: i <= n - (k - len(current)) + 1 = 10 - 2 + 1 = 9. So i runs up to 8 (inclusive), stopping before 9. This eliminates subtrees that cannot possibly produce a valid combination, which is a significant constant-factor speedup for large n with small k.'
FROM public.problems WHERE slug = 'combinations' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'How many combinations does combine(4, 2) produce, and how does this match C(4,2)?',
  '["8 combinations — 4 choices for the first element times 2 choices for the second.", "6 combinations — C(4,2) = 4! / (2! * 2!) = 6, matching the example output [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]].", "4 combinations — one for each starting element.", "12 combinations — 4*3 ordered pairs divided by a deduplication factor."]',
  1,
  'C(4,2) = 4! / (2! * 2!) = 24 / 4 = 6. The example output shows exactly 6 combinations. The backtracking generates them without duplicates because the loop always starts from i+1 — ensuring each pair is counted once in increasing order. Unlike permutations (P(4,2) = 12), combinations do not count different orderings of the same pair as distinct. The formula C(n,k) = n! / (k! * (n-k)!) gives the exact number of results the backtracking will produce.'
FROM public.problems WHERE slug = 'combinations' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Permutations',
  'permutations',
  'medium',
  'Permutations generates all orderings of a set of distinct integers — a classic backtracking problem. Unlike Combinations (which picks without regard to order) and Subsets (which builds up from left to right), Permutations allows each element to appear at any position, so the recursive loop always starts from index 0 but skips elements already in the current path.\n\nThe key modification: track which elements have been used (via a boolean array or by checking if the element is already in current). At each step, try all unused elements; after recursing, mark the element as unused again (backtrack).\n\nThe number of permutations is N! — much larger than 2^N (subsets) or C(N,K) (combinations). Understanding why and how the search tree differs from those problems is the core conceptual lesson here.',
  '## Permutations\n\nGiven an array `nums` of distinct integers, return all the possible permutations. You can return the answer in any order.\n\n---\n\n**Example 1:**\n```\nInput:  nums = [1,2,3]\nOutput: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]\n```\n\n**Example 2:**\n```\nInput:  nums = [0,1]\nOutput: [[0,1],[1,0]]\n```\n\n**Example 3:**\n```\nInput:  nums = [1]\nOutput: [[1]]\n```\n\n---\n\n**Constraints:**\n- `1 <= nums.length <= 6`\n- `-10 <= nums[i] <= 10`\n- All the integers of `nums` are unique.',
  '{"python": "from typing import List\n\nclass Solution:\n    def permute(self, nums: List[int]) -> List[List[int]]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} nums\n * @return {number[][]}\n */\nvar permute = function(nums) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public List<List<Integer>> permute(int[] nums) {\n        // Your solution here\n        return new ArrayList<>();\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<vector<int>> permute(vector<int>& nums) {\n        // Your solution here\n        return {};\n    }\n};"}',
  'CORRECT APPROACH: Define backtrack(current, used). Base case: len(current) == len(nums): append copy of current to result, return. For each i in range(len(nums)): if used[i] is True, skip. Mark used[i] = True, append nums[i], recurse, pop nums[i], mark used[i] = False.\n\nALTERNATIVE: Swap-based approach — swap nums[start] with nums[i] for each i in [start, end], recurse, then swap back. Avoids the used array.\n\nWHAT COUNTS AS CORRECT: Produces exactly N! permutations. No duplicates. Uses a mechanism to skip already-used elements. Appends copies. O(N * N!) time.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Using start index (like Combinations): generates only sorted-order combinations, not all orderings.\n- Checking "nums[i] in current" instead of a used array: O(N) per check, making the algorithm O(N^2 * N!) total — correct but unnecessarily slow.\n- Appending current without copying.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'backtracking' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'In the Subsets and Combinations problems, the inner loop starts from a ''start'' index and moves forward. Why does the Permutations inner loop iterate over ALL indices (0 to N-1) instead?',
  '["Permutations requires checking all indices for correctness even though most are skipped.", "Permutations allow each position to be filled by any unused element, regardless of its original index. Elements can appear in any order, so all indices must be considered at every recursive level.", "The start-index approach also works for permutations but is slightly less efficient.", "Permutations use all indices because the numbers can be negative."]',
  1,
  'In Subsets/Combinations, we enforce increasing order to avoid duplicate subsets: [1,2] and [2,1] are the same subset. The start index achieves this. In Permutations, [1,2] and [2,1] ARE distinct permutations and both must be generated. So we cannot restrict the loop to elements after a start index — we must consider all positions. The used array (or swap mechanism) prevents using the same element twice, while the all-indices loop ensures all orderings are explored.'
FROM public.problems WHERE slug = 'permutations' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For N = 3 (nums = [1,2,3]), the algorithm produces 6 permutations. Why is the count N! = 6 and not 2^N = 8 (as in Subsets)?',
  '["Permutations is more restrictive than Subsets, so it produces fewer results.", "Subsets allow any number of elements (0 to N); permutations use exactly all N elements in some order. With N choices for position 1, N-1 for position 2, ..., 1 for position N: N! orderings total.", "The count 2^N would be correct if order mattered in Subsets.", "N! < 2^N always, which is why permutations produce fewer results than subsets."]',
  1,
  'Subsets: choose 0, 1, 2, ... or N elements from N options — 2^N total. Permutations: arrange all N elements — N! total. For N=3: 2^3=8 subsets but 3!=6 permutations. Note 2^N and N! compare differently as N grows: 2^10=1024 but 10!=3,628,800. Permutations grow far faster than subsets for large N because every arrangement of all elements is counted. The search tree has N levels of branching factor N, N-1, N-2, ..., 1 — the product of which is N!.'
FROM public.problems WHERE slug = 'permutations' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The swap-based permutation approach swaps nums[start] with nums[i], recurses, then swaps back. How does this avoid the need for a separate ''used'' array?',
  '["It does not avoid a used array — swapping is just an alternative way to mark elements as used.", "By swapping nums[i] into position start, all elements before start are already placed (unavailable) and all elements from start onward are candidates. No separate tracking is needed — the array''s own state encodes which elements are used.", "The swap approach generates permutations in sorted order, which makes a used array unnecessary.", "The swap approach only works for arrays without duplicate values."]',
  1,
  'After placing nums[start] (the chosen element), everything at index < start is locked in (part of the current prefix). Elements at index >= start are the remaining candidates. By swapping nums[i] into position start, the chosen element is "consumed" (moved before the recursion boundary) without a separate data structure. After recursing, the swap is undone, restoring the original order for the next iteration. The array''s left/right partitioning implicitly tracks "used" vs "available."'
FROM public.problems WHERE slug = 'permutations' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Letter Combinations of a Phone Number',
  'letter-combinations-phone',
  'medium',
  'Given a string of digits, return all letter combinations that the digits could represent (as on a phone keypad). Each digit maps to 2-4 letters; you must produce all combinations across all digits.\n\nThis is backtracking applied to a product space: the total number of combinations is the product of the number of letters per digit. The recursive structure is natural: at each level, try all letters for the current digit, recurse for the rest, and backtrack.\n\nThis problem differs from Subsets and Combinations in that the "choices" at each level vary (digit 2 gives "abc", digit 3 gives "def", etc.) — the backtracking framework handles non-uniform branching cleanly. It is a gateway to word-break, word-search, and autocomplete problems.',
  '## Letter Combinations of a Phone Number\n\nGiven a string containing digits from `2-9` inclusive, return all possible letter combinations that the number could represent. Return the answer in **any order**.\n\nA mapping of digits to letters (just like on a telephone dial) is given below.\n```\n2: abc   3: def   4: ghi   5: jkl\n6: mno   7: pqrs  8: tuv   9: wxyz\n```\n\n---\n\n**Example 1:**\n```\nInput:  digits = "23"\nOutput: ["ad","ae","af","bd","be","bf","cd","ce","cf"]\n```\n\n**Example 2:**\n```\nInput:  digits = ""\nOutput: []\n```\n\n**Example 3:**\n```\nInput:  digits = "2"\nOutput: ["a","b","c"]\n```\n\n---\n\n**Constraints:**\n- `0 <= digits.length <= 4`\n- `digits[i]` is a digit in the range `[''2'', ''9'']`.',
  '{"python": "from typing import List\n\nclass Solution:\n    def letterCombinations(self, digits: str) -> List[str]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {string} digits\n * @return {string[]}\n */\nvar letterCombinations = function(digits) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public List<String> letterCombinations(String digits) {\n        // Your solution here\n        return new ArrayList<>();\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<string> letterCombinations(string digits) {\n        // Your solution here\n        return {};\n    }\n};"}',
  'CORRECT APPROACH: Define a phone_map dictionary. If digits is empty, return []. Define backtrack(index, current_str). Base case: index == len(digits): append current_str to result. For each letter in phone_map[digits[index]]: recurse with backtrack(index+1, current_str + letter). Call backtrack(0, "").\n\nSince strings are immutable (no explicit backtrack step needed in Python — concatenation creates a new string), the pattern is slightly simpler than list-based backtracking.\n\nWHAT COUNTS AS CORRECT: Returns [] for empty input. Correct mapping for all digits 2-9. Produces exactly product of letters-per-digit combinations. O(N * 4^N) time where N is the number of digits.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Not handling empty input (returning [[""]] instead of []).\n- Hardcoding letters rather than using a map: fragile and unreadable.\n- Using index for something other than tracking position in digits.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'backtracking' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For digits = "23", the output has 9 combinations (3 letters for ''2'' times 3 letters for ''3''). For "79", how many combinations are there and why?',
  '["9 combinations — all digit pairs produce 3*3 combinations.", "16 combinations — digit ''7'' maps to 4 letters (pqrs) and digit ''9'' maps to 4 letters (wxyz). 4 * 4 = 16.", "8 combinations — the product is 2 * 4 = 8.", "12 combinations — both digits together produce 12 combinations."]',
  1,
  'Digit ''7'' maps to "pqrs" (4 letters); digit ''9'' maps to "wxyz" (4 letters). The total combinations for two digits is the product of the number of letters per digit: 4 * 4 = 16. Unlike "23" where each digit maps to 3 letters (9 total), digits 7 and 9 have 4 letters each. This non-uniform branching is exactly why the backtracking framework (which adapts to the number of choices at each level via the phone_map) handles this cleanly, whereas a fixed-structure loop would not.'
FROM public.problems WHERE slug = 'letter-combinations-phone' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'In string-based backtracking (building a string instead of a list), you concatenate the letter directly: backtrack(index+1, current_str + letter). Why is there no explicit "undo" step needed here?',
  '["There is no undo step because letter combinations are always built left to right.", "String concatenation creates a new string object; the original current_str is unchanged. After the recursive call returns, current_str still refers to the original value — no explicit pop or undo is needed.", "The undo step is implicit in the for loop which resets the letter on each iteration.", "Strings in Python are mutable, so concatenation modifies in place and must be undone."]',
  1,
  'Python strings are immutable. current_str + letter creates a brand-new string; current_str itself is unchanged. Each recursive call receives its own copy. When the call returns, the caller''s current_str is exactly as it was before. Contrast this with list-based backtracking where current.append(item) modifies the shared list — requiring an explicit current.pop() after the recursive call. Immutability gives you backtracking "for free" at the cost of O(N) memory per concatenation instead of O(1) append/pop.'
FROM public.problems WHERE slug = 'letter-combinations-phone' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What should the function return when digits = "" (empty string), and why must this be a special case?',
  '["Return [\"\"] — an empty string is a valid combination of zero digits.", "Return [] — there are no digits to combine, so there are no valid combinations.", "Return [[]] — the empty combination is represented as an empty list.", "The algorithm handles empty input naturally without a special case."]',
  1,
  'When digits is empty, there are zero choices to make and zero valid combinations to produce. The expected output is [] (no combinations), not [""] (which would mean "one combination consisting of an empty string"). Without a special case, the backtracking base case (index == len(digits)) fires immediately and appends current_str = "" to result — producing [""] instead of []. The empty-input guard (return [] if not digits) must precede the backtracking call to handle this correctly.'
FROM public.problems WHERE slug = 'letter-combinations-phone' LIMIT 1;


-- ============================================================
-- ADDITIONAL PROBLEMS: Graphs
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Clone Graph',
  'clone-graph',
  'medium',
  'Cloning a graph requires creating a deep copy — new nodes with the same values and edges, but as entirely separate objects. The challenge is handling cycles: a naive recursive approach would follow a cycle indefinitely.\n\nThe solution: use a hash map from original node to its clone. Before recursing into any neighbor, check if the clone already exists. If it does, return the existing clone (breaking the cycle). If not, create it, map it, then recurse.\n\nThis "visited map" pattern — mapping original to copy — is the standard approach for deep-copying graphs and is the same pattern used in cycle detection and memoization. It appears in serialization/deserialization of graphs and clone-based problems.',
  '## Clone Graph\n\nGiven a reference of a node in a **connected undirected graph**, return a **deep copy** (clone) of the graph.\n\nEach node in the graph contains a value (`int`) and a list (`List[Node]`) of its neighbors.\n\n```\nclass Node {\n    public int val;\n    public List<Node> neighbors;\n}\n```\n\n---\n\n**Example 1:**\n```\nInput:  adjList = [[2,4],[1,3],[2,4],[1,3]]\nOutput: [[2,4],[1,3],[2,4],[1,3]]\nExplanation: A deep copy with the same structure.\n```\n\n**Example 2:**\n```\nInput:  adjList = [[]]\nOutput: [[]]\n```\n\n**Example 3:**\n```\nInput:  node = null\nOutput: null\n```\n\n---\n\n**Constraints:**\n- The number of nodes is in the range `[0, 100]`.\n- `1 <= Node.val <= 100`\n- `Node.val` is unique for each node.\n- There are no self-loops or parallel edges.',
  '{"python": "from typing import Optional\n\n# class Node:\n#     def __init__(self, val = 0, neighbors = None):\n#         self.val = val\n#         self.neighbors = neighbors if neighbors is not None else []\n\nclass Solution:\n    def cloneGraph(self, node: Optional[''Node'']) -> Optional[''Node'']:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {Node} node\n * @return {Node}\n */\nvar cloneGraph = function(node) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public Node cloneGraph(Node node) {\n        // Your solution here\n        return null;\n    }\n}", "cpp": "class Solution {\npublic:\n    Node* cloneGraph(Node* node) {\n        // Your solution here\n        return nullptr;\n    }\n};"}',
  'CORRECT APPROACH: Handle null input (return null). Use a hash map old_to_new. Define dfs(node): if node in old_to_new, return old_to_new[node]. Create clone = Node(node.val). Map old_to_new[node] = clone. For each neighbor: clone.neighbors.append(dfs(neighbor)). Return clone. Call dfs(node).\n\nKEY INVARIANT: Create the clone and map it BEFORE recursing into neighbors. This prevents infinite recursion on cycles by ensuring any revisited node returns its already-created clone.\n\nWHAT COUNTS AS CORRECT: Handles null. Creates entirely new nodes (not references to originals). Correctly reproduces all edges. O(V+E) time, O(V) space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Not checking the map before creating a new clone: infinite loop on cycles.\n- Adding old nodes to the clone''s neighbors instead of new clones.\n- Mapping AFTER recursing into neighbors: the cycle check fires but the clone does not yet exist, causing a KeyError.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'graphs' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'In the DFS clone function, you create the clone and add it to old_to_new BEFORE recursing into its neighbors. Why must this happen before recursion rather than after?',
  '["It is more efficient to map early — reduces the number of map lookups.", "If node A has neighbor B and B has neighbor A (a cycle), recursing into B first would call dfs(A) again. If A is not yet in old_to_new, a new duplicate clone of A would be created. Mapping A before recursing ensures dfs(A) returns the existing clone instead.", "The clone must be mapped before recursion only when the graph has more than one cycle.", "The order does not matter — the map lookup at the start of dfs catches any revisit."]',
  1,
  'Suppose A and B are connected to each other. dfs(A): clone A, if not mapped yet → infinite recursion. The sequence must be: check map (not found), create clone_A, map A→clone_A, THEN recurse into neighbors (including B which will call dfs(A), find A in the map, and return clone_A immediately). If you recurse before mapping, dfs(B) calls dfs(A) which has not been mapped yet — it creates another clone_A, maps it, and the duplicate exists. The map must be set before any path that could lead back to the current node.'
FROM public.problems WHERE slug = 'clone-graph' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'When building the cloned neighbors list, you append dfs(neighbor) (a new cloned node) rather than appending neighbor (the original node). Why is this critical?',
  '["It is not critical — original and cloned nodes can be mixed freely.", "A deep copy requires that the cloned graph is entirely self-contained. Appending original nodes would make the clone''s neighbors point back into the original graph — breaking the copy''s independence.", "Appending the original node causes a type error in typed languages.", "The original nodes are garbage collected after cloning, so appending them would create dangling references."]',
  1,
  'A deep copy means the new graph shares no object references with the original. If clone_A.neighbors contained original node B, then modifying the original graph (changing B''s value or neighbors) would affect the "copy" — which is no longer independent. By appending dfs(neighbor) — which returns a newly created clone — the cloned graph is fully self-contained: every node in it is a fresh object. This is the definition of deep copy vs. shallow copy.'
FROM public.problems WHERE slug = 'clone-graph' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'What is the time complexity of the DFS clone approach for a graph with V nodes and E edges?',
  '["O(V^2) — each node is visited once for each of its neighbors.", "O(V + E) — each node is visited exactly once (due to the map check), and each edge is traversed once when building the neighbors list.", "O(V * E) — building the neighbors list requires scanning all edges for each node.", "O(E) — the nodes themselves require no work, only the edges."]',
  1,
  'Each node is processed exactly once: the first time it is visited, it is mapped, created, and its neighbors are queued for DFS. Subsequent visits return the existing clone in O(1). Total node work: O(V). Each edge (u, v) is processed once when building u''s clone neighbors and once when building v''s clone neighbors (since the graph is undirected). Total edge work: O(E). Grand total: O(V + E). Space: O(V) for the hash map plus the cloned graph itself.'
FROM public.problems WHERE slug = 'clone-graph' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Course Schedule',
  'course-schedule',
  'medium',
  'You must take some courses before others (prerequisites). Can you complete all courses? This is a cycle detection problem on a directed graph: if prerequisites form a cycle, it is impossible to complete all courses.\n\nThe approach: model courses as nodes and prerequisites as directed edges. Run DFS on each unvisited node. During DFS, track nodes in the current path (cycle detection). If DFS reaches a node already in the current path, a cycle exists. If DFS completes without finding a cycle, the node is safe.\n\nThis is the foundational topological sort / cycle detection problem. The same pattern detects deadlocks in OS, validates dependency graphs, and checks for circular imports in build systems.',
  '## Course Schedule\n\nThere are a total of `numCourses` courses you have to take, labeled from `0` to `numCourses - 1`. You are given an array `prerequisites` where `prerequisites[i] = [ai, bi]` indicates that you must take course `bi` first if you want to take course `ai`.\n\nReturn `true` if you can finish all courses. Otherwise, return `false`.\n\n---\n\n**Example 1:**\n```\nInput:  numCourses = 2, prerequisites = [[1,0]]\nOutput: true\nExplanation: Take course 0 then course 1.\n```\n\n**Example 2:**\n```\nInput:  numCourses = 2, prerequisites = [[1,0],[0,1]]\nOutput: false\nExplanation: Courses 0 and 1 are prerequisites of each other — impossible.\n```\n\n---\n\n**Constraints:**\n- `1 <= numCourses <= 2000`\n- `0 <= prerequisites.length <= 5000`\n- `prerequisites[i].length == 2`\n- `0 <= ai, bi < numCourses`\n- All the pairs `prerequisites[i]` are unique.',
  '{"python": "from typing import List\n\nclass Solution:\n    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number} numCourses\n * @param {number[][]} prerequisites\n * @return {boolean}\n */\nvar canFinish = function(numCourses, prerequisites) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public boolean canFinish(int numCourses, int[][] prerequisites) {\n        // Your solution here\n        return false;\n    }\n}", "cpp": "class Solution {\npublic:\n    bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {\n        // Your solution here\n        return false;\n    }\n};"}',
  'CORRECT APPROACH: Build an adjacency list. Use a state array with three states: 0=unvisited, 1=in-progress (in current DFS path), 2=completed (no cycle found). For each unvisited node, run DFS. In DFS: if state == 1, return False (cycle). If state == 2, return True (already verified). Set state = 1, recurse into neighbors, set state = 2, return True.\n\nALTERNATIVE: BFS topological sort (Kahn''s algorithm) — count in-degrees, process nodes with in-degree 0, reduce neighbors'' in-degrees. If all nodes are processed, no cycle exists.\n\nWHAT COUNTS AS CORRECT: Detects cycles correctly. Handles disconnected components (check all nodes). O(V+E) time, O(V+E) space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Using only visited/unvisited (two states): cannot distinguish "in current path" from "previously completed" — produces false positives on non-cyclic paths.\n- Not checking all nodes: misses components unreachable from the first node.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'graphs' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The DFS uses three states: unvisited (0), in-progress (1), and completed (2). Why is two states (visited/unvisited) insufficient for directed cycle detection?',
  '["Two states are sufficient — visited means the node was reached, which is all cycle detection requires.", "With two states, you cannot distinguish ''currently on the DFS stack'' from ''already fully explored.'' A node visited in a previous DFS call would appear as visited, preventing correct cycle detection on new paths that happen to reach the same node.", "Two states would cause infinite recursion rather than incorrect cycle detection.", "Two states work for undirected graphs but not directed graphs."]',
  1,
  'Consider courses: 0→1→2 and 3→1. When DFS from 0 completes, node 1 is marked "visited." When DFS from 3 visits node 1, it sees "visited" and — with only two states — might interpret that as a cycle (node 1 was in a previous path). But this is NOT a cycle; node 1 is reachable from multiple sources in a DAG. The "in-progress" state (1) specifically means "node is on the current DFS stack." Only if we reach an in-progress node do we have a true cycle.'
FROM public.problems WHERE slug = 'course-schedule' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The outer loop in canFinish iterates over ALL nodes 0..numCourses-1, even those with no prerequisites. Why not only start DFS from nodes that appear in the prerequisites list?',
  '["Starting from all nodes is less efficient but required for correctness in all cases.", "The graph might be disconnected. A course with no prerequisites and no dependents would never be reached if DFS only started from nodes in the prerequisites list. All components must be checked for cycles.", "Courses with no prerequisites cannot form cycles, so checking them is redundant.", "The outer loop is only necessary when numCourses > 1000."]',
  1,
  'If prerequisites = [[1,0]] and numCourses = 4, courses 2 and 3 have no prerequisites or dependents. They appear nowhere in the prerequisites list. If you only start DFS from nodes in that list (0 and 1), you never visit 2 or 3 — and while those specific nodes cannot form a cycle, in a larger example they might be part of an isolated cycle not connected to the main component. The outer loop ensures every node in the graph is eventually visited.'
FROM public.problems WHERE slug = 'course-schedule' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'After DFS from a node completes without finding a cycle, you mark it as state 2 (completed). What benefit does this provide beyond correctness?',
  '["It prevents the node from being deleted from the adjacency list.", "It memoizes the cycle-free result: if another DFS path reaches this node later, we immediately return True without re-exploring its entire subtree. This prevents redundant work and keeps the algorithm O(V+E) rather than O(V^2).", "It is required by the problem to count the number of completed courses.", "Marking state 2 is only needed for nodes that have outgoing edges."]',
  1,
  'Without memoization (state 2), if node X is reachable from both A and B in a DAG, DFS from A fully explores X''s subtree, then DFS from B explores it again. For a star graph (one node connected to N others), this gives O(N^2) redundant work. State 2 short-circuits: the second DFS to reach X sees state=2 and returns True immediately. This is the same principle as memoized recursion in dynamic programming — cache the result once computed to avoid recomputation.'
FROM public.problems WHERE slug = 'course-schedule' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Pacific Atlantic Water Flow',
  'pacific-atlantic-water-flow',
  'medium',
  'Water flows from higher or equal elevation cells to lower or equal cells and eventually reaches the Pacific (top/left edges) or Atlantic (bottom/right edges). You need cells from which water can reach BOTH oceans.\n\nThe naive approach — for each cell, run DFS/BFS to check if both oceans are reachable — is O(M^2 * N^2). The clever reversal: instead of flowing water downhill from each cell, reverse the process. Start from each ocean''s border and "flow water uphill" (to cells with equal or greater elevation). Any cell reachable from the Pacific border AND the Atlantic border answers the query.\n\nThis problem teaches the reverse-thinking pattern: when the forward direction is expensive, reverse the problem. This appears in many graph problems including word ladder and minimum steps to reach a target.',
  '## Pacific Atlantic Water Flow\n\nThere is an `m x n` rectangular island that borders both the **Pacific Ocean** and **Atlantic Ocean**. The Pacific Ocean touches the island''s left and top edges. The Atlantic Ocean touches the island''s right and bottom edges.\n\nWater can only flow in four directions (up, down, left, right) to an adjacent cell with height less than or equal to the current cell''s height.\n\nReturn a list of grid coordinates `result` where `result[i] = [ri, ci]` denotes that rain water can flow from cell `(ri, ci)` to **both** the Pacific and Atlantic oceans.\n\n---\n\n**Example 1:**\n```\nInput:  heights = [[1,2,2,3,5],[3,2,3,4,4],[2,4,5,3,1],[6,7,1,4,5],[5,1,1,2,4]]\nOutput: [[0,4],[1,3],[1,4],[2,2],[3,0],[3,1],[4,0]]\n```\n\n**Example 2:**\n```\nInput:  heights = [[1]]\nOutput: [[0,0]]\n```\n\n---\n\n**Constraints:**\n- `m == heights.length`, `n == heights[0].length`\n- `1 <= m, n <= 200`\n- `0 <= heights[i][j] <= 10^5`',
  '{"python": "from typing import List\n\nclass Solution:\n    def pacificAtlantic(self, heights: List[List[int]]) -> List[List[int]]:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[][]} heights\n * @return {number[][]}\n */\nvar pacificAtlantic = function(heights) {\n    // Your solution here\n};", "java": "import java.util.*;\n\nclass Solution {\n    public List<List<Integer>> pacificAtlantic(int[][] heights) {\n        // Your solution here\n        return new ArrayList<>();\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<vector<int>> pacificAtlantic(vector<vector<int>>& heights) {\n        // Your solution here\n        return {};\n    }\n};"}',
  'CORRECT APPROACH: BFS/DFS from all Pacific border cells (top row + left column), marking cells reachable going uphill (>= current height). BFS/DFS from all Atlantic border cells (bottom row + right column), doing the same. Collect all cells in BOTH reachable sets.\n\nWHAT COUNTS AS CORRECT: Reverses flow direction (uphill). Seeds BFS/DFS from border cells. Returns intersection of two reachable sets. O(M*N) time, O(M*N) space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Running DFS from every cell in the forward direction: O(M^2 * N^2) — ask if there is a smarter starting point.\n- Flowing downhill instead of uphill during reverse BFS: produces incorrect reachable sets.\n- Forgetting to seed ALL border cells for each ocean before starting BFS.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'graphs' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The reverse approach starts BFS from the ocean borders and moves UPHILL (to cells with height >= current). Why uphill rather than the original downhill direction?',
  '["Uphill traversal is faster because elevation increases monotonically.", "We are reversing the problem: instead of asking ''can cell X reach the ocean?'' we ask ''can the ocean reach cell X?'' Water that originally flowed downhill from X to the ocean, in reverse, flows uphill from the ocean back to X. So reverse flow = uphill.", "Uphill traversal avoids revisiting cells that are at the same elevation.", "Downhill traversal from borders would also work; uphill is just a convention."]',
  1,
  'Original direction: water at cell X flows to neighbors with height <= X (downhill). Reversed: water at the ocean border flows to neighbors with height >= border height (uphill). This is the logical reversal of the edge direction. Instead of propagating from every cell to the ocean (O(M^2 * N^2) in the worst case), we propagate from the ocean to all reachable cells in one BFS per ocean (O(M*N) each). The reversal converts an expensive multi-source problem into two efficient single-source BFS runs.'
FROM public.problems WHERE slug = 'pacific-atlantic-water-flow' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For the Pacific BFS, you seed it with ALL cells on the top row and left column simultaneously. Why seed from all border cells at once rather than running separate BFS from each border cell?',
  '["Seeding from all at once is a style choice — separate BFS from each border cell produces the same result.", "Multi-source BFS: all border cells are ''distance 0'' from the Pacific. Seeding the queue with all of them simultaneously finds all reachable cells in one pass, in O(M*N) total. Running a separate BFS per border cell would be O((M+N) * M*N) total.", "You must seed all at once to avoid marking cells as visited prematurely.", "Seeding from all border cells is only needed when the grid is square."]',
  1,
  'Multi-source BFS treats all sources as equivalent starting points. All Pacific border cells are at "distance 0" from the ocean — they trivially reach it. From there, BFS explores neighbors in increasing-distance layers. Running separate BFS from each of the M+N-1 border cells and taking the union would produce the correct reachable set but at O((M+N) * M*N) cost. The multi-source approach processes all cells in one O(M*N) pass by loading all sources into the queue before starting.'
FROM public.problems WHERE slug = 'pacific-atlantic-water-flow' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'After computing pacific_reachable and atlantic_reachable sets, you return the intersection. A cell at [2,2] is in pacific_reachable but not atlantic_reachable. What does this mean physically?',
  '["Water at [2,2] can reach the Pacific but not the Atlantic — it is blocked by higher terrain on the Atlantic side.", "Water at [2,2] can reach the Atlantic but not the Pacific.", "Cell [2,2] has zero elevation and water pools there instead of flowing.", "The cell has not been visited yet and should be re-examined."]',
  0,
  'pacific_reachable contains all cells from which water CAN reach the Pacific (established by the reverse BFS from Pacific borders going uphill). atlantic_reachable contains all cells from which water can reach the Atlantic. If [2,2] is in pacific_reachable only, it means water there flows toward and reaches the Pacific, but terrain or grid boundaries prevent it from reaching the Atlantic. Only cells in the INTERSECTION — reachable from both ocean borders in reverse BFS — can drain to both oceans.'
FROM public.problems WHERE slug = 'pacific-atlantic-water-flow' LIMIT 1;


-- ============================================================
-- ADDITIONAL PROBLEMS: 1-D Dynamic Programming
-- ============================================================

INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Min Cost Climbing Stairs',
  'min-cost-climbing-stairs',
  'easy',
  'Min Cost Climbing Stairs is the first optimization variant of Climbing Stairs. Instead of counting ways to reach the top, you minimize the total cost paid. At each step you pay the step''s cost, then move 1 or 2 steps.\n\nThe recurrence: the minimum cost to reach step i is min(cost[i-1] + min_cost_to_i-1, cost[i-2] + min_cost_to_i-2). But a cleaner formulation is: cost_to_reach[i] = min(cost_to_reach[i-1] + cost[i-1], cost_to_reach[i-2] + cost[i-2]) where cost_to_reach represents the cost to reach step i (without paying for step i itself, since you pay when you leave).\n\nThis problem builds the habit of carefully distinguishing "reach" vs. "leave" in stair/path cost problems.',
  '## Min Cost Climbing Stairs\n\nYou are given an integer array `cost` where `cost[i]` is the cost of `i`th step on a staircase. Once you pay the cost, you can either climb one or two steps.\n\nYou can either start from the step with index `0`, or the step with index `1`.\n\nReturn the minimum cost to reach the top of the floor.\n\n---\n\n**Example 1:**\n```\nInput:  cost = [10,15,20]\nOutput: 15\nExplanation: Start at step 1. Pay 15, climb 2 steps to the top.\n```\n\n**Example 2:**\n```\nInput:  cost = [1,100,1,1,1,100,1,1,100,1]\nOutput: 6\n```\n\n---\n\n**Constraints:**\n- `2 <= cost.length <= 1000`\n- `0 <= cost[i] <= 999`',
  '{"python": "from typing import List\n\nclass Solution:\n    def minCostClimbingStairs(self, cost: List[int]) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} cost\n * @return {number}\n */\nvar minCostClimbingStairs = function(cost) {\n    // Your solution here\n};", "java": "class Solution {\n    public int minCostClimbingStairs(int[] cost) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class Solution {\npublic:\n    int minCostClimbingStairs(vector<int>& cost) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Append 0 to cost (representing the top). Define dp[i] = minimum cost to reach step i. dp[0] = 0, dp[1] = 0 (can start at either step 0 or 1 for free). For i from 2 to len(cost): dp[i] = min(dp[i-1] + cost[i-1], dp[i-2] + cost[i-2]). Return dp[len(cost)].\n\nALTERNATIVE: In-place modification of cost array or two-variable rolling approach.\n\nWHAT COUNTS AS CORRECT: Can start at index 0 or 1 (no cost to begin). Pays cost[i] when leaving step i. Returns the cost to reach the top (beyond the last step). O(N) time, O(1) space with rolling variables.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Forgetting that you can start at index 0 OR 1 (not only 0): affects base cases.\n- Confusing "cost to reach" with "cost to leave": off-by-one in when cost is added.\n- Returning dp[len(cost)-1] (last step) instead of dp[len(cost)] (above the last step).\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'one-d-dp' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The problem says "you can either start from step 0 or step 1." How does this affect the base cases in your DP formulation?',
  '["It does not affect the base cases — you always start from step 0.", "The cost to reach step 0 and step 1 is both 0: you choose your starting step for free. This gives dp[0] = 0 and dp[1] = 0, reflecting that no payment is required to be at either starting position.", "You must start at the cheaper of step 0 or step 1, setting dp[0] = min(cost[0], cost[1]) and dp[1] = 0.", "dp[0] = cost[0] and dp[1] = cost[1], since you pay the cost immediately upon arrival."]',
  1,
  'You pay cost[i] when you LEAVE step i (to take 1 or 2 steps from it). Arriving at step 0 or step 1 costs nothing — you choose freely. So dp[0] = 0 (free to start here) and dp[1] = 0 (free to start here). For step 2 and beyond, you must have come from step 0 or step 1, paying their respective costs: dp[2] = min(dp[0] + cost[0], dp[1] + cost[1]) = min(0 + 10, 0 + 15) = 10 for Example 1. Getting the base cases wrong propagates errors through all subsequent states.'
FROM public.problems WHERE slug = 'min-cost-climbing-stairs' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For cost = [10,15,20], the answer is 15. Walking through the DP: dp[0]=0, dp[1]=0, dp[2]=min(0+10, 0+15)=10, dp[3]=min(dp[2]+cost[2], dp[1]+cost[1])=min(10+20, 0+15)=15. Why is dp[3] the answer rather than dp[2]?',
  '["dp[2] is the last step, so it should be the answer.", "The top of the floor is BEYOND the last step. With cost of length 3, steps are indexed 0,1,2. The top is position 3. dp[3] = minimum cost to reach the top.", "dp[3] is wrong — the answer should be dp[len(cost)-1] = dp[2] = 10.", "The answer depends on whether you end on step 2 or step 3."]',
  1,
  'The staircase has len(cost) steps indexed 0 through len(cost)-1. The "top of the floor" is one beyond the last step — you need to climb off the staircase entirely. So the answer is dp[len(cost)], not dp[len(cost)-1]. In this example, len(cost)=3 and the answer is dp[3]=15. If you returned dp[2]=10 you would be reporting the cost to reach the last step, not the cost to leave it and reach the top. This off-by-one is the most common error in this problem.'
FROM public.problems WHERE slug = 'min-cost-climbing-stairs' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'How does Min Cost Climbing Stairs differ from Climbing Stairs (counting ways), and what changes in the recurrence?',
  '["The recurrences are identical — both use dp[i] = dp[i-1] + dp[i-2].", "Climbing Stairs SUMS the two options (both ways are valid and count separately). Min Cost MINIMIZES over the two options (only the cheaper path matters). dp[i] = dp[i-1] + dp[i-2] vs. dp[i] = min(dp[i-1] + cost[i-1], dp[i-2] + cost[i-2]).", "The only difference is that Min Cost multiplies by cost[i] instead of adding.", "Min Cost requires sorting the cost array first, while Climbing Stairs does not."]',
  1,
  'Both problems share the same structural observation (you arrived from step i-1 or step i-2). But Climbing Stairs asks "how many ways?" so it ADDS the counts from both predecessors. Min Cost asks "what is the cheapest way?" so it MINIMIZES over the two options, adding the predecessor''s cost. This sum-vs-min switch is the difference between counting problems and optimization problems in DP. Recognizing this pattern lets you adapt the Climbing Stairs template to Min Cost Climbing Stairs (and beyond to general path-cost minimization problems).'
FROM public.problems WHERE slug = 'min-cost-climbing-stairs' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Coin Change',
  'coin-change',
  'medium',
  'Given coin denominations and a target amount, find the minimum number of coins needed. This is the canonical unbounded knapsack / DP problem.\n\nThe brute-force tries every combination of coins: exponential. DP eliminates redundancy: dp[i] = minimum coins to make amount i. For each amount from 1 to target, try all coins. If coin <= i: dp[i] = min(dp[i], dp[i - coin] + 1).\n\nThis "try all options and take the min/max" recurrence is the core of unbounded knapsack DP. The key insight: subproblems overlap (dp[7] is used to compute dp[10], dp[9], etc.) and DP caches each result once, giving O(amount * num_coins) instead of exponential brute-force.',
  '## Coin Change\n\nYou are given an integer array `coins` representing coins of different denominations and an integer `amount` representing a total amount of money.\n\nReturn the fewest number of coins that you need to make up that amount. If that amount of money cannot be made up by any combination of the coins, return `-1`.\n\nYou may assume that you have an **infinite number** of each kind of coin.\n\n---\n\n**Example 1:**\n```\nInput:  coins = [1,2,5], amount = 11\nOutput: 3\nExplanation: 11 = 5 + 5 + 1\n```\n\n**Example 2:**\n```\nInput:  coins = [2], amount = 3\nOutput: -1\n```\n\n**Example 3:**\n```\nInput:  coins = [1], amount = 0\nOutput: 0\n```\n\n---\n\n**Constraints:**\n- `1 <= coins.length <= 12`\n- `1 <= coins[i] <= 2^31 - 1`\n- `0 <= amount <= 10^4`',
  '{"python": "from typing import List\n\nclass Solution:\n    def coinChange(self, coins: List[int], amount: int) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} coins\n * @param {number} amount\n * @return {number}\n */\nvar coinChange = function(coins, amount) {\n    // Your solution here\n};", "java": "class Solution {\n    public int coinChange(int[] coins, int amount) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class Solution {\npublic:\n    int coinChange(vector<int>& coins, int amount) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Initialize dp = [infinity] * (amount+1). Set dp[0] = 0. For each i from 1 to amount: for each coin in coins: if coin <= i: dp[i] = min(dp[i], dp[i-coin] + 1). Return dp[amount] if dp[amount] != infinity else -1.\n\nWHAT COUNTS AS CORRECT: dp[0] = 0 (base case: 0 coins for amount 0). Initializes other entries to infinity (unreachable). Correctly returns -1 when amount is unreachable. Iterates all coin-amount combinations. O(amount * num_coins) time, O(amount) space.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Greedy (always use the largest coin): fails for coins=[1,3,4], amount=6 where greedy gives 4+1+1=3 but optimal is 3+3=2.\n- Initializing dp with 0 instead of infinity: cannot distinguish "amount is reachable with 0 coins" from "amount is initialized to 0."\n- Returning dp[amount] without the infinity check: returns a large number instead of -1 for impossible cases.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'one-d-dp' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'Why does a greedy approach (always pick the largest coin <= remaining amount) fail for coins = [1,3,4] and amount = 6?',
  '["It does not fail — greedy always finds the optimal solution for coin change.", "Greedy picks 4 first (6-4=2 remaining), then 1, then 1: 3 coins. The optimal is 3+3: 2 coins. Greedy makes a locally optimal choice that leads to a globally suboptimal solution.", "Greedy fails only when coin denominations are not powers of 2.", "Greedy fails because it does not consider coins in sorted order."]',
  1,
  'Greedy: pick 4 (remaining 2), pick 1 (remaining 1), pick 1 (remaining 0) — 3 coins. Optimal: pick 3 (remaining 3), pick 3 (remaining 0) — 2 coins. Greedy committed to 4 which left an awkward remainder. DP avoids this by considering ALL coin choices at each amount and taking the minimum. Greedy works for canonical coin systems (like US coins: 25, 10, 5, 1) due to their mathematical structure, but not for arbitrary denominations.'
FROM public.problems WHERE slug = 'coin-change' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The dp array is initialized to infinity (or amount+1) rather than 0. What goes wrong if you initialize it to 0?',
  '["Nothing — 0 is a valid default and the algorithm handles it correctly.", "If dp[i] starts at 0, the update dp[i] = min(dp[i], dp[i-coin]+1) would never increase dp[i] above 0, since min(0, anything) = 0. Every amount would falsely appear to require 0 coins.", "If dp[i] starts at 0, the algorithm would always return 0 for any amount.", "Initializing to 0 causes integer overflow when computing dp[i-coin]+1."]',
  1,
  'dp[i] represents the minimum coins needed for amount i. A value of 0 means "this amount is achievable for free (0 coins)" — only dp[0] should be 0. All other amounts start as "unreachable" (infinity). If you initialize everything to 0, then min(0, dp[i-coin]+1) = 0 for all i — the 0 baseline is never beaten and every amount appears to need 0 coins. Infinity ensures that only genuinely reachable amounts get updated to finite values, and unreachable amounts remain infinity (returned as -1).'
FROM public.problems WHERE slug = 'coin-change' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The outer loop iterates over amounts (1 to target) and the inner loop over coins. Could you swap the order (outer: coins, inner: amounts) and still get the correct answer?',
  '["No — swapping the loops would produce incorrect results for all inputs.", "Yes — both loop orders compute the same dp values. The inner coin loop tries all coins for each amount; swapping just changes the traversal order but all (amount, coin) pairs are still evaluated.", "Yes for the minimum coins answer, but No if you also needed to count the number of ways.", "No — the outer loop must be over amounts to ensure dp[i-coin] is already computed when needed."]',
  1,
  'For this specific problem (unbounded coin change, minimization), swapping the loops gives the same result. Each dp[i] is computed by taking the min over all coins c of dp[i-c]+1. Whether you fix i and iterate c, or fix c and iterate i, all necessary dp[i-c] values are computed before dp[i] is needed (since i-c < i and we iterate i in increasing order regardless of loop nesting). However, for the "number of ways" variant, loop order DOES matter — outer coins vs outer amounts gives different counts — so being aware of this distinction is important.'
FROM public.problems WHERE slug = 'coin-change' LIMIT 1;


INSERT INTO public.problems (pattern_id, title, slug, difficulty, importance_context, problem_statement, starter_code, expected_pattern_approach)
SELECT
  id,
  'Longest Increasing Subsequence',
  'longest-increasing-subsequence',
  'medium',
  'Find the length of the longest strictly increasing subsequence. A subsequence does not have to be contiguous — you can skip elements.\n\nThe O(N^2) DP approach: dp[i] = length of the LIS ending at index i. For each i, check all j < i where nums[j] < nums[i]: dp[i] = max(dp[i], dp[j] + 1). Answer is max(dp).\n\nAn O(N log N) approach uses binary search to maintain a "patience sorting" array, but the O(N^2) DP is the expected approach in this module and demonstrates the "for each position, try all valid predecessors" pattern that generalizes to 2-D DP problems.\n\nThis problem is the prototype for Longest Common Subsequence, Edit Distance, and Russian Doll Envelopes.',
  '## Longest Increasing Subsequence\n\nGiven an integer array `nums`, return the length of the longest strictly increasing subsequence.\n\n---\n\n**Example 1:**\n```\nInput:  nums = [10,9,2,5,3,7,101,18]\nOutput: 4\nExplanation: The LIS is [2,3,7,101] with length 4.\n```\n\n**Example 2:**\n```\nInput:  nums = [0,1,0,3,2,3]\nOutput: 4\n```\n\n**Example 3:**\n```\nInput:  nums = [7,7,7,7,7,7,7]\nOutput: 1\n```\n\n---\n\n**Constraints:**\n- `1 <= nums.length <= 2500`\n- `-10^4 <= nums[i] <= 10^4`',
  '{"python": "from typing import List\n\nclass Solution:\n    def lengthOfLIS(self, nums: List[int]) -> int:\n        # Your solution here\n        pass", "javascript": "/**\n * @param {number[]} nums\n * @return {number}\n */\nvar lengthOfLIS = function(nums) {\n    // Your solution here\n};", "java": "class Solution {\n    public int lengthOfLIS(int[] nums) {\n        // Your solution here\n        return 0;\n    }\n}", "cpp": "class Solution {\npublic:\n    int lengthOfLIS(vector<int>& nums) {\n        // Your solution here\n        return 0;\n    }\n};"}',
  'CORRECT APPROACH: Initialize dp = [1] * len(nums). For i from 1 to len(nums)-1: for j from 0 to i-1: if nums[j] < nums[i]: dp[i] = max(dp[i], dp[j] + 1). Return max(dp).\n\nWHAT COUNTS AS CORRECT: Base case dp[i] = 1 (every element is an LIS of length 1 by itself). Correct strictly-less-than comparison (not <=, since the problem says strictly increasing). Returns max(dp) not dp[-1]. O(N^2) time, O(N) space.\n\nALTERNATIVE: Patience sort with binary search — O(N log N). Acknowledge if the student proposes it.\n\nCOMMON VIOLATIONS TO CALL OUT:\n- Using <= instead of <: allows equal elements in the subsequence, violating "strictly increasing."\n- Returning dp[-1] instead of max(dp): assumes the LIS ends at the last element, which is false in general.\n- Not initializing dp[i] = 1: LIS of length 0 is invalid — every single element is a valid subsequence.\n\nGUARDRAILS: Never output code. One Socratic question per issue.'
FROM public.patterns WHERE slug = 'one-d-dp' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'For nums = [10,9,2,5,3,7,101,18], the function returns max(dp), not dp[-1]. Why is dp[-1] (the dp value at the last index) insufficient?',
  '["dp[-1] would work if the array were sorted first.", "The LIS does not have to end at the last element. For this input, the LIS [2,3,7,101] ends at index 6, not the last index 7 (value 18). dp[-1] = dp[7] = 3 ([2,3,18] or similar) which is less than the true answer of 4.", "dp[-1] would give the same answer as max(dp) because the longest subsequence always ends last.", "dp[-1] is always 1 since 18 is less than 101."]',
  1,
  'dp[i] = length of the longest increasing subsequence ending specifically at index i. The global LIS can end at any index. For [10,9,2,5,3,7,101,18]: dp[6]=4 ([2,3,7,101]), dp[7]=3 ([2,3,18] or [2,5,18] or [2,7,18]). Returning dp[7]=3 misses the longer subsequence ending at index 6. max(dp) correctly returns 4. This is a common final-answer bug in LIS and similar problems — always return the global maximum over all dp values, not just the last.'
FROM public.problems WHERE slug = 'longest-increasing-subsequence' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'The inner loop checks if nums[j] < nums[i] (strictly less than). What would change if you used <= instead?',
  '["Nothing — the LIS length is the same whether equal elements are allowed or not.", "Using <= would allow equal elements in the subsequence, producing the Longest Non-Decreasing Subsequence instead of the Longest Strictly Increasing Subsequence. For [7,7,7], the answer would become 3 instead of 1.", "Using <= would produce an incorrect result only when all elements are distinct.", "Using <= is more correct because the problem says increasing, not strictly increasing."]',
  1,
  'With strict < : [7,7,7] has LIS of length 1 (no pair is strictly increasing). With <= : 7 <= 7 allows 7 to extend a subsequence containing 7, giving length 3. The problem explicitly says "strictly increasing," which requires < not <=. This distinction appears in follow-up variants (Longest Non-Decreasing Subsequence) and is commonly tested. In Russian Doll Envelopes (a 2-D LIS), strict vs. non-strict inequality on one dimension is the key trick to avoid double-counting.'
FROM public.problems WHERE slug = 'longest-increasing-subsequence' LIMIT 1;

INSERT INTO public.mcqs (problem_id, question, options, correct_option_index, explanation)
SELECT id,
  'An O(N log N) solution exists using binary search (patience sorting). What is the core trade-off between the O(N^2) DP and the O(N log N) approach?',
  '["The O(N log N) approach is always better — there is no reason to use O(N^2) DP.", "The O(N^2) DP is simpler to understand, reason about, and generalize to 2-D variants (like LCS or edit distance). The O(N log N) binary search approach is faster but harder to extend and less illuminating conceptually.", "The O(N log N) approach requires sorting the array first, which changes the problem.", "The O(N log N) approach uses O(N^2) space compared to O(N) for the DP approach."]',
  1,
  'For N <= 2500 (the constraint here) the O(N^2) DP is fast enough. More importantly, the O(N^2) DP pattern — "for each position, try all valid predecessors and take the best" — generalizes directly to Longest Common Subsequence (2-D DP), Edit Distance, and other sequence alignment problems. The O(N log N) patience sort is a clever standalone optimization specific to LIS that does not generalize as broadly. Learning the O(N^2) approach first builds the conceptual foundation; O(N log N) is the follow-up optimization once the pattern is understood.'
FROM public.problems WHERE slug = 'longest-increasing-subsequence' LIMIT 1;
