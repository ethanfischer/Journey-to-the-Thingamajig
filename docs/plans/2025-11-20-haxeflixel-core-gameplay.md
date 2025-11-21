# HaxeFlixel Core Gameplay Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Convert core gameplay components (PlayState, Player, GameLevel, Level1) to create a minimal playable HaxeFlixel game.

**Architecture:** Incremental conversion starting with base classes (GameLevel), then player mechanics, then a simplified Level1, and finally PlayState to tie everything together. Each component will be converted with minimal dependencies first, then enhanced iteratively.

**Tech Stack:** HaxeFlixel 6.1.1, Haxe 4.x, OpenFL 9.5.0, Lime 8.3.0

**Strategy:** Start with simplified stub versions to get the game loop running, then incrementally add features. Use TDD where practical. Focus on getting a playable Level1 as the milestone.

---

## Task 1: Create GameLevel Base Class (Stub)

**Goal:** Create a minimal GameLevel base class that future levels can extend.

**Files:**
- Create: `source/GameLevel.hx`
- Reference: git tag `v1.0-flash:src/GameLevel.as`

**Step 1: Create GameLevel stub with basic structure**

Create file `source/GameLevel.hx`:

```haxe
package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.FlxSprite;

/**
 * Base class for all game levels
 * Manages tilemaps, player, entities, and level-specific logic
 */
class GameLevel extends FlxGroup
{
	// Tilemaps for parallax layers
	public var background:FlxTilemap;
	public var backbackground:FlxTilemap;
	public var foreground:FlxTilemap;
	public var foreforeground:FlxTilemap;

	// Level dimensions
	public var width:Int;
	public var height:Int;

	// Player reference
	public var player:Player;

	// Entities (to be added as needed)
	// public var bots:Bots;
	// public var rocks:Rocks;
	// etc.

	// UI and messages
	public var letterMsg:FlxText;

	// Level metadata
	public var levelNumber:Int = 1;

	public function new()
	{
		super();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	override public function destroy():Void
	{
		super.destroy();
	}
}
```

**Step 2: Verify compilation**

Run: `haxelib run lime build html5` (or `lime build html5` if in PATH)

Expected: Project compiles successfully (GameLevel not instantiated yet, so just needs to compile)

**Step 3: Commit**

```bash
git add source/GameLevel.hx
git commit -m "feat: add GameLevel base class stub

- Base class for all game levels
- Tilemaps for parallax backgrounds
- Player and entity references
- Ready for Level1 to extend

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Task 2: Create Player Class (Minimal)

**Goal:** Create a minimal Player class with basic movement and rendering.

**Files:**
- Create: `source/Player.hx`
- Reference: git tag `v1.0-flash:src/Player.as` (simplified)
- Update: `source/AssetPaths.hx` (add player assets)

**Step 1: Add player assets to AssetPaths**

Edit `source/AssetPaths.hx`, add to existing constants:

```haxe
// Player Graphics (already exist, but verify)
public static inline var PLAYER:String = "assets/player.png";
public static inline var PLAYER_HURT:String = "assets/player_hurt.png";

// Player Audio
public static inline var FOOTSTEP:String = "assets/footstep.mp3";
public static inline var FAST_STEP:String = "assets/faststep.mp3";
public static inline var JUMP_SFX3:String = "assets/jumpSFX3.mp3";
public static inline var SLIDE_SFX:String = "assets/slide.mp3";
public static inline var HURT_SFX:String = "assets/hurtSFX.mp3";
public static inline var LAND_SFX:String = "assets/land.mp3";
```

**Step 2: Create minimal Player class**

Create file `source/Player.hx`:

```haxe
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/**
 * Player character class
 * Handles movement, jumping, animations, and collision
 */
class Player extends FlxSprite
{
	// Movement constants
	private static inline var GRAVITY:Float = 600;
	private static inline var MAX_VELOCITY_X:Float = 170;
	private static inline var MAX_VELOCITY_Y:Float = 400;
	private static inline var JUMP_POWER:Float = -280;
	private static inline var GROUND_DRAG:Float = 600;
	private static inline var AIR_DRAG:Float = 300;

	// State flags
	private var canJump:Bool = true;
	public var isDying:Bool = false;
	public var isDucking:Bool = false;

	// Starting position
	private var startPos:FlxPoint;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		startPos = FlxPoint.get(x, y);

		// Load player sprite (40x60 frames)
		loadGraphic(AssetPaths.PLAYER, true, 40, 60);

		// Set up animations
		// Frame layout from Flash: idle, walk, jump, duck, etc.
		animation.add("idle", [0], 6, false);
		animation.add("walk", [1, 2, 3, 4], 8, true);
		animation.add("jump", [5], 6, false);
		animation.add("fall", [6], 6, false);
		animation.add("duck", [7], 6, false);

