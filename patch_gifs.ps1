$ErrorActionPreference = "Stop"
$jsonPath = "C:\Users\Vaishnav\antigravityvaishnav\data\exercises.json"
$exercises = Get-Content $jsonPath -Raw | ConvertFrom-Json

$manualMap = @{
    "Jumping Jacks"          = "3224"
    "High Knees"             = "3655"
    "Butt Kicks"             = "3220"
    "Arm Circles"            = "3214"
    "Lunges"                 = "3582"
    "Jump Squats"            = "0514"
    "Diamond Push Ups"       = "0283"
    "Pike Push Ups"          = "3662"
    "Plank"                  = "0464"
    "Crunches"               = "0274"
    "Leg Raises"             = "0620"
    "Russian Twists"         = "0687"
    "Burpees"                = "1160"
    "Mountain Climbers"      = "2466"
    "Barbell Squats"         = "0043"
    "Leg Press"              = "2287"
    "Bench Press"            = "0025"
    "Incline Dumbbell Press" = "1512"
    "Lat Pulldown"           = "2330"
    "Barbell Rows"           = "0027"
    "Deadlift"               = "0032"
    "Cable Crunches"         = "0174"
    "Hanging Leg Raises"     = "0472"
    "Treadmill Walk"         = "3666"
    "Bicep Curls"            = "1634"
    "Tricep Extensions"      = "0018"
    "Bulgarian Split Squats" = "1368"
    "Romanian Deadlift"      = "0085"
    "Goblet Squat"           = "1760"
    "Leg Extensions"         = "0585"
    "Hamstring Curls"        = "0599"
    "Calf Raises"            = "0999"
    "Overhead Press"         = "1012"
    "Lateral Raises"         = "0977"
    "Front Raises"           = "0978"
    "Face Pulls"             = "0977"
    "Pull Ups"               = "0652"
    "Dips"                   = "1399"
    "Bicycle Crunches"       = "0972"
    "Ab Wheel Rollouts"      = "0276"
    "Dead Bugs"              = "0276"
    "Kettlebell Swings"      = "0549"
    "Box Jumps"              = "1374"
    "Battle Ropes"           = "0128"
    "Hip Thrusts"            = "3236"
    "Glute Bridges"          = "1409"
    "Shadow Boxing"          = "3361"
    "Pistol Squats"          = "0544"
}

foreach ($ex in $exercises) {
    if ($manualMap.ContainsKey($ex.name)) {
        $id = $manualMap[$ex.name]
        $ex.gif = "https://raw.githubusercontent.com/omercotkd/exercises-gifs/main/assets/${id}.gif"
    }
    else {
        # Keep existing if not mapped, but maybe fix the bodyweight squat
        if ($ex.name -eq "Bodyweight Squats") {
            $ex.gif = "https://raw.githubusercontent.com/omercotkd/exercises-gifs/main/assets/1368.gif"
        }
        if ($ex.name -eq "Push Ups") {
            $ex.gif = "https://raw.githubusercontent.com/omercotkd/exercises-gifs/main/assets/0662.gif"
        }
    }
}

$json = $exercises | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($jsonPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Manual fixes complete!"
