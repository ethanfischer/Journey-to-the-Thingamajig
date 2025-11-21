package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/**
 * Player character class
 * Handles movement, jumping, animations, and collision
 */
class Player extends FlxSprite
{
	// Movement constants
	private static inline var GRAVITY:Float = 600;
	private static inline var MAX_VELOCITY_X:Float = 170;
	private static inline var MAX_VELOCITY_Y:Float = 400;
	private static inline var JUMP_POWER:Float = -280;
	private static inline var GROUND_DRAG:Float = 600;
	private static inline var AIR_DRAG:Float = 300;

	// State flags
	private var canJump:Bool = true;
	public var isDying:Bool = false;
	public var isDucking:Bool = false;

	// Starting position
	private var startPos:FlxPoint;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		startPos = FlxPoint.get(x, y);

		// Load player sprite (40x60 frames)
		loadGraphic(AssetPaths.PLAYER, true, 40, 60);

		// Set up animations
		// Frame layout from Flash: idle, walk, jump, duck, etc.
		animation.add("idle", [0], 6, false);
		animation.add("walk", [1, 2, 3, 4], 8, true);
		animation.add("jump", [5], 6, false);
		animation.add("fall", [6], 6, false);
		animation.add("duck", [7], 6, false);

		animation.play("idle");

		// Physics setup
		acceleration.y = GRAVITY;
		maxVelocity.set(MAX_VELOCITY_X, MAX_VELOCITY_Y);
		drag.x = GROUND_DRAG;

		// Collision box (smaller than sprite for better feel)
		width = 30;
		height = 55;
		offset.set(5, 5);
	}

	override public function update(elapsed:Float):Void
	{
		// Movement input
		handleMovement();

		// Animation
		updateAnimation();

		super.update(elapsed);
	}

	private function handleMovement():Void
	{
		if (isDying || isDucking)
		{
			acceleration.x = 0;
			return;
		}

		// Horizontal movement
		if (FlxG.keys.pressed.LEFT)
		{
			acceleration.x = -Registry.playerNormalAccel;
			facing = FlxObject.LEFT;
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			acceleration.x = Registry.playerNormalAccel;
			facing = FlxObject.RIGHT;
		}
		else
		{
			acceleration.x = 0;
		}

		// Jumping
		if (FlxG.keys.justPressed.Z || FlxG.keys.justPressed.SPACE)
		{
			if (isTouching(FlxObject.DOWN) && canJump)
			{
				velocity.y = JUMP_POWER;
				FlxG.sound.play(AssetPaths.JUMP_SFX3);
			}
		}

		// Ducking
		if (FlxG.keys.pressed.DOWN && isTouching(FlxObject.DOWN))
		{
			isDucking = true;
			acceleration.x = 0;
		}
		else
		{
			isDucking = false;
		}

		// Adjust drag based on ground contact
		if (isTouching(FlxObject.DOWN))
		{
			drag.x = GROUND_DRAG;
		}
		else
		{
			drag.x = AIR_DRAG;
		}
	}

	private function updateAnimation():Void
	{
		if (isDying)
		{
			return;
		}

		if (isDucking)
		{
			animation.play("duck");
		}
		else if (!isTouching(FlxObject.DOWN))
		{
			if (velocity.y < 0)
			{
				animation.play("jump");
			}
			else
			{
				animation.play("fall");
			}
		}
		else if (velocity.x != 0)
		{
			animation.play("walk");
		}
		else
		{
			animation.play("idle");
		}
	}

	public function takeDamage(amount:Int = 1):Void
	{
		// TODO: Implement health system
		FlxG.sound.play(AssetPaths.HURT_SFX);
	}

	public function die():Void
	{
		isDying = true;
		velocity.set(0, 0);
		acceleration.set(0, 0);
		// TODO: Death animation and state transition
	}

	override public function destroy():Void
	{
		if (startPos != null)
		{
			startPos.put();
		}
		startPos = null;
		super.destroy();
	}
}
