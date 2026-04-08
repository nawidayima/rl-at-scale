# RL at Scale: Textbook Restructure Design

**Date:** 2026-04-07
**Author:** Amiya Diwan (with Claude)
**Status:** Design approved, pending implementation plan

---

## 1. Economic Imperative & Thesis

### The Opening Frame

Frontier AI labs are valued at hundreds of billions of dollars on the premise that they will achieve AGI. These valuations are sustained by related-party investment cycles -- GPU suppliers, cloud providers, and strategic partners funding each other. This is not a stable equilibrium. When capital markets tighten, the labs that survive are the ones whose unit economics justify their existence independently.

Responsible AGI development requires fiscal sustainability. The single largest variable cost is inference compute. Optimizing it is not an engineering problem. It is a survival problem.

### Why RL Specifically

Inference matters for two reasons:

1. **Serving users** -- the obvious cost center. Every API call, every conversation, every enterprise deployment. This is where revenue comes from.
2. **RL training** -- the less obvious but equally critical cost center. RL is how a pretrained base model becomes a product worth serving. The RL training loop is dominated by rollout generation, which is itself an inference workload.

The inference/training boundary collapses for RL workloads. Optimizing inference for RL rollout generation is simultaneously a serving problem and a training problem. This is where the hardest, least-understood optimization challenges live -- and where skills have the most leverage. Everything the reader learns transfers directly to user-facing serving.

### Scope

Long-running RL processes for frontier model capability improvement. This is the proven path to smarter, more capable models.

### North Star Metric

**Policy improvement per dollar of rollout compute.**

- Driven on the systems side by making rollouts cheaper (tokens/second/dollar)
- Driven on the algorithmic side by making rollouts more useful (better reward signals, smarter exploration, tighter on-policy requirements)
- Measurable at every scale -- from a $50 TinyRL experiment to a multi-GW cluster
- Forces the reader to balance systems throughput against algorithmic signal quality, because optimizing one at the expense of the other moves the metric in the wrong direction

---

## 2. Book Philosophy

### Practical, Not Academic

Research taste is driven by time and dollar constraints. The reader learns to:

- **Test the riskiest assumption at the smallest informative scale.** "Informative" means the experimental setup preserves the phenomenon under study. The TinyStories principle: a 28M-parameter model can exhibit emergence behaviors normally requiring 1.5B+ parameters -- not because small models are secretly powerful, but because the dataset was designed so that small scale is informative about the phenomenon being investigated. The same principle applies to RL experiments: design the setup so that small scale preserves the pipeline dynamics you care about (rollout generation bottleneck, on-policy freshness pressure, reward signal quality).
- **Recognize when small scale is NOT informative** for a specific question, and know what the smallest informative scale actually is.
- **Design experiments that distinguish "promising, worth scaling up" from "dead on arrival"** before committing large compute budgets.

The book does not prescribe a compute budget. Different readers have different ceilings (frontier lab employees, PhD students with modest stipends, self-funded individuals). The skill is finding the smallest informative scale for your specific question -- that skill is the same regardless of budget.

### Multidisciplinary Convergence

The book targets the overlap between Research Engineering and Production Engineering on an RL team. These roles are converging:

- Research-minded readers learn to think about engineering realities (memory walls, kernel bottlenecks, systems throughput)
- Engineering-minded readers learn to understand the math behind the algorithms they deploy and optimize (policy gradients, advantage estimation, clipping, KL constraints)

The reader is responsible for holding both perspectives simultaneously. Every systems decision has an algorithmic consequence. Every algorithmic choice has a systems cost. No handoff to another team.

### Timeless Patterns

The book teaches patterns of thinking that preserve their value when the technology landscape changes:

- How to reason about hardware architecture tradeoffs (not "how Nvidia's B200 works")
- How to classify inference bottlenecks and select the right optimization lever (not "use FlashAttention v3")
- How to design informative small-scale experiments (not "run this specific benchmark")
- How to stand up a decision-grade benchmark on unfamiliar hardware (not "benchmark AMD MI300X")

