# Level 1 Full Parity Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Complete Flash parity for Level 1 - enemies, checkpoints, collectibles, audio, and NPCs.

**Architecture:** Level1.hx spawns entities from CSV files, PlayState.hx handles all collision callbacks, entity classes contain self-contained behavior.

**Tech Stack:** HaxeFlixel 6.1.1, Haxe

---

## Task 1: Copy Missing CSV Files to Assets

**Files:**
- Copy: `map/mapCSV_Level1_Checkpoint.csv` → `assets/`
- Copy: `map/mapCSV_Level1_Reinforcements.csv` → `assets/`
- Copy: `map/mapCSV_Level1_Rocks.csv` → `assets/`

**Step 1: Copy the CSV files**

```bash
cp map/mapCSV_Level1_Checkpoint.csv assets/
cp map/mapCSV_Level1_Reinforcements.csv assets/
cp map/mapCSV_Level1_Rocks.csv assets/
```

**Step 2: Verify files exist**

```bash
ls assets/mapCSV_Level1_*.csv
```

Expected: Should show Checkpoint, Reinforcements, Rocks CSVs

**Step 3: Commit**

```bash
git add assets/mapCSV_Level1_*.csv
git commit -m "chore: copy entity CSV files from map/ to assets/"
```

---

## Task 2: Add CSV Paths to AssetPaths.hx

**Files:**
- Modify: `source/AssetPaths.hx`

**Step 1: Add entity CSV path constants**

After line 66 (L1_BACKBACKGROUND_CSV), add:

```haxe
	public static inline var L1_BOTS_CSV:String = "assets/mapCSV_Level1_Bots.csv";
	public static inline var L1_ROCKS_CSV:String = "assets/mapCSV_Level1_Rocks.csv";
	public static inline var L1_CHECKPOINT_CSV:String = "assets/mapCSV_Level1_Checkpoint.csv";
	public static inline var L1_REINFORCEMENTS_CSV:String = "assets/mapCSV_Level1_Reinforcements.csv";
```

**Step 2: Add audio paths for Level 1**

After ROCK_BUST_SFX, add:

```haxe
	// Level 1 Audio
	public static inline var L1_MUSIC:String = "assets/DwarfDance.mp3";
	public static inline var BOT_KILL_SFX:String = "assets/botKillSFX2.mp3";
	public static inline var COLLECT_SFX:String = "assets/NomNomcollect.mp3";

	// NPC Audio
	public static inline var FROG_SFX:String = "assets/frog.mp3";
```

**Step 3: Add Reinforcement graphic path**

```haxe
	// Collectibles
	public static inline var REINFORCEMENT:String = "assets/reinforcement.png";
```

**Step 4: Build to verify**

```bash
./build.sh
```

Expected: BUILD SUCCEEDED

**Step 5: Commit**

```bash
git add source/AssetPaths.hx
git commit -m "feat: add Level 1 entity and audio asset paths"
```

---

## Task 3: Create Reinforcement.hx Entity

**Files:**
- Create: `source/Reinforcement.hx`

**Step 1: Create the Reinforcement class**

```haxe
package;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * Collectible orb that grants health/power
 */
class Reinforcement extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		// Load graphic - use checkpoint as placeholder if reinforcement.png doesn't exist
		if (openfl.Assets.exists(AssetPaths.REINFORCEMENT))
		{
			loadGraphic(AssetPaths.REINFORCEMENT, true, 16, 16);
		}
		else
		{
			makeGraphic(16, 16, 0xFFFFFF00); // Yellow placeholder
		}

		// Simple bob animation
		animation.add("idle", [0], 0, false);
		animation.play("idle");
	}

	public function collect():Void
	{
		// Play collect sound
		FlxG.sound.play(AssetPaths.COLLECT_SFX);

		// TODO: Add to player health/power
		// Registry.playerHealth += 1;

		// Remove self
		kill();
	}
}
```

**Step 2: Build to verify**

```bash
./build.sh
```

Expected: BUILD SUCCEEDED

**Step 3: Commit**

```bash
git add source/Reinforcement.hx
git commit -m "feat: add Reinforcement collectible entity"
```

---

## Task 4: Create Reinforcements.hx Group

**Files:**
- Create: `source/Reinforcements.hx`

**Step 1: Create the group class**

```haxe
package;

import flixel.group.FlxGroup;

/**
 * Group manager for Reinforcement collectibles
 */
class Reinforcements extends FlxTypedGroup<Reinforcement>
{
	public function new()
	{
		super();
	}

	/**
	 * Add a reinforcement at tile coordinates
	 */
	public function addReinforcement(tileX:Int, tileY:Int):Reinforcement
	{
		var r = new Reinforcement(tileX * 16, tileY * 16);
		add(r);
		return r;
	}
}
```

**Step 2: Build and commit**

```bash
./build.sh
git add source/Reinforcements.hx
git commit -m "feat: add Reinforcements group manager"
```

---

## Task 5: Update GameLevel with Reinforcements Group

