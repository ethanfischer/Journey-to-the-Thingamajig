package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;

/**
 * Level 1 - First playable level
 * Simple forest level with basic platforming
 */
class Level1 extends GameLevel
{
	// Background sprites (parallax layers)
	private var bgSprite:FlxSprite;
	private var bgBackSprite:FlxSprite;

	public function new()
	{
		super();

		levelNumber = 1;

		// Back-background layer (farthest parallax - scrolls slowest)
		// The woody images have trees on the right half (256-512), left half is empty
		// Use clipRect to only show the right portion with trees
		bgBackSprite = new FlxSprite(0, 0);
		bgBackSprite.loadGraphic(AssetPaths.L1_BACKBACKGROUND_TILES);
		bgBackSprite.scrollFactor.set(0, 0);
		bgBackSprite.clipRect = new flixel.math.FlxRect(256, 0, 256, 300);

		// Background layer (mid parallax)
		bgSprite = new FlxSprite(0, 0);
		bgSprite.loadGraphic(AssetPaths.L1_BACKGROUND_TILES);
		bgSprite.scrollFactor.set(0.3, 0);
		bgSprite.clipRect = new flixel.math.FlxRect(256, 0, 256, 300);

		// Foreground tilemap (main collision layer)
		foreground = new FlxTilemap();
		foreground.loadMapFromCSV(AssetPaths.L1_FOREGROUND_CSV, AssetPaths.L1_FOREGROUND_TILES, 16, 16, null, 0, 1, 1);

		// Set level dimensions from foreground tilemap
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
			// Spawn at level start (original Flash position)
			player = new Player(50, 200);
		}

		Registry.player = player;

		// Camera follows player within level bounds
		FlxG.camera.setScrollBoundsRect(0, 0, width, height);
		FlxG.camera.follow(player);

		// Add everything to the group (render order matters - back to front!)
		add(bgBackSprite);
		add(bgSprite);
		add(foreground);
		add(player);

		// Background color (sky blue behind the forest)
		FlxG.cameras.bgColor = FlxColor.fromRGB(135, 206, 235);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Collision handled in PlayState

		// Check if player reached level exit
		if (player != null && Registry.levelExit != null)
		{
			var playerMid = player.getMidpoint();
			if (playerMid.distanceTo(Registry.levelExit) < 32)
			{
				// TODO: Transition to next level or level complete state
				trace("Level complete!");
			}
			playerMid.put(); // Return pooled point
		}

		// Check if player fell off the map (death)
		if (player != null && player.y > height + 100)
		{
			player.die();
			// TODO: Respawn or death menu
		}
	}
}
