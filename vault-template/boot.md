# Boot — active projects cursor

*The first file any session reads. Keep it short: one line per project, pointers only. See
[[README]] for conventions and [[procedures]] for the operating templates.*

## Active projects

- **[[projects/example-project/index|Example project]]** — one line of current status, derived
  from ground truth, with the thing that is actually blocking it.

## Read these first

1. [[projects/example-project/index]]

## Current focus

*(What is in flight right now. One short paragraph or a handful of bullets. If a long sprint is
running under its own execution prompt, put its launch line here verbatim so any session can
relaunch it:*

```
Execute <absolute path to execution prompt> exactly as written.
```

*Crash recovery: a fresh session re-launched with that same line resumes from the last committed
save point. This vault is for orientation, never a second authority.)*
