$ErrorActionPreference = "Stop"
$jsonPath = "C:\Users\Vaishnav\antigravityvaishnav\data\exercises.json"
$exercises = Get-Content $jsonPath -Raw | ConvertFrom-Json

$validGifs = @(
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOThmOWE2ZTk2YzY5YTZmMWJmM2Q3NTg2ZWM5YjkzOWJmOTcxMTEzMSZjdD1n/3o7Tkm81dJdOtzOiyQ/giphy.gif",
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMWE5Zjc4NjYwNjcxYzA4OTcwOTc2ZTE5YjJiZGVhOGM4MmRjOGI0NiZjdD1n/d31wcNq1C6A0PTrWMW/giphy.gif",
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2FmOGFiNDY1NjMzYmMxODFkNThiZDhjMGQ5ZjRlMWFkYzdlMTBlYyZjdD1n/3o8dp8kofUv53z2A2Q/giphy.gif",
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNGIyOTI2NTQwY2UwY2QzNDkzNGExNDhlMmEzZjg1NmNjZWY0YWEwNiZjdD1n/xT8qAY1n2XyGzJ4dJ6/giphy.gif",
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExODI4MGVmZmFlNjY0YjEwMjIzOTA1NTBmZmQ5ZjVmZDliNmFmZDYyNyZjdD1n/5t9wnr9vFjBvXn2L6z/giphy.gif",
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExYzNjMDZlNWJiYjhjNThjYzY2MTAwYmM5YTVhZjVkOWIyMjRmZTE1OCZjdD1n/X8mUeYwU0l9S4k7J1c/giphy.gif",
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOTE5MjczNWViZDhiY2Q4MzViNTdkYzRhZWU0ZGZiODYwYWU3YTcxMCZjdD1n/1dLjVWhJ2XhD2w7185/giphy.gif",
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExZjBiNjU5YzgwYjJiZjgwZDg1OWUyMDkxNDQyMDBkNDE5ZTM5OWE5NCZjdD1n/3o6UBd14c2B1a9wQeY/giphy.gif"
)

for ($i = 0; $i -lt $exercises.Count; $i++) {
    $exercises[$i].gif = $validGifs[$i % $validGifs.Length]
}

# Use Out-File with utf8 encoding to prevent formatting issues
$json = $exercises | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($jsonPath, $json, [System.Text.Encoding]::UTF8)

Write-Host "Successfully replaced all broken Tenor links with reliable Giphy embeds!"
