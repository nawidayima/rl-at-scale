# Nippon Seasons Color Scheme Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the clashing rainbow color scheme across all RL-at-Scale tex files with a harmonious Nippon Seasons (日本の伝統色) palette — 5 named colors derived from Japanese traditional dyes, each mapped to a season.

**Architecture:** Define 5 custom colors + 3 code syntax colors in `preamble.tex`. Update all 5 box environments to use them. Then update every TikZ diagram across 8 chapter files using a semantic warm-to-cool mapping (warm = action/speed, cool = abstraction/depth). Code syntax uses colorblind-safe blue/teal/gray.

**Tech Stack:** LaTeX xcolor `\definecolor{}{HTML}{}`, tcolorbox, TikZ, lstlistings

---

## Color Palette

### Box Colors (5 types)

| Box | Japanese Name | Hex | Season | Semantic |
|-----|-------------|-----|--------|----------|
| Exercise | Kitsune-iro (狐色, fox) | `#C3803A` | Autumn | Warmth of doing |
| Think First | Ai-iro (藍色, indigo) | `#004C71` | Winter | Depth of thought |
| Portfolio | Beni (紅, safflower) | `#B14A4A` | Summer | Culminating work |
| Why This Matters | Matcha (抹茶) | `#7B8B4E` | Spring | Growth/relevance |
| Research Taste | Sumi (墨, ink) | `#4A4A4A` | Timeless | Calligraphy ink |

### Code Syntax Colors (colorblind-safe)

| Role | Hex | LaTeX name |
|------|-----|-----------|
| Keywords | `#0077BB` | `codekey` |
| Comments | `#7F7F7F` | `codecomm` |
| Strings | `#009988` | `codestr` |

### Diagram Semantic Mapping

The old rainbow maps to Nippon colors by **temperature = abstraction level**:

| Old Color | New Color | Semantic Rule |
|-----------|-----------|--------------|
| red | beni | Hot/expensive/generation/cost |
| orange | kitsune | Intermediate/reward/cache |
| yellow | kitsune!50!white | Light warm (L2 cache, mild highlight) |
| green | matcha | Success/grounded/draft/hardware util |
| blue | aiiro | Systems/HBM/training/infrastructure |
| purple | aiiro!70!beni!30 | RL-specific (blend of depth + action) |
| gray | sumi | Neutral/idle/labels/axes |

---

## Task 1: Define Palette and Update Box Environments in `preamble.tex`

**Files:**
- Modify: `preamble.tex:12,22-58`

- [ ] **Step 1: Add color definitions after `\usepackage{xcolor}`**

After line 12 (`\usepackage{xcolor}`), add:

```latex
% --- Nippon Seasons palette (日本の伝統色) ---
\definecolor{kitsune}{HTML}{C3803A}   % 狐色 fox — autumn
\definecolor{aiiro}{HTML}{004C71}     % 藍色 indigo — winter
\definecolor{beni}{HTML}{B14A4A}      % 紅 safflower — summer
\definecolor{matcha}{HTML}{7B8B4E}    % 抹茶 tea — spring
\definecolor{sumi}{HTML}{4A4A4A}      % 墨 ink — timeless
% Colorblind-safe code syntax (Okabe-Ito derived)
\definecolor{codekey}{HTML}{0077BB}
\definecolor{codecomm}{HTML}{7F7F7F}
\definecolor{codestr}{HTML}{009988}
```

- [ ] **Step 2: Replace all 5 box definitions (lines 22-58)**

Replace the entire `% --- Workbook boxes ---` section with:

