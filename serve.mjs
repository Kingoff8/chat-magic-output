// chat-magic-output — мини-сервер для «живого» HTML-вывода.
// Страница опрашивает answer.md по http и анимирует замену контента.
// file:// не подходит: браузер блокирует чтение соседних файлов.
//
//   node serve.mjs <dir> [port]
//   node serve.mjs .chat-magic-output 8787   →  http://127.0.0.1:8787/

import { createServer } from "node:http";
import { readFile, stat } from "node:fs/promises";
import { extname, join, normalize, sep } from "node:path";

const root = process.argv[2] || ".";
const port = Number(process.argv[3] || 8787);

const types = {
  ".html": "text/html; charset=utf-8",
  ".md": "text/markdown; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".ico": "image/x-icon",
};

createServer(async (req, res) => {
  try {
    const url = new URL(req.url, "http://127.0.0.1");
    let p = decodeURIComponent(url.pathname);
    if (p === "/" || p.endsWith("/")) p += "answer.html";

    // не выпускаем за пределы root
    const file = join(root, normalize(p).replace(/^([/\\])+/, ""));
    if (!file.startsWith(root.endsWith(sep) ? root : root + sep) && file !== root) {
      res.writeHead(403).end("403");
      return;
    }

    const s = await stat(file);
    if (!s.isFile()) throw new Error("not a file");

    const buf = await readFile(file);
    res.writeHead(200, {
      "content-type": types[extname(file).toLowerCase()] || "application/octet-stream",
      "cache-control": "no-store, must-revalidate",
    });
    res.end(buf);
  } catch {
    res.writeHead(404, { "content-type": "text/plain; charset=utf-8" });
    res.end("404");
  }
}).listen(port, "127.0.0.1", () => {
  console.log(`chat-magic-output live: http://127.0.0.1:${port}/  (root: ${root})`);
});
