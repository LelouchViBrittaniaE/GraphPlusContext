---
name: context-vault
description: "The durable context layer for multi-session agent work — dispatch, wind-down, wake, verification, and continuity across model/profile/tool switches. Trigger whenever a session is asked to wind down, hand off, or end; when asked to verify a predecessor's handoff or receipt; when dispatching work to a project; when waking or resuming from a handoff or interruption; when adding a project; when the user switches accounts, subscriptions, or tools; and when starting substantive work with no project named. Also on '/context-vault'."
---

# Context vault — the durable layer

Sessions are disposable. Context is not. The vault is a folder of plain markdown that outlives
every session, model, subscription, and tool, so a fresh agent can reconstruct working state in
under a minute.

**The vault for this machine lives at `__VAULT_PATH__`.** Do not restate its contents here or
anywhere — read the live files:

1. `README.md` — conventions (pointers only; one writer per surface; the dispatch template).
2. `procedures.md` — **the moves.** §1 dispatch · §2 standard wind-down · §3 save-point
   wind-down · §4 outside-in verification · §5 standard wake · §6 sealed-entrance wake ·
   §7 account/tool switches.
3. `boot.md` — the live cursor: active projects, current focus, read-first pointers.
4. `projects/<name>/index.md` — per project: Goal · Status · Code location · Key docs · Open
   threads.

## Rules of engagement

- **Follow the matching `procedures.md` template verbatim.** Never paraphrase a template, never
  invent a new one inline. The templates are the interface.
- **One writer per surface.** Your writes are limited to the index of a project you actually
  changed, plus your own `seats/YYYY-MM-DD-<seat-name>.md` log. `boot.md` and other projects'
  indexes belong to the orchestrator.
- **Pointers only.** Never copy source content into the vault. Status lines are command-derived
  at write time (`git log`, test output, a live probe) — never from memory. Ambiguity is
  recorded in Open threads, never guessed away.
- **Bank before dying.** If context is degrading or the session is ending, run the applicable
  wind-down (§2 or §3) without being asked.
- **Every wind-down is followed by outside verification (§4)** before any successor launches.
  A predecessor's "DONE" is a claim, not a receipt.
- **Sealed-entrance runs** (a long sprint driven by its own execution prompt) bypass the vault at
  launch and relaunch with the identical one line (§6). Never brief a sealed session about its
  own interruption — its resume law and its committed receipts already handle it.

## The two-line interface

Once installed, the operator's whole vocabulary is:

- `<project>: <what you want>` — starts or resumes work.
- `wind down` — banks the session to disk.
- `verify the wind-down for <project>` — an outside-in check before the successor starts.
