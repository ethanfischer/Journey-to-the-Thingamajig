package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * Bot enemy - walking robot that patrols platforms
 * Turns around at edges and when hitting walls
 * Can be killed by player bouncing on it or knockback
 */
class Bot extends FlxSprite
{
	public var isDying:Bool = false;
	private var dieTimer:Float = 0;
	private var bounceTimer:Float = 0;
	private var turnAroundTimer:Float = 0;
	private var knockBackTimer:Float = 0;
	private var canKnockback:Bool = false;
	private var retreatFlag:Bool = false;
	public var specialOne:Bool = false;
	public var dTurnFlag:Bool = false;
	private var suicidal:Bool = false;
	private var isSuiciding:Bool = false;

	public function new(tileX:Int, tileY:Int, initialFacing:Int, isSuicidal:Bool = false)
	{
		super(tileX * 16, tileY * 16);

		retreatFlag = false;
		suicidal = isSuicidal;

		loadGraphic(AssetPaths.BOT, true, 16, 24);

		facing = initialFacing;
		solid = true;

		// Animations
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, true);
		animation.add("idleRight", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, true);
		animation.add("idleLeft", [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 20, true);
		animation.add("stop", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 10, true);
		animation.add("dead", [0, 11, 12, 13], 40, false);
		animation.add("retreat", [14, 15, 16, 17, 16, 17, 16, 17], 20, false);

		animation.play("walk");

		offset.y = 0;
		acceleration.y = 500;

		// Flip sprite based on facing (0x0010 = RIGHT, 0x0001 = LEFT)
		setFacingFlip(0x0010, false, false); // RIGHT
		setFacingFlip(0x0001, true, false);  // LEFT

		// Set initial velocity based on facing direction
		if (facing == 0x0001) // LEFT
		{
			velocity.x = -30;
		}
		else // RIGHT (0x0010)
		{
			velocity.x = 30;
		}
	}

	override public function kill():Void
	{
		isDying = true;
		acceleration.x = 0;
		drag.x = 100;
		removeSprite();
	}

	public function isBot2():Bool
	{
		return false;
	}

	public function dodge():Void
	{
		// Placeholder - overridden in Bot2
	}

	private function removeSprite():Void
	{
		dieTimer = 3;
		animation.play("dead");
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		checkSuicide();

		// Check for collision with walls
		// Note: We check wasTouching (from previous frame) because FlxG.collide
		// happens after update(), so touching flags are set for next frame
		if ((wasTouching.toInt() & 0x0010) != 0) // Was touching RIGHT last frame
		{
			turnAround();
		}
		if ((wasTouching.toInt() & 0x0001) != 0) // Was touching LEFT last frame
		{
			turnAround();
		}

		// Timers
		updateTimers(elapsed);

		// Edge detection for turning around
		if (!canKnockback && !isDying && !isSuiciding)
		{
			checkEdge();
		}
	}

	private function updateTimers(elapsed:Float):Void
	{
		// Die timer
		if (dieTimer > 0)
		{
			dieTimer -= elapsed;
			if (dieTimer < 1)
				alpha -= elapsed * 5;
		}
		if (dieTimer < 0)
		{
			exists = false;
		}

		// Knockback timer
		if (knockBackTimer > 0)
		{
			knockBackTimer -= elapsed;
		}
		if (knockBackTimer < 0)
		{
			knockBackTimer = 0;
			canKnockback = true;

			velocity.y = -75;
			drag.x = 200;

			if (Registry.player != null && x > Registry.player.x)
			{
				velocity.x = 400;
				angle += 20;
			}
			else
			{
				if (Registry.stageCount == 2)
					velocity.x = -600;
				else
					velocity.x = -400;
				angle -= 20;
			}
		}

		// Bounce timer
		if (bounceTimer > 0)
		{
			bounceTimer -= elapsed;
		}
		else if (bounceTimer < 0)
		{
			bounceTimer = 0;
			velocity.y = -75;
			drag.x = 1000;
		}

		// Turn around timer
		if (turnAroundTimer > 0)
		{
			turnAroundTimer -= elapsed;
		}
		else if (turnAroundTimer < 0)
		{
			turnAroundTimer = 0;
			dTurnFlag = false;
			turnAround();
		}
	}

	private function checkEdge():Void
	{
		if (Registry.map == null)
			return;

		var tx:Float = x / 16;
		var ty:Float = y / 15.5;

		if (facing == LEFT)
		{
			// Check tile ahead and below - if air, turn around
			if (Registry.map.getTile(Std.int(tx - 0.2), Std.int(ty + 1.5)) <= 23)
			{
				delayedTurnaround(0.25);
				return;
			}
		}
		else
		{
			if (Registry.map.getTile(Std.int(tx + 1), Std.int(ty + 1.5)) <= 23)
			{
				delayedTurnaround(0.25);
				return;
			}
		}
	}

	public function turnAround():Void
	{
		if (!isDying && !isSuiciding)
		{
			if (facing == 0x0010) // RIGHT
			{
				facing = 0x0001; // LEFT
				velocity.x = -30;
				animation.play("idleRight");
			}
			else
			{
				facing = 0x0010; // RIGHT
				velocity.x = 30;
				animation.play("idleLeft");
			}
		}
	}

	/**
	 * Called when player bounces on bot
	 */
	public function bounce():Void
	{
		kill();
		bounceTimer = 0.1;
		FlxG.camera.shake(0.04, 0.15);
	}

	/**
	 * Called when player knockbacks bot (slide attack)
	 */
	public function knockback():Void
	{
		kill();
		FlxG.camera.shake(0.03, 0.1);
		knockBackTimer = 0.01;
	}

	private function checkSuicide():Void
	{
		if (suicidal && isOnScreen() && Registry.player != null && Registry.player.isTouching(FLOOR) && Registry.playtime % 300 > 0 && Registry.playtime % 300 < 0.5 && Registry.playtime > 1)
		{
			velocity.y = -150;
			velocity.x = 60;
			solid = false;
			suicidal = false;
			isSuiciding = true;
			FlxG.sound.play(AssetPaths.EJECT_SFX);
			FlxG.sound.play(AssetPaths.WILHELM_SFX);
		}
	}

	public function hop():Void
	{
		if (bounceTimer == 0)
		{
			bounceTimer = 0.1;
		}
	}

	public function retreat():Void
	{
		if (!retreatFlag)
		{
			FlxG.sound.play(AssetPaths.EJECT_SFX);
			animation.play("retreat");
			drag.x = 200;
			// TODO: lilguy integration when LilGuy class exists
			retreatFlag = true;
		}
		active = false;
	}

	public function delayedTurnaround(delay:Float):Void
	{
		if (!dTurnFlag && !isDying && !isSuiciding)
		{
			velocity.x = 0;
			animation.play("stop");
			turnAroundTimer = delay;
			dTurnFlag = true;
		}
	}
}