		animation.play("idle");

		// Physics setup
		acceleration.y = GRAVITY;
		maxVelocity.set(MAX_VELOCITY_X, MAX_VELOCITY_Y);
		drag.x = GROUND_DRAG;

		// Collision box (smaller than sprite for better feel)
		width = 30;
		height = 55;
		offset.set(5, 5);
	}

	override public function update(elapsed:Float):Void
	{
		// Movement input
		handleMovement();

		// Animation
		updateAnimation();

		super.update(elapsed);
	}

	private function handleMovement():Void
	{
		if (isDying || isDucking)
		{
			acceleration.x = 0;
			return;
		}

		// Horizontal movement
		if (FlxG.keys.pressed.LEFT)
		{
			acceleration.x = -Registry.playerNormalAccel;
			facing = LEFT;
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			acceleration.x = Registry.playerNormalAccel;
			facing = RIGHT;
		}
		else
		{
			acceleration.x = 0;
		}

		// Jumping
		if (FlxG.keys.justPressed.Z || FlxG.keys.justPressed.SPACE)
		{
			if (isTouching(DOWN) && canJump)
			{
				velocity.y = JUMP_POWER;
				FlxG.sound.play(AssetPaths.JUMP_SFX3);
			}
		}

		// Ducking
		if (FlxG.keys.pressed.DOWN && isTouching(DOWN))
		{
			isDucking = true;
			acceleration.x = 0;
		}
		else
		{
			isDucking = false;
		}

		// Adjust drag based on ground contact
		if (isTouching(DOWN))
		{
			drag.x = GROUND_DRAG;
		}
		else
		{
			drag.x = AIR_DRAG;
		}
	}

	private function updateAnimation():Void
	{
		if (isDying)
		{
			return;
		}

		if (isDucking)
		{
			animation.play("duck");
		}
		else if (!isTouching(DOWN))
		{
			if (velocity.y < 0)
			{
				animation.play("jump");
			}
			else
			{
				animation.play("fall");
			}
		}
		else if (velocity.x != 0)
		{
			animation.play("walk");
		}
		else
		{
			animation.play("idle");
		}
	}

	public function takeDamage(amount:Int = 1):Void
	{
		// TODO: Implement health system
		FlxG.sound.play(AssetPaths.HURT_SFX);
	}

	public function die():Void
	{
		isDying = true;
		velocity.set(0, 0);
		acceleration.set(0, 0);
		// TODO: Death animation and state transition
	}

	override public function destroy():Void
	{
		startPos = FlxPoint.weak();
		super.destroy();
	}
}
```

**Step 3: Verify compilation**

Run: `haxelib run lime build html5`

Expected: Project compiles successfully

**Step 4: Commit**

```bash
git add source/Player.hx source/AssetPaths.hx
git commit -m "feat: add minimal Player class

- Basic movement (left/right, jump, duck)
- Animation system (idle, walk, jump, fall, duck)
- Physics (gravity, acceleration, drag)
- Collision detection
- Sound effects for jump and hurt

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Task 3: Create Level1 Class (Minimal)

**Goal:** Create a simplified Level1 that extends GameLevel with basic tilemap and player spawn.

**Files:**
- Create: `source/Level1.hx`
- Reference: git tag `v1.0-flash:src/Level1.as`
- Update: `source/AssetPaths.hx` (add Level1 assets)

**Step 1: Add Level1 assets to AssetPaths**

Edit `source/AssetPaths.hx`:

```haxe
// Level 1 Assets
public static inline var L1_FOREGROUND_TILES:String = "assets/forest_tiles(4).png";
public static inline var L1_FOREGROUND_CSV:String = "assets/mapCSV_Level1_Foreground.csv";
```

**Step 2: Create Level1 class**

Create file `source/Level1.hx`:

```haxe
package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/**
 * Level 1 - First playable level
 * Simple forest level with basic platforming
 */
class Level1 extends GameLevel
{
	public function new()
	{
		super();

		levelNumber = 1;

		// Set up foreground tilemap (main collision layer)
		foreground = new FlxTilemap();
		foreground.loadMapFromCSV(AssetPaths.L1_FOREGROUND_CSV, AssetPaths.L1_FOREGROUND_TILES, 16, 16);

		// Set collision properties for solid tiles
		// Tiles 1-63 are solid, 0 is empty
		for (i in 1...64)
		{
			foreground.setTileProperties(i, FlxObject.ANY);
		}

		// Special tiles that can be jumped through from below (one-way platforms)
		foreground.setTileProperties(57, FlxObject.UP);

		// Register foreground as the collision map
		Registry.map = foreground;

		// Set level dimensions
		width = Std.int(foreground.width);
		height = Std.int(foreground.height);

		// Set level exit point (coordinates from Flash version)
		Registry.levelExit = FlxPoint.get(99 * 16, 16 * 16);

		// Create player at starting position
		if (Registry.checkpointFlag && Registry.checkpoint != null)
		{
			// Spawn at checkpoint
			player = new Player(Registry.checkpoint.x + 5, Registry.checkpoint.y - 5);
		}
		else
		{
			// Spawn at level start
			player = new Player(50, height - 64);
		}

		Registry.player = player;

		// Set camera bounds to level size
		FlxG.camera.setScrollBoundsRect(0, 0, width, height);

		// Camera follows player
		FlxG.camera.follow(player);

		// Add everything to the group (render order matters!)
		add(foreground);
		add(player);

		// Background color
		FlxG.cameras.bgColor = FlxColor.fromRGB(135, 206, 235); // Sky blue
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Collision between player and foreground
		FlxG.collide(player, foreground);

		// Check if player reached level exit
		if (player != null && Registry.levelExit != null)
		{
			if (player.overlaps(Registry.levelExit))
			{
				// TODO: Transition to next level or level complete state
				trace("Level complete!");
			}
		}

		// Check if player fell off the map (death)
		if (player != null && player.y > height + 100)
		{
			player.die();
			// TODO: Respawn or death menu
		}
	}
}
```

**Step 3: Verify compilation**

Run: `haxelib run lime build html5`

Expected: Project compiles successfully

**Step 4: Commit**

```bash
git add source/Level1.hx source/AssetPaths.hx
git commit -m "feat: add minimal Level1 class

- Extends GameLevel base class
- Loads tilemap from CSV and tileset PNG
- Collision setup for solid and one-way platforms
- Player spawn point handling
- Camera follows player
- Level exit detection
- Fall death detection

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Task 4: Create PlayState (Minimal)

**Goal:** Create PlayState that loads Level1 and manages basic game flow.

**Files:**
- Create: `source/PlayState.hx`
- Reference: git tag `v1.0-flash:src/PlayState.as`

**Step 1: Create PlayState class**

Create file `source/PlayState.hx`:

```haxe
package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * Main gameplay state
 * Manages level loading, UI, and game flow
 */
class PlayState extends FlxState
{
	private var currentLevel:GameLevel;
	private var levelButton:FlxButton;

	override public function create():Void
	{
		super.create();

		// Set up mouse cursor
		#if !FLX_NO_MOUSE
		FlxG.mouse.load(Registry.cursor, 1, 0, 0);
		FlxG.mouse.visible = true;
		#end

		// Load Level1
		loadLevel(1);

		// Create UI buttons
		createUI();
	}

	private function loadLevel(levelNum:Int):Void
	{
		// Clear existing level
		if (currentLevel != null)
		{
			remove(currentLevel);
			currentLevel.destroy();
			currentLevel = null;
		}

		// Create new level based on level number
		switch (levelNum)
		{
			case 1:
				currentLevel = new Level1();
			default:
				trace("Level " + levelNum + " not implemented yet");
				currentLevel = new Level1(); // Default to Level1
		}

		// Add level to state
		add(currentLevel);

		// Update Registry
		Registry.gameLevel = currentLevel;
		Registry.stageCount = levelNum - 1;
	}

	private function createUI():Void
	{
		// "Levels" button to return to menu
		levelButton = new FlxButton(2, 1, "Levels", goToMainMenu);
		levelButton.label.color = FlxColor.GRAY;
		levelButton.scrollFactor.set(0, 0); // Fixed to camera
		add(levelButton);

		// TODO: Add health bar, death counter, etc.
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// ESC key to return to menu
		if (FlxG.keys.justPressed.ESCAPE)
		{
			goToMainMenu();
		}

		// Debug: R to restart level
		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}
	}

	private function goToMainMenu():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.3, false, function()
		{
			FlxG.switchState(new MainMenuState());
		});
	}

	override public function destroy():Void
	{
		currentLevel = null;
		levelButton = null;

		super.destroy();
	}
}
```

**Step 2: Verify compilation**

Run: `haxelib run lime build html5`

Expected: Project compiles successfully

**Step 3: Commit**

```bash
git add source/PlayState.hx
git commit -m "feat: add minimal PlayState class

- Loads and manages game levels
- Creates UI (menu button)
- Handles level transitions
- ESC to return to menu
- R to restart level (debug)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Task 5: Connect MainMenuState to PlayState

**Goal:** Update MainMenuState to actually launch PlayState instead of showing stubs.

**Files:**
- Modify: `source/MainMenuState.hx`

**Step 1: Enable PlayState transitions**

Edit `source/MainMenuState.hx`, find and update these functions:

In `changeState()`:
```haxe
private function changeState():Void
{
	if (selector == 1)
	{
		FlxG.switchState(new PlayState());
	}
	else if (selector == 2)
	{
		// TODO: Convert LevelMenuState before uncommenting
		// FlxG.switchState(new LevelMenuState());
		trace("LevelMenuState not yet converted - staying on MainMenuState");
	}
}
```

