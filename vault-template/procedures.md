# Procedures — dispatch, wind-down, wake, verify

The operating templates. [[README]] holds the conventions; this file holds the moves. Copy them
verbatim — they are the interface, and paraphrasing them is how drift starts.

**Auto-load note:** if you installed the CLAUDE.md / AGENTS.md snippets, the vault pointer, the
one-writer rules, and the bank-before-dying duty are injected into every session automatically —
no paste required for a session to know the system exists. The templates below are the
explicit-move layer on top.

## 1. Dispatch a session to a project

Route by **index path**, never by project name alone and never by working directory.

```
Read <VAULT>/projects/<name>/index.md.
Before working, state which project you are on and where its code lives, per that index.
Task: <task>
Method: the work is a graph — run independent items in parallel; never serialize without a real dependency.
Your only vault write surfaces are that index and your own seats/ logs.
```

Sealed-entrance runs (a sprint with its own execution prompt) skip the vault entirely:

```
Execute <absolute path to prompt> exactly as written.
```

## 2. Wind-down — standard project session

Design principle: **treat the outgoing session's memory as untrusted.** Its job is not "write
what you remember" — it is "commit what exists on disk and generate a handoff where every line
comes from a command run at write time." The successor trusts the tree, not the prose.

```
WIND-DOWN ORDER. Your context is degraded — do not trust your memory. No new
work, no fixes, no one last improvement. Do these steps in order, then stop.

1. STOP MACHINERY. Stop and drain every loop, watcher, or background process
   you started. Verify with ps that nothing of yours still runs. Record what
   you stopped and its last state — read it from its own logs/state files,
   not from memory. Check BOTH sides: local scheduled jobs AND anything you
   started on a remote host.

2. COMMIT EVERYTHING. In <repo>: run git status, then commit ALL work in
   coherent commits (one per area, real messages). End state: zero dirty
   files, or an explicit list of files deliberately left uncommitted with a
   one-line reason each.

3. HANDOFF FROM GROUND TRUTH. Write <handoff path>. Rule: every state line
   comes from a command you run at write time (git log, gates, test counts,
   live queries, service status, ls) — cite the command beside the line.
   Anything you believe but cannot re-derive with a command goes under a
   section titled UNVERIFIED CLAIMS, presented as leads, never as fact.

4. VAULT RECONCILE. Update Status and Open threads in
   <VAULT>/projects/<name>/index.md (only the indexes of projects you
   actually changed) — pointer lines derived from steps 2–3, pointing at your
   handoff. Then append your own log in your own words as
   <VAULT>/seats/YYYY-MM-DD-<seat-name>.md.

5. Reply DONE with: final commit hashes, the handoff path, and the list of
   stopped machinery. Then do nothing further in this session.
```

## 3. Wind-down — save-point sprint (sealed entrance)

For long runs whose own execution prompt defines committed save points. The architecture already
handles interruption: the successor resumes from the last **committed** save point and redoes
nothing before it. Resume-from-save-point discards **claims**, not **artifacts** — files survive
via WIP commits, remote state survives where it lives, and the re-run verifies rather than
rebuilds whatever already passes its checks.

```
WIND-DOWN ORDER — your context is degraded. Stop all new work now. The
sprint resumes in a fresh session from the last COMMITTED save point; your
only job is to leave the tree honest. Binding rules: never fake a state,
never round up a status, never claim a save point whose checks have not all
passed.

1. STOP. No new save-point work, no fixes, no "just finishing this step."

2. DERIVE STATE FROM GIT, NOT MEMORY. Run git log and identify the last save
   point actually committed with passing checks. Everything after it is
   in-flight and will be redone by design — do not rescue it, do not
   describe it from memory.

3. MACHINERY CENSUS — commands, not recollection. List what you started that
   is still live, locally AND remotely. Leave running anything a committed
   save point legitimately armed. Stop anything only your in-flight step
   depends on, and record each stop with the command used.

3b. PRESERVE INVENTORY — state that must survive. Record in the receipt, each
   with path + hash from a command run now, anything irreplaceable
   (conversation/profile state, adapter or credential config, session state
   files). Mark each line PRESERVED STATE — the successor verifies these,
   never recreates or deletes them. If any fix or output exists ONLY on a
   remote host and not in the repo, copy it into the repo now as a WIP commit
   (copy, never move).

4. COMMIT AN INTERRUPTION RECEIPT at <receipts dir>/interruption-<date>.md —
   every line derived from a command run at write time: last committed save
   point; the in-flight save point named as NOT REACHED with which checks
   passed and which did not; the machinery census; the preserve inventory;
   any owner actions surfaced and their status. No narrative, no advice to
   the successor. Commit it.

5. WIP commits only in commits whose message starts with WIP — never inside a
   save-point commit. Reply DONE with: last committed save point, receipt
   path, machinery stopped. Then nothing further.
```

## 4. Outside-in verification — before any relaunch

The outgoing session's DONE is a claim. A **fresh** session (any model, any account — this
requires zero memory of the dead session) runs the check:

1. **Commits actually landed** — `git log`, and confirm nothing is sitting unpushed if the
   handoff claims a push.
2. **The handoff or receipt exists** where the claim says, and is committed.
3. **Claimed machinery states match reality** — process lists, scheduled jobs, remote services.
   Hunt for machinery the census does *not* mention; that is where the real finds are.
4. **Preserved state re-derives** — the hashed paths still exist and match, or the difference is
   explained by legitimate continued operation.
5. **Load-bearing blockers get a live probe** where cheap. A blocker written down an hour ago may
   already be fixed — or, worse, still broken while everyone assumes a lane cleared it.

## 5. Wake — standard project session

```
Read <VAULT>/projects/<name>/index.md.
Before working, state which project you are on and where its code lives, per
that index.

Then read the handoff of record: <handoff path>.
Standing rule: paper claims need fresh receipts. Re-verify its key claims
yourself before relying on them. Anything under UNVERIFIED CLAIMS is a lead,
not a fact. The previous session wound down with degraded context; the tree
and the gates are the truth, its prose is not.

Task: <task>
Method: the work is a graph — run independent items in parallel; never
serialize without a real dependency.
Your only vault write surfaces are that index and your own seats/ logs.
```

Where two handoffs conflict with each other or with what the operator knows, add a **Phase 0**:
audit primary sources (build service history, receipts, live service state), state the
operator's own testimony as binding evidence, and list unverifiable items with the exact
two-minute check a human can do.

## 6. Wake — save-point sprint

The identical original launch line, nothing added:

```
Execute <absolute path to execution prompt> exactly as written.
```

Resist briefing the fresh session about the interruption. The sealed entrance is the drift
protection; the interruption receipt is already in the tree where `git log` surfaces it.

## 7. Account, subscription, and tool switches

- The vault is plain files on disk. It is independent of chat history, model, harness, and
  account. Switching accounts loses per-account chat history and per-account memory; the vault
  loses nothing.
- Any session on any account boots identically: read `boot.md`, follow the pointers.
- Before switching mid-work: run the wind-down (§2/§3) so state is banked. After switching: wake
  per §5/§6. A switch is a session death plus a session birth — nothing more.
- One-writer-per-surface holds across accounts: two accounts' sessions are still two sessions.
