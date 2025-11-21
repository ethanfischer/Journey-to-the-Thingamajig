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
