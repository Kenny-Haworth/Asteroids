# Asteroids

**Asteroids** is a video game containing both a copy of [the classic arcade game Asteroids](https://en.wikipedia.org/wiki/Asteroids_(video_game)) and a variant version with modern graphics and powerups.

![Home Screen of Project](https://github.com/Kenny-Haworth/Digital-Journal/blob/master/Screenshots/Home%20Screen%20with%20Memories.PNG)

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
  - Same as the classic version with the additions of temporary...
    - Powerups
	  - Missiles do not despawn after a certain distance
	    - ![Delay](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Delay.png)
	  - Extra life
	    - ![ExtraLife](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/ExtraLife.png)
	  - Score x5
	    - ![FiveTimes](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/FiveTimes.png)
	  - Missile circle burst around the ship
	    - ![MissileCircle](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/MissileCircle.png)
	  - Rapid fire missiles
	    - ![RapidFire](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/RapidFire.png)
	  - Legendary powerup - activates all of the above powerups at once, and gives additional rotational thrust
	    - ![Legendary](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Legendary.png)
	- Debuffs
	  - Asteroid speed x5
	    - ![Asteroids](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Asteroids.png)
	  - Controls become jumbled
	    - ![BadControls](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/BadControls.png)
	  - Your ship becomes invisible
	    - ![Invisible](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/Invisible.png)
	  - You lose a life (does nothing if you are already on your last life)
	    - ![LoseALife](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/LoseALife.png)
	  - Missiles are jammed (unable to fire)
	    - ![NoMissile](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/NoMissile.png)
	  - Ship thrusts uncontrollably
	    - ![MaximumOverdrive](https://github.com/Kenny-Haworth/Asteroids/blob/master/Screenshots/MaximumOverdrive.png)

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
- Kenneth-Matthew Velarde
  - Designed the main menu.
- Andrew Wood
  - Fixed various programming bugs and implemented some of the powerups.