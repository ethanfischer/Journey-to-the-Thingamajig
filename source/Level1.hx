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
	public function new()
	{
		super();

		levelNumber = 1;

		// Set up foreground tilemap (main collision layer)
		foreground = new FlxTilemap();

		// Simple test map: 25 tiles wide, 20 tiles tall
		// Tile 0 = empty, Tile 1 = solid ground
		var testMapData:Array<Int> = [];
		for (row in 0...19)
		{
			for (col in 0...25)
			{
				testMapData.push(0); // empty
			}
		}
		// Bottom row - all solid (tile 1)
		for (col in 0...25)
		{
			testMapData.push(1);
		}

		// loadMapFromArray params: mapData, widthInTiles, heightInTiles, tileGraphic, tileWidth, tileHeight, autoTile, startingIndex, drawIndex, collideIndex
		foreground.loadMapFromArray(testMapData, 25, 20, AssetPaths.L1_FOREGROUND_TILES, 16, 16, null, 0, 1, 1);

		// Set level dimensions from tilemap
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
			// Spawn at level start - player is 55 tall, floor is at 304 (row 19 * 16)
			// Spawn 50 pixels above floor: 304 - 55 - 50 = 199
			player = new Player(50, 199);
		}

		Registry.player = player;

		// Camera follows player within level bounds
		FlxG.camera.setScrollBoundsRect(0, 0, width, height);
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