Technology-specific examples are instances of these patterns, not the subject matter.

### Pedagogy

- Active hands-on problem solving -- not rote learning or tutorials
- Every chapter produces a portfolio-worthy artifact demonstrating the thinking pattern, not just the technical outcome
- TikZ visuals and diagrams only where they reduce cognitive load -- spatial relationships, temporal sequences, architecture comparisons. Never as decoration.
- Writing follows crispy-rewrite principles: no filler, quantify or cut, direct and assertive tone

---

## 3. Chapter Structure

Six chapters, linear pipeline. Each chapter teaches a thinking pattern and produces a deliverable.

### Chapter 0: Introduction

**Purpose:** Frame the economic urgency, establish the thesis, and set the book's philosophy.

**Structure (4 paragraphs, each earning the next):**

1. **Economic urgency.** Frontier lab valuations, related-party investment instability, unit economics as survival. Responsible AGI development requires fiscal sustainability. Attention-grabbing, creates urgency.
2. **Inference as the largest variable cost.** The obvious case: serving users. Establish as given.
3. **The less obvious case.** RL training loops are also inference workloads. The inference/training boundary collapses. This is where the hardest optimization problems live.
4. **Therefore.** This book focuses on the RL side. Introduce the north star metric (policy improvement per dollar of rollout compute). Introduce the convergence thesis (RE/PE overlap). Introduce the experimental philosophy (smallest informative scale). Chapter map.

**Does NOT include:**
- Three separate role definitions (PE/RE/RS) -- only the convergence of two
- Metaphors that need decoding
- A separate methodology section -- the methodology is the pipeline itself
- Prescribed compute budgets

---

### Chapter 1: The Memory Wall & Inference Architectures

**Purpose:** Teach the reader to reason about why inference hardware is designed the way it is, so they can evaluate any current or future architecture.

**Move 1 -- The memory wall as first principles.**
Compute performance has roughly tripled every few years; off-chip memory bandwidth has improved by a factor of ~1.6x (Gholami et al.). This divergence explains the entire inference hardware landscape. Prefill is compute-bound (parallel tokenization). Decode is memory-bound (sequential token generation, constant weight fetches). Every hardware design is a bet on which side of this split to optimize. MoE as the extreme illustration: massive parameter footprint, sparse activation, maximum memory pressure per FLOP of useful compute.

**Move 2 -- Five architectural approaches to the memory wall.**
Not vendors -- strategies:

| Strategy | Approach | Tradeoff | Current example |
|---|---|---|---|
| More SRAM | Eliminate the wall by making on-chip memory enormous | Wafer-scale cost, practical limits for very large models | Cerebras WSE-3 |
| Smarter data movement | Software-choreographed access patterns on existing hardware | Depends on software sophistication, limited by SRAM size | Nvidia Groq 3 LPX |
| Flexible compute allocation | Reconfigurable arrays that adapt to prefill vs decode | Design complexity, utilization depends on workload mix | MatX splittable systolic arrays |
| In-memory computing | Collapse memory and compute into same substrate | New manufacturing, limited reprogrammability | d-Matrix |
| Algorithm-specific hardware | Strip everything away, hardwire the model architecture | Obsolescence risk: 12-18 month chip cycle vs faster algorithm evolution | Etched (transformers), CAS wire-encoded weights |

For each: what it optimizes, what it sacrifices, under what conditions it wins. The reader finishes able to classify the next chip announcement they read about.

**Move 3 -- Exercise template: decision-grade benchmarking on unfamiliar hardware.**
The repeatable skill: given a new chip or platform, stand up a rollout throughput benchmark and produce a cost-per-token comparison. AMD MI300X as the first instance. Cerebras Cloud as a second. The exercise is identical; the substrate changes. This is the portfolio artifact (Sholto-endorsed).

**Key TikZ visual:** Memory hierarchy diagram showing SRAM/DRAM/HBM access latency and bandwidth gaps, with the five strategies mapped to where they intervene.

**Does NOT cover:** Kernel writing (Ch 2), serving system configuration (Ch 3), vendor product recommendations.