In `startIt()`:
```haxe
private function startIt():Void
{
	Registry.stageCount = 0;
	Registry.musixFlag = true;
	FlxG.camera.flash(FlxColor.BLACK, 1);
	Registry.chkptsUsed = 0;

	FlxG.switchState(new PlayState());
}
```

**Step 2: Test the game**

Run: `haxelib run lime test html5`

Expected:
1. Main menu appears with animations
2. Pressing SPACE or clicking "START" transitions to PlayState
3. Level1 loads with player and tilemap
4. Player can move left/right and jump
5. Pressing ESC returns to main menu

**Step 3: Commit**

```bash
git add source/MainMenuState.hx
git commit -m "feat: connect MainMenuState to PlayState

- Enable PlayState transition from main menu
- Start button now launches Level1
- Game loop now functional: menu -> gameplay -> menu

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Task 6: Add Missing Registry Properties

**Goal:** Add any missing properties to Registry that the new classes need.

**Files:**
- Modify: `source/Registry.hx`

**Step 1: Add missing Registry properties**

Edit `source/Registry.hx`, add these properties if they don't exist:

```haxe
// Add after existing properties:
public static var gameLevel:GameLevel;
```

**Step 2: Verify compilation and test**

Run: `haxelib run lime test html5`

Expected: Game runs without errors

**Step 3: Commit**

```bash
git add source/Registry.hx
git commit -m "feat: add gameLevel property to Registry

- Allows PlayState to store current level reference
- Used for level management and transitions

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Task 7: Fix Compilation Errors and Test

**Goal:** Address any compilation errors and ensure the game runs.

**Step 1: Build and identify errors**

Run: `haxelib run lime build html5 -v`

Expected: Compilation succeeds, or specific errors are shown

**Step 2: Fix errors systematically**

Common issues to watch for:
- Missing imports
- Type mismatches (Int vs Float)
- Null safety issues
- Asset paths incorrect

For each error:
1. Read the error message
2. Identify the file and line
3. Fix the issue
4. Rebuild

**Step 3: Test the game**

Run: `haxelib run lime test html5`

Test checklist:
- [ ] Main menu loads with animations
- [ ] START button works
- [ ] Level1 loads
- [ ] Player sprite appears
- [ ] Player can move left/right
- [ ] Player can jump
- [ ] Player collides with ground
- [ ] Camera follows player
- [ ] ESC returns to menu

**Step 4: Commit fixes**

```bash
git add -u
git commit -m "fix: resolve compilation errors and runtime issues

- Fixed [specific issues]
- Game now runs smoothly
- All basic gameplay mechanics working

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Milestone: Minimal Playable Game Complete

At this point you should have:
- ✅ Functional main menu
- ✅ Working PlayState that loads levels
- ✅ Playable Level1 with collision
- ✅ Player movement and jumping
- ✅ Camera following
- ✅ Menu navigation

**Next Steps (Future Plans):**
- Add more entities (enemies, collectibles)
- Implement health system
- Add sound effects throughout
- Convert remaining levels (Level2-7)
- Add LevelMenuState for level selection
- Implement death/respawn system
- Add checkpoint system
- Convert entity classes as needed

---

## Testing Plan

After each task, verify:
1. **Compilation**: `haxelib run lime build html5` succeeds
2. **No console errors**: Check browser console for errors
3. **Visual verification**: Assets load correctly
4. **Functionality**: Feature works as expected

Final integration test:
1. Start game from main menu
2. Navigate to Level1
3. Play through Level1
4. Return to menu
5. Repeat cycle to ensure stability

---

## Notes for Implementation

**File Reading Strategy:**
- Use git tag `v1.0-flash:src/FileName.as` to reference original Flash code
- Example: `git show v1.0-flash:src/Player.as`

**HaxeFlixel API Differences from Flash:**
- `FlxG.play()` → `FlxG.sound.play()`
- `FlxG.playMusic()` → `FlxG.sound.playMusic()`
- `new FlxPoint(x, y)` → `FlxPoint.get(x, y)` (pooled)
- `FlxObject.NONE/ANY/UP/DOWN` for collision directions
- `FlxG.camera.follow()` instead of manual camera management

**Asset Loading:**
- No `[Embed]` metadata in HaxeFlixel
- Use string paths from AssetPaths class
- CSV maps load with `loadMapFromCSV()`
- PNG tiles load directly as second parameter

**Common Gotchas:**
- Remember `elapsed` parameter in update()
- Use `override` keyword for FlxSprite/FlxState methods
- Call `super.update(elapsed)` in update methods
- Call `super.create()` in create methods
- Proper cleanup in `destroy()` methods