```latex
% --- Workbook boxes ---

% Exercise box (Kitsune — autumn warmth)
\newtcolorbox{exercise}[1][]{
  colback=kitsune!5!white, colframe=kitsune!80!black, boxrule=0.6pt,
  left=5pt, right=5pt, top=3pt, bottom=3pt,
  fonttitle=\bfseries\small, title=Exercise: #1,
  breakable
}

% Think-first box (Ai-iro — winter depth)
\newtcolorbox{thinkfirst}[1][]{
  colback=aiiro!5!white, colframe=aiiro!70!black, boxrule=0.5pt,
  left=5pt, right=5pt, top=3pt, bottom=3pt,
  fonttitle=\bfseries\small, title={Think First (no computer): #1},
  breakable
}

% Portfolio project box (Beni — summer culmination)
\newtcolorbox{portfolio}[1][]{
  colback=beni!5!white, colframe=beni!80!black, boxrule=0.6pt,
  left=5pt, right=5pt, top=3pt, bottom=3pt,
  fonttitle=\bfseries\small, title={Portfolio Project: #1},
  breakable
}

% Why this matters box (Matcha — spring relevance)
\newtcolorbox{whythis}{
  colback=matcha!5!white, colframe=matcha!70!black, boxrule=0.5pt,
  left=5pt, right=5pt, top=3pt, bottom=3pt,
  fonttitle=\bfseries\small, title=Why This Matters at Frontier Scale
}

% Research taste box (Sumi — timeless ink)
\newtcolorbox{taste}{
  colback=sumi!5!white, colframe=sumi!70!black, boxrule=0.5pt,
  left=5pt, right=5pt, top=3pt, bottom=3pt,
  fonttitle=\bfseries\small, title=Research Taste Check
}
```

- [ ] **Step 3: Verify preamble compiles**

Run: `cd /Users/amiyadiwan/Desktop/Karpathy/rl-at-scale && make`
Expected: Compiles without errors. Box colors changed.

- [ ] **Step 4: Commit**

```bash
git add preamble.tex
git commit -m "style: define Nippon Seasons palette and update box environments"
```

---

## Task 2: Update Code Syntax Highlighting in `textbook.tex` and `standalone.tex`

**Files:**
- Modify: `textbook.tex:22-24`
- Modify: `standalone.tex:22-24`

- [ ] **Step 1: Update textbook.tex syntax colors**

Replace lines 22-24:
```latex
  keywordstyle=\color{codekey}\bfseries,
  commentstyle=\color{codecomm}\itshape,
  stringstyle=\color{codestr},
```

- [ ] **Step 2: Update standalone.tex syntax colors (identical change)**

Same replacement at lines 22-24.

- [ ] **Step 3: Commit**

```bash
git add textbook.tex standalone.tex
git commit -m "style: use colorblind-safe code syntax highlighting"
```

---

## Task 3: Update `chapters/00-introduction.tex` Diagrams

**Files:**
- Modify: `chapters/00-introduction.tex`

Color references to update:

| Line | Old | New | Context |
|------|-----|-----|---------|
| 11 | `colback=purple!5!white, colframe=purple!50!black` | `colback=matcha!5!white, colframe=matcha!70!black` | Governing metric box |
| 34 | `gray!60` | `sumi!60` | Arrow style |
| 37 | `fill=blue!8` | `fill=aiiro!8` | PE tier box |
| 41 | `fill=purple!8` | `fill=beni!8` | RL tier box |
| 49 | `gray!70` | `sumi!70` | Text color |
| 62 | `fill=#1` | (no change — parametric) | Box style |
| 65 | `box=blue!10` | `box=aiiro!10` | PE box usage |
| 66 | `box=purple!10` | `box=beni!10` | RL box usage |

- [ ] **Step 1: Apply all color replacements**

- [ ] **Step 2: Verify compilation**

Run: `cd /Users/amiyadiwan/Desktop/Karpathy/rl-at-scale && make`

- [ ] **Step 3: Commit**

```bash
git add chapters/00-introduction.tex
git commit -m "style: apply Nippon palette to introduction diagrams"
```

---

## Task 4: Update `chapters/01-cuda-kernels.tex` Diagrams

