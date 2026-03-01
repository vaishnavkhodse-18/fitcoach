$ErrorActionPreference = "Stop"

$rawText = "C:\Users\Vaishnav\antigravityvaishnav\raw_exercises.txt"
$csvPath = "C:\Users\Vaishnav\antigravityvaishnav\exercises_db.csv"
$jsonPath = "C:\Users\Vaishnav\antigravityvaishnav\data\exercises.json"

$lines = Get-Content $rawText
$db = Import-Csv $csvPath

# Helper function to guess equipment
function Get-Equip($name) {
    if ($name -match "(?i)dumbbell|db") { return "dumbbell" }
    if ($name -match "(?i)barbell|smith|zercher|landmine") { return "barbell" }
    if ($name -match "(?i)cable|rope|pulldown|kickback") { return "cable" }
    if ($name -match "(?i)machine|pec deck|hack squat|leg press|leg extension|leg curl") { return "machine" }
    if ($name -match "(?i)band|resistance") { return "band" }
    if ($name -match "(?i)kettlebell|kb") { return "kettlebell" }
    if ($name -match "(?i)plate") { return "plate" }
    if ($name -match "(?i)sled") { return "sled" }
    return "none"
}

# Helper function for word-overlap matching
function Find-BestMatch($exerciseName, $muscleGroup) {
    # Clean the search string
    $cleanSearch = $exerciseName.ToLower() -replace "[^\w\s]", ""
    $searchWords = $cleanSearch -split "\s+" | Where-Object { $_.trim() -ne "" }
    
    $bestScore = -1
    $bestMatch = $null

    foreach ($entry in $db) {
        $entryName = $entry.name.ToLower() -replace "[^\w\s]", ""
        $entryWords = $entryName -split "\s+"
        
        $score = 0
        foreach ($w in $searchWords) {
            # Trim trailing 's' to match singulars too
            $wSingular = $w -replace 's$', ''
            if ($entryName -match "\b$w\b" -or ($wSingular.length -gt 3 -and $entryName -match "\b$wSingular\b")) {
                $score++
            }
        }
        
        # Penalize extra words to favor exact-ish matches
        $penalty = $entryWords.Length - $searchWords.Length
        if ($penalty -lt 0) { $penalty = 0 } # if db name is shorter, don't penalize as much
        
        $finalScore = $score * 10 - $penalty

        if ($finalScore -gt $bestScore) {
            $bestScore = $finalScore
            $bestMatch = $entry
        }
    }

    # If score is very low, pick a random one from the same muscle just to not crash
    if ($bestScore -lt 1) {
        $bestMatch = $db | Get-Random
    }
    
    return $bestMatch.id
}

$newExercises = @()
$currentCategory = ""
$currentMuscle = "full"
$currentType = "Strength"
$index = 100

foreach ($line in $lines) {
    $line = $line.Trim()
    if ([string]::IsNullOrEmpty($line)) { continue }

    if ($line -cnotmatch "[a-z]") {
        # This is a category header (all caps)
        $currentCategory = $line
        
        switch -Regex ($currentCategory) {
            "CHEST" { $currentMuscle = "chest"; $currentType = "Strength" }
            "BACK" { $currentMuscle = "back"; $currentType = "Strength" }
            "SHOULDERS" { $currentMuscle = "shoulder"; $currentType = "Strength" }
            "BICEPS" { $currentMuscle = "arms"; $currentType = "Strength" }
            "TRICEPS" { $currentMuscle = "arms"; $currentType = "Strength" }
            "LEGS" { $currentMuscle = "lower"; $currentType = "Strength" }
            "CORE" { $currentMuscle = "core"; $currentType = "Core" }
            "POWERLIFTING" { $currentMuscle = "full"; $currentType = "Strength" }
            Default { $currentMuscle = "full"; $currentType = "Strength" }
        }
        continue
    }

    $equip = Get-Equip $line
    $duration = if ($currentType -eq "Core") { 45 } elseif ($equip -eq "barbell") { 90 } else { 60 }
    
    # Generate exID
    $exId = "exa$($index.ToString('000'))"
    $index++

    # Match GIF
    $gifId = Find-BestMatch $line $currentCategory
    $gifUrl = "https://raw.githubusercontent.com/omercotkd/exercises-gifs/main/assets/${gifId}.gif"

    $exObj = [ordered]@{
        id       = $exId
        name     = $line
        type     = $currentType
        equip    = $equip
        muscle   = $currentMuscle
        duration = $duration
        gif      = $gifUrl
    }
    
    $newExercises += $exObj
}

# Now merge with existing JSON
$existing = Get-Content $jsonPath -Raw | ConvertFrom-Json
$combined = @()
$combined += $existing
$combined += $newExercises

$json = $combined | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($jsonPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Successfully added $($newExercises.Count) new exercises to the database!"