---

### Chapter 2: Kernel Optimization for Inference

**Purpose:** Teach the reader to optimize the building blocks that determine rollout generation speed -- organized by bottleneck type, not hardware vendor.

**Move 1 -- The two regimes.**
Every inference kernel is either compute-bound or memory-bound. The roofline model as diagnostic tool: plot arithmetic intensity against hardware's compute/bandwidth ratio. You immediately know which regime you're in and what optimization lever matters. Teach once, apply to every kernel in the chapter.

**Move 2 -- The critical kernels, organized by bottleneck:**

- **Attention kernels.** FlashAttention and variants. Why fusing QKV and softmax avoids materializing the full attention matrix in DRAM. How this differs for decode (single query against growing KV-cache) vs prefill (full sequence, embarrassingly parallel). Paged attention for KV-cache memory management.
- **Quantized matmuls.** INT8/INT4 weight-only quantization. Directly attacks the memory wall during decode (half the bits = half the bandwidth). The tension the reader must balance: aggressive quantization makes rollouts cheaper but noisier -- you need to measure where policy gradient estimates become unreliable, not just where perplexity degrades.
- **MoE routing and expert kernels.** Load balancing, expert parallelism, sparse dispatch. Why naive implementations leave most compute idle.

**Move 3 -- Cross-platform pattern matching.**
GPU (CUDA) and TPU (Pallas/XLA) as two instances of the same optimization principles. Shared memory tiling <-> VMEM prefetching. Warp-level operations <-> sublane operations. The thinking transfers even when the API is completely different. This is the timeless skill.

**Key TikZ visual:** Roofline diagram with critical kernels plotted, showing compute-bound vs memory-bound regimes and how optimizations (quantization, fusion) shift a kernel's position.

**Does NOT cover:** Training kernels (backward pass), full kernel tutorials from scratch, hardware procurement (Ch 1).

---

### Chapter 3: Rollout Generation at Scale

**Purpose:** The centerpiece. Optimize the system that generates rollouts for the RL training loop.

**Move 1 -- Why rollout generation is different from serving users.**
User-facing serving optimizes for latency under diverse queries. RL rollout generation optimizes for throughput under predictable workloads (same model, same policy, batches from training distribution). Latency matters less. Throughput is everything. This changes every design decision.

**Move 2 -- The prefill/decode split as a systems design decision.**
Disaggregated serving: prefill and decode on different hardware or configurations. More exploitable for rollout generation because you control the workload. On-policy freshness constraints create deadline pressure that doesn't exist in vanilla serving -- you can't batch indefinitely because the RL algorithm needs rollouts from the current policy.

**Move 3 -- Scaling across nodes.**
Actor-learner architectures. Actors generate rollouts, learners consume them for policy updates. How many actors per learner? How to pipeline generation and training to minimize idle time. What happens when actors outpace learners (rollouts go stale) vs learners outpace actors (learners starve). Framed entirely around the RL pipeline.

**Move 4 -- The optimization toolkit, applied:**

- Continuous batching for rollout requests
- Speculative decoding to convert sequential decode into partially parallel work
- KV-cache sharing across rollouts that share prompt prefixes (common in RL)
- Quantization tradeoffs at the system level: Ch 2 taught the kernel tradeoff, here measure end-to-end impact on rollout quality and policy improvement rate
- MoE serving at system level: expert parallelism across nodes, load imbalance from rollout diversity

**Tensions the reader must balance:**

- **Batch size vs on-policy freshness.** Larger batches amortize memory access cost, but stale rollouts bias gradient estimates. Reason about both the systems throughput gain and the statistical cost of staleness.
- **Quantization vs signal quality.** Aggressive quantization cuts cost per rollout but degrades generation quality. Measure where policy gradient signal breaks down -- RL training amplifies small distributional shifts that eval benchmarks miss.
- **Actor/learner ratio.** Simultaneously a capacity planning decision and a sample efficiency decision. Over-provisioning actors wastes compute. Under-provisioning starves training. The right ratio depends on model size, rollout length, and policy change rate.

