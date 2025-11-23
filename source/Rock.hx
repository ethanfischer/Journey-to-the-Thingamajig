package;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * Rock obstacle - destructible rock that explodes when hit
 */
class Rock extends FlxSprite
{
	private var timer:Float = 0;
	private var killFlag:Bool = false;

	public function new(tileX:Int, tileY:Int)
	{
		super(tileX * 16, tileY * 16);

		drag.x = 9000;

		loadGraphic(AssetPaths.ROCK, true, 24, 24);
		width = 16;
		height = 16;
		offset.x = 4;
		offset.y = 4;

		animation.add("explode", [1, 2, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4], 24, false);
		animation.add("idle", [1], 10, false);

		animation.play("idle");

		solid = true;
		immovable = true;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Death timer
		if (timer > 0)
		{
			timer -= elapsed;
			animation.play("explode");
		}
		if (timer < 0)
		{
			exists = false;
		}
	}

	override public function kill():Void
	{
		solid = false;
		FlxG.sound.play(AssetPaths.ROCK_BUST_SFX);
		acceleration.y = 100;

		if (!killFlag)
		{
			timer = 0.3;
			killFlag = true;
		}
	}

	// Placeholder for PlayState compatibility
	public function knockback():Void {}
}
