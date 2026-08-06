# Context vault — conventions

The durable context layer for this machine's active projects. Any fresh agent session reads
[[boot]] first and reconstructs project context in under a minute. Humans can open the folder in
Obsidian (or any editor — it is plain markdown).

## Rules

1. **Pointers only.** No source content is copied or summarized into this vault. Every status
   line derives from ground truth the writer verified themselves (`git log`, `ls`, a test run, a
   live probe) — never from memory or from summarizing a conversation.
2. **Code stays where it is.** The vault holds status and pointers. Use absolute paths for
   anything outside the vault; `[[wikilinks]]` between vault files.
3. **Read-only outside the vault.** Vault maintenance never moves, edits, or deletes anything in
   the projects themselves.
4. **Ambiguity is recorded, not resolved.** If ground truth is ambiguous, it goes in the
   project's Open threads as an ambiguity — no guessing.
5. **One writer per surface.** A session writes only the index of a project it actually changed,
   plus its own seat log. `boot.md` belongs to the orchestrator.

## Layout

- [[boot]] — the cursor: active projects, current focus, read-first pointers
- [[procedures]] — dispatch, wind-down, wake, verification, account switches
- `projects/<name>/index.md` — one per active project: Goal / Status / Code location / Key docs /
  Open threads
- `seats/` — per-session logs, `YYYY-MM-DD-<seat-name>.md`, written by the session itself

## Dispatching a session to a project

Route by index path, never by project name or working directory. Launch template:

```
Read <VAULT>/projects/<name>/index.md.
Before working, state which project you are on and where its code lives, per that index.
Task: <task>
Method: the work is a graph — run independent items in parallel; never serialize without a real dependency.
Your only vault write surfaces are that index and your own seats/ logs.
```

Sealed-entrance launches (a sprint with its own execution prompt) skip the vault:
`Execute <absolute path to prompt> exactly as written.`

## Adding a project

1. Create `projects/<name>/index.md` with the five sections.
2. Record verified absolute code and document paths — never inferred ones.
3. Add one line to `boot.md` under Active projects.
4. Put unresolved location or state questions in Open threads.

Do not create `.obsidian/` by hand — Obsidian makes its own on first open.
