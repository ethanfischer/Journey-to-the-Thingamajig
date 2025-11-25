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
