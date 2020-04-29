# Asteroids

**Asteroids** is a video game containing both a copy of [the classic arcade game Asteroids](https://en.wikipedia.org/wiki/Asteroids_(video_game)) and a variant version with modern graphics and powerups.

![Main Menu](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Main%20Menu.png)

## Table of Contents
1. [Features](#Features)
2. [Controls](#Controls)
3. [Screenshots](#Screenshots)
4. [Development Notes](#Development)
5. [Contributors](#Contributors)

<a name="Features"></a>
## Features

- The classic arcade game Asteroids
  - Move and fire at asteroids
  - The ship and asteroids wrap around the screen
  - Extra life for every 10,000 points
  - Every level (each time all asteroids are cleared from the screen) increases the number of spawned asteroids by 1
- A variant version of Asteroids
  - Same as the classic version with the additions of temporary powerups
	
|       Buffs      | Icon                                                                                                                               | Description |
|------------------|------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------- |
| No Despawn       | <img src="https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Powerups/Delay.png" width="100" height="100">         | Missiles do not despawn after a certain distance |
| Extra life       | <img src="https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Powerups/ExtraLife.png" width="100" height="100">     | Grants the player an extra life |                                                               
| Score x5         | <img src="https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Powerups/FiveTimes.png" width="100" height="100">     | Multiplies all points gained by 5 |
| Burst            | <img src="https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Powerups/MissileCircle.png" width="100" height="100"> | 3x missile circle burst around the ship |
| Rapid Fire       | <img src="https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Powerups/RapidFire.png" width="100" height="100">     | No delay on firing |
| Legendary        | <img src="https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Powerups/Legendary.png" width="100" height="100">     | Activates all of the above powerups at once and grants additional rotational thrust |
    
|      Debuffs     | Icon                                                                                                                                  | Description |
|------------------|---------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------- |
| Asteroid Speedup | <img src="https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Powerups/Asteroids.png" width="100" height="100">        | Speed of all asteroids increases x5 |
| Jumbled Controls | <img src="https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Powerups/BadControls.png" width="100" height="100">      | Controls become jumbled |
| Invisible Ship   | <img src="https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Powerups/Invisible.png" width="100" height="100">        | Your ship becomes invisible |
| Lose a Life      | <img src="https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Powerups/LoseALife.png" width="100" height="100">        | Lose a life (does nothing if the player is on their last life) |
| Jammed Missiles  | <img src="https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Powerups/NoMissile.png" width="100" height="100">        | The player is unable to fire |
| Maximum Thrust   | <img src="https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Powerups/MaximumOverdrive.png" width="100" height="100"> | The ship thrusts uncontrollably |

<a name="Controls"></a>
## Controls

- **Left and right arrow keys** to change facing direction
- **Up arrow key** to thrust forward
- **Space** to shoot
- **Escape** to pause the game
- **P** to respawn manually
  - The game will automatically respawn you in the center of the screen when there are no nearby asteroids within a set radius. However, in later levels so many asteroids fly around that this may take a very long time. You can force spawn with this key when you see a clear chance to spawn, but if you time it wrong you may die instantly.

<a name="Screenshots"></a>
## Screenshots

![Classic 1](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Classic%201.png)
![Classic 2](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Classic%202.png)
![Variant Debuffs](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Variant%20Debuffs.png)
![Variant Powerups](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Variant%20Powerups.png)

<a name="Development"></a>
## Development Notes

This was created in Godot (v3.0.6), a game engine similar to Unity which uses a Python-lite backend programming language.
The development of this game is completed. Please open an issue on this repository if you discover any bugs.

<a name="Contributors"></a>
## Contributors

This game was created for a game development class I took in college along with 3 other group members. I did the majority of the programming. Here are the contributions of my group members.

- Justin Tok
  - Created the custom graphics for the powerups, debuffs, and cleaned up the asteroid graphics.
- Andrew Wood
  - Fixed various programming bugs and implemented some of the powerups.
- Kenneth-Matthew Velarde
  - Designed the main menu.