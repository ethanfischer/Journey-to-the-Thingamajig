package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
#if html5
import js.Browser;
#end

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

		// Set up animations (frame indices from Flash original)
		animation.add("idle", [0], 0, false);
		animation.add("walk", [1, 0, 2, 0], 7, true);
		animation.add("run", [8, 9, 7, 9], 9, true);
		animation.add("jump", [11], 2, false);
		animation.add("fall", [12, 13], 15, true);
		animation.add("duck", [14], 0, false);

		animation.play("idle");

		// Physics setup
		acceleration.y = GRAVITY;
		maxVelocity.set(MAX_VELOCITY_X, MAX_VELOCITY_Y);
		drag.x = GROUND_DRAG;

		// Collision box (from Flash original - smaller than sprite)
		// Note: HaxeFlixel offset shifts graphic relative to hitbox differently than Flash
		width = 12;
		height = 32;
		offset.set(15, 28);

		// Enable collision
		solid = true;

		// Set up sprite flipping based on facing direction
		// Sprite faces right by default, flip horizontally when facing left
		setFacingFlip(RIGHT, false, false);
		setFacingFlip(LEFT, true, false);

		// Debug hitbox visualization
		debugHitbox = new FlxSprite();
		debugHitbox.makeGraphic(Std.int(width), Std.int(height), 0x80FF0000); // Semi-transparent red
	}

	// Debug hitbox sprite
	private var debugHitbox:FlxSprite;

	override public function draw():Void
	{
		super.draw();

		// Draw debug hitbox
		if (debugHitbox != null)
		{
			debugHitbox.x = x;
			debugHitbox.y = y;
			debugHitbox.draw();
		}
	}

	override public function update(elapsed:Float):Void
	{
		// Movement input
		handleMovement();

		// Animation selection (before super.update so animation.update() advances frames)
		selectAnimation();

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
			facing = LEFT;
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			acceleration.x = Registry.playerNormalAccel;
			facing = RIGHT;
		}
		else
		{
			acceleration.x = 0;
		}

		// Jumping
		if (FlxG.keys.justPressed.Z || FlxG.keys.justPressed.SPACE)
		{
			if (isTouching(FLOOR) && canJump)
			{
				velocity.y = JUMP_POWER;
				FlxG.sound.play(AssetPaths.JUMP_SFX3);
			}
		}

		// Ducking
		if (FlxG.keys.pressed.DOWN && isTouching(FLOOR))
		{
			isDucking = true;
			acceleration.x = 0;
		}
		else
		{
			isDucking = false;
		}

		// Adjust drag based on ground contact
		if (isTouching(FLOOR))
		{
			drag.x = GROUND_DRAG;
		}
		else
		{
			drag.x = AIR_DRAG;
		}
	}

	private function selectAnimation():Void
	{
		if (isDying)
		{
			return;
		}

		// Use both isTouching and wasTouching for more reliable ground detection
		// This handles the one-frame delay in collision detection
		var onGround = isTouching(FLOOR) || wasTouching.has(FLOOR);

		// Determine which animation should play
		var anim:String = "idle";

		if (isDucking)
		{
			anim = "duck";
		}
		else if (!onGround)
		{
			if (velocity.y < 0)
			{
				anim = "jump";
			}
			else
			{
				anim = "fall";
			}
		}
		else if (velocity.x != 0)
		{
			// Run animation at max speed (Flash original: >= MAXSPEED which is 170)
			if (Math.abs(velocity.x) >= MAX_VELOCITY_X)
			{
				anim = "run";
			}
			else
			{
				anim = "walk";
			}
		}

		// Only change animation if different (prevents restarting looping animations)
		if (animation.name != anim)
		{
			remoteLog("Animation change: " + animation.name + " -> " + anim + " | velocity.x=" + velocity.x + " | threshold=" + MAX_VELOCITY_X);
			animation.play(anim);
		}
	}

	private function remoteLog(msg:String):Void
	{
		#if html5
		Browser.window.fetch("http://localhost:9999/log", {
			method: "POST",
			body: msg
		});
		#end
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
