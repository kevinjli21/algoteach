@AGENTS.md
# Algo-Patterns-Hub: Project Overview & Context

## Our Mission
We are building a free, high-quality technical interview preparation platform for Computer Science students. Most existing platforms (LeetCode, AlgoExpert) hide deep conceptual learning behind paywalls. Our goal is to make comprehensive pattern-based learning entirely open and accessible, focusing heavily on core data structures, algorithms, and advanced paradigms like Network Flow.

## Target Audience
- Computer Science students preparing for internships and full-time software engineering roles.
- Users who need to learn *how to think* in patterns rather than memorizing specific puzzle solutions.

## Core Architectural Pillars

### 1. Curriculum Structure
- Progresses strictly from absolute basics to advanced intermediate patterns.
- **The Flow:** 
  1. *Concept Introduction:* Why this pattern matters, when to spot it.
  2. *Introductory Problem:* A foundational problem to practice the layout.
  3. *Conceptual MCQs:* Multiple-choice questions that test edge cases, time/space complexity, and conceptual understanding before moving on.

### 2. The AI Interviewer Persona (Crucial Guardrails)
- The platform features an automated AI Agent that evaluates user code submissions.
- **The Persona:** A supportive, elite technical interviewer at a top tech company.
- **The Guardrails:** 
  - The AI must *never* give away the answer.
  - The AI must *never* output code snippets or direct syntax corrections.
  - The AI *must* provide subtle hints, nudge the user toward optimal time/space complexity, or point out edge cases they forgot to consider.
  - It should explicitly call out if the user's code violates the pattern being taught (e.g., using a nested loop when they should be using a Sliding Window).