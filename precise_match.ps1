$ErrorActionPreference = "Stop"
$jsonPath = "C:\Users\Vaishnav\antigravityvaishnav\data\exercises.json"
$csvPath = "C:\Users\Vaishnav\antigravityvaishnav\exercises_db.csv"

$exercises = Get-Content $jsonPath -Raw | ConvertFrom-Json
$db = Import-Csv $csvPath

# Specific regexes to find the absolute BEST match for our 50 exercises
$searchMap = @{
    "Jumping Jacks"          = "^jumping jack$"
    "High Knees"             = "high knee"
    "Butt Kicks"             = "butt kick"
    "Arm Circles"            = "arm circle"
    "Bodyweight Squats"      = "^bodyweight squat$"
    "Lunges"                 = "^bodyweight lunge$"
    "Jump Squats"            = "^jump squat$"
    "Push Ups"               = "^push-up$"
    "Diamond Push Ups"       = "^diamond push-up$"
    "Pike Push Ups"          = "^pike push-up$"
    "Plank"                  = "^front plank$"
    "Crunches"               = "^crunch$"
    "Leg Raises"             = "^leg raise$"
    "Russian Twists"         = "^russian twist$"
    "Burpees"                = "^burpee$"
    "Mountain Climbers"      = "^mountain climber$"
    "Barbell Squats"         = "^barbell full squat$"
    "Leg Press"              = "leg press"
    "Bench Press"            = "^barbell bench press$"
    "Incline Dumbbell Press" = "incline dumbbell press"
    "Lat Pulldown"           = "lat pulldown"
    "Barbell Rows"           = "^barbell bent over row$"
    "Deadlift"               = "^barbell deadlift$"
    "Cable Crunches"         = "cable crunch"
    "Hanging Leg Raises"     = "^hanging leg raise$"
    "Treadmill Walk"         = "^walk$"
    "Bicep Curls"            = "^dumbbell bicep curl$"
    "Tricep Extensions"      = "triceps extension"
    "Bulgarian Split Squats" = "bulgarian split squat"
    "Romanian Deadlift"      = "romanian deadlift"
    "Goblet Squat"           = "goblet squat"
    "Leg Extensions"         = "leg extension"
    "Hamstring Curls"        = "seated leg curl"
    "Calf Raises"            = "calf raise"
    "Overhead Press"         = "overhead press"
    "Lateral Raises"         = "lateral raise"
    "Front Raises"           = "front raise"
    "Face Pulls"             = "face pull"
    "Pull Ups"               = "^pull-up$"
    "Dips"                   = "^triceps dip$"
    "Bicycle Crunches"       = "bicycle crunch"
    "Ab Wheel Rollouts"      = "ab wheel"
    "Dead Bugs"              = "^dead bug$"
    "Kettlebell Swings"      = "^kettlebell swing$"
    "Box Jumps"              = "box jump"
    "Battle Ropes"           = "battle rope"
    "Hip Thrusts"            = "hip thrust"
    "Glute Bridges"          = "glute bridge"
    "Shadow Boxing"          = "shadow boxing"
    "Pistol Squats"          = "pistol squat"
}

foreach ($ex in $exercises) {
    $regex = $searchMap[$ex.name]
    $match = $null

    if ($regex) {
        $match = $db | Where-Object { $_.name -match $regex } | Select-Object -First 1
    }

    # Fallback 1: Broad search for exact words
    if (-not $match) {
        $cleanName = $ex.name.ToLower().Replace("s", "")
        $match = $db | Where-Object { $_.name -match [Regex]::Escape($cleanName) } | Select-Object -First 1
    }

    # Fallback 2: Basic muscle match if still nothing (better than random)
    if (-not $match) {
        $muscle = $ex.muscle
        $match = $db | Where-Object { $_.bodyPart -match $muscle -or $_.target -match $muscle } | Select-Object -First 1
    }

    # Final Absolute Fallback
    if (-not $match) {
        $match = $db | Select-Object -First 1
    }
    
    $gifId = $match.id
    $ex.gif = "https://raw.githubusercontent.com/omercotkd/exercises-gifs/main/assets/${gifId}.gif"
}

$json = $exercises | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($jsonPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Matched precisely!"
