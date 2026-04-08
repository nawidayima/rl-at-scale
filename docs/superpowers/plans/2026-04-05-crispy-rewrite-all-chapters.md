> **DEPRECATED:** This plan references the old 9-chapter structure. The textbook
> has been restructured to 6 chapters per `docs/superpowers/specs/2026-04-07-textbook-restructure-design.md`.
> A new crispy-rewrite plan should be created for the new chapter structure.

# Crispy-Rewrite All Chapters Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Run crispy-rewrite on each chapter of `rl-at-scale/`, tightening prose and adding TikZ visualizations only where they genuinely enhance readability.

**Architecture:** Each chapter is an independent rewrite task. Tasks are ordered by chapter number but can be executed in any order. Each task follows the crispy-rewrite pipeline: diagnose specific issues, execute targeted rewrites, add TikZ where justified, verify compilation. Chapter 08 (epilogue) is a stub and is skipped.

**Tech Stack:** LaTeX, TikZ (with `positioning` and `arrows.meta` libraries already loaded in `preamble.tex`), tectonic build system.

**Build command:** `cd rl-at-scale && tectonic textbook.tex -o build`
**Single chapter:** `cd rl-at-scale && tectonic standalone.tex -Z shell-escape --texinput "\def\chapterfile{chapters/XX-name}" -o build && mv build/standalone.pdf build/XX-name.pdf`

---

## Global Crispy-Rewrite Calibration

**Audience:** AI/ML engineers with strong CS fundamentals preparing for research engineering roles at frontier labs. They know Python, linear algebra, and basic ML. They may not know GPU architecture, TPU internals, or RL theory deeply.

**Success test:** A reader can scan any section heading + first sentence and know whether to read that section. Dense prose walls are broken by diagrams where spatial/temporal relationships are the content. No diagram exists purely for decoration.

**TikZ policy:** Add a TikZ diagram ONLY when:
1. The content describes a spatial relationship (memory hierarchy, network topology, data flow)
2. The content describes a temporal sequence (pipeline phases, protocol steps)
3. The content compares two architectures where visual juxtaposition clarifies differences
4. A table or enumerated list is struggling to convey structure that is inherently visual

Do NOT add TikZ for:
- Content that is already clear in prose (equations, definitions)
- Simple lists or enumerations
- Decoration or visual variety

**Prose principles (from crispy-rewrite):**
- Every word earns its place. "It is important to note that X" → "X"
- Quantify or cut. "Significantly improved" → the number
- Preserve technical qualifiers that bound claims. "Usually" stays if it's a valid bound
- Preserve the author's voice (direct, assertive, metric-driven)
- Rigid elements (math environments, code blocks, tables, tcolorbox environments) are tokenized as placeholders during structural edits, re-injected after

---

## Task 0: Preamble — Add TikZ Libraries

**Files:**
- Modify: `preamble.tex:17-18`

The current preamble loads `positioning` and `arrows.meta`. Several diagrams in the plan need additional TikZ libraries.

- [ ] **Step 1: Check which libraries are needed**

Review all planned TikZ diagrams below. Libraries needed beyond what's loaded:
- `calc` — for coordinate arithmetic in timeline diagrams
- `patterns` — for hatched fill patterns (waste/bubble regions)
- `fit` — for bounding boxes around node groups
- `decorations.pathreplacing` — for curly braces annotations

- [ ] **Step 2: Add libraries to preamble**

In `preamble.tex`, change:

```latex
\usetikzlibrary{positioning, arrows.meta}
```

to:

```latex
\usetikzlibrary{positioning, arrows.meta, calc, patterns, fit, decorations.pathreplacing}
```

- [ ] **Step 3: Verify build**

Run: `cd rl-at-scale && tectonic textbook.tex -o build`
Expected: Successful compilation with no errors.

- [ ] **Step 4: Commit**

```bash
git add preamble.tex
git commit -m "chore: add TikZ libraries for chapter diagrams"
```

---

## Task 1: Chapter 00 — Introduction

**Files:**
- Modify: `chapters/00-introduction.tex`

### Diagnosis

**Intervention level:** Conservative trim. The chapter is already well-structured with two good TikZ diagrams.

**Issues identified:**
1. **Paragraph 1 (lines 3-5):** Dense wall of numbers. The opening buries the thesis ("Every wasted FLOP has a dollar cost") behind spending figures.
2. **Chapter Map (lines 81-95):** Each item has an italicized aside that describes the deliverable — good. But the descriptions mix "what you learn" with "what you produce." Tighten to lead with the deliverable.
3. **"By goal" list (lines 118-124):** Good parallel structure. No changes needed.
4. **No TikZ additions needed.** The two existing diagrams (tier hierarchy, PE-RL flywheel) are well-placed and sufficient.

### Rewrite spec

- Tighten opening paragraph: lead with the thesis, move spending numbers to support
- Trim chapter map descriptions to consistent format: deliverable first, context second
- Minor prose polish throughout (remove "is designed so that," etc.)

- [ ] **Step 1: Tighten opening paragraph**

Lines 3-5, change:

```latex
Frontier labs are deploying compute at unprecedented scale. Anthropic is scaling from approximately 2.5~GW to over 5~GW by year-end, at roughly \$10--13B per year in rental cost per gigawatt. The Big Four hyperscalers are spending a combined \$600B in CapEx this year. Every wasted FLOP has a dollar cost that compounds at datacenter scale.
```

to:

```latex
Every wasted FLOP has a dollar cost that compounds at datacenter scale. Anthropic is scaling from 2.5~GW to over 5~GW by year-end at \$10--13B/GW/year; the Big Four hyperscalers are spending a combined \$600B in CapEx this year. The problems are coupled: generation throughput gates RL rollouts, algorithm choice determines whether those rollouts produce signal, and the unit economics---cost per useful training step, hardware utilization, the 5--6 year payback per GW deployed---determine whether a research direction is financially viable.
```

This eliminates the vague opener "Frontier labs are deploying compute at unprecedented scale" and leads with the thesis.

- [ ] **Step 2: Tighten the coupling paragraph**

Lines 5-7, the original coupling paragraph is now redundant (merged into opening). Remove:

```latex
The problems are coupled. The generation bottleneck gates how many rollouts RL can run. The algorithm choice determines whether those rollouts produce signal. And the unit economics --- cost per useful training step, hardware utilization rates, the 5--6 year payback period on each GW deployed --- determine whether a research direction is financially viable. Anthropic's RL infrastructure spans performance engineering, research engineering, and research science. Understanding across these boundaries makes you better at any one of them.
```

Replace with:

```latex
Anthropic's RL infrastructure spans performance engineering, research engineering, and research science. Understanding across these boundaries makes you better at any one of them.
```

- [ ] **Step 3: Tighten the guide description**

Change:

```latex
This guide is organized around a single metric that sits at the intersection of hardware efficiency, algorithmic quality, and cost: \textit{intelligence per Watt}. It is designed so that an engineer can build RL intuition and a researcher can build systems intuition, with every chapter producing something publishable.
```

to:

```latex
This guide is organized around a single metric: \textit{intelligence per Watt}. Every chapter builds cross-boundary intuition and produces a publishable artifact.
```

- [ ] **Step 4: Trim chapter map entries**

Tighten each chapter description. Example — Chapter 2, change:

```latex
\item \textbf{Benchmarking AMD MI300X.} Applies kernel engineering to AMD's architecture to evaluate a multi-billion dollar hardware investment decision: where does AMD win on intelligence-per-Watt, and what engineering investment closes the gaps? Produces a decision-grade benchmarking report.
```

to:

```latex
\item \textbf{Benchmarking AMD MI300X.} Evaluates a multi-billion dollar hardware investment: where does AMD win on intelligence-per-Watt, and what engineering closes the gaps? \textit{Produces a decision-grade benchmarking report.}
```

Apply the same pattern to all 7 entries: cut "Applies X to Y" preambles, lead with the question or deliverable.

- [ ] **Step 5: Verify build**

Run: `cd rl-at-scale && tectonic standalone.tex -Z shell-escape --texinput "\def\chapterfile{chapters/00-introduction}" -o build && mv build/standalone.pdf build/00-introduction.pdf`
Expected: Successful compilation. Open PDF and visually confirm layout is intact.

- [ ] **Step 6: Commit**

```bash
git add chapters/00-introduction.tex
git commit -m "edit: tighten Ch 0 introduction — lead with thesis, trim chapter map"
```

---

## Task 2: Chapter 01 — CUDA Kernel Optimization

**Files:**
- Modify: `chapters/01-cuda-kernels.tex`

### Diagnosis

**Intervention level:** Moderate restructure. Strong content but two opportunities for TikZ.

**Issues identified:**
1. **Part A Think First boxes:** The Hopper vs Blackwell box (lines 27-44) is well-structured. The Triton box (lines 47-68) has some "Where X wins / Where Y wins" parallel structure that's already clean. The precision shift box (lines 70-100) is excellent.
2. **Missing visual: GPU memory hierarchy.** The one-paragraph GPU mental model (line 13) describes registers → shared memory → L2 → HBM — this is spatial and would benefit from a TikZ diagram. Referenced repeatedly throughout Ch 1-3.
3. **Missing visual: Roofline comparison.** The H100 vs B200 ridge points are derived numerically but never visualized. A roofline diagram would anchor the repeated roofline reasoning across chapters.
4. **Part B kernel progression (lines 106-170):** Dense but well-structured. Each kernel follows the same format. No changes needed.
5. **Part E Flash Attention (lines 248-266):** The memory-IO analysis is the key insight. The contrast between standard ($\Theta(N^2)$) and Flash ($\Theta(Nd)$) HBM traffic could be a small comparison diagram, but the bullet-point format already works. Skip TikZ here.

### Rewrite spec

- Add GPU memory hierarchy TikZ diagram after the mental model paragraph
- Add H100 vs B200 roofline comparison TikZ diagram in Part A
- Tighten the "Why This Matters" box: remove "The progression follows..." sentence (implementation detail, not motivation)
- Minor prose polish in Think First boxes

- [ ] **Step 1: Add GPU memory hierarchy diagram**

After line 13 (the "fundamental optimization challenge" paragraph), insert:

```latex
\begin{center}
\begin{tikzpicture}[
  mem/.style={draw, thick, rounded corners=3pt, minimum width=3.4cm, minimum height=0.9cm,
              text centered, font=\small},
  lbl/.style={font=\footnotesize\itshape, text width=3cm, align=left},
  arr/.style={-{Stealth[length=5pt]}, thick, gray!50}
]
  \node[mem, fill=red!8]   (reg) {Registers};
  \node[mem, fill=orange!8, below=0.35cm of reg] (smem) {Shared Memory / L1};
  \node[mem, fill=yellow!8, below=0.35cm of smem] (l2)   {L2 Cache};
  \node[mem, fill=blue!8,   below=0.35cm of l2]   (hbm)  {HBM (Global Memory)};

  \node[lbl, right=0.6cm of reg]  {fastest, smallest\\$\sim$256 KB/SM};
  \node[lbl, right=0.6cm of smem] {programmer-managed\\48--228 KB/SM};
  \node[lbl, right=0.6cm of l2]   {hardware-managed\\50 MB};
  \node[lbl, right=0.6cm of hbm]  {slowest, largest\\80--192 GB};

  \draw[arr] (hbm) -- (l2);
  \draw[arr] (l2) -- (smem);
  \draw[arr] (smem) -- (reg);

  \node[font=\footnotesize, gray!60, left=0.4cm of smem, rotate=90, anchor=south] {increasing speed};
  \node[font=\footnotesize, gray!60, left=0.4cm of l2, rotate=90, anchor=north] {increasing capacity};
\end{tikzpicture}
\end{center}
```

**Justification:** This is a spatial hierarchy referenced throughout Ch 1-3. Visualizing it once here prevents the reader from re-parsing the same prose description in every chapter.

- [ ] **Step 2: Add roofline comparison diagram**

In the Hopper vs Blackwell Think First box, after the bullet about roofline ridge point (around line 36), insert:

```latex
\begin{center}
\begin{tikzpicture}[
  scale=0.9,
  every node/.style={font=\footnotesize}
]
  % Axes
  \draw[-{Stealth[length=5pt]}, thick] (0,0) -- (7.5,0)
    node[right] {Arithmetic Intensity (FLOP/byte)};
  \draw[-{Stealth[length=5pt]}, thick] (0,0) -- (0,5.5)
    node[above, rotate=90, anchor=south, yshift=3mm] {Attainable TFLOP/s};

  % H100 roofline (log-scale conceptual)
  \draw[blue!70, very thick]
    (0,0) -- (3.8,3.8) -- (7,3.8)
    node[right, blue!70] {H100 (495 dense)};
  \draw[blue!70, dashed, thin] (3.8,0) -- (3.8,3.8);
  \node[blue!70, below] at (3.8,0) {148};

  % B200 roofline
  \draw[red!70, very thick]
    (0,0) -- (5.2,5.2) -- (7,5.2)
    node[right, red!70] {B200 (4500)};
  \draw[red!70, dashed, thin] (5.2,0) -- (5.2,5.2);
  \node[red!70, below] at (5.2,0) {562};

  % Decode region
  \fill[green!15, rounded corners=2pt] (0.15,0.15) rectangle (1.2,1.5);
  \node[font=\scriptsize, green!50!black, text width=1.2cm, align=center] at (0.67,0.85)
    {decode\\(BW-bound)};

  % Training region
  \fill[purple!10, rounded corners=2pt] (4.5,3.5) rectangle (6.5,5.0);
  \node[font=\scriptsize, purple!50!black, text width=1.8cm, align=center] at (5.5,4.25)
    {training matmul\\(compute-bound)};
\end{tikzpicture}
\end{center}

\smallskip
\noindent\textit{Conceptual roofline (not to log-scale). Decode-phase operations cluster in the bandwidth-bound regime; training matmuls cluster in the compute-bound regime. The gap between H100 and B200 ceilings is largest in the compute-bound region.}
```

**Justification:** The roofline model is the central analytical tool for Ch 1-4. A single diagram here replaces hundreds of words of repeated prose reasoning.

- [ ] **Step 3: Tighten the "Why This Matters" box**

Change lines 6-9:

```latex
The progression follows Simon Boehm's SGEMM\_CUDA project (13 kernels from naive to 93.7\% of cuBLAS), then extends to Blackwell-specific features: TMEM, native FP4/FP6, and thread block clusters. The governing metric throughout is \textit{intelligence per Watt}: useful inference throughput per joule, which is the actual constraint in large-scale RLVR training.
```

to:

```latex
The governing metric is \textit{intelligence per Watt}: useful inference throughput per joule. The progression follows Simon Boehm's SGEMM\_CUDA project (13 kernels, naive to 93.7\% of cuBLAS), then extends to Blackwell-specific features: TMEM, native FP4/FP6, and thread block clusters.
```

- [ ] **Step 4: Minor prose tightening**

Scan for crispy-rewrite violations. Examples:

- "If you have not programmed a GPU before, here is the one-paragraph orientation." → Cut the meta-sentence. Just give the orientation.
- "The fundamental optimization challenge:" → already fine, it's a colon introduction.

