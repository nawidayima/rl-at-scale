# Textbook Restructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure rl-at-scale from 9 vendor-organized chapters to 6 bottleneck-organized chapters focused on serving RL workloads.

**Architecture:** Hybrid write strategy — new chapter shells from scratch with the new framing, then transplant flagged content from old chapters. Exception: Ch 4 (Policy Gradients) modified from old Ch 05 directly. Old chapters archived in `chapters/old/` for reference during transplant, then deleted after all tasks complete.

**Tech Stack:** LaTeX (tectonic compiler), TikZ for diagrams, tcolorbox environments (exercise, thinkfirst, portfolio, whythis, taste). Build: `make textbook` or `make ch=<name>`.

**Spec:** `docs/superpowers/specs/2026-04-07-textbook-restructure-design.md`

**Pedagogy rules (apply to ALL tasks):**
- Writing follows crispy-rewrite: no filler, quantify or cut, direct tone. Top-down from most important idea, MECE layers before drilling into details.
- Single-reader framing: no "PE wants X, RE wants Y." Reader balances both perspectives.
- TikZ only where it reduces cognitive load (spatial relationships, temporal sequences, architecture comparisons). Never decoration.
- Box types: `whythis` (frontier relevance), `thinkfirst` (conceptual, no computer), `exercise` (hands-on), `portfolio` (publishable artifact), `taste` (research judgment).

---

## File Structure

### New files (to create)
- `chapters/00-introduction.tex` — Economic imperative, thesis, philosophy, chapter map
- `chapters/01-memory-wall.tex` — Memory wall first principles, five architectural strategies, benchmarking exercise template
- `chapters/02-kernel-optimization.tex` — Roofline model, attention/quantization/MoE kernels, cross-platform pattern matching
- `chapters/03-rollout-generation.tex` — Rollout generation vs serving, prefill/decode split, actor-learner, optimization toolkit
- `chapters/04-policy-gradients.tex` — Modified from old Ch 05: RL loop as consumer, load-bearing choices, ablation skill
- `chapters/05-tinyrl-pipeline.tex` — Pipeline as single system, TinyRL platform, capstone exercise

### Files to modify
- `textbook.tex` — Update `\input{}` lines to reference new chapter filenames
- `Makefile` — No changes needed (wildcards `chapters/[0-9]*.tex` already match)

### Files to archive then delete
- `chapters/old/` — Temporary archive of all 9 old chapter files during transplant
- After all tasks complete: delete `chapters/old/`

---

## Task 0: Archive Old Chapters & Update Build System

**Files:**
- Create: `chapters/old/` (temporary archive directory)
- Modify: `textbook.tex:49-57`

This task sets up the workspace. Old chapters are moved to `chapters/old/` so they remain accessible for content transplant but don't conflict with new filenames. The build system is updated to point at the new chapter files.

- [ ] **Step 1: Create archive directory and move old chapters**

```bash
cd /Users/amiyadiwan/Desktop/Karpathy/rl-at-scale
mkdir -p chapters/old
mv chapters/00-introduction.tex chapters/old/
mv chapters/01-cuda-kernels.tex chapters/old/
mv chapters/02-amd-benchmarking.tex chapters/old/
mv chapters/03-tpu-pallas.tex chapters/old/
mv chapters/04-inference-serving.tex chapters/old/
mv chapters/05-policy-gradients.tex chapters/old/
mv chapters/06-tinyrl-pipeline-scaling.tex chapters/old/
mv chapters/07-distributed-training.tex chapters/old/
mv chapters/08-epilogue.tex chapters/old/
```

- [ ] **Step 2: Create placeholder files for all new chapters**

Create minimal LaTeX files so the build doesn't break while chapters are being written. Each file contains just a section header.

`chapters/00-introduction.tex`:
```latex
\section*{Introduction}
% TODO: Write new introduction per spec Section 3, Chapter 0
```

`chapters/01-memory-wall.tex`:
```latex
\section*{The Memory Wall \& Inference Architectures}
% TODO: Write new chapter per spec Section 3, Chapter 1
```

`chapters/02-kernel-optimization.tex`:
```latex
\section*{Kernel Optimization for Inference}
% TODO: Write new chapter per spec Section 3, Chapter 2
```

`chapters/03-rollout-generation.tex`:
```latex
\section*{Rollout Generation at Scale}
% TODO: Write new chapter per spec Section 3, Chapter 3
```

`chapters/04-policy-gradients.tex`:
```latex
\section*{Policy Gradients}
% TODO: Modify from old Ch 05 per spec Section 3, Chapter 4
```

`chapters/05-tinyrl-pipeline.tex`:
```latex
\section*{The RL Pipeline}
% TODO: Write new chapter per spec Section 3, Chapter 5
```

- [ ] **Step 3: Update textbook.tex to reference new chapter files**

Replace lines 49-57 in `textbook.tex`:

```latex
\input{chapters/00-introduction}
\input{chapters/01-memory-wall}
\input{chapters/02-kernel-optimization}
\input{chapters/03-rollout-generation}
\input{chapters/04-policy-gradients}
\input{chapters/05-tinyrl-pipeline}
```

- [ ] **Step 4: Verify build compiles**

```bash
cd /Users/amiyadiwan/Desktop/Karpathy/rl-at-scale
make textbook
```

Expected: `build/textbook.pdf` generated successfully with 6 placeholder chapters.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "chore: archive old chapters and scaffold new 6-chapter structure

