# GraphPlusContext

**Two disciplines for running real work across many AI coding sessions: fan the work out like a
graph, and keep the context somewhere the sessions can't take with them when they die.**

Drop-in skills and a vault scaffold for Claude Code, Codex, and any agent tool that reads a
global instructions file or a skills directory. Plain markdown, MIT licensed, no dependencies
beyond `bash` and (optionally) `jq`.

---

## The two problems this solves

**1. Serial agent chains.** You type "do A, and then B, and then C" — and B never actually reads
A's output. You just paid wall-clock for an ordering you invented while typing. At scale this is
the dominant waste in agent work, and it hides because the result still arrives.

**2. Context that dies with the session.** Everything the session learned — what's committed,
what's deployed, what's still broken — lives in a chat window. When the window degrades, or you
switch models, or your subscription rolls over, that knowledge is gone. The usual fix is a
hand-written handoff, which is where the *second* failure lives: a degraded session writing down
what it *remembers*, confidently, including the parts that are wrong.

GraphPlusContext addresses both as machinery rather than as good intentions.

---

## What you get

```
skills/graph-method/SKILL.md      the executable parallelism discipline — draw, fan out,
                                  verify on fresh context, isolate the writers, anchor the truth
skills/context-vault/SKILL.md     the durable-context discipline — dispatch, wind-down, wake,
                                  outside-in verification, continuity across tools and accounts
vault-template/                   the vault itself: boot.md cursor, per-project indexes,
                                  procedures.md (the copy-paste templates), seats/ logs
snippets/                         standing laws for CLAUDE.md / AGENTS.md, plus an optional
                                  SessionStart hook that injects the live cursor into every session
docs/FAILURE-MODES.md             the failures this was built from, and what each one cost
install.sh                        installs the skills, scaffolds the vault, prints the two
                                  config steps it deliberately leaves to you
```

The skills trigger themselves. `graph-method` fires before any dispatch of two or more pieces of
work, and before any plan containing an "and then". `context-vault` fires on wind-down, hand-off,
wake, and project dispatch. You do not have to remember to invoke either one.

---

## Install

```bash
git clone https://github.com/<you>/GraphPlusContext.git
cd GraphPlusContext
./install.sh ~/context-vault
```

The installer copies both skills into `~/.claude/skills/` (and `~/.codex/skills/` if Codex is
present), scaffolds the vault, and then **stops and prints** the two steps that modify your
config files — appending the standing laws to `CLAUDE.md`, and merging the optional
`SessionStart` hook into `settings.json`. Installers that silently edit your settings are a bad
habit; those two commands are yours to run.

Then fill in `boot.md` and one project index, and you're running.

---

## Daily use

The whole operator vocabulary, once it's installed:

| You say | What happens |
|---|---|
| `<project>: <what you want>` | The session boots with the cursor already injected, states which project it's on, reads that project's index, works the graph way. |
| `wind down` | The session stops, commits, writes a handoff where **every line comes from a command run at write time**, reconciles the project index, writes its own seat log, and reports what machinery it stopped. |
| `verify the wind-down for <project>` | A **fresh** session — any model, any account, zero memory of the dead one — checks the claims from outside: commits landed, receipt exists, machinery census matches reality, preserved state re-derives. |

That's it. No pasting long templates, no remembering paths.

---

## The design, in five ideas

**1. Sessions are disposable; the vault is not.** The vault is a folder of plain markdown on
disk. It does not care which model wrote to it, which subscription you're on, or which tool you
switched to. A profile switch is a session death plus a session birth — the durable layer never
notices.

**2. Pointers, never content.** The vault records *where the truth lives* and *what state it was
in when someone last checked with a command*. It never copies source content in. A vault that
accumulates content becomes a second, competing source of truth — and a stale one.

**3. Ground truth outranks prose.** Every status line must trace to `git log`, a test run, a live
probe. Anything believed but not re-derivable goes under a heading that says **UNVERIFIED
CLAIMS**, and the next session treats it as a lead, not a fact.

**4. A predecessor's "done" is a claim, not a receipt.** Wind-down is followed by an outside-in
verification pass run by a session that has no memory of the work. This is not paranoia — in
practice this pass finds something real most times it runs (see `docs/FAILURE-MODES.md`).

**5. One writer per surface.** A session may write the index of a project it actually changed
and its own uniquely-named seat log. Nothing else. Concurrent sessions cannot clobber each other
because their write surfaces do not overlap.

---

## Why the graph part matters

The `graph-method` skill is the part that changes throughput rather than safety. Its core move
takes thirty seconds:

> List the work as nodes. Walk every "and then" in your own plan and ask: **does the next step
> actually read the previous step's output?** If yes, keep the edge and name the data crossing
> it. If no, there is no edge — the wait is wasted, and they dispatch together.

Most chains turn out to have two or three arrows carrying no data. Cut those and the chain
collapses into something wide. The skill goes on to cover the failures that show up once you *do*
run wide: agents that agree with themselves (fresh-context verifiers, never the author), agents
that overwrite each other (a worktree per writing node), cycles that never converge (dedupe
against everything seen, not just against confirmed results), and graphs where nothing touches
reality (anchors — tests that actually ran).

It also tells you **when not to graph**, which matters more than it sounds. Most tasks are not
graphs, and forcing one on a genuinely sequential task buys coordination cost for zero speedup.

---

## Compatibility

- **Claude Code** — skills auto-discovered from `~/.claude/skills/`; standing laws via
  `~/.claude/CLAUDE.md`; optional `SessionStart` hook via `~/.claude/settings.json`.
- **Codex CLI** — skills from `~/.codex/skills/`; standing laws via `~/.codex/AGENTS.md`.
- **Anything else** — the skills are plain markdown with YAML frontmatter, and the vault is a
  folder. Point your tool's instruction file at the vault path and the same discipline applies.
- **Obsidian** (optional) — the vault uses `[[wikilinks]]`, so `boot.md` becomes a clickable
  cursor and the graph view shows the structure. Obsidian is viewing software; the files are the
  system.

---

## Credit

The graph discipline is distilled from public writing on graph-engineering agent loops
(0xCodila's five-step loop, 0xCodez's fourteen-step roadmap), from publicly reported large-scale
agent ports, and from production experience running multi-agent sprints where each of the
failure modes in `docs/FAILURE-MODES.md` happened for real.

MIT licensed. Fork it, strip what you don't need, keep the parts that survive contact with your
own work.
