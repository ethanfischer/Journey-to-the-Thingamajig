# Level 1 Full Parity Design

**Date:** 2025-11-23
**Goal:** Achieve complete Flash parity for Level 1 of Journey to the Thingamajig

## Current State

- Player mechanics working (movement, jump, variable jump height, flip animation)
- Tilemaps loading (3 layers with parallax)
- Basic collision with foreground tilemap
- Entity classes exist but not spawned: Bot, Bots, Rock, Rocks, Checkpoint, Poof

## Architecture Overview

### Entity Spawning (Level1.hx)

Parse 4 CSV files at creation time:
- `mapCSV_Level1_Bots.csv` → Spawn Bots (tile 1=right, 2=left, 3=suicidal)
- `mapCSV_Level1_Rocks.csv` → Spawn Rocks (tile 1 and 2)
- `mapCSV_Level1_Checkpoint.csv` → Spawn Checkpoints (tile 1=checkpoint, tile 3=end bubble)
- `mapCSV_Level1_Reinforcements.csv` → Spawn Reinforcements

Render order: background → entities → player → foreground decorations

### Collision System (PlayState.update)

```
FlxG.collide(bots, foreground)           // Bots walk on ground
FlxG.collide(rocks, foreground)          // Rocks sit on ground
FlxG.overlap(player, bots, hitBot)       // Damage player OR bounce-kill bot
FlxG.overlap(player, rocks, hitRock)     // Block player
FlxG.overlap(player, checkpoints, hitCheckpoint)  // Save or end level
FlxG.overlap(player, reinforcements, hitReinforcement)  // Collect orb
FlxG.overlap(player.hitBox, bots, punchBot)    // Punch kills bot
FlxG.overlap(player.hitBox, rocks, punchRock)  // Punch destroys rock
```

### Callback Logic

- **hitBot:** If player falling on bot → kill bot, bounce player. Else → hurt player.
- **hitCheckpoint:** Regular → save position. End bubble (tile 3) → pop sound, level complete.
- **hitReinforcement:** Collect sound, add health/power, destroy orb.

## New Entity Classes

### Reinforcement.hx
- Simple animated sprite (existing graphic in assets)
- No AI, just collectible
- Plays `NomNomcollect.mp3` when collected
- Spawned from CSV tile positions

### Sign.hx
- Static sprite with text overlay
- Two signs: "PRESS 'Z' TO JUMP" and "ball of pointlessness"
- Shows text when player nearby

### Frog.hx
- Animated sprite that taunts player
- Runs away when player gets close
- Plays `frog.mp3` when speaking
- Created at (625, 100) after checkpoint

### End Bubble
- Not new class - Checkpoint with `isEnd=true` flag
- Different sprite (bubble animation)
- Triggers level complete instead of saving

## Audio Integration

### Level Music
- `DwarfDance.mp3` - loops during Level 1
- Start in Level1.create(), stop on level complete

### Sound Effects
| Sound | Trigger |
|-------|---------|
| jumpSFX.mp3 | Player jump |
| land.mp3 | Player landing |
| pop.mp3 | Checkpoint touched |
| botKillSFX2.mp3 | Bot killed |
| rockBust2.mp3 | Rock destroyed |
| NomNomcollect.mp3 | Reinforcement collected |
| hurtSFX.mp3 | Player damaged |
| frog.mp3 | Frog speaks |

## Tilemap Verification

CSV files in `/assets/` may differ from `/map/` folder. Verify and copy correct CSVs if needed.

## Implementation Priority

1. Entity spawning from CSVs in Level1
2. Collision callbacks in PlayState
3. Reinforcement class
4. End bubble checkpoint variant
5. Audio (music + SFX)
6. Sign and Frog NPCs
7. Tilemap fixes if needed
