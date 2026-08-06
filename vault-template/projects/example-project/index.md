# Example project

*Copy this file to `projects/<your-project>/index.md` and fill it from ground truth. Every status
line must be something you verified with a command at write time.*

## Goal

One line. What this project is for, in plain language.

## Status

3–5 lines, each derived from ground truth — `git log`, a test run, a deploy check, the project's
own docs. Not from memory, not from summarizing a conversation. Cite the command where it
matters:

- Last landed work: `<commit> "<subject>"` — `git log --oneline -1`.
- Gate/test state: `<N passing / M failing>` — `<the command you ran>`.
- Deployed state: `<what is actually running where>` — `<the check you ran>`.

## Code location

Absolute paths. One project can span several repos — list them all, and say which is live:

- `/absolute/path/to/primary-repo` — live development
- `/absolute/path/to/other-repo` — secondary, or frozen (say which and why)

## Key docs

Pointers only, no content copied in:

- `/absolute/path/to/handoff-or-spec.md` — what it covers
- `/absolute/path/to/runbook.md` — what it covers

## Open threads

Unfinished work found in ground truth. Pointer plus one line each:

- The thing that is actually blocking, and where its evidence lives.
- Ambiguity recorded rather than guessed: *"which of these two trees is live is unresolved;
  evidence points at X but Y was modified more recently."*
- Debt deliberately left, with the reason.
