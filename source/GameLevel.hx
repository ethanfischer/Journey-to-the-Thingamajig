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
