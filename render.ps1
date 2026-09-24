#Requires -Version 5.1
<#
.SYNOPSIS
  Render a Markdown answer to a styled HTML page (chat-magic-output).

.DESCRIPTION
  The look comes from demo.html: its <style> blocks are injected verbatim, then
  prose.css adds the element/helper styles demo.html does not define. demo.html
  stays the single source of truth, so the rendered answer always matches the
  demo styling. Do not inline a separate copy of the CSS here.

.EXAMPLE
  powershell -File render.ps1 -Markdown .chat-magic-output/answer.md -Out .chat-magic-output/answer.html -Theme opencode
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Markdown,
  [Parameter(Mandatory = $true)][string]$Out,
  [string]$Theme = "opencode",
  [string]$Title = "chat-magic-output"
)

$ErrorActionPreference = "Stop"
$skillDir  = $PSScriptRoot
$tplPath   = Join-Path $skillDir "output-template.html"
$demoPath  = Join-Path $skillDir "demo.html"
$prosePath = Join-Path $skillDir "prose.css"

if (-not (Test-Path -LiteralPath $tplPath)) { throw "Template not found: $tplPath" }
if (-not (Test-Path -LiteralPath $Markdown)) { throw "Markdown not found: $Markdown" }

# --- CSS: demo.html is the single source of truth for the look -------------
$demoCss = ""
if (Test-Path -LiteralPath $demoPath) {
  $demo = Get-Content -LiteralPath $demoPath -Raw -Encoding UTF8
  $demoCss = ([regex]::Matches($demo, '(?s)<style>(.*?)</style>') |
      ForEach-Object { $_.Groups[1].Value }) -join "`n"
}
else {
  Write-Warning "demo.html not found - rendering with prose.css only"
}

$proseCss = ""
if (Test-Path -LiteralPath $prosePath) {
  $proseCss = Get-Content -LiteralPath $prosePath -Raw -Encoding UTF8
}

$css = ($demoCss, $proseCss | Where-Object { $_ -and $_.Trim() }) -join "`n"
if ([string]::IsNullOrWhiteSpace($css)) { $css = "body{font-family:system-ui;padding:40px}" }

# --- render ----------------------------------------------------------------
$tpl = Get-Content -LiteralPath $tplPath -Raw -Encoding UTF8
$md  = Get-Content -LiteralPath $Markdown -Raw -Encoding UTF8

# base64 keeps any characters (including `</script>` and quotes) safe
$b64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($md))

$safeTheme = ($Theme -replace '[^A-Za-z0-9_-]', '')
$safeTitle = [System.Net.WebUtility]::HtmlEncode($Title)

$html = $tpl.
  Replace('__CSS__', $css).
  Replace('__TITLE__', $safeTitle).
  Replace('__THEME__', $safeTheme).
  Replace('__B64__', $b64)

$full = [System.IO.Path]::GetFullPath($Out)
$dir  = [System.IO.Path]::GetDirectoryName($full)
if ($dir -and -not (Test-Path -LiteralPath $dir)) {
  New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

# keep the disposable render folder out of git
if ($dir -and (Split-Path -Leaf $dir) -eq '.chat-magic-output') {
  $gi = Join-Path $dir '.gitignore'
  if (-not (Test-Path -LiteralPath $gi)) { Set-Content -LiteralPath $gi -Value '*' -Encoding UTF8 }
}

$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($full, $html, $utf8)

Write-Output $full
