---
name: graph-method
description: "The work is a graph, not a chain — serial agent chains are a defect class, not a style choice. Draw the nodes, cut the fake edges, fan out, verify on fresh context, isolate the writers, anchor the truth. Trigger: the user says 'graph this', 'draw the graph', '/graph-method', 'why is this serial', 'parallelize this'; ALSO trigger unprompted before dispatching two or more pieces of work, before writing any plan containing an 'and then', and before handing a mandate to a delegated agent."
---

# Graph Method — parallel agent work, made executable

**The law:** the work is a graph. Independent work dispatches together. A serial chain of agent
calls is the defect class, not a style preference.

**Why this exists as a skill and not a paragraph in a README:** a prose law is an unenforced
law. This file is the procedure you run under pressure, at the exact moment when the fast thing
to do is type one more "and then".

*Distilled from public writing on graph-engineering agent loops (0xCodila's five-step loop,
0xCodez's fourteen-step roadmap) and from production experience running large multi-agent
sprints. Adapt freely.*

---

## STEP 1 — THE DRAW (never skip; it takes 30 seconds)

Before acting, before dispatching, before writing the plan: **list the work as nodes.**

- A **node** is one unit of work: one agent, one bounded job, one input in, one output out.
- An **edge** is a dependency: this node's output feeds that node's input. Nothing more.

Then walk every `and then` in your own plan and ask the one question:

> **Does the next step actually read the previous step's output?**
>
> - **Yes** → real edge. Keep the order. Name the edge by the DATA that crosses it, not by
>   the order you typed it.
> - **No** → **no edge. The wait is wasted. They dispatch together.**

*"Summarize this file and then tell me the weather" — the weather doesn't read the summary.*
Two independent nodes that a linear habit chained for no reason.

**The finding you should expect:** most chains have two or three arrows that carry no data —
they are just the order you happened to type things in. Cut those arrows and the chain
collapses into something wider.

**Write the draw down** in the reply or the plan doc: one line per node, plus the edges you kept
and why each kept edge is real. A kept edge with no named data crossing it is a fake edge you
have not cut yet.

**The tell:** if you cannot find two boxes with no arrow between them, there is no graph here.
Go to §6 (WHEN NOT TO GRAPH). That is a legitimate answer — but it must be the CONCLUSION of a
draw, never a substitute for doing one.

---

## STEP 2 — THE FAN-OUT RULE

**Fan out where the work is independent.** N independent nodes → one batch, spawned at once,
results collected as an array. This is the move that pays for everything else.

**What dispatches in one batch:**
- Every node with no inbound edge from an unfinished node. All of them. Same batch.
- Every independent tool call in ONE assistant turn — never N sequential rounds.
- Multi-step artifact work (write + publish + verify + commit) is **one brief to one agent**,
  not N orchestrator rounds.

**Make "wide" mean something:**
- Concurrency is typically capped near core count locally; excess **queues**, it does not fail.
  Passing a hundred jobs is legal — they all finish, a handful at a time.
- A job that throws should **resolve to null** rather than sink the batch. Always filter the
  results, and design every fan-in to tolerate missing inputs rather than assume a full set.
- **Start scoped: cap the first run at ~20 items**, watch behaviour and cost, then open it up.
  The saving from orchestration is in COORDINATION — the script's variables hold intermediate
  results instead of your context — not in the work itself, which still costs what it costs.
- The publicly reported ceiling, with its price attached: Bun's Zig→Rust port ran dozens of
  agent workflows at a peak of ~64 agents in parallel, converting a very large codebase in
  days — at a six-figure usage bill, with a human designing and monitoring throughout. The
  scale is real. So is the price and the supervision.

**What a barrier costs:** a barrier makes **everything wait for the slowest node** before the
next stage starts. That latency is real, measurable, wasted time.

**Default to a pipeline** — each item streams through all stages independently, item A in stage
3 while item B is still in stage 1, fast items finishing early instead of idling behind slow
ones.

**A barrier is genuinely required for exactly three things:**
1. **Cross-item dedupe** — the stage must see every result to know what is a duplicate.
2. **Early-exit on the total** — the decision is about the whole set (nothing came back; the
   total crossed a threshold; the sweep is empty, so stop).
3. **Cross-comparison** — the prompt compares each item against *the other findings* (ranking
   by impact, picking a winner, adjudicating between them).

**A barrier is laziness when** the reason is "it's cleaner code", "the stages feel separate", or
"I want to read them all before continuing". *Separate is not the same as synchronized.*

**The smell test:** if you wrote `parallel → transform → parallel` and that middle transform has
no cross-item dependency, you should have used a pipeline and skipped the barrier. Flattening a
list is an **edge**, not a node — do it inline, in code. A great deal of what people burn model
tokens on is really an edge, and **edges are free**.

---

## STEP 3 — THE VERIFIER RULE

**The first failure mode of every graph: the graph agrees with itself.** When an agent checks
its own work it goes easy on itself — models prefer their own outputs.

So a verifier node sits **on the edge**, before a result is allowed downstream, and its only job
is **to try to kill the finding**. If it survives, it passes. If not, it never reaches the
answer.

**Three non-negotiables. All three, or it is not a verifier:**
1. **Fresh context.** Its own window. Hand a verifier the same conversation the executor had and
   it is not verifying — *it is agreeing with itself in a different font.* A graph of agents
   sharing one context is a single loop in a costume: it fails the same way, later, more
   expensively, with more green lights on the way down.
2. **A real signal.** Not *"did the agent say it's done"* — **"does the test actually pass"**.
   Evidence, not self-report.
3. **Never the author.** The seat that produced the thing may not be the seat that confirms it.
   Self-confirmation is the same claim made twice, not a check.

**The three verifier shapes, and when each fits:**

| Shape | What it does | Reach for it when |
|---|---|---|
| **Adversarial refute** | For each finding, spawn N independent skeptics prompted to REFUTE it; keep it only if a majority survive. | The output is a **claim that could be wrong** — a finding, a fact, a "this is fixed". The default shape for anything factual. |
| **Perspective-diverse** | Give each verifier a distinct lens — correctness, security, does-it-reproduce, design-fit — because diversity catches failure modes N identical checks never will. | The output is an **artifact with several ways to be wrong** — a diff, a screen, a migration, a document. |
| **Judge panel** | Generate N attempts from different angles, score them with parallel judges, synthesize from the winner while grafting the best of the runners-up. | The output is a **choice among candidates** — which draft, which architecture, which of three plans. |

**Route the verifier by size.** A small change gets one quick pass; a large one triggers the
full parallel audit. Make the router code, not vibes — so skipping it would have to be written
into the graph.

---

## STEP 4 — ISOLATION (before the fan-out, not after the collision)

**The second failure mode: agents stepping on each other.** This is not hypothetical. When
Bun's team first fanned a large port across many agents, the run failed operationally — agents
ran shared git commands in one workspace and **overwrote each other**. The fix was
**structural, not clever prompting**: forbid the unsafe commands, give each group its own
isolated worktree.

**Rule: workers that WRITE must not share a workspace.** Each writing node gets its own git
worktree, does its work in a sandbox, and merges cleanly.

**Reach for isolation only when nodes actually write in parallel.** It is the seatbelt for the
one topology that needs it, not a default tax on every run. Read-only fan-out needs no worktree.

**Answer these three, out loud, BEFORE you fan out:**
1. **Where does each agent work?** (Which worktree, which branch, which owned paths.)
2. **How do results merge?** (Who applies, in what order, against what checkout.)
3. **What happens when two disagree?** (Which node adjudicates, on what evidence.)

*A graph without that plan doesn't scale — it fails faster.*

**Failure containment.** In a chain, a failure cascades: C dies, D never runs, the whole thing
halts. In a graph, failure is contained to its node — one bad agent drops out, eight good ones
still return. Preserve that: never write a fan-in that assumes a full set.

---

## STEP 5 — ANCHORS

**Topology alone does not buy truth.** A network of agents all confirming each other, none of
them touching anything real, fails exactly like the single loop did — just with more moving
parts and more green lights.

**The graph needs anchors: nodes that cannot be argued with.**
- **Tests that actually ran.** Not "should pass" — **did pass**, with the output.
- **A verifier on evidence, not vibes.** A fetched page, a rendered surface someone opened, a
  command whose output you can read, a source URL that resolves.
- **Frozen rules an optimizer may not tune** — because those are exactly the ones an optimizer
  would weaken. Acceptance criteria, standing rules, the definition of done. Checks are the
  definition of done and are never weakened to get past them; raising a bar carries a note
  citing intent.

*The graph is only as honest as the things in it that refuse to move.*

**Build your own anchors and name them.** Useful ones from practice: a *sighting receipt* (a
delivery claim is unverified until an independent read of the rendered surface confirms it —
and whoever looked must not be whoever claimed); a *claims register* (facts are graded by an
evidence owner, never by the agent that wants to use them); a *conformance CLI* (your standing
rules run as a test suite, so a violated rule fails a build instead of surviving in prose).

---

## STEP 6 — WHEN NOT TO GRAPH

**Most tasks are not graphs.** Reaching for one when you don't need it burns money and adds ways
to fail. Say so plainly and move — refusing to graph, with the reason named, is conformance, not
laziness.

**Skip the graph when:**
- **The task is small or isolated.** Adding a function, fixing one bug. A workflow is pure
  overhead; a single agent is faster and cheaper.
- **The user wants tight oversight.** If every step is to be read and approved before the next
  runs, the graph's whole point — running wide without them — works against them.
- **You don't know what you're looking for yet.** Exploratory work wants one agent you can
  steer, not a fleet committed to a plan before the problem is understood.
- **The steps genuinely depend on each other.** If every step reads the last step's output, it's
  a real chain. Parallelism has nothing to grab, and forcing a graph on it adds coordination
  cost for zero speedup.

**The tell is Step 1.** If you cannot find two boxes with no arrow between them, there is no
graph to build. It's a loop, and a loop is fine. **A graph is a tool for width.** When the work
isn't wide, the line was never the problem.

---

## STEP 7 — LOOP-UNTIL-DRY (cycles that converge)

Sometimes the size of the job is unknown until you are in it: discovery of unknown size, a sweep
where finding one thing reveals three more. That needs a **cycle** — a controlled edge back to
an earlier node.

**The danger is obvious:** a cycle that doesn't converge is an infinite loop that spawns agents
until the budget is gone.

**The pattern that converges — loop-until-dry:**
1. Fan out finders in parallel.
2. Dedupe each new find.
3. Verify the survivors on fresh context (§3).
4. **Keep looping until K consecutive rounds surface nothing new** (K = 2 is the working
   default), then stop.

**The one detail that makes or breaks it — the mistake almost everyone makes the first time:**

> **Dedupe against EVERYTHING SEEN, not just against confirmed results.**

Otherwise rejected findings reappear every round, the loop never runs dry, and you have built a
machine that pays to rediscover the same dead ends forever.

**Convergence is an EVENT criterion, never a clock one** — K consecutive empty rounds, not "stop
after an hour". Machines run on turns and rounds; wall-clock belongs only where you must detect
*absence* (nothing fired at all), which produces no turns to count.

---

## STEP 8 — MANDATES, NOT TASKS (when your agents have roles)

If your system has standing agent roles — a research seat, a review seat, a department head —
the distinction below is operational, not decorative:

> **A role decides what to do. A worker is told.**

**Work handed to a role-bearing agent is a MANDATE with judgment latitude — never a single
mechanical step.**

**The anti-pattern, named so you catch yourself writing it:**

> If you find yourself writing **"advance X one step"** for a standing role — stop. That is the
> defect. You have just built a one-node line and put a department head in it.

**What that agent's turn must contain instead:**
- The **outcome it owns**, stated as an outcome, not as the next action.
- Its **own state** — open work, what came back — as an instrument panel, not as instructions.
- **Latitude to fan out itself.** An agent that only consumes assigned items and never delegates
  is being operated, not employed.
- **The right to ask** — a first-class question back, with enough context to be answerable cold.

**The class-fix test:** if your answer to an agent underperforming is a better instruction to
that agent, you have issued an instance order. The fix is machinery — the loop, the gate, the
state block — built so the agent produces the behaviour itself, forever.

**Corollary — the orchestrator is not the workbench.** Machine work belongs to the machine. An
orchestrator chain longer than about four dependent calls either justifies its dependency out
loud or becomes a delegated lane.

---

## STEP 9 — THE SELF-CHECK (answer these OUT LOUD, every turn)

Four questions. Say the answers in the reply or the plan doc — an unstated answer is a skipped
check, and the honest answer "none, and here is why" is a pass.

1. **What ran in parallel this turn?** (Name the batch. If nothing, name the real edge that
   forced the line.)
2. **What barrier did I pay for, and why?** (One of the three legitimate reasons in §2 — or it
   was laziness; say which.)
3. **Who verified with fresh eyes?** (Name the verifier, its shape, and confirm it is not the
   author.)
4. **What anchor proved it?** (The test that ran, the surface someone opened, the frozen rule
   that held. "The agent said so" is not an anchor.)

---

## ANTI-PATTERNS — each of these is a defect, not a style

| You wrote / did | The defect | The fix |
|---|---|---|
| "Do A, then B, then C" with no data crossing | A single chain: if C stalls, D never happens | Draw it (§1), cut the fake arrows, dispatch A/B/C together |
| N orchestrator rounds for N independent tool calls | Serial chain — the named defect class | One turn, one batch |
| The executor reviews its own output | The graph agrees with itself | Fresh-context verifier, never the author (§3) |
| A verifier handed the executor's transcript | A single loop in a costume | Its own window, checking a real signal |
| `parallel → transform → parallel` with no cross-item dependency | A barrier bought for nothing | Pipeline it; the transform is an edge |
| Barrier because "it's cleaner" / "stages feel separate" | Laziness priced in wall-clock | Separate ≠ synchronized |
| Several writing agents in one checkout | Agents overwrite each other | One worktree per writing node (§4) |
| A fan-in that assumes every input arrived | One flaky node halts eight good ones | Tolerate nulls; filter the results |
| A cycle deduping only against CONFIRMED results | Rejected findings return forever; never runs dry | Dedupe against everything seen (§7) |
| "Stop after N minutes" as the convergence rule | Time-based criterion | K consecutive empty rounds (§7) |
| "Advance X one step" handed to a standing role | A department head in a one-node line | Mandate with latitude (§8) |
| A graph forced onto a genuinely sequential task | Coordination cost for zero speedup | Say it's a loop and run it (§6) |
| Agents confirming each other, none touching anything real | Topology without anchors | Tests that ran, evidence not vibes (§5) |

---

## SIX GRAPHS THAT ALREADY HAVE A SHAPE

Change the task line, keep the skeleton: **find the real edges → fan out → verify on independent
context → isolate the writers.**

1. **Sweep across every file** — one agent per file hunting one class of defect, a verifier
   confirming each hit before it reaches the report.
2. **Cited report** — decompose into distinct angles, search in parallel, dedupe sources,
   adversarially verify every claim before writing.
3. **Port / migrate a module** — file by file, the test suite as a gate on each, failures looped
   back, adversarial review catching what a single pass would ship broken.
4. **Adversarial diff review** — routed by size: small change → one pass; large → full parallel
   audit on distinct lenses, then a judge panel synthesizes.
5. **Scheduled ecosystem scan** — many sources in parallel, ranked by impact at a barrier
   (legitimate: cross-comparison), written up. Saved once, re-run by name.
6. **Discovery of unknown size** — finders in parallel, each result deduped against everything
   seen, survivors verified, looping until two rounds turn up nothing new.

---

## THE SHIFT

> A prompter asks a question. **An architect draws a graph.**

The linear agent was never the ceiling — it was the first shape, the one everyone reaches for
because it matches how we type: one line, one thing at a time.

**Fan out where the work is independent. Gate the edges where confidence matters. Freeze the
nodes that hold the truth.**

Draw the graph. Stay the architect.
