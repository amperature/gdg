# Brookline

## Overview

Brookline is an arcade stacker that takes inspiration from the game Tetris and is focused around moving a piece and clearing lines to score points!


## Instructions
In order to run Brookline, you must have [LÖVE2D](https://love2d.org/) installed. If you are on **Windows**, then there is no need to install LÖVE, since it comes with the program.

However, if you are on **macOS** or **Linux**, then you will need to install LÖVE by downloading it, then dragging and dropping the .love file of Brookline into the LÖVE executable.

## Controls
Up Arrow = Rotate Clockwise

Down Arrow = Soft Drop

Left Arrow = Move Left

Right Arrow = Move Right

P = Pause

R = Restart

## Interface
At the bottom, you will see 2 counters: the line counter, which counts the number of lines that have been cleared, and the speed, which is the number of pieces that have been placed. It also goes up when lines are cleared. This "speed" counter is referred to as "Levels" in the TGM Series. You will also see the next queue to the right of the board, which indicates the next piece.

## Gameplay
The gameplay is very similar to the hit stacking game Tetris. In the game, you have to stack blocks grouped up in 4s (known as Tetriminos) and clear lines by filling the entire horizontal row. The more lines you clear, the further you progress in the game, where the pieces start to drop automatically faster and faster. The game ends at level 500.

## Credits

**TPM and Oshisaure**: HUGE help and resource; helped me with learning Lua and LOVE2D as well as making a Tetris game 

**Alexey Pajitnov**: Tetris

**Cambridge: The Open Source Arcade Stacker**: Inspiration for the name and another resource for the project.

**lua-users.org**: Sleep Function

