package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * Checkpoint entity - save point that player can activate
 * When touched, sets the player's spawn point for respawning after death
 */
class Checkpoint extends FlxSprite
{
	public var isDying:Bool = false;
	private var dieTimer:Float = 0;
	public var aliveTimer:Float = 0;
	public var dieFlag:Bool = false;
	public var isEnd:Bool;
	public var popable:Bool = true;
	public var second:Bool;

	public function new(tileX:Int, tileY:Int, isEndCheckpoint:Bool = false, isSecond:Bool = false)
	{
		super(tileX * 16, tileY * 16);

		second = isSecond;
		isEnd = isEndCheckpoint;

		if (isEnd)
		{
			loadGraphic(AssetPaths.ENDING, true, 32, 32);
		}
		else
		{
			loadGraphic(AssetPaths.CHECKPOINT, true, 16, 16);
		}

		facing = RIGHT;
		width = 16;
		height = 16;

		solid = true;

		// Animations
		animation.add("run", [3, 4, 0, 1, 2, 1, 0, 4], 2, true);
		animation.add("fall", [2], 12, true);
		animation.add("pop", [5, 5, 5, 5, 6, 7, 10], 7, false);

		animation.play("run");
	}

	/**
	 * Called when checkpoint is activated by player
	 */
	override public function kill():Void
	{
		popable = false;

		if (!dieFlag)
		{
			FlxG.camera.flash(0xFFCCCC, 0.3);
			animation.play("pop");

			if (!isEnd)
			{
				if (Registry.stageCount != 5)
					FlxG.sound.play(AssetPaths.POP_SFX);
			}

			isDying = true;
			dieTimer = 1.7;
			dieFlag = true;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Die timer
		if (dieTimer > 0)
		{
			dieTimer -= elapsed;
		}
		if (dieTimer < 0)
		{
			exists = false;
		}
	}
}