**Files:**
- Modify: `source/GameLevel.hx`

**Step 1: Add reinforcements property**

After the `checkpoints` declaration, add:

```haxe
	public var reinforcements:Reinforcements;
```

**Step 2: Build and commit**

```bash
./build.sh
git add source/GameLevel.hx
git commit -m "feat: add reinforcements group to GameLevel"
```

---

## Task 6: Update Checkpoint for End Bubble Support

**Files:**
- Modify: `source/Checkpoint.hx`

**Step 1: Add isEnd flag to Checkpoint class**

Add property after other class variables:

```haxe
	public var isEnd:Bool = false;
```

**Step 2: Modify constructor to accept isEnd parameter**

Update constructor signature:

```haxe
	public function new(x:Float, y:Float, isEnd:Bool = false)
```

And in constructor body after loading graphic:

```haxe
		this.isEnd = isEnd;

		if (isEnd)
		{
			// Use ending bubble graphic
			loadGraphic(AssetPaths.ENDING, true, 32, 32);
			setSize(32, 32);
		}
```

**Step 3: Build and commit**

```bash
./build.sh
git add source/Checkpoint.hx
git commit -m "feat: add isEnd support to Checkpoint for level exit bubble"
```

---

## Task 7: Add Entity Spawning to Level1.hx

**Files:**
- Modify: `source/Level1.hx`

**Step 1: Add imports at top**

```haxe
import haxe.io.Path;
import sys.io.File;
```

**Step 2: Create parseEntityCSV helper function**

Add after the class declaration:

```haxe
	/**
	 * Parse CSV and call callback for each non-zero tile
	 */
	private function parseEntityCSV(csvPath:String, callback:(Int, Int, Int) -> Void):Void
	{
		var csvData = openfl.Assets.getText(csvPath);
		if (csvData == null) return;

		var lines = csvData.split("\n");
		for (row in 0...lines.length)
		{
			var cols = lines[row].split(",");
			for (col in 0...cols.length)
			{
				var tile = Std.parseInt(cols[col]);
				if (tile != null && tile > 0)
				{
					callback(col, row, tile);
				}
			}
		}
	}
```

**Step 3: Initialize entity groups in constructor**

After creating player, add:

```haxe
		// Initialize entity groups
		bots = new Bots();
		rocks = new Rocks();
		checkpoints = new FlxGroup();
		reinforcements = new Reinforcements();

		// Parse and spawn bots
		parseEntityCSV(AssetPaths.L1_BOTS_CSV, function(col, row, tile) {
			var facing = (tile == 2) ? FlxObject.LEFT : FlxObject.RIGHT;
			var suicidal = (tile == 3);
			bots.addBot(col, row, facing, suicidal);
		});

		// Parse and spawn rocks
		parseEntityCSV(AssetPaths.L1_ROCKS_CSV, function(col, row, tile) {
			rocks.addRock(col, row);
		});

		// Parse and spawn checkpoints
		parseEntityCSV(AssetPaths.L1_CHECKPOINT_CSV, function(col, row, tile) {
			var isEnd = (tile == 3);
			var cp = new Checkpoint(col * 16, row * 16, isEnd);
			checkpoints.add(cp);
		});

		// Parse and spawn reinforcements
		parseEntityCSV(AssetPaths.L1_REINFORCEMENTS_CSV, function(col, row, tile) {
			reinforcements.addReinforcement(col, row);
		});
```

**Step 4: Update render order**

Replace the add() calls with:

```haxe
		// Add everything to the group (render order matters - back to front!)
		add(backbackground);
		add(background);
		add(foreground);
		add(checkpoints);
		add(reinforcements);
		add(rocks);
		add(bots);
		add(player);
```

**Step 5: Build and test**

```bash
./build.sh
```

Open browser, verify entities appear on screen.

**Step 6: Commit**

```bash
git add source/Level1.hx
git commit -m "feat: spawn entities from CSV files in Level1"
```

---

## Task 8: Add Collision Handling to PlayState

**Files:**
- Modify: `source/PlayState.hx`

**Step 1: Add collision checks in update()**

After the existing foreground collision, add:

```haxe
			// Collide entities with foreground
			if (currentLevel.bots != null) {
				FlxG.collide(currentLevel.bots, currentLevel.foreground);
			}
			if (currentLevel.rocks != null) {
				FlxG.collide(currentLevel.rocks, currentLevel.foreground);
			}

			// Player-entity overlaps
			if (currentLevel.bots != null) {
				FlxG.overlap(currentLevel.player, currentLevel.bots, hitBot);
			}
			if (currentLevel.checkpoints != null) {
				FlxG.overlap(currentLevel.player, currentLevel.checkpoints, hitCheckpoint);
			}
			if (currentLevel.reinforcements != null) {
				FlxG.overlap(currentLevel.player, currentLevel.reinforcements, hitReinforcement);
			}
```

**Step 2: Add collision callback functions**

Add these functions to PlayState class:

```haxe
	private function hitBot(player:Player, bot:Bot):Void
	{
		// If player falling onto bot, kill the bot
		if (player.velocity.y > 0 && player.y + player.height < bot.y + bot.height / 2)
		{
			bot.die();
			player.velocity.y = -150; // Bounce
			FlxG.sound.play(AssetPaths.BOT_KILL_SFX);
		}
		else if (!player.isHurt())
		{
			// Bot hurts player
			player.hurt(1);
		}
	}

	private function hitCheckpoint(player:Player, checkpoint:Dynamic):Void
	{
		var cp:Checkpoint = cast checkpoint;
		if (cp.isEnd)
		{
			// Level complete!
			FlxG.sound.play(AssetPaths.POP_SFX);
			cp.kill();
			trace("Level complete - end bubble popped!");
			// TODO: Transition to level complete state
		}
		else
		{
			// Save checkpoint
			if (!cp.activated)
			{
				cp.activate();
				Registry.checkpoint = cp.getMidpoint();
				Registry.checkpointFlag = true;
				FlxG.sound.play(AssetPaths.POP_SFX);
			}
		}
	}

	private function hitReinforcement(player:Player, reinforcement:Reinforcement):Void
	{
		reinforcement.collect();
	}
```

**Step 3: Build and test**

```bash
./build.sh
```

Test in browser:
- Walk into a bot - should take damage
- Jump on a bot - should kill it and bounce
- Touch a checkpoint - should hear pop sound
- Touch reinforcement - should hear collect sound and disappear

**Step 4: Commit**

```bash
git add source/PlayState.hx
git commit -m "feat: add entity collision handling in PlayState"
```

---

## Task 9: Add Level Music

**Files:**
- Modify: `source/Level1.hx`

**Step 1: Add music start in constructor**

At the end of Level1 constructor:

```haxe
		// Start level music
		FlxG.sound.playMusic(AssetPaths.L1_MUSIC, 0.7, true);
```

**Step 2: Build and test**

```bash
./build.sh
```

Test in browser - should hear DwarfDance.mp3 playing

**Step 3: Commit**

```bash
git add source/Level1.hx
git commit -m "feat: add level music to Level1"
```

---

## Task 10: Clean Up Debug Logging

**Files:**
- Modify: `source/Player.hx`

**Step 1: Remove debug remote logging**

Search for and remove all `remoteLog()` calls that were added during flip animation debugging.

Remove the `remoteLog` function if it exists.

Remove any `JUMP_ANIM`, `FLIP:`, or debug logging statements.

**Step 2: Build and verify**

```bash
./build.sh
```

**Step 3: Commit**

```bash
git add source/Player.hx
git commit -m "chore: remove debug logging from Player"
```

---

## Task 11: Create Sign.hx Entity (Optional Polish)

**Files:**
- Create: `source/Sign.hx`

**Step 1: Create Sign class**

```haxe
package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;

/**
 * Tutorial sign that displays text when player is nearby
 */
class Sign extends FlxSprite
{
	private var text:FlxText;
	private var message:String;

	public function new(x:Float, y:Float, message:String)
	{
		super(x, y);
		this.message = message;

		makeGraphic(32, 32, 0xFF8B4513); // Brown placeholder

		text = new FlxText(x - 50, y - 20, 150, message);
		text.setFormat(null, 8, 0xFFFFFF, CENTER);
		text.visible = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Show text when player is nearby
		if (Registry.player != null)
		{
			var dist = Math.sqrt(Math.pow(x - Registry.player.x, 2) + Math.pow(y - Registry.player.y, 2));
			text.visible = (dist < 64);
		}
	}

	override public function draw():Void
	{
		super.draw();
		if (text.visible) text.draw();
	}
}
```

**Step 2: Add signs to Level1 constructor**

```haxe
		// Add tutorial signs
		var sign1 = new Sign(100, 180, "PRESS 'Z' TO JUMP");
		add(sign1);
```

**Step 3: Build and commit**

```bash
./build.sh
git add source/Sign.hx source/Level1.hx
git commit -m "feat: add Sign entity for tutorial text"
```

---

## Task 12: Verification

**Step 1: Full playthrough test**

1. Start game, enter Level 1
2. Verify music plays
3. Walk right, encounter enemies
4. Jump on enemy to kill it (bounce)
5. Walk into enemy to take damage
6. Touch checkpoint (hear pop)
7. Collect reinforcements (hear collect sound)
8. Reach end bubble, pop it
9. Verify "Level complete" message

**Step 2: Final commit**

```bash
git status
git add -A
git commit -m "feat: Level 1 full parity complete"
```

---

## Summary

After completing all tasks:
- Enemies spawn from CSV and can be killed/damage player
- Checkpoints save progress, end bubble completes level
- Reinforcements are collectible
- Level music plays
- Basic tutorial signs (optional)

Remaining for later:
- Frog NPC (complex behavior, lower priority)
- Level complete state transition
- Player health/death system polish
