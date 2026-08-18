---
name: graph-method
description: "The work is a graph, not a chain — serial agent chains are a defect class, not a style choice. Draw the nodes, cut the fake edges, fan out, verify on fresh context, isolate the writers, anchor the truth, and discipline every recurring loop with a state hub, work ledger, scored ratchet, bounds, and escalation. Trigger: the user says 'graph this', 'draw the graph', '/graph-method', 'why is this serial', 'parallelize this'; ALSO trigger unprompted before dispatching two or more pieces of work, before writing any plan containing an 'and then', before handing a mandate to a delegated agent, and before wiring any recurring or event-driven trigger."
---

# Graph Method — parallel agent work, made executable

**The law:** the work is a graph. Independent work dispatches together. A serial chain of
agent calls is the defect class, not a style preference. A recurring loop is a graph node with
its own discipline: state, claims, measurement, limits, and escalation.

This skill is distilled from public graph-engineering writing and public loop-engineering
practice. The primary public references are [Karpathy's autoresearch repository](https://github.com/karpathy/autoresearch), [0xCodila's loop-engineering discourse](https://x.com/0xCodila/status/2079597821511020996), and [0xCodez's graph-engineering roadmap](https://x.com/0xCodez/status/2079165300625330317). Adapt the machinery to the project; keep the falsifiers.

## STEP 0 — THE PERMISSION TABLE

Before anything dispatches, declare every artifact the work touches and assign each exactly one
permission:

| Permission | What lives there | Who writes it |
|---|---|---|
| **IMMUTABLE** | Acceptance criteria, falsifiers, reference specs, and definition of done | Nobody in the loop; changing one is an explicit maintainer decision |
| **READ** | Mandates, goals, and instructions the work runs under | The loop reads them; it does not author them |
| **WRITE** | The implementation, reports, and other work product | Exactly one region, owned by exactly one writing node |

This is an artifact write-ACL, not a capability restriction. Workers retain their tools; the
truth-bearing artifacts remain protected. An optimizer that can edit its own grader can make the
test easier. The acceptance bar resolves to a pinned reference, never to the previous
iteration's output.

The useful model from `autoresearch` is a three-file split: instructions, work, and grader. The
general rule is stronger than a prose reminder: the grader, tests, and acceptance criteria are
immutable to the worker. A sentence saying “do not change this” is not enforcement by itself.

## STEP 1 — THE DRAW

Before acting, dispatching, or writing a plan, list the work as nodes.

- A **node** is one bounded unit of work: one agent, job, or input-to-output operation.
- An **edge** is a dependency: this node's output feeds that node's input. Nothing more.

Walk every `and then` in the plan and ask:

> Does the next step actually read the previous step's output?

If yes, keep the edge and name the data crossing it. If no, cut the edge and dispatch both
together. Write the draw down. If there are no two independent boxes, this is a sequential task
or a loop; follow the relevant loop discipline below instead of pretending it is a graph.

## STEP 2 — FAN OUT, PIPELINE, AND BARRIERS

Fan out every node with no inbound edge from unfinished work in one batch. A failed node must
resolve to a recorded failure, not silently sink the batch; fan-ins tolerate missing results.

Prefer a pipeline when each item can move through stages independently. A barrier is justified
only by:

1. cross-item deduplication;
2. an early exit based on the total result; or
3. cross-comparison, ranking, or adjudication between results.

“Cleaner code,” “the stages feel separate,” and “I want to read them all first” are not
dependencies. Flattening a list is an edge, not a node.

## STEP 3 — THE VERIFIER RULE

The graph must not agree with itself. Put a verifier on the edge before a result can travel
downstream. Its job is to try to kill the finding.

Three conditions are mandatory:

1. **Fresh context.** The verifier has its own context and does not inherit the executor's
   transcript.
2. **A real signal.** It runs a test, checks evidence, or reproduces the behavior; it does not
   ask whether the author says it is done.
3. **Never the author.** The node that produced the work cannot be the node that confirms it.

**Default verdict: REJECT.** The burden of proof is on the work. A timeout, missing verdict,
unreadable receipt, or check the verifier cannot run resolves to `REJECT` or
`ESCALATE_HUMAN`, never to pass. Do not trust an implementer's report that tests passed; run
them independently.

The verifier also checks scope and intent, and looks for manufactured greens: disabled tests,
weakened assertions, commented-out checks, argument-position mistakes, routes around the gate,
and receipts that merely repeat the test input.

Choose the shape by the output:

| Shape | Use it for |
|---|---|
| **Adversarial refute** | Claims or findings that could be false; independent skeptics try to refute them |
| **Perspective-diverse** | Artifacts with multiple failure modes; use distinct correctness, security, reproduction, and fit lenses |
| **Judge panel** | A choice among candidates; independent judges score candidates before synthesis |

Scale verifier depth with change size, never verifier existence. In a loop, verification fires
on every iteration.

## STEP 4 — ISOLATION

Workers that write in parallel must not share a checkout. Give each writing node its own
worktree or sandbox, with explicit owned paths. Read-only fan-out needs no worktree.

Before parallel writes, answer:

1. Where does each writer work?
2. How do results merge?
3. Who adjudicates disagreement, and against what evidence?

## STEP 5 — ANCHORS AND RECEIPTS-OR-RED

The graph needs anchors that cannot be argued with:

- tests that actually ran, with their output;
- independently checked evidence or a rendered surface;
- immutable acceptance criteria and falsifiers;
- a verifier that is not the author.

Evidence is an artifact. Every gate emits a machine receipt containing the command, relevant
output, exit status, event count or timestamp, and runner identity. A prose “PASS” is a claim,
not a receipt. A capability (“the code supports it”) is not a measurement (“it ran; here is the
output”). **Missing, unreadable, or unattributed evidence is RED.**

Gates are standing invariants, not one-time admission tests. Declare each gate's re-run trigger
alongside its pass condition: a new component, changed adapter, amended specification, crossed
meter threshold, or claimed milestone. A negative falsifier can prove the old thing is gone; it
cannot prove the replacement is bounded. Every ladder also carries an economic falsifier, such
as calls, tokens, spawns, resumes, or work items per round, with a named threshold. Measure the
largest object crossing the context boundary, not merely the convenient one.

## STEP 6 — WHEN NOT TO GRAPH

Skip graph orchestration for a small isolated change, for exploratory work whose target is not
known, when the user requires approval after every step, or when every step genuinely reads the
last. Say why. If the task is a loop, that is a branch into the loop discipline, not permission
to omit controls.

## STEP 6a — LOOP DISCIPLINE

The graph defines macro-architecture; each recurring node is a loop inside a harness. Every
loop declares the following before its first iteration.

### 6a.1 — State hub

Use one durable, versioned, out-of-context state artifact per loop. Every iteration reads it
first and writes it last. It contains the mandate, acceptance criteria, current score per
criterion, tried and rejected approaches with reasons, open questions, and next action.

Read the hub verbatim; do not regenerate it from memory. Bound and meter its size, including the
largest object entering context. A summary that is re-derived each run is not durable state.

### 6a.2 — Work ledger

Track work items through an explicit lifecycle:
`open → claimed → in_progress → done/failed`.

Claiming is atomic: once claimed, no other runner can see the item as available. Never start a
run on a terminal item or an item held by another run. An agent's own output must never be the
trigger for a new run targeting that agent; the self-trigger count is a falsifier and must be
zero.

### 6a.3 — Scored ratchet

Write criteria and a named bar before work starts. Verification produces a number for every
criterion and identifies the weakest. Each iteration targets the weakest score, even if a
previously cleared criterion regresses. Keep improvements; revert regressions or errors and log
the rejected hypothesis in the state hub. Never use one scalar where deterministic per-criterion
checks exist. A judge score is provisional where no deterministic check exists. The bar always
resolves to a pinned reference, not the previous iteration's output.

### 6a.4 — Bounds

Every loop has four event-counted bounds:

1. an iteration cap per item;
2. a token, spawn, and tool-call budget per item plus a shared fan-out ceiling;
3. a circuit breaker on the same action and result, detected by action hash over a sliding event
   window; and
4. cancellation propagation from a completed, failed, or cancelled parent to every child.

Reaching any cap is an escalation event, never permission to continue. A wall-clock watchdog is
allowed only for a foreign process that is externally hung; it escalates and never passes work.

### 6a.5 — Escalation

Declare the risk classes that stop the machine before dispatch: security, schema, public
interfaces, authentication, payments, auto-merge paths, and changes to the permission table.
Verifier rejection with reasons escalates; it does not silently retry forever. Escalate again
when the same item has been retried or escalated twice. The classifier that calls a change safe
is itself verified under STEP 3.

### 6a.6 — Conditional triggers

Schedules, webhooks, labels, queues, and heartbeats may replace a human prompt only after the
loop demonstrably has the atomic work ledger, scored bar, four bounds, and an economic
falsifier. Without all four, an event-driven trigger is an amplifier, not an automation.

## STEP 7 — LOOP-UNTIL-DRY

For unknown-size discovery:

1. fan out finders;
2. dedupe each new find against **everything seen**, including rejected findings;
3. verify survivors on fresh context; and
4. stop after K consecutive rounds produce nothing new (K = 2 is a useful default).

Convergence is an event criterion, never a clock criterion. The four bounds in §6a.4 still
apply; empty rounds do not replace hard ceilings.

## STEP 8 — MANDATES, NOT TASKS

When a system has role-bearing agents, give each a mandate with an owned outcome and judgment
latitude, not “advance X one step.” Include its current state, room to fan out, and a way to ask
an answerable question. If a role underperforms, fix the machinery — loop, gate, state, or
ledger — rather than issuing a better instance order.

## STEP 9 — SEVEN-QUESTION SELF-CHECK

Answer these out loud every turn. They are discipline, not verification; fresh-context checks
and machine receipts remain the gates.

1. What ran in parallel this turn? If nothing, what real edge forced the line?
2. What barrier did I pay for, and which legitimate reason required it?
3. Who verified with fresh eyes, in which shape, and were they not the author?
4. What anchor proved it?
5. What per-criterion score cleared the pinned bar, and where is the receipt?
6. What event-counted bounds govern this loop, and what escalates at the cap?
7. What was written to the state hub, and what will the next run read verbatim?

## ANTI-PATTERNS — each is a defect

| You wrote or did | The defect | The fix |
|---|---|---|
| “Do A, then B” with no data crossing | Fake serial edge | Draw, cut the edge, dispatch together |
| N sequential calls for N independent items | Serial orchestrator chain | One batch |
| Executor reviews its own output | Self-confirmation | Fresh-context verifier |
| Several writers share one checkout | Overwrite collision | One worktree per writer |
| Barrier because it is cleaner | Wasted synchronization | Pipeline it |
| Missing receipt treated as green | Evidence laundering | Receipts-or-RED |
| Gate runs only at admission | Regressions re-enter later | Declare and honor re-run triggers |
| State regenerated from memory | Lossy continuity | One bounded, metered hub read first and written last |
| Wake targets terminal or held work | Duplicate work | Atomic claim; terminal is terminal |
| Agent output triggers its own wake | Self-trigger storm | Suppress it; falsifier must be zero |
| One scalar says done | Goodhart bait | Per-criterion scored ratchet |
| Cap says continue | No real bound | Escalate at the cap |
| “Stop after N minutes” | Clock-based convergence | K empty event rounds plus hard bounds |
| Event trigger added before controls | Amplifier without brakes | Ledger, ratchet, bounds, economic falsifier first |
| Cycle dedupes only confirmed results | Rejected work returns forever | Dedupe everything seen |
| A role receives “advance X one step” | Role reduced to a worker | Mandate with latitude |

## THE SHIFT

> A prompter asks a question. **An architect draws a graph and engineers the loop inside it.**

Fan out where work is independent. Gate every edge where confidence matters. Freeze the nodes
that hold the truth. Give every loop a state hub, ledger, ratchet, bounds, escalation policy,
and conditional ingress. Draw the graph. Stay the architect.
