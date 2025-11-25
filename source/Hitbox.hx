package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * Invisible collision box for player attacks (punching/kicking)
 * Follows player and positioned based on facing direction
 */
class Hitbox extends FlxSprite
{
	public function new()
	{
		super();

		// Load hitbox sprite (invisible in game, but has collision)
		loadGraphic(AssetPaths.HITBOX, false, 34, 20);
		width = 38;
		height = 20;
		immovable = true;
		visible = false; // Debug: set to true to see hitbox
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (Registry.player == null) return;

		// Position hitbox relative to player character
		if (Registry.character == "girl")
		{
			y = Registry.player.y + 10;
		}
		else if (Registry.character == "bot")
		{
			y = Registry.player.y;
		}
		else
		{
			// Default for other characters
			y = Registry.player.y + 10;
		}

		// Position based on facing direction
		if (Registry.player.facing == RIGHT)
		{
			x = Registry.player.x + 8;
		}
		else // LEFT
		{
			x = Registry.player.x - 32;
		}
	}
}
