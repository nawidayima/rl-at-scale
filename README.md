# The Critical Path, Vol. I: RL at Scale

A practical guide to reinforcement learning inference optimization for frontier AI systems.

## What this book is about

Smarter AI models come from RL, and RL training is bottlenecked by inference. Every technique that makes rollout generation cheaper also makes production serving cheaper. This book covers the full stack from hardware memory hierarchies to policy gradient variance, treating performance engineering and research engineering as one discipline.

**North star metric:** policy improvement per dollar of rollout compute.

## Chapters

| Ch | Title | What you learn |
|----|-------|---------------|
| 1 | The Memory Wall | Reason about hardware from first principles |
| 2 | Kernel Optimization | Optimize inference building blocks |
| 3 | Rollout Generation | Optimize end-to-end throughput |
| 4 | Policy Gradients | Understand what the training loop actually needs |
| 5 | The RL Pipeline | Wire it all together |

## Who this is for

You understand how neural networks are trained and what a transformer does. You want to work at the intersection of systems and ML research, whether you're coming from the systems side or the research side. This is a workshop, not a lecture: exercises ask you to solve problems before reading the solution.

## The series

This is the first volume in *The Critical Path*, a series about identifying and attacking the bottlenecks that slow down progress on hard problems. Future volumes will cover other domains. Inference optimization comes first because cheaper inference makes AI a better tool for everything else.

## Status

This is an experiment in learning by writing. The book is a work in progress. Contributions, feedback, and corrections are welcome. Open an issue or submit a PR.

## Building

Requires a LaTeX distribution with `pdflatex`.

```bash
make textbook        # build pdf to build/
make publish         # copy to pdf/ for distribution
make ch=00-introduction chapter   # build a single chapter
```

Pre-built PDFs are in [`pdf/`](pdf/).
