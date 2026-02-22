# Cold Landscape

A dark theme for Visual Studio Code inspired by cold, foggy landscapes — designed to reduce eye strain during long coding sessions.

---

[img](/assets/image.png)

## Philosophy

Cold Landscape was built around a single idea: your editor should feel like looking out at a frozen lake on a cloudy morning. Every color decision prioritizes comfort over decoration. The palette was extracted from photographs of cold landscapes — frozen lakes, overcast skies, conifer forests, blue-shadowed snow, and moss on stone.

The theme combines the neutral backgrounds of VS Code Dark Modern with accent colors derived from that photographic palette. Saturation is kept between 40% and 70% across the board: vivid enough to create clear visual hierarchy, soft enough to stay comfortable after hours of work.

---

## Color Palette

### Backgrounds

The background stack uses a series of very close neutral dark tones. The difference between each level is intentional and subtle — the goal is depth without heavy shadows.

| Role | Hex | Description |
|---|---|---|
| Editor | `#1e1e1e` | Near-black neutral — the anchor |
| Sidebar / panels | `#252526` | One step above the editor |
| Activity Bar | `#2c2c2c` | Subtle separation from the sidebar |
| Title Bar / Status Bar | `#1a1a1a` | Slightly darker than the editor |
| Hover / soft selection | `#2d2d30` | Faint cool bias for hover states |
| Input fields | `#3c3c3c` | Clearly distinct from the background |

### Syntax Colors

Each accent color maps to a semantic role and was chosen to be distinguishable from its neighbors both by hue and by perceived temperature.

| Role | Hex | Tone | Notes |
|---|---|---|---|
| Base text — variables, operators | `#cdd1d4` | Cold white | The most present color; comfortable for sustained reading |
| Keywords (`if`, `for`, `class`, `import`) | `#7cb7d4` | Glacial blue | The most immediately recognizable color in any file |
| Strings | `#a8c7a0` | Muted moss green | Strings are long and frequent — the color must not be aggressive |
| Functions and methods | `#c8aee0` | Foggy lavender | Distinguishes calls from operators and types |
| Types, interfaces, enums (references) | `#9ecfd4` | Cold cyan | Close to blue but perceptually distinct |
| Numbers, constants, enum members | `#d4b896` | Cold sandy beige | Warm tone within a cold palette — temperature contrast |
| Parameters | `#d4b896` italic | Cold sandy beige | Same beige as numbers, italicized to separate from variables |
| Comments | `#5c6370` | Medium gray | Intentionally recedes — readable when you want, invisible when you don't |
| Delimiters — brackets, braces, parens | `#6c7a80` | Bluish gray | Present but not attention-grabbing |
| Errors | `#c17c7c` | Desaturated red | Signals a problem without visual aggression |
| Warnings | `#c4a76a` | Cold ochre | Distinct from errors without using neon yellow |

### UI Accent Colors

| Role | Hex | Notes |
|---|---|---|
| Cursor (caret) | `#7cb7d4` | Same as keywords — a consistent visual anchor |
| Text selection | `#2d4a5a` | Very dark blue — does not compete with selected text |
| Current line highlight | `#232a2d` | Minimal difference from the background, just perceptible |
| Indentation guides | `#383838` | Nearly invisible — guides without distracting |
| Bracket match | `#4a6270` | Slightly more vivid than the normal delimiter |
| Active tab indicator | `#7cb7d4` | Glacial blue, consistent with keywords |
| Git modified (gutter) | `#7cb7d4` | Blue, consistent temperature |
| Git added (gutter) | `#a8c7a0` | Moss green, consistent |
| Git deleted (gutter) | `#c17c7c` | Desaturated red, consistent |

---

## Design Principles

**Clear visual hierarchy.** The eye should instantly know what is active code, what is a comment, and what is background — without conscious effort.

**Controlled saturation.** Accent colors are vivid but not maximally saturated. The 40–70% saturation range is enough to stand out without being harsh.

**Consistent temperature.** The entire palette stays cold. Mixing warm and cold accents randomly creates visual dissonance; the single warm tone (`#d4b896`) is used precisely *because* it creates a deliberate temperature contrast for numbers and constants.

**Functional contrast, not decorative.** Every contrast decision has a purpose — legibility, hierarchy, or area delimitation. Nothing is there just to look interesting.

---

## Contrast and Accessibility

All primary syntax colors target WCAG AA compliance (4.5:1 minimum contrast ratio against the editor background). The most-used colors — base text, keywords, strings, and functions — aim for 5:1 to 7:1. Comments intentionally fall below 4.5:1; this is a deliberate design choice so they visually recede while remaining readable on demand.

---

## Supported Languages

The theme includes carefully tuned token scopes for:

- JavaScript and TypeScript (including JSX/TSX)
- Python, Rust, C, C++, C#, Ruby, Haskell, OCaml, Clojure, F#
- HTML and CSS
- JSON, YAML, XML
- Markdown
- SQL
- Docker Compose

---

## Installation

1. Clone or download this repository.
2. Open VS Code and run `Developer: Install Extension from Location...` from the Command Palette.
3. Select the root folder of this repository.
4. Open the Command Palette again, run `Preferences: Color Theme`, and select **Cold Landscape**.

---

## Requirements

VS Code `^1.75.0`