**Files:**
- Modify: `chapters/01-cuda-kernels.tex`

Color references to update:

| Line | Old | New | Context |
|------|-----|-----|---------|
| 20 | `gray!50` | `sumi!50` | Arrow style |
| 22 | `fill=red!8` | `fill=beni!8` | Registers (fastest — hot) |
| 23 | `fill=orange!8` | `fill=kitsune!8` | Shared memory |
| 24 | `fill=yellow!8` | `fill=kitsune!30!white` | L2 cache (lighter warm) |
| 25 | `fill=blue!8` | `fill=aiiro!8` | HBM (slowest — cool) |
| 36-37 | `gray!60` | `sumi!60` | Text labels |
| 76-80 | `blue!70` | `aiiro!70` | H100 roofline curve + labels |
| 83-87 | `red!70` | `beni!70` | B200 roofline curve + labels |
| 90 | `fill=green!15` | `fill=matcha!15` | Decode region |
| 91 | `green!50!black` | `matcha!50!black` | Decode label |
| 95 | `fill=purple!10` | `fill=aiiro!15!beni!5` | Training region |
| 96 | `purple!50!black` | `aiiro!50!black` | Training label |

- [ ] **Step 1: Apply all color replacements**

- [ ] **Step 2: Verify compilation**

Run: `cd /Users/amiyadiwan/Desktop/Karpathy/rl-at-scale && make`

- [ ] **Step 3: Commit**

```bash
git add chapters/01-cuda-kernels.tex
git commit -m "style: apply Nippon palette to CUDA kernels diagrams"
```

---

## Task 5: Update `chapters/02-AMD-benchmarking.tex` Diagrams

**Files:**
- Modify: `chapters/02-AMD-benchmarking.tex`

| Line | Old | New | Context |
|------|-----|-----|---------|
| 70 | `fill=blue!8` | `fill=aiiro!8` | XCD style |
| 73 | `draw=gray!40, fill=gray!5` | `draw=sumi!40, fill=sumi!5` | Fabric style |
| 74 | `gray!50` | `sumi!50` | Link style |
| 87 | `fill=green!8` | `fill=matcha!8` | Node fill |
| 94,96,98 | `gray!60` | `sumi!60` | Text labels |

- [ ] **Step 1: Apply all color replacements**

- [ ] **Step 2: Commit**

```bash
git add chapters/02-AMD-benchmarking.tex
git commit -m "style: apply Nippon palette to AMD benchmarking diagrams"
```

---

## Task 6: Update `chapters/03-tpu-pallas.tex` Diagrams

**Files:**
- Modify: `chapters/03-tpu-pallas.tex`

| Line | Old | New | Context |
|------|-----|-----|---------|
| 33 | `gray!50` | `sumi!50` | Arrow style |
| 35 | `fill=red!8` | `fill=beni!8` | VREGs (fastest) |
| 36 | `fill=orange!8` | `fill=kitsune!8` | VMEM/SRAM |
| 37 | `fill=blue!8` | `fill=aiiro!8` | HBM |
| 43 | `gray!60` | `sumi!60` | Text label |
| 62 | `fill=blue!15` | `fill=aiiro!15` | DMA phase |
| 63 | `fill=orange!15` | `fill=kitsune!15` | Compute phase |
| 70 | `gray!50` | `sumi!50` | Arrow |
| 84 | `gray!40` | `sumi!40` | Brace |
| 86 | `gray!60` | `sumi!60` | Text label |

- [ ] **Step 1: Apply all color replacements**

- [ ] **Step 2: Commit**

```bash
git add chapters/03-tpu-pallas.tex
git commit -m "style: apply Nippon palette to TPU Pallas diagrams"
```

---

## Task 7: Update `chapters/04-inference-serving.tex` Diagrams

**Files:**
- Modify: `chapters/04-inference-serving.tex`

