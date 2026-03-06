# ============================================================
#  Northern Forest — PowerShell Profile
#  Equivalent of .zshrc for Windows + Starship + PSReadLine
# ============================================================

# --- PSReadLine ---
Import-Module PSReadLine

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -BellStyle None

# --- Northern Forest — PSReadLine syntax colors ---
Set-PSReadLineOption -Colors @{
    Command                = '#56d6b6'   # warm teal (commands)
    String                 = '#7ddba8'   # bright moss (strings)
    Comment                = '#3a4f4a'   # muted bark (comments)
    Keyword                = '#4dc4b0'   # glacier cyan (if/for/function)
    Variable               = '#c5d1cc'   # morning mist
    Parameter              = '#6b8580'   # dim mist (flags)
    Type                   = '#5b8fb4'   # twilight sky ([Type])
    Number                 = '#e8c478'   # bright amber
    Operator               = '#d4a35c'   # amber lichen (|, +, -eq)
    Member                 = '#56b68a'   # moss green (.Property)
    Error                  = '#d4555e'   # autumn berry
    Default                = '#c5d1cc'   # morning mist
    Selection              = '#1e3a34'   # deep forest (selection bg)
    Emphasis               = '#e8c478'   # bright amber (search highlight)
    ContinuationPrompt     = '#3a4f4a'   # muted bark
    InlinePrediction       = '#3a4f4a'   # muted (ghost text)
    ListPrediction         = '#6b8580'   # dim mist
    ListPredictionSelected = '#243838'   # twilight
}

# --- Key bindings ---
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# --- Terminal Icons (file icons in ls output) ---
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons
}

# --- Aliases ---
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name which -Value Get-Command
function touch { param([string]$Path) New-Item -ItemType File -Path $Path -Force | Out-Null }

# --- Starship prompt ---
Invoke-Expression (&starship init powershell)

# --- Fastfetch on launch ---
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch
}