Old chapters moved to chapters/old/ for content transplant reference.
New placeholder files created for the restructured chapter layout.
textbook.tex updated to reference new filenames."
```

---

## Task 1: Chapter 0 — Introduction

**Files:**
- Create: `chapters/00-introduction.tex` (overwrite placeholder)
- Reference: `chapters/old/00-introduction.tex` (for intelligence-per-Watt concept, flywheel TikZ)

**Spec reference:** Section 3, Chapter 0. Four paragraphs, each earning the next.

This chapter is written entirely from scratch. The old introduction's framing (three-tier hierarchy, PE/RE/RS split, methodology section) is replaced. Transplant candidates from old Ch 00: the intelligence-per-Watt definition box concept (reframed as policy improvement per dollar of rollout compute) and the flywheel TikZ diagram concept (adapted to the new thesis).

- [ ] **Step 1: Write the whythis box and opening paragraph (economic urgency)**

The opening must grab attention. Frame frontier lab valuations, related-party investment instability, unit economics as survival. The exact language from the spec:

> "Frontier AI labs are valued at hundreds of billions of dollars on the premise that they will achieve AGI. These valuations are sustained by related-party investment cycles — GPU suppliers, cloud providers, and strategic partners funding each other. This is not a stable equilibrium. When capital markets tighten, the labs that survive are the ones whose unit economics justify their existence independently."

Follow with: responsible AGI development requires fiscal sustainability.

- [ ] **Step 2: Write paragraph 2 (inference as the largest variable cost)**

The obvious case: serving users. Every API call, every conversation, every enterprise deployment. This is revenue. Establish inference cost as the single largest variable cost — this is uncontroversial and earns the reader's trust before the less obvious claim.

- [ ] **Step 3: Write paragraph 3 (the less obvious case — RL training loops are inference)**

The inference/training boundary collapses for RL workloads. RL training loops are dominated by rollout generation, which is itself an inference workload. This is where the hardest optimization problems live — and where skills transfer directly to serving.

- [ ] **Step 4: Write paragraph 4 (therefore — this book's focus)**

Introduce:
- North star metric: policy improvement per dollar of rollout compute (in a definition box, styled like the old intelligence-per-Watt box)
- Convergence thesis: RE/PE overlap, single reader responsible for both perspectives
- Experimental philosophy: test the riskiest assumption at the smallest informative scale (reference TinyStories principle)
- Chapter map: 5 content chapters forming a linear pipeline

- [ ] **Step 5: Write the chapter map section**

Brief description of each chapter and what thinking pattern it teaches. No methodology section — the methodology is the pipeline itself. No prescribed compute budgets.

| Chapter | Thinking Pattern |
|---------|-----------------|
| 1. The Memory Wall | Reason about hardware |
| 2. Kernel Optimization | Optimize the building blocks |
| 3. Rollout Generation | Optimize the system |
| 4. Policy Gradients | Understand the consumer |
| 5. The RL Pipeline | Build the whole thing |

- [ ] **Step 6: Create TikZ diagram — the RL inference/training flywheel**

Adapt the flywheel concept from old Ch 00 (lines 60-73) to the new framing. The cycle should show:
- Faster rollout generation → more rollouts per dollar → better policy gradient estimates → smarter model → model worth more to serve → revenue funds more compute → faster rollout generation

Use the Nippon palette: `aiiro` for the cycle arrows, `beni` for the north star metric annotation.

- [ ] **Step 7: Build and verify**

```bash
make ch=00-introduction
```

Expected: `build/00-introduction.pdf` compiles cleanly, contains the 4-paragraph structure with definition box, chapter map, and flywheel TikZ.

- [ ] **Step 8: Commit**

```bash
git add chapters/00-introduction.tex
git commit -m "feat: write new Ch 0 Introduction

