# chat-magic-output

**Скилл для OpenCode, который делает ответы в чате красивыми, структурными и легко читаемыми.** Плюс 7 цветовых палитр, интерактивное демо и библиотека готовых инфографических блоков.

> Формат этого README — пример вывода, который генерирует сам скилл.

[![Live Demo](https://img.shields.io/badge/Live_Demo-Open-7aa2f7?style=for-the-badge)](https://kingoff8.github.io/chat-magic-output/)
[![Repo](https://img.shields.io/badge/Repo-GitHub-181717?style=for-the-badge&logo=github)](https://github.com/Kingoff8/chat-magic-output)

🌐 **Живое демо:** https://kingoff8.github.io/chat-magic-output/

---

## Что это

Скилл задаёт правила оформления **каждого** ответа ассистента: ответ первым, короткие абзацы, списки и таблицы вместо «простыни», команды и код вместо описаний, без воды. Дополнительно — правила выбора цветовой палитры и набор переиспользуемых компонентов.

## Что внутри

| Файл | Назначение |
| --- | --- |
| `SKILL.md` | Правила, строительные блоки, шаблоны ответов, раздел палитр и правило первого запуска |
| `demo.html` | Интерактивный гайд: параллакс, split-сравнение, счётчики, 7 палитр, библиотека компонентов |
| `index.html` | Редирект на `demo.html` для GitHub Pages |
| `palette.txt` | Ваша палитра (создаётся при первом выборе, в репозиторий не попадает) |
| `README.md` | Этот файл |

## Плюсы

- ✅ **Читаемость** — ответ считывается за секунды: вывод в первых строках, детали ниже.
- ✅ **Единый стиль** — одинаковое оформление во всех сессиях и проектах.
- ✅ **Скорость восприятия** — заголовки, списки, таблицы и код вместо сплошного текста.
- ✅ **7 палитр** — от тёмной до фирменных OpenCode / DeepSeek / Harness / Codex / Cursor.
- ✅ **Офлайн** — демо и правила работают без интернета и зависимостей.
- ✅ **Переиспользование** — блоки копируются кнопками **Copy HTML / Copy CSS**.
- ✅ **Не мешает работе** — правило выбора палитры ничего не блокирует, можно пропустить.

## Палитры

| id | Название | Акцент |
| --- | --- | --- |
| `dark` | Тёмная | индиго `#7aa2f7` |
| `light` | Светлая | синий `#2f6fed` |
| `opencode` | OpenCode | тёплый `#f5a97f` |
| `deepseek` | DeepSeek | `#4D6BFE` |
| `harness` | Harness | бирюза `#00d4a0` |
| `codex` | Codex | зелёный OpenAI `#10A37F` |
| `cursor` | Cursor | фиолет `#6B5CE7` |

Переключить можно тремя способами: кнопкой 🎨 в демо, карточками в секции «Палитры» или ссылкой `demo.html?theme=deepseek`.

🌐 **Живое демо:** [kingoff8.github.io/chat-magic-output](https://kingoff8.github.io/chat-magic-output/) — открывается сразу, без установки.

## Установка

```bash
# вариант 1 — через skills CLI
npx skills add Kingoff8/chat-magic-output -g

# вариант 2 — вручную
git clone git@github.com:Kingoff8/chat-magic-output.git \
  ~/.config/opencode/skills/chat-magic-output
```

Windows-путь: `%USERPROFILE%\.config\opencode\skills\chat-magic-output\`. Скилл совместим с любым агентом, читающим `SKILL.md` (например, `~/.claude/skills/`).

После установки перезапустите OpenCode — правила подхватятся в новых сессиях.

## Как редактировать

### 1. Правила оформления

Откройте `SKILL.md` и правьте раздел **Golden rules** и **Building blocks**. После изменения перезапустите OpenCode.

```text
SKILL.md
├── Golden rules      ← главные правила
├── Building blocks   ← таблица «элемент → для чего → правило»
├── Response skeletons← шаблоны ответов
├── Anti-patterns     ← чего избегать
└── Color palettes    ← палитры и правило первого запуска
```

### 2. Цветовые палитры

Палитры живут в `demo.html` как блоки `[data-theme="…"]`. Добавьте свою, скопировав любой блок и поменяв переменные:

```css
[data-theme="custom"] {
  --bg: #101018;
  --panel: rgba(255,255,255,.05);
  --border: rgba(255,255,255,.1);
  --text: #f0f0f5;
  --muted: #9090a0;
  --accent: #ff6b9d;
  --accent-2: #ffd166;
  --ok: #4ade80; --warn: #fbbf24; --err: #fb7185; --info: #38bdf8;
  --code-bg: #0c0c14; --code-text: #dcdce6;
  --on-accent: #14060c;
  /* …остальные переменные скопируйте из соседнего блока… */
}
```

Затем добавьте в раздел «Палитры» кнопку `data-theme="custom"` и (при желании) в панель 🎨.

### 3. Компоненты и инфографика

Все блоки — в секции **«Библиотека компонентов»** демо: каллоут, карточка «плюсы/минусы/вердикт», статус-бейдж, прогресс-бар. Кнопка **Copy HTML** кладёт разметку в буфер, **Copy CSS** — всю таблицу стилей целиком.

### 4. Своя палитра по умолчанию

Запишите id в `palette.txt` (одно слово) — скилл будет использовать её и не станет спрашивать:

```text
opencode
```

## Первый запуск

При первом использовании скилла, если `palette.txt` пуст, ассистент **предложит выбрать палитру** (с подсказкой под текущую среду) и продолжит работу, не дожидаясь ответа. Если ни одна не подходит — опишите свои цвета, и будет собрана кастомная. Выбор сохранится, повторно спрашивать не будут.

---

## English

**chat-magic-output** is an OpenCode skill that makes every chat reply beautiful, scannable and easy to read: answer-first layout, short paragraphs, headings, bullets, tables and fenced code instead of walls of text — plus **7 color palettes** (dark, light, OpenCode, DeepSeek, Harness, Codex, Cursor), an interactive offline demo (`demo.html`) with parallax, a draggable before/after split and animated infographics, and a component library with one-click **Copy HTML / Copy CSS**. The palette choice is stored in `palette.txt`; on first run the skill offers to pick one if none is set. Install with `npx skills add Kingoff8/chat-magic-output -g` or clone into `~/.config/opencode/skills/`. Live demo: https://kingoff8.github.io/chat-magic-output/ . MIT licensed.
