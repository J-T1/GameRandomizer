

**Game Randomizer Script**
==========================

**Overview**
------------

This script randomizes game settings and player inputs for a game. It uses an `.env` file to store player and game inputs, separated by commas.

**Usage**
-----
1. Clone the Repository
```
git clone https://github.com/J-T1/GameRandomizer
```
2. Create an `.env` file in the root directory of the script with the following format:
```
PLAYER=player1,player2,player3
GAMES=game1,game2,game3
```
Replace `player1`, `player2`, `player3` with the desired player inputs, and `game1`, `game2`, `game3` with the desired game inputs.

3. Run the script with julia.
```
julia game_randomizer.jl
```

**How it Works**
----------------

The script reads the `.env` file and parses the player and game inputs into arrays. It then uses these arrays to randomize the game settings and player inputs.