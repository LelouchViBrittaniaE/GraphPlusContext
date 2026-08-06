# Seat logs — convention

Each working session appends its own log at wind-down as:

```
seats/YYYY-MM-DD-<seat-name>.md
```

Written by the session itself, in its own words. The orchestrator never writes, edits, or
compresses a seat log — relay is verbatim or not at all. Compression by a coordinator is how
manufactured disputes start: a one-line summary gets followed over the sources it summarized.

Unique filenames mean two concurrent sessions can never collide here. This is the one vault
surface that is safe to write without coordination.

A useful seat log answers: what I did, what I proved (with the command), what I left undone, and
what the next session should distrust.
