# MATLAB_Snake_Game
Snake Game developed using MATLAB
Snake Game (MATLAB GUI)
🎮 Overview

This is a classic Snake Game developed using MATLAB GUI. The game is designed to run in MATLAB using GUIDE and includes modern enhancements such as high score tracking, pause and restart functionality, levels & speed display, and wall collision toggle.

The snake moves around a 100x100 grid, eating red food to grow. Avoid collisions with yourself or the walls (if wall collision is enabled). The game features a soft notification sound, red food, and clear visible boundaries for smooth gameplay.

🛠 Features

Snake Movement: Controlled using arrow keys or GUI buttons.

Red Food: Snake eats food to grow; new food appears in a random location.

High Score System: Tracks and saves your highest score across sessions.

Pause, Restart, and End Game: Full game control at any time.

Levels & Speed Display: Game speed increases as points increase.

Wall Collision Toggle: Option to turn walls on/off for extra challenge.

Soft Notification Sound: Gentle sound when the snake eats food or game ends.

Visible Boundaries: Clear white boundary around the game area.


⚡ How to Play

Run gamesgui.m in MATLAB.

Use arrow keys or GUI buttons to move the snake:

Up: ↑ or Up Button

Down: ↓ or Down Button

Left: ← or Left Button

Right: → or Right Button

Eat red food to grow. Each food increases your score by 1.

Avoid colliding with yourself.

If Wall Collision is enabled, avoid hitting the boundaries.

Pause the game anytime using the Pause button.

Restart the game using the Restart button.

End the game anytime using the End Game button.

🧩 Implementation Details

Language: MATLAB (R2024+ recommended)

GUI: Created using GUIDE

Image Rendering: Snake and food displayed using imshow with RGB matrices.

Game Loop: Controlled using a while loop with dynamic pause for speed.

Global Variables: Used to manage snake state, direction, food location, points, and game status.

Notification Sound: Generated using MATLAB sound() function.


📈 Enhancements

Adjustable game speed depending on score.

Optional wall collision toggle for advanced gameplay.

High score saving between sessions.

Soft sound notifications for food eaten and game over.

🎯 Future Improvements

Convert GUI to MATLAB App Designer for modern app compatibility.

Add menu pop-out for Star, Instructions, and Exit functionality.

Add multiple themes and snake skins.

Mobile-friendly or MATLAB Web App deployment.
