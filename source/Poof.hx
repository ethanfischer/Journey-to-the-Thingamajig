package;

import flixel.FlxSprite;

/**
 * Poof particle effect - explosion/puff animation
 * Auto-destroys when animation completes
 */
class Poof extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		loadGraphic(AssetPaths.POOF, true, 16, 16);

		animation.add("poof", [0, 1, 2, 3], 12, false);
		animation.play("poof");
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Destroy when animation finishes
		if (animation.finished)
		{
			exists = false;
		}
	}
}