- [ ] **Step 5: Verify build**

Run: `cd rl-at-scale && tectonic standalone.tex -Z shell-escape --texinput "\def\chapterfile{chapters/01-cuda-kernels}" -o build && mv build/standalone.pdf build/01-cuda-kernels.pdf`
Expected: Compiles. Diagrams render correctly. No overfull hbox warnings on diagram pages.

- [ ] **Step 6: Commit**

```bash
git add chapters/01-cuda-kernels.tex
git commit -m "edit: Ch 1 CUDA — add memory hierarchy + roofline TikZ, tighten prose"
```

---

## Task 3: Chapter 02 — AMD Benchmarking

**Files:**
- Modify: `chapters/02-amd-benchmarking.tex`

### Diagnosis

**Intervention level:** Moderate restructure. Dense prerequisites section needs trimming. Strong analytical content in Parts A-C.

**Issues identified:**
1. **Prerequisites (lines 11-48):** 37 lines before any content. The vocabulary gate list (lines 22-30) is useful but wordy — each term has a parenthetical reference that could be a footnote or dropped. The "Read before starting" list (lines 32-37) repeats the vocabulary gate's Boehm reference.
2. **Part A Think First box 1 (lines 54-66):** 4 architecture differences described in prose. This is exactly the case for a comparison table or side-by-side TikZ.
3. **Part B single massive exercise (lines 149-200):** 5 operations in one exercise block. Well-structured internally but the block is intimidating. Consider adding visual breaks (subsection labels within the exercise are already present via \textbf{Operation N}).
4. **Missing visual: MI300X GCD topology.** The 8-XCD architecture is described in prose (line 63) but never visualized. This topology directly causes the inter-XCD latency penalty mentioned repeatedly.
5. **Missing visual: AMD vs NVIDIA architecture comparison.** The four differences (execution width, LDS, MFMA, GCD) are described in prose but are inherently comparative.

### Rewrite spec

