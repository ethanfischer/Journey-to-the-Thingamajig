# Level 1 Test Plan

**Purpose:** Verify HaxeFlixel port matches Flash original behavior

## Testing Approach

HaxeFlixel games are typically verified through **manual integration testing** rather than unit tests, because:
1. Game logic is highly visual and interactive
2. Physics/collision behavior is hard to unit test
3. Most bugs are integration issues (entity interactions)

However, we'll document both approaches.

---

## Manual Integration Test Checklist

Run these tests in-browser after completing implementation tasks 4-12.

### Player Movement
- [ ] Walk left/right with arrow keys - should accelerate smoothly
- [ ] Jump with Z - should have responsive arc
- [ ] Variable jump height - release Z early = shorter jump
- [ ] Flip animation plays when changing direction mid-air
- [ ] Land animation plays when touching ground

### Tilemap/Collision
- [ ] Player collides with foreground tiles (forest_tiles_l1.png)
- [ ] Background parallax scrolls at 0.7x speed
- [ ] Back-background parallax scrolls at 0.2x speed
- [ ] Camera follows player (PLATFORMER style)
- [ ] No falling through tiles

### Entities - Spawn Verification
- [ ] Bots spawn at correct positions from CSV
- [ ] Bots face correct direction (tile 1=RIGHT, 2=LEFT)
- [ ] Suicidal bots spawn (tile 3) and behave differently
- [ ] Rocks spawn at correct positions
- [ ] Checkpoints spawn (tile 1)
- [ ] End bubble spawns at level exit (tile 3)
- [ ] Reinforcement orbs spawn from CSV

### Bot Interactions
- [ ] **Jump on bot:** Player bounces up, bot dies, hear botKillSFX2.mp3
- [ ] **Walk into bot:** Player takes damage, hurt animation plays
- [ ] Bots walk on platforms (collide with foreground)
- [ ] Bots turn around at edges/walls
- [ ] Dead bots play poof animation

### Rock Interactions
- [ ] Rocks block player movement
- [ ] Rocks stay on platforms (collide with foreground)

### Checkpoint System
- [ ] Touch regular checkpoint: Hear pop.mp3, checkpoint activates
- [ ] Die and respawn: Player respawns at last checkpoint
- [ ] Touch end bubble: Hear pop.mp3, bubble pops, "Level complete" message

### Reinforcements (Collectibles)
- [ ] Touch reinforcement: Hear NomNomcollect.mp3, orb disappears
- [ ] TODO: Health/power increases (when Registry system implemented)

### Audio
- [ ] Level music (DwarfDance.mp3) plays on level start
- [ ] Music loops continuously
- [ ] Bot kill sound plays when stomping bot
- [ ] Collect sound plays when getting reinforcement
- [ ] Checkpoint pop sound plays

### Optional Features
- [ ] Tutorial sign: "PRESS 'Z' TO JUMP" appears at x=135
- [ ] Sign shows text when player nearby
- [ ] Frog NPC at (625,100) or (1872,200) based on checkpoint
- [ ] Frog runs away when player approaches

---

## Automated Test Scenarios (Future)

If we implement automated testing with a framework like munit or utest, these would be good candidates:

### Entity Spawn Tests
```haxe
@Test
public function test_parseBots_spawnCorrectCount():Void
{
    var level = new Level1();
    assertTrue(level.bots != null);
    assertEqual(level.bots.length, EXPECTED_BOT_COUNT);
}

@Test
public function test_parseBots_correctFacing():Void
{
    // Verify bots face LEFT or RIGHT based on CSV tile value
}
```

### Collision Logic Tests
```haxe
@Test
public function test_hitBot_jumpKillsBotAndBounces():Void
{
    // Create mock player falling onto bot
    // Verify bot.isDying == true
    // Verify player.velocity.y < 0 (bounced)
}

@Test
public function test_hitBot_walkIntoBot_hurtPlayer():Void
{
    // Create mock player walking into bot
    // Verify player health decreased
}
```

### Audio Tests
```haxe
@Test
public function test_reinforcementCollect_playsSound():Void
{
    var r = new Reinforcement(0, 0);
    r.collect();
    // Verify FlxG.sound.play() was called with COLLECT_SFX
}
```

---

## Comparison Testing (Flash vs HaxeFlixel)

### Visual Comparison
1. Record Flash version gameplay video
2. Record HaxeFlixel version gameplay video
3. Compare side-by-side:
   - Player movement speed
   - Jump arc height/duration
   - Bot patrol behavior
   - Entity positions
   - Animation timing

### Behavioral Comparison
| Behavior | Flash | HaxeFlixel | Match? |
|----------|-------|------------|--------|
| Jump on bot kills it | ✅ | TBD | ? |
| Walk into bot hurts player | ✅ | TBD | ? |
| Reinforcement plays collect sound | ✅ | TBD | ? |
| Checkpoint saves position | ✅ | TBD | ? |
| End bubble completes level | ✅ | TBD | ? |

---

## Regression Testing

After each task completion, verify:
1. Game still compiles (`./build.sh`)
2. No new console errors in browser
3. Player can still move/jump
4. Previously working features still work

---

## Performance Testing

Compare Flash vs HaxeFlixel:
- [ ] FPS stays at 60 (check with openfl.display.FPS counter)
- [ ] No frame drops during entity spawning
- [ ] Smooth scrolling with parallax backgrounds
- [ ] Memory usage stable (no leaks)

---

## Acceptance Criteria

**Level 1 port is complete when:**
1. All manual integration tests pass ✅
2. Gameplay feels identical to Flash version
3. No visual artifacts or glitches
4. Audio plays correctly
5. Entities spawn and behave as expected
6. Checkpoint/end bubble system works
7. No console errors in browser

---

## Known Limitations

Features NOT being ported for Level 1 initial release:
- Punch/kick mechanics (player.hitBox interactions)
- Letter message system (tutorial text)
- Frog NPC (complex AI, deferred)
- Sign entities (nice-to-have, optional)
- Registry.firstLevel1 flag handling

These can be added in future iterations after core gameplay works.