Economic urgency framing, policy improvement per dollar of rollout
compute as north star, RE/PE convergence thesis, smallest informative
scale philosophy, 5-chapter pipeline map."
```

---

## Task 2: Chapter 1 — The Memory Wall & Inference Architectures

**Files:**
- Create: `chapters/01-memory-wall.tex` (overwrite placeholder)
- Reference: `chapters/old/01-cuda-kernels.tex` (memory hierarchy TikZ lines 16-38, roofline concept lines 62-98)
- Reference: `chapters/old/02-amd-benchmarking.tex` (MI300X benchmarking exercise structure, XCD topology TikZ lines 69-100)
- Reference: `chapters/old/03-tpu-pallas.tex` (TPU memory hierarchy TikZ lines 29-45, Ironwood discussion lines 228-245)

**Spec reference:** Section 3, Chapter 1. Three moves: memory wall first principles, five architectural strategies, exercise template.

This chapter is mostly new material informed by the Economist article. Transplant candidates: memory hierarchy TikZ from old Ch 01 (adapt to show SRAM/DRAM/HBM with five strategy intervention points), roofline ridge point concept, and the benchmarking exercise structure from old Ch 02 (generalized from AMD-specific to exercise template).

- [ ] **Step 1: Write the whythis box**

Frame: the memory wall is the single fact that explains the entire inference hardware landscape and why different chips exist. Understanding this lets you evaluate any current or future architecture — including ones that don't exist yet.

- [ ] **Step 2: Write Move 1 — The memory wall as first principles**

Content:
- Gholami et al. finding: compute triples every few years, memory bandwidth improves ~1.6x
- This divergence explains everything
- Prefill: compute-bound (parallel tokenization, high arithmetic intensity)
- Decode: memory-bound (sequential token generation, constant weight fetches from DRAM)
- Every hardware design is a bet on which side of this split to optimize
- MoE as the extreme illustration: massive parameter footprint, sparse activation, maximum memory pressure per FLOP of useful compute

Include a `thinkfirst` box: "Before reading further, consider: if you were designing a chip specifically for autoregressive decoding, what would you change about the memory system? What tradeoffs would you accept?"

- [ ] **Step 3: Create TikZ diagram — memory hierarchy with strategy intervention points**

Adapt the memory hierarchy from old Ch 01 (lines 16-38). Show:
- Registers → SRAM (on-chip) → DRAM/HBM (off-chip) with latency and bandwidth annotations
- The "wall" between SRAM and DRAM clearly marked
- Five strategy arrows showing where each architectural approach intervenes:
  - "More SRAM" → makes the on-chip layer bigger
  - "Smarter data movement" → optimizes traffic across the wall
  - "Flexible compute" → adapts processing to workload
  - "In-memory computing" → collapses memory and compute
  - "Algorithm-specific" → eliminates memory reads entirely

Use Nippon palette: `aiiro` for the memory wall line, `sumi` for hierarchy labels, strategy arrows in `kitsune`/`matcha`/`beni`.

- [ ] **Step 4: Write Move 2 — Five architectural approaches to the memory wall**

For each strategy, write a subsection covering:
1. **More SRAM** (Cerebras WSE-3): eliminate the wall by making on-chip memory enormous. 900K cores, 44GB SRAM. Tradeoff: wafer-scale cost, practical limits for models that don't fit.
2. **Smarter data movement** (Nvidia Groq 3 LPX): software-choreographed access patterns. 500MB SRAM with smart scheduling. Tradeoff: limited by SRAM size, software complexity.
3. **Flexible compute allocation** (MatX splittable systolic arrays): reconfigurable arrays that adapt to prefill vs decode. Tradeoff: design complexity, utilization depends on workload mix.
4. **In-memory computing** (d-Matrix): collapse memory and compute into same substrate. Tradeoff: new manufacturing, limited reprogrammability.
5. **Algorithm-specific hardware** (Etched for transformers, CAS wire-encoded weights): strip everything away, hardwire the architecture. Tradeoff: obsolescence risk — 12-18 month chip cycle vs faster algorithm evolution.

Include a `taste` box: "When you read about a new chip announcement, your first question should be: which of these five strategies is it pursuing? Your second: what does it sacrifice?"

- [ ] **Step 5: Write Move 3 — Exercise template: decision-grade benchmarking on unfamiliar hardware**

Generalize the benchmarking methodology from old Ch 02. The exercise template has these steps (hardware-agnostic):
1. Identify the hardware's theoretical peak compute and memory bandwidth
2. Calculate the roofline ridge point
3. Predict where RL rollout generation (autoregressive decode, batch size 1-64) falls on the roofline
4. Run actual throughput measurements and compare prediction vs reality
5. Compute cost-per-token at measured throughput
6. Produce a one-page decision-grade comparison against a reference platform

Provide two exercise instances:

```
\begin{exercise}[Hardware Benchmarking: AMD MI300X]
Apply the benchmarking template to the AMD MI300X. Hypothesis: MI300X's
5.3 TB/s bandwidth (vs H100's 3.35 TB/s) should yield ~1.58× generation
throughput for memory-bound autoregressive decode. Verify or refute.
\end{exercise}

\begin{exercise}[Hardware Benchmarking: Cerebras Cloud]
Apply the benchmarking template to Cerebras Cloud (cloud.cerebras.ai).
Hypothesis: with 44GB of on-chip SRAM, models that fit entirely in SRAM
should show dramatically lower decode latency. What is the crossover
model size where this advantage disappears?
\end{exercise}
```

Include a `portfolio` box framing the benchmarking report as a publishable artifact.

- [ ] **Step 6: Build and verify**

```bash
make ch=01-memory-wall
```

Expected: `build/01-memory-wall.pdf` compiles cleanly with all three moves, TikZ diagram, exercises, and boxes.

- [ ] **Step 7: Commit**

```bash
git add chapters/01-memory-wall.tex
git commit -m "feat: write new Ch 1 The Memory Wall & Inference Architectures

Memory wall first principles (Gholami et al.), five architectural
strategies organized by approach not vendor, decision-grade benchmarking
exercise template with AMD and Cerebras instances."
```

---

## Task 3: Chapter 2 — Kernel Optimization for Inference

**Files:**
- Create: `chapters/02-kernel-optimization.tex` (overwrite placeholder)
- Reference: `chapters/old/01-cuda-kernels.tex` (roofline TikZ lines 65-98, Boehm progression concept, FP8/FP4 arithmetic intensity lines 111-166, memory hierarchy reasoning line 109)
- Reference: `chapters/old/02-amd-benchmarking.tex` (MI300X roofline lines 106-121, LDS vs shared memory lines 62-66)
- Reference: `chapters/old/03-tpu-pallas.tex` (TPU memory hierarchy TikZ lines 29-45, DMA/MXU pipeline TikZ lines 59-87, VMEM tiling lines 48-54, GPU vs TPU mental model lines 11-23, Pallas kernel progression)
- Reference: `chapters/old/04-inference-serving.tex` (sampling kernels section)

**Spec reference:** Section 3, Chapter 2. Three moves: the two regimes (roofline), critical kernels by bottleneck, cross-platform pattern matching.

Transplant strategy: The roofline model and arithmetic intensity concepts from old Ch 01 and Ch 03 are directly reusable but need reframing around inference-specific kernels rather than training. The cross-platform GPU vs TPU comparison from old Ch 03 lines 11-23 transplants into Move 3. The Boehm progression is narrowed to inference-relevant kernels only.

- [ ] **Step 1: Write the whythis box**

Frame: kernels are the building blocks of rollout generation. The reader who can diagnose whether a kernel is compute-bound or memory-bound — and select the right optimization lever — can improve throughput on any hardware. This skill outlasts any specific kernel library.

- [ ] **Step 2: Write Move 1 — The two regimes (roofline model)**

Teach the roofline model as a diagnostic tool. Transplant the ridge point concept from old Ch 01 (lines 62-98) but generalize:
- Arithmetic intensity = FLOPs / bytes moved
- Ridge point = peak compute / peak bandwidth
- Below ridge: memory-bound (optimize data movement)
- Above ridge: compute-bound (optimize arithmetic)
- Key insight: the same operation can be in different regimes on different hardware (this was explicitly shown in old Ch 01 for H100 vs B200)

Include a `thinkfirst` box: "For autoregressive decode with batch size 1, estimate the arithmetic intensity of a single transformer layer's attention computation. Is it compute-bound or memory-bound on a chip with 1000 TFLOP/s and 3 TB/s bandwidth?"

- [ ] **Step 3: Create TikZ diagram — roofline with inference kernels plotted**

Adapt the roofline TikZ from old Ch 01 (lines 65-98). Plot these inference-specific operations:
- Autoregressive attention (batch=1): far left, deep in memory-bound territory
- Batched attention (batch=64): moving toward ridge
- Prefill attention (long context): near or past ridge, compute-bound
- Quantized decode (INT4): shifts the memory-bound operations right (higher arithmetic intensity per byte)
- MoE forward pass: positioned to show sparse compute utilization

Annotate the diagram showing how quantization and batching shift operations along the x-axis.

- [ ] **Step 4: Write Move 2a — Attention kernels**

Cover:
- Why naive attention materializes O(n²) memory in DRAM
- FlashAttention: fuse QKV and softmax, tile computation to fit in SRAM, never materialize full attention matrix
- Decode vs prefill difference: decode is single-query against growing KV-cache (memory-bound), prefill is full-sequence (compute-bound)
- Paged attention for KV-cache: non-contiguous memory allocation, enables continuous batching (reference vLLM's approach)
- KV-cache quantization: FP8/INT8 reduces cache memory 2-4×, but caution — for RL rollouts, generation quality directly affects reward signal and gradient estimates

Include an `exercise` box: profile FlashAttention decode latency across batch sizes 1, 8, 32, 64. Plot on the roofline. Identify the crossover point where decode transitions from memory-bound to compute-bound.

- [ ] **Step 5: Write Move 2b — Quantized matmuls**

Cover:
- Weight-only quantization (INT8, INT4): halving bits halves bandwidth requirement during memory-bound decode
- Transplant arithmetic intensity table concept from old Ch 01 (lines 111-166): show FP16, FP8, FP4 arithmetic intensities
- The tension: quantization makes rollouts cheaper but noisier. The reader must measure where policy gradient estimates become unreliable — not just where perplexity degrades, because RL amplifies small distributional shifts
- FP4 on Blackwell: transplant from old Ch 01 lines 264-273 (bandwidth arithmetic showing "at batch size 1 with FP4, still memory-bound on B200")

Include a `thinkfirst` box: "If you quantize model weights from FP16 to INT4 and rollout quality degrades by 2% on an eval benchmark, is this acceptable for RL training? What would you need to measure to answer this question?"

- [ ] **Step 6: Write Move 2c — MoE routing and expert kernels**

Cover:
- MoE forward pass: router selects top-k experts per token, only activated experts compute
- Load balancing: if tokens consistently route to the same experts, other experts are idle (wasted SRAM/compute)
- Expert parallelism: distributing experts across devices introduces all-to-all communication
- Sparse dispatch kernels: gathering tokens for each expert, computing, scattering results back
- Why naive implementations leave most compute idle: the combination of sparse activation and routing imbalance

- [ ] **Step 7: Write Move 3 — Cross-platform pattern matching**

Transplant the GPU vs TPU mental model contrast from old Ch 03 (lines 11-23). Reframe as:
- GPU: threads and memory access patterns. Shared memory tiling. Warp-level primitives.
- TPU: pipeline efficiency and keeping the systolic array fed. VMEM prefetching. DMA/compute overlap.
- The mapping: shared memory tiling ↔ VMEM prefetching. Warp-level operations ↔ sublane operations. Thread blocks ↔ tiles.
- Transplant the DMA/MXU pipeline timeline TikZ from old Ch 03 (lines 59-87) to illustrate the overlap concept.

Key message: the optimization *thinking* is identical — diagnose the bottleneck with roofline, optimize data movement, overlap compute and memory access. Only the API changes.

Include an `exercise` box: take one of the attention kernel optimizations from Move 2a and describe how you would implement the same optimization on a TPU using Pallas. Focus on the conceptual mapping, not the syntax.

- [ ] **Step 8: Build and verify**

```bash
make ch=02-kernel-optimization
```

Expected: `build/02-kernel-optimization.pdf` compiles cleanly with roofline TikZ, all three kernel sections, and cross-platform section.

- [ ] **Step 9: Commit**

```bash
git add chapters/02-kernel-optimization.tex
git commit -m "feat: write new Ch 2 Kernel Optimization for Inference

Roofline model as diagnostic tool, attention kernels (FlashAttention,
paged attention, KV-cache), quantized matmuls (INT8/INT4 with RL signal
quality tension), MoE routing kernels, cross-platform GPU/TPU pattern
matching."
```

---

## Task 4: Chapter 3 — Rollout Generation at Scale

**Files:**
- Create: `chapters/03-rollout-generation.tex` (overwrite placeholder)
- Reference: `chapters/old/04-inference-serving.tex` (KV cache management, speculative decoding TikZ, continuous batching TikZ, MoE serving patterns, GRPO batching)
- Reference: `chapters/old/07-distributed-training.tex` (three-phase RLVR pipeline, actor-learner timeline TikZ, straggler problem, synchronization barriers, parallelism strategies for 70B model)

**Spec reference:** Section 3, Chapter 3. Four moves: rollout vs serving distinction, prefill/decode split, scaling across nodes, optimization toolkit.

Transplant strategy: Old Ch 04 has the richest directly transplantable content (KV-cache, speculative decoding, continuous batching, MoE serving — all need reframing from "serving users" to "generating rollouts"). Old Ch 07's three-phase RLVR pipeline and actor-learner patterns transplant into Move 3. The parallelism strategies section (DP, TP, PP, FSDP) from old Ch 07 is cut — it's generic training content outside this book's scope.

- [ ] **Step 1: Write the whythis box**

Frame: rollout generation is where 50-70% of RL training wall time is spent. This chapter is the centerpiece — every optimization here directly reduces the denominator of the north star metric (dollars of rollout compute).

- [ ] **Step 2: Write Move 1 — Why rollout generation is different from serving users**

Cover:
- User-facing serving: optimize latency (TTFT, TPOT) under diverse, unpredictable queries from many users
- RL rollout generation: optimize throughput (total tokens/second/$) under predictable workloads (same model, same policy, batches from training distribution)
- Latency matters less — no human waiting for each token. Throughput is everything.
- This changes every decision: batch sizes can be much larger, scheduling can be more aggressive, hardware allocation can be workload-specific

Include a `thinkfirst` box: "List three specific design decisions in an inference serving system that would change if you knew all queries came from the same model, used the same prompt distribution, and no human was waiting for the response."

- [ ] **Step 3: Write Move 2 — The prefill/decode split as a systems design decision**

Cover:
- Disaggregated serving: run prefill and decode on different hardware or configurations
- Why this is more exploitable for rollout generation: you control the workload, so you can tune the split precisely rather than reacting to unpredictable user traffic
- On-policy freshness constraints: the RL algorithm needs rollouts from the *current* policy. As training proceeds, the policy updates. Rollouts generated from the old policy become stale. This creates deadline pressure that doesn't exist in vanilla serving.
- The tradeoff: you can't batch indefinitely because staleness degrades gradient quality. But too-small batches waste throughput. The reader must find the sweet spot for their specific RL algorithm's freshness tolerance.

- [ ] **Step 4: Write Move 3 — Scaling across nodes (actor-learner architectures)**

Transplant the three-phase RLVR pipeline concept from old Ch 07 (generation → reward evaluation → policy update) and reframe around actor-learner architecture:
- Actors: nodes dedicated to rollout generation (inference)
- Learners: nodes dedicated to policy gradient computation and weight updates (training)
- The ratio question: how many actors per learner? Depends on model size, rollout length, and how quickly the policy changes.
- What happens when actors outpace learners: rollouts queue up and go stale before being consumed. Wasted compute.
- What happens when learners outpace actors: learners starve for data, sit idle. Wasted hardware.
- Pipelining: overlap generation batch N+1 with training on batch N. Transplant the timeline TikZ from old Ch 07 (generation/reward/training across GPUs) and adapt to actor-learner framing.

Create TikZ: actor-learner pipeline timeline showing:
- Actor nodes generating rollouts (colored in `kitsune`)
- Communication phase (colored in `sumi`)
- Learner nodes computing updates (colored in `aiiro`)
- Idle time clearly visible
- Pipelined version showing overlap

- [ ] **Step 5: Write Move 4 — The optimization toolkit**

Transplant and reframe from old Ch 04:

**Continuous batching** (transplant from old Ch 04 batching section):
- Static batching wastes compute when rollouts have variable length (and they always do in RL)
- Continuous batching: as one rollout finishes, a new one enters the batch immediately
- GRPO synchronization: all G completions per prompt must finish before training can start. This creates a synchronization barrier within continuous batching.
- Transplant the static vs continuous batching TikZ from old Ch 04 and reframe for rollout generation.

**Speculative decoding** (transplant from old Ch 04 speculative decoding section):
- Use a small draft model to generate candidate tokens, verify with full model in parallel
- Converts sequential decode into partially parallel work
- Transplant the breakeven analysis: acceptance rate α must exceed c_d/c_t (draft cost / target cost)
- For RL: the draft model can be a previous policy checkpoint — it's naturally similar to the current policy

**KV-cache sharing** (partially new):
- In RL, many rollouts share the same task prompt. Prompt prefixes can share KV-cache entries.
- Prefix caching: compute KV-cache for shared prompt once, reuse across all rollouts for that prompt
- This is a free optimization specific to RL workloads that user-facing serving can't fully exploit

**Quantization at system level** (extend from Ch 2):
- Ch 2 taught the kernel-level tradeoff. Here: measure end-to-end impact.
- Quantize → generate rollouts → compute rewards → compute policy gradients → measure policy improvement
- The question isn't "does perplexity degrade?" but "does policy improvement per dollar improve or degrade?"

**MoE serving at system level** (transplant from old Ch 04 MoE section):
- Expert parallelism across nodes: each node holds a subset of experts
- All-to-all communication for expert routing across nodes
- Load imbalance: rollout diversity means different tokens route to different experts. If the RL training distribution is narrow, some experts are overloaded.

- [ ] **Step 6: Write the tensions section**

Three tensions the reader must balance (single-reader framing, not PE/RE split):

1. **Batch size vs on-policy freshness:** Larger batches amortize memory access cost and improve hardware utilization. But stale rollouts bias gradient estimates. Reason about both the throughput gain and the statistical cost of staleness to find the sweet spot.

2. **Quantization vs signal quality:** Aggressive quantization cuts cost per rollout. But it degrades generation quality. Measure where the policy gradient signal breaks down — RL training amplifies small distributional shifts that eval benchmarks might miss.

3. **Actor/learner ratio:** Simultaneously a capacity planning decision and a sample efficiency decision. Over-provisioning actors wastes compute on rollouts that go stale. Under-provisioning actors starves the training loop.

Include an `exercise` box for each tension: design a small experiment to find the tradeoff boundary for a specific configuration.

- [ ] **Step 7: Build and verify**

```bash
make ch=03-rollout-generation
```

Expected: `build/03-rollout-generation.pdf` compiles cleanly with all four moves, actor-learner TikZ, batching TikZ, and tension exercises.

- [ ] **Step 8: Commit**

```bash
git add chapters/03-rollout-generation.tex
git commit -m "feat: write new Ch 3 Rollout Generation at Scale

Centerpiece chapter. Rollout vs serving distinction, prefill/decode
disaggregation, actor-learner architectures, optimization toolkit
(continuous batching, speculative decoding, KV-cache sharing,
quantization, MoE serving). Three key tensions for the reader to balance."
```

---

## Task 5: Chapter 4 — Policy Gradients

**Files:**
- Create: `chapters/04-policy-gradients.tex` (overwrite placeholder)
- Reference: `chapters/old/05-policy-gradients.tex` (primary source — modify rather than rewrite)

**Spec reference:** Section 3, Chapter 4. Three moves: RL loop as consumer of rollouts, load-bearing algorithmic choices, ablation as experimental skill.

This is the exception chapter — modify old Ch 05 rather than write from scratch. Old Ch 05 is already organized around "levers ordered by cost impact" which aligns with the spec's "load-bearing choices that interact with systems." Main changes: (1) reframe opening from "cost ledger" to "consumer of rollouts" — connecting explicitly to Ch 3, (2) cut content that doesn't interact with systems (preconditioning/optimizer section — SOAP/K-FAC are algorithmic choices with minimal systems interaction), (3) strengthen the ablation methodology section to teach the "smallest informative scale" skill, (4) ensure single-reader framing throughout.

- [ ] **Step 1: Copy old Ch 05 as starting point**

```bash
cp chapters/old/05-policy-gradients.tex chapters/04-policy-gradients.tex
```

- [ ] **Step 2: Rewrite the whythis box**

Replace the existing whythis box with new framing: "You built a rollout generation system (Ch 3). This chapter teaches you what happens to those rollouts — and why understanding the consumer is essential to optimizing the producer. Every algorithmic choice here has a systems consequence: it changes how many rollouts you need, how fresh they must be, and how much each one costs."

- [ ] **Step 3: Rewrite opening section — RL loop as consumer of rollouts**

Replace the "RLVR Cost Ledger" framing. The new opening:
- Policy gradient methods use rollouts to compute weight updates
- The quality, diversity, and freshness of rollouts directly determine whether that update improves the policy or wastes compute
- The reader's job: understand the consumer well enough to make informed producer decisions (batch size, quantization level, actor/learner ratio from Ch 3)
- Keep the cost breakdown statistic (60-80% generation) but frame it as "this is why Ch 3 is the centerpiece, and this chapter explains what the remaining 20-40% does with what Ch 3 produces"

- [ ] **Step 4: Keep and tighten Lever 1 (Rollout Allocation / Clipping)**

Keep the existing content on:
- Clipping (PPO-style): prevents destructively large updates
- The clip-high mechanism causing entropy reduction
- Dead rollouts problem (30% near-zero gradient)

Add explicit connection to Ch 3: "Batch size interacts with clipping — too-small batches produce high-variance advantage estimates that clipping can't save. The batch size you chose in Ch 3 for throughput reasons has a direct algorithmic consequence here."

- [ ] **Step 5: Keep and tighten Lever 2 (KL Penalty / Regularization)**

Keep the existing KL penalty content. Add explicit Ch 3 connection: "KL penalty directly determines how quickly your rollouts go stale. Tight KL means the policy moves slowly per update — rollouts stay on-policy longer, relaxing Ch 3's freshness constraint. Loose KL means the policy changes fast — you need fresher rollouts, which means more generation throughput from Ch 3."

- [ ] **Step 6: Keep Lever 3 (Credit Assignment / GAE)**

Keep the existing credit assignment content. Add: "GAE's lambda parameter controls how far back in the rollout the reward signal propagates. This interacts with rollout length — longer rollouts give GAE more signal but cost more to generate in Ch 3."

- [ ] **Step 7: Cut Lever 4 (Preconditioning / Optimizer)**

Remove the SOAP/K-FAC section. These are algorithmic choices with minimal systems interaction — they don't change rollout generation strategy, batch size decisions, or freshness constraints. Outside this book's scope.

- [ ] **Step 8: Keep and tighten Lever 5 (Collapse Detection / Entropy)**

Keep the entropy collapse content. It's directly relevant — entropy collapse means the model stops exploring, which means rollouts become homogeneous, which means the training signal degrades regardless of how well Ch 3 optimized throughput.

- [ ] **Step 9: Add section — Reward model vs rule-based verification (RLVR)**

New content per spec:
- Different reward sources have different compute profiles
- Learned reward model: adds inference cost per rollout (another model forward pass). This directly increases the cost denominator of the north star metric.
- Rule-based verification: cheap per rollout but constrains the task distribution
- The tradeoff: accuracy of reward signal vs cost of computing it

- [ ] **Step 10: Strengthen ablation methodology section**

Rewrite the measurement section to teach ablation as the core experimental skill:
- How to design an ablation that isolates whether a specific choice is load-bearing
- The "smallest informative scale" applied: what's the minimal experiment that tells you whether clipping matters for your reward landscape?
- Example: to test whether KL penalty is load-bearing, run two TinyRL experiments — one with KL, one without — and measure policy improvement per dollar. If the gap is negligible at small scale, it's likely negligible at large scale (per scaling law assumptions). If the gap is large, KL is load-bearing and the specific coefficient matters.

Include an `exercise` box: design a $20 ablation experiment for each of the four remaining levers. State your hypothesis, your informative scale, and what result would change your Ch 3 configuration.

- [ ] **Step 11: Remove PE/RE split language if any remains**

Search for any "PE" or "RE" role-specific framing and replace with single-reader framing.

- [ ] **Step 12: Build and verify**

```bash
make ch=04-policy-gradients
```

Expected: `build/04-policy-gradients.pdf` compiles cleanly with reframed content.

- [ ] **Step 13: Commit**

```bash
git add chapters/04-policy-gradients.tex
git commit -m "feat: reframe Ch 4 Policy Gradients as consumer of rollouts

Reframed from cost ledger to consumer-of-rollouts perspective. Cut
preconditioning section (no systems interaction). Added explicit
connections to Ch 3 tradeoffs, RLVR reward source comparison, and
ablation-as-experimental-skill methodology."
```

---

## Task 6: Chapter 5 — The RL Pipeline (TinyRL)

**Files:**
- Create: `chapters/05-tinyrl-pipeline.tex` (overwrite placeholder)
- Reference: `chapters/old/06-tinyrl-pipeline-scaling.tex` (TinyRL design principles, environment architecture, TinyRL-Code/Align/Quant environments, verification hacking discussion)

**Spec reference:** Section 3, Chapter 5. Three moves: pipeline as single system, TinyRL as experimental platform, capstone exercise.

Transplant strategy: Old Ch 06 has excellent TinyRL environment designs (Code, Align, Quant) and the verification hacking discussion — these transplant directly. The framing needs to shift from "community OSS framework" to "capstone that integrates all chapters." The TinyStories design principles section transplants with minor reframing. New content: the pipeline-as-single-system walkthrough and the capstone optimization exercise.

- [ ] **Step 1: Write the whythis box**

Frame: this chapter is where everything composes. The reader has learned to reason about hardware (Ch 1), optimize kernels (Ch 2), build a rollout generation system (Ch 3), and understand what the RL algorithm demands (Ch 4). Now they see how changing one parameter ripples through the entire system — and they build the capstone artifact that demonstrates this integrated thinking.

- [ ] **Step 2: Write Move 1 — The pipeline as a single system**

New content. Walk through the complete RL training loop as a data flow:
1. **Prompt sampling:** select prompts from training distribution
2. **Rollout generation:** actors generate completions (Ch 3's optimization target)
3. **Reward computation:** score each rollout (Ch 4's RLVR discussion)
4. **Advantage estimation:** compute per-rollout advantages (Ch 4's GAE/normalization)
5. **Policy update:** compute gradients and update weights (Ch 4's clipping, KL)
6. **Repeat:** new policy → new rollouts → next iteration

Key point: these stages aren't independent. Batch size in step 2 affects advantage variance in step 4. Quantization in step 2 affects reward signal quality in step 3. Actor/learner ratio determines how steps 2 and 5 overlap. The reader must see the full loop to make informed local decisions.

- [ ] **Step 3: Create TikZ diagram — full pipeline data flow**

The one diagram that ties the whole book together. Show:
- Prompt buffer → Actor nodes (rollout generation) → Reward computation → Advantage estimation → Learner node (policy update) → weight sync back to actors
- Annotate each stage with which chapter's optimizations apply:
  - Actors: "Ch 2 kernels, Ch 3 batching/scheduling"
  - Reward: "Ch 4 RLVR vs reward model"
  - Advantage: "Ch 4 GAE, normalization"
  - Learner: "Ch 4 clipping, KL"
  - Weight sync: "Ch 3 actor-learner pipelining"
- Show the feedback loop explicitly

Use Nippon palette: actors in `kitsune`, reward in `matcha`, learner in `aiiro`, arrows in `sumi`.

- [ ] **Step 4: Write Move 2 — TinyRL as the experimental platform**

Transplant the design principles from old Ch 06:
- Controlled data distribution (TinyStories principle)
- Tasks learnable by small models (GPT-2 scale, <10M parameters)
- Clean evaluation / deterministic verification
- Phenomena observable at small scale

Transplant the three environments from old Ch 06:

**TinyRL-Code** ("The MNIST of RLVR"):
- 50-100 curated programming puzzles
- Deterministic verification via unit tests
- Exploits to watch for: hardcoded outputs, format gaming, specification ambiguity
- Transplant the Reward Hacking Gallery concept

**TinyRL-Align** ("The RLHF Baseline"):
- Sentiment classifier on IMDB reviews
- Demonstrates reward hacking on proxy neural rewards
- Mode collapse and entropy collapse dynamics

**TinyRL-Quant** ("The PE-RL Flywheel"):
- Precision selection reward: accuracy × (1/avg_bits)
- The RL agent learns to quantize its own layers — Ch 2's quantization tension made concrete

Reframe all three as experimental platforms for testing Ch 3 and Ch 4 decisions, not as standalone frameworks.

- [ ] **Step 5: Write Move 3 — The capstone exercise**

New content. This is the portfolio artifact.

```
\begin{portfolio}[End-to-End RL Pipeline Optimization]
Given a baseline TinyRL-Code configuration and a fixed compute budget
(you choose the amount):

1. Profile the baseline: where is wall time spent? (generation? reward?
   training? communication?)
2. Identify the bottleneck using Ch 1 and Ch 2 reasoning (is it
   compute-bound or memory-bound? which kernel?)
3. Hypothesize an intervention from Ch 3 (batch size? quantization?
   speculative decoding?) or Ch 4 (clipping? KL? GAE lambda?)
4. Predict the effect on policy improvement per dollar before running
   the experiment
5. Run the experiment at the smallest informative scale
6. Measure: did policy improvement per dollar go up or down?
7. Iterate: what's the next bottleneck?

Deliverable: a documented optimization case study showing your reasoning
chain, experiments run, predictions vs results, and final
throughput/quality tradeoff. This is publishable as a blog post or
technical report.
\end{portfolio}
```

Include a `taste` box: "The difference between a good engineer and a great one is the ability to predict which intervention will have the largest effect *before* running the experiment. This exercise tests that skill directly."

- [ ] **Step 6: Build and verify**

```bash
make ch=05-tinyrl-pipeline
```

Expected: `build/05-tinyrl-pipeline.pdf` compiles cleanly with pipeline TikZ, three environments, and capstone exercise.

- [ ] **Step 7: Commit**

```bash
git add chapters/05-tinyrl-pipeline.tex
git commit -m "feat: write new Ch 5 The RL Pipeline (TinyRL)

Capstone chapter. Full pipeline data flow with chapter cross-references,
TinyRL environments (Code, Align, Quant) as experimental platform,
end-to-end optimization exercise as portfolio artifact."
```

---

## Task 7: Full Build Verification & Cleanup

**Files:**
- Verify: `textbook.tex` (full book build)
- Delete: `chapters/old/` (archive no longer needed)

- [ ] **Step 1: Build full textbook**

```bash
cd /Users/amiyadiwan/Desktop/Karpathy/rl-at-scale
make clean
make textbook
```

Expected: `build/textbook.pdf` compiles cleanly with all 6 chapters, table of contents reflects new structure.

- [ ] **Step 2: Verify table of contents**

Open `build/textbook.pdf` and verify:
- 6 chapters listed (Introduction through The RL Pipeline)
- No references to old chapter names
- Page numbers are correct

- [ ] **Step 3: Build each chapter standalone**

```bash
make all-chapters
```

Expected: 6 individual PDFs in `build/`, all compile cleanly.

- [ ] **Step 4: Delete old chapter archive**

```bash
rm -rf chapters/old/
```

- [ ] **Step 5: Final commit**

```bash
git add -A
git commit -m "chore: remove old chapter archive, verify full build

All 6 new chapters compile individually and as full textbook.
Old chapter archive removed — content has been transplanted."
```

---

## Task 8: Update Existing Plan References

**Files:**
- Modify: `docs/superpowers/plans/2026-04-05-crispy-rewrite-all-chapters.md`

- [ ] **Step 1: Add deprecation notice to old crispy-rewrite plan**

The old crispy-rewrite plan references the 9-chapter structure which no longer exists. Add a notice at the top:

```markdown
> **DEPRECATED:** This plan references the old 9-chapter structure. The textbook
> has been restructured to 6 chapters per `docs/superpowers/specs/2026-04-07-textbook-restructure-design.md`.
> A new crispy-rewrite plan should be created for the new chapter structure.
```

- [ ] **Step 2: Commit**

```bash
git add docs/superpowers/plans/2026-04-05-crispy-rewrite-all-chapters.md
git commit -m "docs: deprecate old crispy-rewrite plan

Old plan references 9-chapter structure that no longer exists.
New crispy-rewrite plan needed for 6-chapter structure."
```