- Trim prerequisites: merge Boehm references, tighten vocabulary gate to a compact table
- Add AMD vs NVIDIA architecture comparison as a TikZ side-by-side or a compact table (table is better here — the differences are quantitative, not spatial)
- Add MI300X GCD topology TikZ diagram
- Tighten Part A Think First prose (remove "Write down:" imperative phrases that repeat the box title's purpose)

- [ ] **Step 1: Convert vocabulary gate to a compact table**

Replace the 8-item vocabulary gate list (lines 22-30) with:

```latex
\textbf{Vocabulary gate.} Eight GPU terms used throughout. If any are unfamiliar, read Simon Boehm's ``How to Optimize a CUDA Matmul'' first ($\sim$2 hours).

\begin{center}
\small
\begin{tabular}{@{}lll@{}}
\toprule
\textbf{Term} & \textbf{Meaning} & \textbf{Reference} \\
\midrule
Tiling & Breaking ops into sub-blocks that fit in fast memory & Boehm K1--3 \\
Scheduling & How the GPU picks which thread groups run when & CUDA Guide Ch.~5 \\
Warp / wavefront & 32 threads (NVIDIA) or 64 threads (AMD) in lockstep & CUDA Guide Ch.~4 \\
GEMM & General Matrix Multiply ($C = AB$) & Boehm (entire blog) \\
Register pressure & Too many registers/thread $\to$ fewer concurrent threads & Boehm K6--7 \\
On-chip scratch & Fast die-level memory: shared memory (NVIDIA) / LDS (AMD) & Boehm K2+ \\
Double buffering & Load next tile while computing current tile & Boehm K5--6 \\
\bottomrule
\end{tabular}
\end{center}
```

This replaces 22 lines of prose with a scannable table.

- [ ] **Step 2: Merge redundant reading references**

The "Read before starting" list (lines 32-37) re-references Boehm (already in the vocabulary table) and the CDNA3 whitepaper. Trim to:

```latex
\textbf{Read before starting:} (1) Simon Boehm, ``How to Optimize a CUDA Matmul'' --- the table above references specific kernels; (2) AMD CDNA3 Architecture Whitepaper, Sections 1--3 (XCD topology, HBM3, MFMA units, $\sim$1 hour); (3) Wen-mei Hwu, ``Programming Massively Parallel Processors'' lectures on YouTube/Coursera, Chapters 4--6.
```

This replaces 6 itemized lines with 3 in-line.

- [ ] **Step 3: Add MI300X GCD topology diagram**

In Part A, Think First box 1, after the GCD topology description (line 63), insert:

```latex
\begin{center}
\begin{tikzpicture}[
  xcd/.style={draw, thick, rounded corners=2pt, fill=blue!8,
              minimum width=1.3cm, minimum height=1.3cm,
              text centered, font=\scriptsize\bfseries},
  fab/.style={draw=gray!40, thick, fill=gray!5, rounded corners=4pt},
  link/.style={gray!50, thick}
]
  % Infinity Fabric backbone
  \node[fab, minimum width=9cm, minimum height=1.2cm] (fabric) at (4,0)
    {\footnotesize\itshape Infinity Fabric};

  % 8 XCDs in two rows
  \foreach \i/\x in {0/0.5, 1/1.8, 2/3.1, 3/4.4} {
    \node[xcd] (xcd\i) at (\x, 1.6) {XCD \i};
    \draw[link] (xcd\i.south) -- (xcd\i.south |- fabric.north);
  }
  \foreach \i/\x in {4/5.0, 5/6.3, 6/7.6, 7/8.9} {
    \node[xcd] (xcd\i) at (\x, 1.6) {XCD \i};
    \draw[link] (xcd\i.south) -- (xcd\i.south |- fabric.north);
  }

  % HBM stacks below
  \node[draw, thick, rounded corners=2pt, fill=green!8,
        minimum width=9cm, minimum height=0.8cm,
        font=\footnotesize] (hbm) at (4,-1.2)
    {192 GB HBM3 \quad (5.3 TB/s aggregate bandwidth)};
  \draw[link] (fabric.south) -- (hbm.north);

  % Annotation
  \node[font=\scriptsize\itshape, gray!60, right] at (9.5,1.6)
    {Each XCD has\\own LDS (64 KB)};
  \node[font=\scriptsize\itshape, gray!60, right] at (9.5,0)
    {Inter-XCD comm\\$\to$ Fabric latency};
\end{tikzpicture}
\end{center}
```

**Justification:** The XCD topology is referenced in Part A (architecture differences), Part B (unexpected slowdowns), and the Optional Deep Dive (wavefront scheduling). A single diagram here prevents re-explaining it.

- [ ] **Step 4: Tighten Part A Think First prose**

Examples:
- "Write down: which operations in an RLVR training loop do you expect to be memory-bandwidth-bound" → "Predict: which RLVR operations are memory-bandwidth-bound, and which compute-bound?"
- "The counterintuitive implication:" → keep — this flags a non-obvious result.

- [ ] **Step 5: Tighten Part C exercise**

The "Step 3: Write the memo" section (lines 236-242) is excellent structure. No changes.

Tighten the gap source itemize (lines 230-234):
- "kernel not yet optimized (e.g., RCCL, FA not tuned): gap closable with engineering effort." → "kernel not yet optimized (RCCL, FA): closable with engineering."

- [ ] **Step 6: Verify build**

Run: `cd rl-at-scale && tectonic standalone.tex -Z shell-escape --texinput "\def\chapterfile{chapters/02-amd-benchmarking}" -o build && mv build/standalone.pdf build/02-amd-benchmarking.pdf`
Expected: Compiles. GCD topology diagram renders. No overfull hboxes.

- [ ] **Step 7: Commit**

```bash
git add chapters/02-amd-benchmarking.tex
git commit -m "edit: Ch 2 AMD — vocab table, GCD topology TikZ, tighten prerequisites"
```

---

## Task 4: Chapter 03 — TPU/Pallas

**Files:**
- Modify: `chapters/03-tpu-pallas.tex`

### Diagnosis

**Intervention level:** Conservative trim + add 2 TikZ diagrams.

**Issues identified:**
1. **Missing "Why This Matters" box.** The intro paragraph (lines 3-5) serves this purpose but lacks the tcolorbox structure used in every other chapter. Inconsistency.
2. **Missing visual: TPU memory hierarchy.** The HBM → VMEM → VREGs hierarchy is described in the Think First box (line 24) but never visualized. This is the TPU analog of the GPU hierarchy diagram in Ch 1.
3. **Missing visual: Double-buffering pipeline.** The Think First box (line 31) asks the reader to "draw the pipeline on paper." This is exactly where a TikZ timeline diagram earns its place — the reader should see it AFTER attempting to draw it, as confirmation.
4. **Pallas kernel exercise (lines 49-83):** Well-structured with clear progression. No changes.
5. **TPUv7 Think First box (lines 171-188):** Strong analytical content. No changes.

### Rewrite spec

- Wrap intro in a `whythis` box for consistency
- Add TPU memory hierarchy TikZ diagram
- Add double-buffering pipeline timeline TikZ diagram
- Minor prose tightening

- [ ] **Step 1: Wrap intro in "Why This Matters" box**

Change lines 3-5:

```latex
The RLVR training pipeline is ``held together by duct tape.'' Every percentage point of hardware utilization matters at scale. Simon Boehm's blog post walking through CUDA matmul optimization from 1.3\% to 93.7\% of cuBLAS remains the reference for GPU kernel pedagogy. No equivalent guide exists for TPUs and Pallas. This chapter follows the same methodology: start naive, profile, fix one thing, measure, repeat.
```

to:

```latex
\begin{whythis}
Every percentage point of hardware utilization matters at scale. Simon Boehm's blog post walking through CUDA matmul optimization from 1.3\% to 93.7\% of cuBLAS remains the reference for GPU kernel pedagogy. No equivalent exists for TPUs and Pallas. This chapter follows the same methodology: start naive, profile, fix one thing, measure, repeat.
\end{whythis}
```

Cuts the "held together by duct tape" cliche and adds structural consistency.

- [ ] **Step 2: Add TPU memory hierarchy diagram**

In the "Memory hierarchy reasoning" Think First box, after the first sentence (line 24), insert:

```latex
\begin{center}
\begin{tikzpicture}[
  mem/.style={draw, thick, rounded corners=3pt, minimum width=3cm, minimum height=0.8cm,
              text centered, font=\small},
  lbl/.style={font=\footnotesize\itshape, text width=3.5cm, align=left},
  arr/.style={-{Stealth[length=5pt]}, thick, gray!50}
]
  \node[mem, fill=red!8]    (vreg) {VREGs};
  \node[mem, fill=orange!8, below=0.3cm of vreg] (vmem) {VMEM (SRAM)};
  \node[mem, fill=blue!8,   below=0.3cm of vmem] (hbm)  {HBM};

  \node[lbl, right=0.5cm of vreg] {fastest\\registers};
  \node[lbl, right=0.5cm of vmem] {on-chip, $\sim$30 MB\\programmer-managed};
  \node[lbl, right=0.5cm of hbm]  {off-chip, 16 GB\\820 GB/s (v5e)};

  \draw[arr] (hbm) -- node[left, font=\scriptsize, gray!60] {DMA} (vmem);
  \draw[arr] (vmem) -- (vreg);
\end{tikzpicture}
\end{center}
```

**Justification:** Direct analog to the GPU diagram in Ch 1. Readers who did Ch 1 first get instant mapping; readers who skipped to Ch 3 get the necessary context.

- [ ] **Step 3: Add double-buffering pipeline diagram**

After the double-buffering question in the Think First box (line 31), insert:

```latex
\medskip
\noindent After you have drawn it yourself, compare against this timeline:

\begin{center}
\begin{tikzpicture}[
  x=1.2cm, y=0.8cm,
  phase/.style={draw, thick, minimum height=0.6cm, text centered, font=\scriptsize},
  dma/.style={phase, fill=blue!15, rounded corners=2pt},
  compute/.style={phase, fill=orange!15, rounded corners=2pt}
]
  % Labels
  \node[font=\footnotesize\bfseries, anchor=east] at (-0.2, 1) {DMA};
  \node[font=\footnotesize\bfseries, anchor=east] at (-0.2, 0) {MXU};

  % Time axis
  \draw[-{Stealth[length=4pt]}, gray!50] (0,-0.6) -- (8.5,-0.6)
    node[right, font=\scriptsize] {time};

  % DMA row
  \node[dma, minimum width=1.8cm] at (1, 1) {Load tile 0};
  \node[dma, minimum width=1.8cm] at (3.2, 1) {Load tile 1};
  \node[dma, minimum width=1.8cm] at (5.4, 1) {Load tile 2};

  % Compute row (offset by one tile)
  \node[compute, minimum width=1.8cm] at (3.2, 0) {Compute tile 0};
  \node[compute, minimum width=1.8cm] at (5.4, 0) {Compute tile 1};
  \node[compute, minimum width=1.8cm] at (7.6, 0) {Compute tile 2};

  % Overlap annotation
  \draw[decorate, decoration={brace, amplitude=4pt, mirror}, thick, gray!40]
    (2.3, -0.2) -- (4.1, -0.2)
    node[midway, below=5pt, font=\scriptsize\itshape, gray!60] {overlap};
\end{tikzpicture}
\end{center}
```

**Justification:** Pipeline timing is inherently temporal/spatial. The reader is asked to draw this — showing it afterward confirms or corrects their mental model.

- [ ] **Step 4: Minor prose tightening**

- Line 5: "This chapter follows the same methodology: start naive, profile, fix one thing, measure, repeat." → Already crisp. Keep.
- Remove "Now answer:" and "Work out these cases" imperatives that duplicate the Think First box title.

- [ ] **Step 5: Verify build**

Run: `cd rl-at-scale && tectonic standalone.tex -Z shell-escape --texinput "\def\chapterfile{chapters/03-tpu-pallas}" -o build && mv build/standalone.pdf build/03-tpu-pallas.pdf`
Expected: Compiles. Both diagrams render.

- [ ] **Step 6: Commit**

```bash
git add chapters/03-tpu-pallas.tex
git commit -m "edit: Ch 3 TPU — add whythis box, memory hierarchy + pipeline TikZ, trim prose"
```

---

## Task 5: Chapter 04 — Inference & Serving

**Files:**
- Modify: `chapters/04-inference-serving.tex`

### Diagnosis

**Intervention level:** Moderate restructure. Prose-heavy chapter with several opportunities for visual breaks.

**Issues identified:**
1. **KV Cache section (lines 17-46):** Dense prose describing paged attention, quantization, eviction/compression/offloading, and MoE memory interaction. Four sub-topics in one subsection with no visual break. The paged vs contiguous memory layout is inherently spatial.
2. **Speculative decoding (lines 48-86):** The math is clean. The flow (draft → verify → accept/reject) is described in prose but is inherently sequential. A flow diagram would anchor the subsequent math.
3. **Continuous batching (lines 88-124):** The GRPO synchronization constraint is the key insight. The contrast between static, dynamic, and group-aware batching is described well in prose but the timeline behavior is temporal.
4. **MoE serving (lines 126-136):** Compact, well-written. No changes.
5. **Sampling kernels (lines 138-148):** Compact. No changes.
6. **Numerical stability (lines 150-168):** Important content. The precision stack (5 levels) is already a clean itemize. No TikZ needed.

### Rewrite spec

- Add speculative decoding flow diagram
- Add static vs continuous batching timeline diagram
- Tighten opening of speculative decoding section (remove re-explanation of autoregressive generation)
- Minor prose polish

- [ ] **Step 1: Add speculative decoding flow diagram**

After the first paragraph of the speculative decoding section (line 52), insert:

```latex
\begin{center}
\begin{tikzpicture}[
  box/.style={draw, thick, rounded corners=3pt, minimum height=0.8cm,
              text centered, font=\small, minimum width=2.4cm},
  arr/.style={-{Stealth[length=5pt]}, thick},
  lbl/.style={font=\scriptsize, midway}
]
  \node[box, fill=green!8]  (draft) {Draft model};
  \node[box, fill=blue!8, right=1.5cm of draft]  (verify) {Target model};
  \node[box, fill=orange!8, right=1.5cm of verify] (out) {Output tokens};

  \draw[arr] (draft) -- node[lbl, above] {$K$ tokens} (verify);
  \draw[arr] (verify) -- node[lbl, above] {$K\alpha + 1$} (out);

  \node[font=\scriptsize\itshape, gray!60, below=0.15cm of draft] {fast, cheap};
  \node[font=\scriptsize\itshape, gray!60, below=0.15cm of verify] {one fwd pass};
  \node[font=\scriptsize\itshape, gray!60, below=0.15cm of out] {accepted};
\end{tikzpicture}
\end{center}
```

**Justification:** The speculative decoding protocol is a 3-stage pipeline. The subsequent math ($K\alpha + 1$, breakeven) references these stages; the diagram anchors them visually.

- [ ] **Step 2: Add batching comparison timeline**

In the continuous batching section, after the "Static batching waste" paragraph (line 94), insert:

```latex
\begin{center}
\begin{tikzpicture}[
  x=0.035cm, y=0.7cm,
  seq/.style={draw, thick, rounded corners=1pt, minimum height=0.45cm},
  waste/.style={pattern=north east lines, pattern color=red!30},
  lbl/.style={font=\footnotesize\bfseries, anchor=east}
]
  % Static batching
  \node[lbl] at (-5, 2) {Static};
  \foreach \i/\len in {0/60, 1/180, 2/40, 3/200} {
    \fill[blue!20, rounded corners=1pt] (0, 2.3-\i*0.55) rectangle (\len, 2.6-\i*0.55);
    \fill[waste, rounded corners=1pt] (\len, 2.3-\i*0.55) rectangle (200, 2.6-\i*0.55);
  }
  \draw[gray!40, dashed] (200, 0.4) -- (200, 2.7);
  \node[font=\scriptsize, gray!50] at (200, 0.25) {max len};

  % Continuous batching
  \node[lbl] at (-5, -0.8) {Continuous};
  \fill[blue!20, rounded corners=1pt] (0, -0.5) rectangle (60, -0.2);
  \fill[green!20, rounded corners=1pt] (65, -0.5) rectangle (165, -0.2);  % new seq
  \fill[blue!20, rounded corners=1pt] (0, -1.05) rectangle (180, -0.75);
  \fill[blue!20, rounded corners=1pt] (0, -1.6) rectangle (40, -1.3);
  \fill[green!20, rounded corners=1pt] (45, -1.6) rectangle (155, -1.3);  % new seq
  \fill[blue!20, rounded corners=1pt] (0, -2.15) rectangle (200, -1.85);

  % Legend
  \node[font=\scriptsize] at (100, -2.7) {%
    \tikz{\fill[blue!20] (0,0) rectangle (0.3,0.2);} original \quad
    \tikz{\fill[green!20] (0,0) rectangle (0.3,0.2);} backfilled \quad
    \tikz{\fill[waste] (0,0) rectangle (0.3,0.2);} wasted};
\end{tikzpicture}
\end{center}
```

**Justification:** The waste from static batching is the motivating problem. Showing the hatched "waste" regions visually conveys why continuous batching matters more effectively than the prose description alone.

- [ ] **Step 3: Tighten speculative decoding prose**

The opening sentence "Speculative decoding is an exact-or-approximate method for accelerating autoregressive generation using a small \textit{draft model}..." is 38 words before the reader hits the key idea. Change to:

```latex
A small \textit{draft model} proposes $K$ tokens in parallel; a single forward pass of the large \textit{target model} verifies all $K$ at once.
```

Then the "key insight" follows naturally.

- [ ] **Step 4: Tighten KV cache section**

- "Every autoregressive generation step recomputes attention over all previous tokens unless the key-value projections are cached." → "KV caching stores key-value projections from previous tokens, avoiding recomputation at each generation step."
- "The factor of 2 is for keys and values." → Cut. The equation makes this obvious.

- [ ] **Step 5: Verify build**

Run: `cd rl-at-scale && tectonic standalone.tex -Z shell-escape --texinput "\def\chapterfile{chapters/04-inference-serving}" -o build && mv build/standalone.pdf build/04-inference-serving.pdf`
Expected: Compiles. Diagrams render. Batching timeline doesn't overflow margins.

- [ ] **Step 6: Commit**

```bash
git add chapters/04-inference-serving.tex
git commit -m "edit: Ch 4 Inference — add spec-dec flow + batching timeline TikZ, tighten prose"
```

---

## Task 6: Chapter 05 — Policy Gradients

**Files:**
- Modify: `chapters/05-policy-gradients.tex`

### Diagnosis

**Intervention level:** Conservative trim. The 5-lever structure is the strongest organizational design in the book. Don't touch it.

**Issues identified:**
1. **Cost ledger (lines 16-24):** The `lstlisting` code block showing wall-clock breakdown is functional but not scannable. A horizontal stacked bar TikZ diagram would make the 60-80% dominance of rollout generation visually immediate.
2. **Five levers enumeration (lines 41-48):** Clean. Keep.
3. **Lever 1 literature (lines 79-85):** Three papers listed. Well-formatted.
4. **Lever 5 clipping mechanism (lines 282-294):** The clip-high vs clip-low explanation is the most mechanistic content in the chapter. The asymmetric effect on entropy (clip-high concentrates, clip-low disperses) is inherently about probability mass movement — a visual would help.
5. **Dashboard table (lines 352-369):** Clean table format. Keep.
6. **Interview Arsenal (lines 386-416):** Excellent. No changes.

### Rewrite spec

- Add cost ledger stacked bar TikZ diagram
- Add clipping mechanism probability mass diagram
- Minor prose tightening (remove "The assumption $N(G) \propto 1/G$ breaks because..." preamble)

- [ ] **Step 1: Add cost ledger stacked bar diagram**

After the `lstlisting` cost ledger (line 24), insert:

```latex
\begin{center}
\begin{tikzpicture}[x=0.065cm, y=0.8cm]
  % Stacked bar
  \fill[red!25, rounded corners=1pt]   (0,0) rectangle (70,0.7);   % generation
  \fill[orange!20, rounded corners=1pt] (70,0) rectangle (80,0.7);  % reward
  \fill[yellow!20, rounded corners=1pt] (80,0) rectangle (90,0.7);  % reference
  \fill[blue!20, rounded corners=1pt]   (90,0) rectangle (100,0.7); % backward
  \fill[gray!15, rounded corners=1pt]   (100,0) rectangle (105,0.7);% comm

  % Labels
  \node[font=\scriptsize, anchor=south] at (35, 0.75)  {Rollout generation (60--80\%)};
  \node[font=\scriptsize, anchor=south] at (85, 0.75)  {\tiny reward + ref};
  \node[font=\scriptsize, anchor=south] at (95, 0.75)  {\tiny bwd};

  % Brace over generation
  \draw[decorate, decoration={brace, amplitude=4pt}, thick, red!50]
    (0, -0.15) -- (70, -0.15)
    node[midway, below=5pt, font=\scriptsize\itshape, red!60] {where cost levers hit hardest};
\end{tikzpicture}
\end{center}
```

**Justification:** The entire chapter's argument rests on "rollout generation dominates wall-clock." Making this visually undeniable in the first page sets up all 5 levers.

- [ ] **Step 2: Add clipping mechanism diagram**

In Lever 5, after the clip-high/clip-low bullet description (line 294), insert:

```latex
\begin{center}
\begin{tikzpicture}[
  x=0.8cm, y=2.5cm,
  every node/.style={font=\scriptsize}
]
  % Axes
  \draw[-{Stealth[length=4pt]}, gray!50] (-0.3,0) -- (7,0) node[right] {tokens};
  \draw[-{Stealth[length=4pt]}, gray!50] (0,-0.05) -- (0,1.2) node[above] {$\pi(a|s)$};

  % Before clipping — spread distribution
  \draw[blue!60, thick, smooth] plot coordinates
    {(0.5,0.05) (1,0.15) (2,0.35) (3,0.55) (4,0.35) (5,0.15) (6,0.05)};
  \node[blue!60, above] at (3, 0.58) {before};

  % After clip-high only — concentrated
  \draw[red!60, thick, smooth, dashed] plot coordinates
    {(0.5,0.02) (1,0.05) (2,0.15) (3,0.85) (4,0.15) (5,0.03) (6,0.01)};
  \node[red!60, above] at (4.5, 0.35) {after clip-high};

  % Annotation
  \draw[-{Stealth[length=3pt]}, red!40, thick] (2.5, 0.3) -- (2.9, 0.6);
  \node[red!40, anchor=east, text width=2cm, align=right] at (2.3, 0.45)
    {mass\\concentrates};
\end{tikzpicture}
\end{center}

\smallskip
\noindent\textit{Symmetric clipping's net effect: clip-high allows probability increases without bound for positive advantages, concentrating mass. Entropy decreases.}
```

**Justification:** The clipping mechanism is the mechanistic explanation for entropy collapse — the most important failure mode in RL training. The visual makes the asymmetry visceral: the reader sees the distribution sharpening.

- [ ] **Step 3: Minor prose tightening**

- "The assumption $N(G) \propto 1/G$ breaks because $N(G)$ flattens once gradient variance drops below the \textit{bias floor}" → Already crisp. Keep.
- "Napkin math:" → Good voice marker. Keep.
- Remove "This section is honest about that." from Lever 4 opening — let the honesty be implicit.

- [ ] **Step 4: Verify build**

Run: `cd rl-at-scale && tectonic standalone.tex -Z shell-escape --texinput "\def\chapterfile{chapters/05-policy-gradients}" -o build && mv build/standalone.pdf build/05-policy-gradients.pdf`
Expected: Compiles. Both diagrams render. Cost ledger bar fits within text width.

- [ ] **Step 5: Commit**

```bash
git add chapters/05-policy-gradients.tex
git commit -m "edit: Ch 5 Policy Gradients — add cost ledger + clipping TikZ, minor polish"
```

---

## Task 7: Chapter 06 — TinyRL + Pipeline + Scaling

**Files:**
- Modify: `chapters/06-tinyrl-pipeline-scaling.tex`

### Diagnosis

**Intervention level:** Moderate restructure. This file contains THREE distinct sections (TinyRL framework, RL Pipeline & Verification, Scaling Laws) — the longest chapter at 537 lines.

**Issues identified:**
1. **Three sections in one file.** The `\section` commands at lines 1, 262, and 436 create proper LaTeX sections, but the file is overloaded. The writing-plans skill says "files that change together should live together" — these are independent topics. However, the user asked to rewrite chapters, not restructure files. Keep in one file but ensure clear visual separation.
2. **TinyRL environment descriptions (lines 89-196):** Each environment (Code, Align, Quant) follows the same structure: Setup → "This Is X" → Dynamics → Competition Metric. Clean parallel structure. No changes.
3. **Missing visual: Post-training pipeline.** The table at lines 268-280 shows pipeline evolution. A timeline TikZ diagram would be more scannable and show the shift from pretraining-dominant to RLVR-dominant.
4. **Missing visual: Verification cleanliness spectrum.** The Think First box at line 209 asks the reader to rank environments by verification cleanliness. A spectrum diagram would anchor this.
5. **Scaling Laws section (lines 436-537):** Well-structured. The Jones replication exercise is strong.

### Rewrite spec

- Add post-training pipeline evolution TikZ diagram
- Add verification cleanliness spectrum TikZ diagram
- Tighten TinyRL "Why This Matters" box (slightly verbose)
- Trim redundant "This is RLHF, not RLVR" section header + first sentence (the content already makes this clear)

- [ ] **Step 1: Tighten TinyRL "Why This Matters" box**

The first paragraph (lines 6-8) makes the pitch. The second paragraph (lines 8-10) re-makes it with the MNIST analogy. Merge:

Change:

```latex
TinyRL fills the same role MNIST filled for computer vision: a standardized, minimal starting point that everyone can benchmark against. MNIST did not replace ImageNet. It gave researchers a shared substrate where ideas could be tested cheaply, compared cleanly, and built upon publicly. TinyRL does this for RLVR.
```

to:

```latex
TinyRL is the MNIST of RLVR: a shared substrate where ideas can be tested cheaply, compared cleanly, and built upon publicly.
```

The MNIST analogy is strong enough to stand alone. The "MNIST did not replace ImageNet" clarification is unnecessary for this audience.

- [ ] **Step 2: Add verification cleanliness spectrum**

Replace the Think First text at line 209 that says "Rank the three TinyRL environments by verification cleanliness" with a TikZ spectrum followed by the questions:

```latex
\begin{center}
\begin{tikzpicture}[x=1cm, y=0.5cm]
  % Spectrum bar
  \shade[left color=green!30, right color=red!30, rounded corners=3pt]
    (0,0) rectangle (12,0.6);

  % Labels
  \node[font=\footnotesize\bfseries, above] at (1.5, 0.7)  {TinyRL-Code};
  \node[font=\footnotesize\bfseries, above] at (6, 0.7)    {TinyRL-Quant};
  \node[font=\footnotesize\bfseries, above] at (10.5, 0.7) {TinyRL-Align};

  % Markers
  \foreach \x in {1.5, 6, 10.5}
    \fill[black] (\x, 0.3) circle (3pt);

  % Annotations below
  \node[font=\scriptsize\itshape, below, text width=2.5cm, align=center] at (1.5, -0.1)
    {unit tests\\(deterministic)};
  \node[font=\scriptsize\itshape, below, text width=2.5cm, align=center] at (6, -0.1)
    {composite score\\(verifiable)};
  \node[font=\scriptsize\itshape, below, text width=2.5cm, align=center] at (10.5, -0.1)
    {neural proxy\\(gameable)};

  % Axis labels
  \node[font=\scriptsize, green!50!black] at (0, -1.0) {cleanest};
  \node[font=\scriptsize, red!50!black] at (12, -1.0) {noisiest};
\end{tikzpicture}
\end{center}
```

**Justification:** The verification spectrum is the central conceptual contribution of the TinyRL section — it shows WHY three environments exist and what each one isolates. The visual makes the spectrum immediately graspable.

- [ ] **Step 3: Add post-training pipeline evolution diagram**

Replace the table at lines 268-280 with a TikZ timeline:

```latex
\begin{center}
\begin{tikzpicture}[
  x=0.8cm, y=1cm,
  era/.style={draw, thick, rounded corners=3pt, minimum height=0.8cm,
              text centered, font=\small},
  lbl/.style={font=\footnotesize\bfseries, anchor=east}
]
  % Era labels
  \node[lbl] at (-0.3, 2) {2020--22};
  \node[lbl] at (-0.3, 1) {2022--24};
  \node[lbl] at (-0.3, 0) {2025+};

  % 2020-22: pretraining only
  \node[era, fill=blue!15, minimum width=12cm] at (6, 2) {Pretraining};

  % 2022-24: pretraining + SFT + RLHF
  \node[era, fill=blue!15, minimum width=9.5cm, anchor=west] at (0, 1) {Pretraining (95\%)};
  \node[era, fill=gray!15, minimum width=1cm, anchor=west] at (9.7, 1) {\tiny SFT};
  \node[era, fill=orange!15, minimum width=1.2cm, anchor=west] at (10.8, 1) {\tiny RLHF};

  % 2025+: pretraining + SFT + RLVR + RLHF
  \node[era, fill=blue!12, minimum width=6cm, anchor=west] at (0, 0) {Pretraining};
  \node[era, fill=gray!12, minimum width=1cm, anchor=west] at (6.1, 0) {\tiny SFT};
  \node[era, fill=purple!20, minimum width=3.5cm, anchor=west] at (7.2, 0) {RLVR};
  \node[era, fill=orange!12, minimum width=1cm, anchor=west] at (10.8, 0) {\tiny RLHF};

  % Arrow showing shift
  \draw[-{Stealth[length=5pt]}, thick, purple!50] (8.5, 0.5) -- (8.5, 0.85)
    node[right, font=\scriptsize\itshape, purple!60] {growing};
\end{tikzpicture}
\end{center}
```

Keep the table's caption as a text note below.

**Justification:** The shift from pretraining-dominant to RLVR-growing is the framing for the entire second half of the chapter. A proportional visual conveys the shift more intuitively than a three-row table.

- [ ] **Step 4: Trim redundant section headers**

The "This Is RLHF, Not RLVR" subsubsection header (line 144) followed by "The reward model is a neural network, not a deterministic verifier. It can be gamed." is redundant after the verification spectrum. Change to just "The reward model is a neural network, not a verifier — it can be gamed." and remove the subsubsection header.

- [ ] **Step 5: Verify build**

Run: `cd rl-at-scale && tectonic standalone.tex -Z shell-escape --texinput "\def\chapterfile{chapters/06-tinyrl-pipeline-scaling}" -o build && mv build/standalone.pdf build/06-tinyrl-pipeline-scaling.pdf`
Expected: Compiles. Spectrum and timeline render within margins.

- [ ] **Step 6: Commit**

```bash
git add chapters/06-tinyrl-pipeline-scaling.tex
git commit -m "edit: Ch 6 TinyRL+Pipeline — add verification spectrum + pipeline TikZ, tighten prose"
```

---

## Task 8: Chapter 07 — Distributed Training

**Files:**
- Modify: `chapters/07-distributed-training.tex`

### Diagnosis

**Intervention level:** Moderate restructure. The chapter's Think First boxes are the longest in the book (80+ lines each). They contain excellent content but need visual support — the communication patterns are inherently spatial/temporal.

**Issues identified:**
1. **Parallelism Think First box (lines 23-80):** 57 lines of dense prose describing DDP, TP, PP, FSDP, and hybrid strategies. Each strategy has the same structure (memory math → cost → conclusion). This is comparative content that benefits from a summary table or diagram.
2. **Communication Patterns Think First box (lines 143-210):** Ring all-reduce, tree all-reduce, and all-to-all described in prose. Ring all-reduce is a textbook diagram candidate — the protocol is spatial (ring topology) and temporal (phases).
3. **RLVR step timeline missing.** The "Why RLVR Distribution Is Harder" box (lines 82-141) describes 3 phases + synchronization barriers. A timeline diagram across GPUs would make the bubble structure immediately visible.
4. **Ring All-Reduce exercise (lines 216-267):** Well-structured. The protocol steps are clear.
5. **Intelligence-per-Watt section (lines 422-448):** Excellent theoretical content. Compact. No changes.

### Rewrite spec

- Add ring all-reduce protocol diagram
- Add RLVR step timeline across 4 GPUs (showing generation, reward, sync barrier, training)
- Add parallelism strategy comparison table (replacing some prose in the Think First box)
- Tighten the Think First boxes by extracting the "Design question" prompts to stand alone

- [ ] **Step 1: Add ring all-reduce diagram**

In the Communication Patterns Think First box, after the ring all-reduce description (around line 167), insert:

```latex
\begin{center}
\begin{tikzpicture}[
  gpu/.style={draw, thick, circle, minimum size=1.1cm, font=\small\bfseries, fill=#1},
  arr/.style={-{Stealth[length=5pt]}, thick, #1}
]
  % 4 GPUs in a ring
  \node[gpu=blue!10]   (g0) at (0, 1.5)  {GPU 0};
  \node[gpu=green!10]  (g1) at (2.5, 0)  {GPU 1};
  \node[gpu=orange!10] (g2) at (0, -1.5) {GPU 2};
  \node[gpu=red!10]    (g3) at (-2.5, 0) {GPU 3};

  % Ring arrows (clockwise)
  \draw[arr=blue!50]   (g0) -- node[right, font=\scriptsize] {$S/N$} (g1);
  \draw[arr=green!50]  (g1) -- node[right, font=\scriptsize] {$S/N$} (g2);
  \draw[arr=orange!50] (g2) -- node[left, font=\scriptsize]  {$S/N$} (g3);
  \draw[arr=red!50]    (g3) -- node[left, font=\scriptsize]  {$S/N$} (g0);

  % Phase labels
  \node[font=\footnotesize\itshape, gray!60] at (4.2, 1.5) {Phase 1: reduce-scatter};
  \node[font=\footnotesize\itshape, gray!60] at (4.2, 0.8) {($N{-}1$ steps)};
  \node[font=\footnotesize\itshape, gray!60] at (4.2, -0.5) {Phase 2: all-gather};
  \node[font=\footnotesize\itshape, gray!60] at (4.2, -1.2) {($N{-}1$ steps)};

  % Total annotation
  \node[font=\footnotesize, anchor=north, text width=4cm, align=center] at (0, -2.5)
    {Total per device: $2(N{-}1)/N \cdot S$ bytes\\Utilization: $(N{-}1)/N$};
\end{tikzpicture}
\end{center}
```

**Justification:** Ring all-reduce is the foundational distributed communication primitive. The ring topology + per-hop chunk size is spatial information that prose struggles to convey. The exercise later asks the reader to implement this — the diagram is the reference.

- [ ] **Step 2: Add RLVR step timeline diagram**

In the "Why RLVR Distribution Is Harder" Think First box, after the "Variable-length outputs" paragraph (around line 120), insert:

```latex
\begin{center}
\begin{tikzpicture}[
  x=0.06cm, y=0.65cm,
  phase/.style={draw, thick, rounded corners=1pt, minimum height=0.4cm, font=\scriptsize},
  gen/.style={phase, fill=red!15},
  rew/.style={phase, fill=orange!15},
  sync/.style={phase, fill=gray!25, pattern=north east lines, pattern color=gray!40},
  train/.style={phase, fill=blue!15},
  lbl/.style={font=\footnotesize\bfseries, anchor=east}
]
  \node[lbl] at (-3, 3) {GPU 0};
  \node[lbl] at (-3, 2) {GPU 1};
  \node[lbl] at (-3, 1) {GPU 2};
  \node[lbl] at (-3, 0) {GPU 3};

  % GPU 0: fast generation
  \node[gen, minimum width=3cm] at (25, 3) {gen};
  \node[rew, minimum width=0.6cm] at (53, 3) {};
  \node[sync, minimum width=2.4cm] at (70, 3) {\tiny wait};
  \node[train, minimum width=1.8cm] at (90, 3) {train};

  % GPU 1: slow generation (straggler)
  \node[gen, minimum width=5cm] at (40, 2) {gen (straggler)};
  \node[rew, minimum width=0.6cm] at (68, 2) {};
  \node[sync, minimum width=0.6cm] at (75, 2) {};
  \node[train, minimum width=1.8cm] at (90, 2) {train};

  % GPU 2: medium
  \node[gen, minimum width=3.6cm] at (28, 1) {gen};
  \node[rew, minimum width=0.6cm] at (55, 1) {};
  \node[sync, minimum width=1.8cm] at (68, 1) {\tiny wait};
  \node[train, minimum width=1.8cm] at (90, 1) {train};

  % GPU 3: fast
  \node[gen, minimum width=2.4cm] at (20, 0) {gen};
  \node[rew, minimum width=0.6cm] at (40, 0) {};
  \node[sync, minimum width=3cm] at (60, 0) {\tiny wait};
  \node[train, minimum width=1.8cm] at (90, 0) {train};

  % Sync barrier
  \draw[dashed, thick, gray!50] (80, -0.5) -- (80, 3.5);
  \node[font=\scriptsize\itshape, gray!60, rotate=90, anchor=south] at (81, 1.5) {sync barrier};

  % Time axis
  \draw[-{Stealth[length=4pt]}, gray!40] (0, -0.7) -- (100, -0.7)
    node[right, font=\scriptsize] {time};

  % Legend
  \node[font=\scriptsize] at (50, -1.5) {%
    \tikz{\fill[red!15] (0,0) rectangle (0.3,0.2);} generation \quad
    \tikz{\fill[orange!15] (0,0) rectangle (0.3,0.2);} reward \quad
    \tikz{\fill[gray!25, pattern=north east lines, pattern color=gray!40] (0,0) rectangle (0.3,0.2);} idle (bubble) \quad
    \tikz{\fill[blue!15] (0,0) rectangle (0.3,0.2);} training};
\end{tikzpicture}
\end{center}
```

**Justification:** This is THE diagram for the chapter. The straggler problem, the sync barrier, and the wasted GPU time are all visible at a glance. The "Design question" at the end of the Think First box asks the reader to draw exactly this — showing it confirms their mental model.

- [ ] **Step 3: Add parallelism strategy summary table**

After the hybrid strategies paragraph (line 76), add a compact comparison table to replace the repeated prose pattern:

```latex
\begin{center}
\small
\begin{tabular}{@{}lccl@{}}
\toprule
\textbf{Strategy} & \textbf{Memory/GPU} & \textbf{Comm. pattern} & \textbf{Bottleneck} \\
\midrule
DDP          & Full model      & All-reduce (gradients)   & Memory: 70B doesn't fit \\
TP ($T{=}8$) & $1/T$ params    & All-reduce (per layer)   & Latency: on critical path \\
PP ($P{=}8$) & $1/P$ layers    & Point-to-point           & Bubbles: $(P{-}1)/(M{+}P{-}1)$ \\
FSDP ($N{=}8$) & $1/N$ everything & Gather + scatter       & Bandwidth: $2\times$ DDP volume \\
\bottomrule
\end{tabular}
\end{center}
```

**Justification:** The Think First box walks through 4 strategies in sequence. After that walk-through, a summary table lets the reader reference the key differences without re-reading 50 lines of prose.

- [ ] **Step 4: Tighten Think First box prose**

- Remove "Before reading further, work through the following from first principles." — the Think First box title already signals this.
- "Does it fit? No --- 560 GB $\gg$ 80 GB." → Already crisp. Keep.
- Trim "This is a \emph{synchronous, latency-sensitive} communication on the critical path." → "This is synchronous and latency-sensitive --- on the critical path."

- [ ] **Step 5: Verify build**

Run: `cd rl-at-scale && tectonic standalone.tex -Z shell-escape --texinput "\def\chapterfile{chapters/07-distributed-training}" -o build && mv build/standalone.pdf build/07-distributed-training.pdf`
Expected: Compiles. All three diagrams render. Timeline doesn't overflow.

- [ ] **Step 6: Commit**

```bash
git add chapters/07-distributed-training.tex
git commit -m "edit: Ch 7 Distributed — add ring all-reduce, RLVR timeline, parallelism table TikZ"
```

---

## Task 9: Full Build Verification

**Files:**
- All modified files

- [ ] **Step 1: Build full textbook**

Run: `cd rl-at-scale && tectonic textbook.tex -o build`
Expected: Successful compilation. No errors.

- [ ] **Step 2: Visual inspection**

Open `build/textbook.pdf`. Check:
- All TikZ diagrams render correctly (no clipped elements, no overfull hbox)
- Diagram placement doesn't create orphaned headings or awkward page breaks
- Existing diagrams in Ch 0 still render
- Table of contents reflects correct section titles

- [ ] **Step 3: Fidelity audit**

For each chapter, verify:
- All math environments (`\[...\]`, `align*`, inline `$...$`) are intact
- All `tcolorbox` environments (exercise, thinkfirst, portfolio, whythis, taste) are intact
- All `lstlisting` code blocks are intact
- All `\textbf{}`, `\textit{}` emphasis is preserved
- No numbers, dates, or dollar amounts changed

- [ ] **Step 4: Final commit**

If any fixes needed from Steps 2-3, apply them and commit:

```bash
git add -A
git commit -m "fix: post-review corrections from full build verification"
```

---

## Summary: TikZ Additions by Chapter

| Chapter | Diagram | Type | Justification |
|---------|---------|------|---------------|
| Ch 1 | GPU memory hierarchy | Spatial hierarchy | Referenced in Ch 1-3; one diagram prevents repeated prose |
| Ch 1 | H100 vs B200 roofline | Comparison | Central analytical tool for Ch 1-4 |
| Ch 2 | MI300X GCD topology | Spatial architecture | Explains inter-XCD latency penalty |
| Ch 3 | TPU memory hierarchy | Spatial hierarchy | TPU analog of Ch 1 diagram |
| Ch 3 | Double-buffer pipeline | Timeline | Temporal sequence readers are asked to draw |
| Ch 4 | Speculative decoding flow | Process flow | Anchors subsequent math |
| Ch 4 | Static vs continuous batching | Timeline comparison | Makes waste visually immediate |
| Ch 5 | Cost ledger stacked bar | Proportional | "60-80% rollout" is the chapter's thesis |
| Ch 5 | Clipping probability mass | Conceptual | Makes entropy collapse mechanism visceral |
| Ch 6 | Verification spectrum | Spectrum/scale | Central conceptual contribution |
| Ch 6 | Pipeline evolution | Timeline | Shows pretraining→RLVR shift |
| Ch 7 | Ring all-reduce | Spatial topology | Foundational communication primitive |
| Ch 7 | RLVR step timeline | Multi-GPU timeline | THE diagram for the chapter |
| Ch 7 | Parallelism strategy table | Summary table | Replaces re-reading 50 lines of prose |

**Total: 14 diagrams across 7 chapters. Zero decorative diagrams.**

## Chapters Not Modified

- **Chapter 08 (Epilogue):** 9-line stub with TODOs. Nothing to rewrite. Write it from the spec when ready.