**Key TikZ visual:** Actor-learner pipeline timeline showing generation, communication, and training phases, where idle time lives, and how pipelining overlaps them.

**Does NOT cover:** User-facing serving optimization (principles transfer, but not the focus), hardware architecture (Ch 1), kernel internals (Ch 2).

---

### Chapter 4: Policy Gradients

**Purpose:** Teach the reader what the RL training loop demands from the rollout generation system, so they can make informed tradeoffs in Ch 3's decisions.

**Move 1 -- The RL training loop as the consumer of rollouts.**
The reader built a rollout generation system (Ch 3). What happens to those rollouts? Policy gradient methods compute a weight update. The quality, diversity, and freshness of rollouts directly determine whether that update improves the policy or wastes compute. Understand the consumer to optimize the producer.

**Move 2 -- Which algorithmic choices are load-bearing, and why.**
Not a textbook survey. Hypothesis-driven depth on decisions that interact with systems:

- **Clipping (PPO-style).** Prevents destructively large updates. Interacts with batch size -- too-small batches produce high-variance advantage estimates that clipping can't save.
- **GAE (Generalized Advantage Estimation).** Lambda controls bias-variance tradeoff in reward attribution. Interacts with rollout length -- longer rollouts give GAE more signal but cost more to generate.
- **KL penalty / reference policy divergence.** Constrains how far the policy moves per update. Directly determines how quickly rollouts go stale -- tight KL means rollouts stay on-policy longer (relaxes Ch 3's freshness constraint), loose KL means you need fresher rollouts (more generation throughput).
- **Reward model vs rule-based verification (RLVR).** Different reward sources have different compute profiles. Learned reward model adds inference cost per rollout. Rule-based verification is cheap but constrains task distribution.

**Move 3 -- Ablation as the core experimental skill.**
How to design ablations that isolate whether a specific algorithmic choice is load-bearing for your setup. This is where "smallest informative scale" becomes concrete. The reader should leave able to design a cheap experiment that answers a specific algorithmic question before committing to an expensive training run.

**Does NOT cover:** RL theory from first principles, reward model training, full PPO/GRPO derivations (only parts with systems implications).

---

### Chapter 5: The RL Pipeline (TinyRL)

**Purpose:** Close the loop. Compose all previous chapters into a working end-to-end pipeline. Produce the capstone portfolio artifact.

**Move 1 -- The pipeline as a single system.**
Walk through the complete RL training loop: prompt sampling -> rollout generation -> reward computation -> advantage estimation -> policy update -> next iteration. Show where each previous chapter's content plugs in. The reader sees that Ch 2 (kernel choice), Ch 3 (batching, actor/learner ratio), and Ch 4 (clipping, GAE, KL) decisions compose into a system where changing one parameter ripples through the others.

**Move 2 -- TinyRL as the experimental platform.**
A minimal, open-source RL training framework designed around the TinyStories principle: small enough to run on a modest budget, but preserving the essential pipeline dynamics (rollout generation bottleneck, on-policy freshness pressure, reward signal quality). The reader uses TinyRL to run Ch 4's ablations, measure Ch 3's throughput optimizations, and observe how algorithmic and systems choices interact in practice. Hands-on, not descriptive.

**Move 3 -- The capstone exercise: end-to-end optimization.**
Given a baseline TinyRL configuration and a fixed compute budget: maximize policy improvement within that budget. This requires reasoning across every chapter. Is the bottleneck in the kernels? The batch size? The algorithm? The actor/learner ratio? The reader profiles, hypothesizes, intervenes, and measures. The result is a publishable artifact: a documented optimization case study showing the reasoning chain, experiments run, and final throughput/quality tradeoff achieved.

**Key TikZ visual:** Full pipeline data flow diagram -- prompt buffer -> actors -> reward computation -> advantage estimation -> learner -> back to actors. Annotated with where each chapter's optimizations apply and where bottlenecks live. The one diagram that ties the whole book together.

**Does NOT cover:** Production-grade framework engineering, scaling to thousands of nodes, novel RL algorithms.

---

## 4. What Was Removed & Why

| Old chapter | Disposition | Reason |
|---|---|---|
| Ch 02: AMD MI300X Benchmarking | Demoted to exercise instance in Ch 1 | Hardware procurement is a different job; the transferable skill is decision-grade benchmarking on unfamiliar hardware |
| Ch 03: TPU/Pallas (standalone) | Merged into Ch 2 as cross-platform pattern matching | Organizing by vendor is not timeless; organizing by bottleneck type is |
| Ch 07: Distributed Training (standalone) | Absorbed into Ch 3 (Rollout Generation at Scale) | Generic allreduce/pipeline parallelism is not the book's scope; distributed rollout generation is |
| Ch 08: Epilogue | Removed | Stub with no content; the capstone in Ch 5 serves as the conclusion |

---

## 5. Recurring Threads (Not Chapters)

These concepts appear across multiple chapters rather than occupying their own:

- **MoE:** Ch 1 (extreme memory wall illustration), Ch 2 (routing/expert kernels), Ch 3 (system-level expert parallelism and load imbalance)
- **Quantization:** Ch 2 (kernel-level INT8/INT4), Ch 3 (system-level impact on rollout quality and policy improvement)
- **Speculative decoding:** Ch 2 (kernel mechanism), Ch 3 (system-level throughput impact for rollout generation)
- **KV-cache management:** Ch 2 (paged attention kernels), Ch 3 (prefix sharing across rollouts, cache eviction under memory pressure)

---

## 6. Mapping Old Content to New Structure

| New chapter | Sources from old chapters |
|---|---|
| Ch 0: Introduction | Old Ch 00 (rewritten), new material |
| Ch 1: Memory Wall & Inference Architectures | New material (Economist article insights), old Ch 02 exercise content |
| Ch 2: Kernel Optimization for Inference | Old Ch 01 (CUDA, narrowed to inference), old Ch 03 (TPU/Pallas), new quantization/MoE content |
| Ch 3: Rollout Generation at Scale | Old Ch 04 (reframed from serving to RL rollouts), old Ch 07 (distributed, RL-specific parts only) |
| Ch 4: Policy Gradients | Old Ch 05 (kept, tightened to systems-relevant algorithmic choices) |
| Ch 5: The RL Pipeline (TinyRL) | Old Ch 06 (reframed as capstone integrating all chapters) |

---

## 7. Key Design Decisions

1. **Linear pipeline structure (Approach A).** Chapters read sequentially. Each assumes the previous. Simplest to write, maintain, and navigate. The convergence point (Ch 3) naturally pulls both RE and PE perspectives together.

2. **Organized by bottleneck, not vendor.** Hardware chapters organized by compute-bound vs memory-bound, not by GPU vs TPU vs ASIC. Kernel chapter organized by attention/quantization/MoE, not by CUDA vs Pallas. Cross-platform pattern matching taught explicitly.

3. **Five architectural strategies, not five vendor reviews.** The memory wall section teaches strategies (more SRAM, smarter data movement, flexible compute, in-memory computing, algorithm-specific hardware) with vendors as illustrative instances.

4. **Benchmarking as a repeatable exercise template.** AMD MI300X, Cerebras, and future hardware are instances of the same exercise: stand up a rollout throughput benchmark on unfamiliar hardware, produce cost-per-token comparison.

5. **MoE as a thread, not a chapter.** Appears in Ch 1 (memory wall illustration), Ch 2 (kernels), Ch 3 (system-level serving). Woven through the narrative rather than isolated.

6. **Single-reader framing.** No "PE wants X, RE wants Y." The reader is responsible for balancing systems throughput against algorithmic signal quality. Every tension is presented as a tradeoff the reader must reason about from both sides.

7. **TinyStories principle for experimental design.** The book does not prescribe compute budgets. It teaches the reader to find the smallest scale where their specific question is informative -- preserving the phenomenon under study while stripping away confounding complexity.