| Line | Old | New | Context |
|------|-----|-----|---------|
| 61 | `fill=green!8` | `fill=matcha!8` | Draft model |
| 62 | `fill=blue!8` | `fill=aiiro!8` | Verify/target model |
| 63 | `fill=orange!8` | `fill=kitsune!8` | Output tokens |
| 68-70 | `gray!60` | `sumi!60` | Text labels |
| 121 | `pattern color=red!30` | `pattern color=beni!30` | Waste pattern |
| 126,134-139 | `blue!20` | `aiiro!20` | Active batch fills |
| 126,134-139 | `green!20` | `matcha!20` | Backfilled batch fills |
| 129 | `gray!40` | `sumi!40` | Dashed line |
| 130 | `gray!50` | `sumi!50` | Text label |
| 143 | `blue!20` | `aiiro!20` | Legend fill |
| 144 | `green!20` | `matcha!20` | Legend fill |

- [ ] **Step 1: Apply all color replacements**

- [ ] **Step 2: Commit**

```bash
git add chapters/04-inference-serving.tex
git commit -m "style: apply Nippon palette to inference serving diagrams"
```

---

## Task 8: Update `chapters/05-policy-gradients.tex` Diagrams

**Files:**
- Modify: `chapters/05-policy-gradients.tex`

| Line | Old | New | Context |
|------|-----|-----|---------|
| 29 | `fill=red!25` | `fill=beni!25` | Compute cost bar |
| 30 | `fill=orange!20` | `fill=kitsune!20` | Memory cost bar |
| 31 | `fill=yellow!20` | `fill=kitsune!10!white` | Comm cost bar |
| 32 | `fill=blue!20` | `fill=aiiro!20` | Other cost bar |
| 33 | `fill=gray!15` | `fill=sumi!15` | Misc bar |
| 41 | `red!50` | `beni!50` | Brace |
| 43 | `red!60` | `beni!60` | Text label |
| 320-321 | `gray!50` | `sumi!50` | Axes |
| 324 | `blue!60` | `aiiro!60` | Before distribution curve |
| 326 | `blue!60` | `aiiro!60` | Before label |
| 329 | `red!60` | `beni!60` | After distribution curve |
| 331 | `red!60` | `beni!60` | After label |
| 334 | `red!40` | `beni!40` | Arrow |
| 335 | `red!40` | `beni!40` | Text label |

- [ ] **Step 1: Apply all color replacements**

- [ ] **Step 2: Commit**

```bash
git add chapters/05-policy-gradients.tex
git commit -m "style: apply Nippon palette to policy gradients diagrams"
```

---

## Task 9: Update `chapters/06-tinyrl-pipeline-scaling.tex` Diagrams

**Files:**
- Modify: `chapters/06-tinyrl-pipeline-scaling.tex`

| Line | Old | New | Context |
|------|-----|-----|---------|
| 211 | `left color=green!30, right color=red!30` | `left color=matcha!30, right color=beni!30` | Noise gradient |
| 232 | `green!50!black` | `matcha!50!black` | Label |
| 233 | `red!50!black` | `beni!50!black` | Label |
| 323 | `fill=blue!15` | `fill=aiiro!15` | Pretraining |
| 326 | `fill=blue!15` | `fill=aiiro!15` | Pretraining (95%) |
| 327 | `fill=gray!15` | `fill=sumi!15` | SFT |
| 328 | `fill=orange!15` | `fill=kitsune!15` | RLHF |
| 331 | `fill=blue!12` | `fill=aiiro!12` | Pretraining (new) |
| 332 | `fill=gray!12` | `fill=sumi!12` | SFT (new) |
| 333 | `fill=purple!20` | `fill=beni!20` | RLVR |
| 334 | `fill=orange!12` | `fill=kitsune!12` | RLHF (new) |
| 337 | `purple!50` | `beni!50` | Growth arrow |
| 338 | `purple!60` | `beni!60` | Label |

