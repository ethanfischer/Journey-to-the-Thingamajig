package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
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
		foreground.loadMapFromCSV(AssetPaths.L1_FOREGROUND_CSV, AssetPaths.L1_FOREGROUND_TILES, 16, 16, null, 0, 1, 24);

		// Set level dimensions from foreground tilemap
		width = Std.int(foreground.width);
		height = Std.int(foreground.height);

		// Set Registry.map for bot edge detection
		Registry.map = foreground;

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

		// Initialize entity groups
		bots = new Bots();
		rocks = new Rocks();
		checkpoints = new FlxGroup();
		reinforcements = new Reinforcements();

		// Parse and spawn bots
		parseEntityCSV(AssetPaths.L1_BOTS_CSV, function(col, row, tile) {
			var facing = (tile == 2) ? 0x0001 : 0x0010; // LEFT : RIGHT
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
			var cp = new Checkpoint(col, row, isEnd);
			checkpoints.add(cp);
		});

		// Parse and spawn reinforcements
		parseEntityCSV(AssetPaths.L1_REINFORCEMENTS_CSV, function(col, row, tile) {
			reinforcements.addReinforcement(col, row);
		});

		// Add tutorial signs
		var sign1 = new Sign(135, 240, "PRESS 'Z' TO JUMP");
		add(sign1);

		// Camera follows player within level bounds
		FlxG.camera.setScrollBoundsRect(0, 0, width, height);
		FlxG.camera.follow(player);

		// Add everything to the group (render order matters - back to front!)
		add(backbackground);
		add(background);
		add(foreground);
		add(checkpoints);
		add(reinforcements);
		add(rocks);
		add(bots);
		add(player);

		// Background color (sky blue behind the forest)
		FlxG.cameras.bgColor = FlxColor.fromRGB(135, 206, 235);

		// Start level music
		FlxG.sound.playMusic(AssetPaths.L1_MUSIC, 0.7, true);
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
}
