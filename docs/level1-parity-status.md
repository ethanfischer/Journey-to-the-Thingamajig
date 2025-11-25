# Level 1 Feature Parity Status

**Date:** 2025-11-24
**Comparing:** Flash (origin/flash-original) vs HaxeFlixel (feature/haxeflixel-port)

## Status Legend
- ✅ Complete and verified
- 🟡 Code exists but not hooked up/spawning
- ❌ Not yet implemented

---

## Entity Spawning

| Feature | Flash | HaxeFlixel | Status | Notes |
|---------|-------|------------|--------|-------|
| **Bots** | parseBots() spawns from CSV | Bots class exists | 🟡 | Need to call parseBots in Level1 constructor |
| **Rocks** | parseRocks() spawns from CSV | Rocks class exists | 🟡 | Need to call parseRocks in Level1 constructor |
| **Checkpoints** | parseCheckpoint() spawns regular + end bubble | Checkpoint class exists | 🟡 | Need to call parseCheckpoint + add isEnd support |
| **Reinforcements** | parseReinforcements() spawns collectibles | Reinforcement class created | 🟡 | Need Reinforcements group + parseReinforcements |
| **Frog NPC** | Created at (625,100) or (1872,200) | N/A | ❌ | Frog class not ported yet |
| **Signs** | 2 tutorial signs created | N/A | ❌ | Sign class not created |

---

## Collision Handling (PlayState)

| Collision Type | Flash | HaxeFlixel | Status |
|----------------|-------|------------|--------|
| Player vs Foreground | `FlxG.collide(player, foreground)` | ✅ | ✅ |
| Bots vs Foreground | `FlxG.collide(bots, foreground)` | N/A | ❌ |
| Rocks vs Player | `FlxG.collide(rocks, player)` | N/A | ❌ |
| Rocks vs Foreground | `FlxG.collide(foreground, rocks)` | N/A | ❌ |
| Player vs Bots (overlap) | `hitBot()` callback | N/A | ❌ |
| Player vs Reinforcements | `hitReinforcement()` callback | N/A | ❌ |
| HitBox vs Bots (punch) | `punchBot()` callback | N/A | ❌ |
| HitBox vs Rocks (punch) | `punchRock()` callback | N/A | ❌ |

---

## Collision Callbacks

### hitBot(player, bot)
**Flash behavior:**
```actionscript
if ((player.velocity.y >= 0) && player.y + player.height < bot.y + 12)
{
    player.bounce(310);      // Bounce player upward
    bot.bounce();           // Kill bot
    FlxG.play(_botKillSFX); // Play sound
}
else if (player.isDucking && Math.abs(player.velocity.x) > 50)
{
    bot.knockback();        // Slide kick
    FlxG.play(kickSFX);
}
else
{
    player.hurt(1);         // Take damage
}
```

**HaxeFlixel:** ❌ Not implemented

### hitReinforcement(player, r)
**Flash behavior:**
```actionscript
r.kill();
FlxG.play(nomNomSFX);
```

**HaxeFlixel:** 🟡 Reinforcement.collect() exists but not called

---

## Audio

| Audio Asset | Flash | HaxeFlixel | Status |
|-------------|-------|------------|--------|
| Level Music | DwarfDance.mp3 (commented out in Flash) | AssetPaths constant added | 🟡 |
| Bot Kill SFX | botKillSFX2.mp3 | AssetPaths constant added | 🟡 |
| Collect SFX | NomNomcollect.mp3 | AssetPaths constant added | 🟡 |
| Pop SFX | pop.mp3 (checkpoint) | AssetPaths constant exists | ✅ |

---

## Level Setup

| Feature | Flash | HaxeFlixel | Status |
|---------|-------|------------|--------|
| **Player Spawn** | (50, height-64) or checkpoint | ✅ | ✅ |
| **Foreground Tilemap** | 215x20 tiles, forest_tiles_l1.png | ✅ | ✅ |
| **Background Tilemap** | woody(green).png, parallax 0.7 | ✅ | ✅ |
| **Back-Background** | woody_back_background.png, parallax 0.2 | ✅ | ✅ |
| **Level Exit** | FlxPoint(99*16, 16*16) | ❌ | ❌ |
| **Letter Message** | "I don't know what it is..." | ❌ | ❌ |
| **Registry Setup** | player, map, hasUmbrella, etc. | ✅ Partial | 🟡 |

---

## Player Mechanics (Already Complete)

| Feature | Flash | HaxeFlixel | Status |
|---------|-------|------------|--------|
| Movement (walk/run) | ✅ | ✅ | ✅ |
| Jump | ✅ | ✅ | ✅ |
| Variable jump height | ✅ | ✅ | ✅ |
| Flip animation | ✅ | ✅ | ✅ |
| Hurt state | ✅ | ✅ | ✅ |
| Duck/slide | ✅ | Partial | 🟡 |

---

## Summary

**Total Features:** 30
**Complete:** 7 (23%)
**Partially Complete:** 10 (33%)
**Not Implemented:** 13 (43%)

**Critical Missing:**
1. Entity spawning from CSVs (Task 7)
2. Collision callbacks in PlayState (Task 8)
3. Reinforcements group (Task 4)
4. Checkpoint end bubble support (Task 6)
5. Level music playback (Task 9)

**Next Steps:**
Continue executing the implementation plan tasks 4-12 to achieve full parity.