- [ ] **Step 1: Apply all color replacements**

- [ ] **Step 2: Commit**

```bash
git add chapters/06-tinyrl-pipeline-scaling.tex
git commit -m "style: apply Nippon palette to TinyRL pipeline diagrams"
```

---

## Task 10: Update `chapters/07-distributed-training.tex` Diagrams

**Files:**
- Modify: `chapters/07-distributed-training.tex`

| Line | Old | New | Context |
|------|-----|-----|---------|
| 141 | `fill=red!15` | `fill=beni!15` | Generation phase |
| 142 | `fill=orange!15` | `fill=kitsune!15` | Reward phase |
| 143 | `fill=gray!25, pattern color=gray!40` | `fill=sumi!25, pattern color=sumi!40` | Sync/idle phase |
| 144 | `fill=blue!15` | `fill=aiiro!15` | Training phase |
| 177 | `gray!50` | `sumi!50` | Sync barrier line |
| 178 | `gray!60` | `sumi!60` | Sync label |
| 181 | `gray!40` | `sumi!40` | Time axis |
| 186 | `red!15` | `beni!15` | Legend: generation |
| 187 | `orange!15` | `kitsune!15` | Legend: reward |
| 188 | `gray!25, pattern color=gray!40` | `sumi!25, pattern color=sumi!40` | Legend: idle |
| 189 | `blue!15` | `aiiro!15` | Legend: training |
| 242 | `gpu=blue!10` | `gpu=aiiro!10` | GPU 0 |
| 243 | `gpu=green!10` | `gpu=matcha!10` | GPU 1 |
| 244 | `gpu=orange!10` | `gpu=kitsune!10` | GPU 2 |
| 245 | `gpu=red!10` | `gpu=beni!10` | GPU 3 |
| 248 | `arr=blue!50` | `arr=aiiro!50` | GPU 0 arrow |
| 249 | `arr=green!50` | `arr=matcha!50` | GPU 1 arrow |
| 250 | `arr=orange!50` | `arr=kitsune!50` | GPU 2 arrow |
| 251 | `arr=red!50` | `arr=beni!50` | GPU 3 arrow |
| 254-257 | `gray!60` | `sumi!60` | Phase labels |

- [ ] **Step 1: Apply all color replacements**

- [ ] **Step 2: Commit**

```bash
git add chapters/07-distributed-training.tex
git commit -m "style: apply Nippon palette to distributed training diagrams"
```

---

## Task 11: Final Build and Visual Verification

- [ ] **Step 1: Full clean build**

```bash
cd /Users/amiyadiwan/Desktop/Karpathy/rl-at-scale && make clean && make
```

- [ ] **Step 2: Verify no xcolor errors**

Grep build log for `Undefined color` or `Package xcolor Error`.

- [ ] **Step 3: Visual spot-check**

Open `textbook.pdf` and verify:
- Page 5: "Why This Matters" box has matcha (green-tea) tint
- Ch01 memory hierarchy: warm-to-cool gradient (beni → kitsune → light kitsune → aiiro)
- Ch01 roofline: aiiro vs beni curves (not blue vs red)
- Ch07 timeline: beni generation, kitsune reward, sumi idle, aiiro training
- Ch07 GPU ring: 4 distinct Nippon colors
- Code listings: blue keywords, gray comments, teal strings

- [ ] **Step 4: Final commit**

```bash
git add -A
git commit -m "style: complete Nippon Seasons color scheme migration"
```

---

## Verification

1. `make clean && make` succeeds with no color-related errors
2. Open PDF and visually confirm all 5 box types show distinct Nippon colors
3. Confirm no leftover raw color references: `grep -rn 'colframe=yellow\|colframe=purple\|colframe=green\|colback=blue\|fill=red!' chapters/ preamble.tex`
4. Confirm code syntax colors: search for any remaining `green!50!black` or `red!60!black` in textbook.tex/standalone.tex
