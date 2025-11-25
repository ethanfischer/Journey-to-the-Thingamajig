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

		// Load the reinforcement sprite (16x16 frames)
		loadGraphic(AssetPaths.REINFORCEMENT, true, 16, 16);

		// Flash animations:
		// idle: [1,2,3,4,5,6,7,7] at 9 fps
		// explode: [8,9,10,11,11,...] at 10 fps
		animation.add("idle", [1, 2, 3, 4, 5, 6, 7, 7], 9, true);
		animation.add("explode", [8, 9, 10, 11], 10, false);
		animation.play("idle");

		immovable = true;
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
