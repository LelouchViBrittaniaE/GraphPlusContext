# Failure modes

Every rule in this repo exists because something broke. These are the failures, genericized from
production multi-agent work, and the machinery each one produced. If you are deciding which parts
of GraphPlusContext to keep, keep the ones whose failure you recognize.

---

## 1. The 208/208 problem — a checklist is not a system

A large agent build reported **"208 of 208 tasks complete"** while the system it was building had
never successfully run once. Every task had been marked done by the agent that did it. Nothing
had been exercised end to end.

**What it produced:**
- **Anchors** (graph-method §5): tests that actually ran, a surface someone opened, a command
  whose output you can read. "The agent said so" is not an anchor.
- **Soak gates**: before a build can be called finished, it has to run unattended through at
  least two complete cycles of every scheduled behaviour, with a sentinel that catches *silence*
  — the failure where nothing happens and no error fires either.

---

## 2. The green suite that shipped a broken product

A test suite passed **201 of 201** while the app's single core action was impossible for a real
user. Four builds were cut and handed over in that state.

**What it produced:**
- A **live end-to-end gate** that runs the real user action against the real backend *before*
  any of the fast checks, and refuses the build on failure. Any red = no build, no upload, no
  artifact.
- The rule that a green suite is evidence about the suite, not about the product.

---

## 3. The confident handoff from a degraded session

A session running low on context wrote a handoff from memory. It contained an over-claim ("build
shipped and verified") that did not survive checking, and — after the correction — an
over-*refutation* in the other direction: a claim that something had never shipped, which the
operator personally knew was false. Both errors came from the same source: prose written by a
session that could no longer tell memory from evidence.

**What it produced:**
- **Wind-down as a procedure, not a request**: stop, commit, then generate the handoff where
  *every state line cites the command that produced it*. Beliefs that cannot be re-derived go
  under **UNVERIFIED CLAIMS**.
- **Wake instructions that order re-verification** rather than inheritance: "the tree and the
  gates are the truth, its prose is not."
- **Phase 0 audits** when two handoffs disagree: go to primary sources, treat the operator's own
  testimony as binding evidence, and list what only a human can check in two minutes.

---

## 4. The machinery nobody remembered starting

Two verified wind-downs, two real finds. In the first, a repository the session believed it had
pushed was sitting five commits ahead of its remote. In the second, a background job created
mid-session — a five-minute sync loop — was still firing after the session ended, absent from the
session's own census, quietly re-dirtying the working tree.

**What it produced:**
- The **machinery census** step: list what you started, *locally and remotely*, from `ps` /
  scheduled-job listings / service status — never from recollection.
- **Outside-in verification** (procedures §4) as a mandatory beat between wind-down and relaunch,
  run by a session with no memory of the work, whose job includes hunting for machinery the
  census does *not* mention.

---

## 5. The summary that manufactured a dispute

A coordinator wrote a one-sentence summary of a system's structure at the top of a brief. Three
downstream agents followed **the summary** instead of the source documents it summarized; a
fourth derived from the source. The resulting three-way disagreement was entirely an artifact of
the coordinator's compression — the sources had never disagreed.

**What it produced:**
- **Briefs carry pointers, not content.** File paths, authority order, task, output shape. Zero
  content assertions.
- **Seat logs are written by the seat, in its own words** — the orchestrator never rewrites or
  compresses them.
- Where sources genuinely conflict, an agent **flags the conflict** rather than receiving a
  pre-resolved answer.

---

## 6. Agents overwriting each other

Publicly reported from a large agent-driven port: the first attempt fanned work across many
agents that shared one workspace and ran shared version-control commands. They overwrote each
other's work. The fix was structural — forbid the unsafe commands, give each writing group its
own isolated worktree — not better prompting.

**What it produced:**
- **Isolation before fan-out** (graph-method §4), and the three questions you answer *out loud*
  before dispatching: where does each agent work, how do results merge, who adjudicates a
  disagreement.
- **One writer per surface** in the vault, so the context layer has the same property: unique
  filenames for seat logs, one owner per project index.

---

## 7. The cycle that never ran dry

A discovery loop was left running to convergence and reached round sixty without converging. It
had been deduplicating new findings against *confirmed* results only — so everything the verifier
rejected came back every round, forever.

**What it produced:**
- **Loop-until-dry** (graph-method §7) with the one detail that makes it work: dedupe against
  **everything seen**, not against what survived.
- **Convergence as an event criterion** — K consecutive empty rounds — never a clock.

---

## 8. Time as a proxy for machine work

A completion bar was written as "run unattended for two days". Two days is a human unit; a
machine runs on cycles and turns. The bar was really "two complete revolutions of the slowest
scheduled loop."

**What it produced:**
- Denominate machine criteria in **cycles, rounds, and turns**.
- Keep wall-clock for exactly one job: the **null-event detector**. A hung system produces zero
  turns, and a turn counter reads zero turns as "nothing to evaluate" rather than as FAIL.
  Absence is only observable against a clock.

---

## The pattern behind all eight

Every one of these is the same shape: **something claimed a state it had not proved.** A
checklist claimed completion. A suite claimed working software. A handoff claimed a push. A
census claimed a stopped process. A summary claimed a structure.

The countermeasure is always the same too, and it is the through-line of this whole repo:

> **Make the claim cite the command that produced it, and let someone with fresh eyes re-run it.**
