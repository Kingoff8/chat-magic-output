#Requires -Version 5.1
<#
.SYNOPSIS
  Render a Markdown answer to a styled HTML page (chat-magic-output).

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
$skillDir = $PSScriptRoot
$tplPath  = Join-Path $skillDir "output-template.html"

if (-not (Test-Path -LiteralPath $tplPath)) { throw "Template not found: $tplPath" }
if (-not (Test-Path -LiteralPath $Markdown)) { throw "Markdown not found: $Markdown" }

$tpl = Get-Content -LiteralPath $tplPath -Raw -Encoding UTF8
$md  = Get-Content -LiteralPath $Markdown -Raw -Encoding UTF8

# base64 keeps any characters (including `</script>` and quotes) safe
$b64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($md))

$safeTheme = ($Theme -replace '[^A-Za-z0-9_-]', '')
$safeTitle = [System.Net.WebUtility]::HtmlEncode($Title)

$html = $tpl.Replace('__TITLE__', $safeTitle).Replace('__THEME__', $safeTheme).Replace('__B64__', $b64)

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
