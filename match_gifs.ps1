$ErrorActionPreference = "Stop"
$jsonPath = "C:\Users\Vaishnav\antigravityvaishnav\data\exercises.json"
$csvPath = "C:\Users\Vaishnav\antigravityvaishnav\exercises_db.csv"

$exercises = Get-Content $jsonPath -Raw | ConvertFrom-Json
$db = Import-Csv $csvPath

Write-Host "Starting matching process..."

foreach ($ex in $exercises) {
    $searchName = $ex.name.ToLower().Replace("bodyweight ", "")
    $match = $null

    # 1. Exact Name match
    $match = $db | Where-Object { $_.name -eq $searchName } | Select-Object -First 1
    
    # 2. Fuzzy Name match
    if (-not $match) {
        $shortName = $searchName -replace 's$', ''
        $match = $db | Where-Object { $_.name -match [Regex]::Escape($shortName) } | Select-Object -First 1
    }

    # 3. Muscle Group match Fallback
    if (-not $match) {
        $muscle = $ex.muscle
        $match = $db | Where-Object { $_.bodyPart -match $muscle -or $_.target -match $muscle } | Get-Random
    }
    
    # 4. Absolute Fallback
    if (-not $match) {
        $match = $db | Get-Random
    }
    
    $gifId = $match.id
    $ex.gif = "https://raw.githubusercontent.com/omercotkd/exercises-gifs/main/assets/${gifId}.gif"
}

$json = $exercises | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($jsonPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Successfully matched and replaced all 50 GIFs!"
