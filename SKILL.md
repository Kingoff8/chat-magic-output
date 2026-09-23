---
name: chat-magic-output
description: "Use for every user-facing chat reply to keep it beautiful, scannable and easy to read. Applies to any OpenCode answer: headings, short paragraphs, bullets, numbered steps, tables, code fences, status markers, file references, summaries, reports, diffs, explanations, error reports. Triggers: formatting, readability, response structure, presentation of results, 'красиво', 'читаемо', 'понятно'."
---

# Chat Magic Output

Make every reply **scannable, structured and pleasant to read**. Optimize for the
reader's eye first, not for token count. Apply this to all user-facing messages,
not to files, commit messages, or code you write.

## Golden rules

1. **Answer first.** Put the result or conclusion in the first 1–2 lines. Details after.
2. **Short paragraphs.** Max 3–4 lines, always separated by a blank line. Never a wall of text.
3. **Structure over prose.** Use headings, bullets, numbered lists, tables and code blocks instead of long sentences.
4. **One idea per bullet.** Keep bullets parallel and start each with a meaningful word.
5. **Show, don't tell.** Prefer an exact command or snippet over a verbal description of it.
6. **Whitespace is free.** Blank line before/after headings, lists, tables and code fences.
7. **Match the user's language** (Russian in → Russian out) and their level of formality.
8. **No filler.** Drop "Sure", "Great question", "As an AI…", and don't restate the question.
9. **Keep tables narrow** enough for a terminal (~80–100 chars). Split wide tables instead of overflowing.

## Building blocks

| Element | Use it for | Rule |
| --- | --- | --- |
| `## Heading` | Sections of a longer answer | Short noun phrases, not sentences |
| `-` bullets | Lists, options, findings | One idea, parallel wording |
| `1.` numbered | Steps, sequences, priorities | Only when order matters |
| Table | Comparisons, options, status | No wide free-text cells |
| ```` ```lang ```` | Commands, code, config | Always tag the language |
| `` `path/file:12` `` | Paths, commands, symbols, env vars | Inline code, never plain text |
| **Bold** | Key terms, verdicts | Sparingly; never whole sentences |
| ✅ / ❌ / ⚠️ / ℹ️ | Status at a glance | As markers only, not decoration |

## File and code references

- Reference files as inline code: `` `src/server.ts` ``, with a line when useful: `` `src/server.ts:120` ``.
- Quote the **smallest** relevant snippet, not whole files. Prefix long quotes with the file path.
- For differences, prefer a fenced `diff` block over prose.

## Response skeletons

Use these for non-trivial replies; skip them for one-liners.

**Task completed**

```text
<one-line result>

**Что сделано**
- <change> — `<file>`

**Проверка**
- `<command>` → <expected result>
```

**Findings / analysis**

```text
<one-line conclusion>

## <topic>
- **<point>** — <one-line explanation>

## Вывод
<what it means / recommendation>
```

**Blocked / error**

```text
⚠️ <one-line problem>

**Причина:** <why>
**Что нужно:** <the one thing required from the user>
```

## Length

- Short by default: as long as necessary, as short as possible.
- If the answer exceeds ~15 lines, add headings so it can be skimmed.
- Never pad with summaries that repeat the body.

## Anti-patterns

- ❌ Multi-paragraph walls with no breaks or structure.
- ❌ Emoji spam or decorative icons in every line.
- ❌ Vague prose where a command or snippet is clearer.
- ❌ Over-nesting bullets (`•` under `•` under `•`) — flatten or use a table.
- ❌ Duplicating the same information in prose and in a list.

## Interactive demo & reusable components

`demo.html` (next to this file) is a self-contained, offline interactive guide:
parallax hero, a draggable before/after split, comparison cards, animated
counters, progress bars, step timeline, status cards, a copyable code block and
a component library with **Copy HTML / Copy CSS** buttons. It ships **7 color
palettes** with a 🎨 switcher and a "Палитры" section. Open it in a browser to
preview the style and copy ready-made infographic blocks for reuse.

## Color palettes

Presets are applied with `data-theme="<id>"` on `<html>`. The demo also accepts
`demo.html?theme=<id>` (and remembers the last choice in `localStorage`).

| id | Name | Accent |
| --- | --- | --- |
| `dark` | Тёмная | indigo `#7aa2f7` |
| `light` | Светлая | blue `#2f6fed` |
| `opencode` | OpenCode | warm amber `#f5a97f` |
| `deepseek` | DeepSeek | `#4D6BFE` |
| `harness` | Harness | teal/mint `#00d4a0` |
| `codex` | Codex | OpenAI green `#10A37F` |
| `cursor` | Cursor | violet `#6B5CE7` |

Brand-matched accents are approximations; tweak the `[data-theme="…"]` block in
`demo.html` if you have exact brand hexes.

### First-run rule (palette)

The user's palette preference lives in `palette.txt` next to this file (one
theme id, no whitespace).

- **On first activation**, if `palette.txt` is missing or empty: briefly offer
  to pick a palette, listing the presets. Suggest the one that matches the
  environment — `opencode` when running in OpenCode, `dark`/`light` to match the
  terminal background — and continue without blocking the task.
- If the user says none of the presets fit, derive a **custom palette** from
  their description (background, accent, accent-2, plus ok/warn/err/info) and
  add it as a new `[data-theme="custom"]` block in `demo.html`.
- Persist the choice by writing the chosen id to `palette.txt`.
  **Do not ask again** while the file exists; just use it.
- Apply the chosen palette to any HTML/infographic you generate
  (`<html data-theme="<id>">`); for the demo open `demo.html?theme=<id>`.
- If the user asks to change the palette, update `palette.txt` and switch the
  demo/artifacts — no need to re-ask every session.
