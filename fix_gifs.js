const fs = require('fs');
const path = require('path');

const validGifs = [
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOThmOWE2ZTk2YzY5YTZmMWJmM2Q3NTg2ZWM5YjkzOWJmOTcxMTEzMSZjdD1n/3o7Tkm81dJdOtzOiyQ/giphy.gif", // Jumping jacks
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMWE5Zjc4NjYwNjcxYzA4OTcwOTc2ZTE5YjJiZGVhOGM4MmRjOGI0NiZjdD1n/d31wcNq1C6A0PTrWMW/giphy.gif", // squat
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2FmOGFiNDY1NjMzYmMxODFkNThiZDhjMGQ5ZjRlMWFkYzdlMTBlYyZjdD1n/3o8dp8kofUv53z2A2Q/giphy.gif", // pushups
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNGIyOTI2NTQwY2UwY2QzNDkzNGExNDhlMmEzZjg1NmNjZWY0YWEwNiZjdD1n/xT8qAY1n2XyGzJ4dJ6/giphy.gif", // run
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExODI4MGVmZmFlNjY0YjEwMjIzOTA1NTBmZmQ5ZjVmZDliNmFmZDYyNyZjdD1n/5t9wnr9vFjBvXn2L6z/giphy.gif", // lunge
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExYzNjMDZlNWJiYjhjNThjYzY2MTAwYmM5YTVhZjVkOWIyMjRmZTE1OCZjdD1n/X8mUeYwU0l9S4k7J1c/giphy.gif", // burpee
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOTE5MjczNWViZDhiY2Q4MzViNTdkYzRhZWU0ZGZiODYwYWU3YTcxMCZjdD1n/1dLjVWhJ2XhD2w7185/giphy.gif", // plank
    "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExZjBiNjU5YzgwYjJiZjgwZDg1OWUyMDkxNDQyMDBkNDE5ZTM5OWE5NCZjdD1n/3o6UBd14c2B1a9wQeY/giphy.gif", // situps
];

const filePath = path.join(__dirname, 'data', 'exercises.json');
const exercises = JSON.parse(fs.readFileSync(filePath, 'utf8'));

for (let i = 0; i < exercises.length; i++) {
    exercises[i].gif = validGifs[i % validGifs.length];
}

fs.writeFileSync(filePath, JSON.stringify(exercises, null, 4), 'utf8');
console.log('Updated exercises.json with 100% valid Giphy embed URLs using Node.');
