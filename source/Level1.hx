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

		// Back-background layer (farthest parallax - scrolls slowest)
		// Flash: backbackground.loadMap(new backbackgroundCSV, backbackgroundTilesPNG, 252, 300);
		backbackground = new FlxTilemap();
		backbackground.loadMapFromCSV(AssetPaths.L1_BACKBACKGROUND_CSV, AssetPaths.L1_BACKBACKGROUND_TILES, 252, 300);
		backbackground.scrollFactor.x = 0.2;

		// Background layer (mid parallax)
		// Flash: background.loadMap(new backgroundCSV, backgroundTilesPNG, 256, 300);
		background = new FlxTilemap();
		background.loadMapFromCSV(AssetPaths.L1_BACKGROUND_CSV, AssetPaths.L1_BACKGROUND_TILES, 256, 300);
		background.scrollFactor.x = 0.7;

		// Foreground tilemap (main collision layer)
		// Flash: foreground.loadMap(new foregroundCSV, foregroundTilesPNG, 16, 16, 0, 0, 1, 24);
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
			// Spawn at level start (original Flash: height - 64, but 200 works for current level)
			player = new Player(50, 200);
		}

		Registry.player = player;

		// Camera follows player within level bounds
		FlxG.camera.setScrollBoundsRect(0, 0, width, height);
		FlxG.camera.follow(player);

		// Add everything to the group (render order matters - back to front!)
		add(backbackground);
		add(background);
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
