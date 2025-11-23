package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
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
	private static inline var GRAVITY:Float = 1000;
	private static inline var MAX_VELOCITY_X:Float = 170;
	private static inline var MAX_VELOCITY_Y:Float = 800;
	private static inline var GROUND_DRAG:Float = 600;
	private static inline var AIR_DRAG:Float = 300;

	// Slide deceleration constants (from Flash original)
	private static inline var SLIDE_DECEL_INITIAL:Float = 80;  // When moving fast (>100)
	private static inline var SLIDE_DECEL:Float = 280;          // When moving slower

	// State flags
	private var _canJump:Bool = true;
	public var isDying:Bool = false;
	public var isDucking:Bool = false;
	public var isSliding:Bool = false;
	public var canIdle:Bool = true;
	public var canPunch:Bool = true;
	public var canDuck:Bool = true;
	public var walkingFlag:Bool = false;
	public var isPumpingBrakes:Bool = false;
	public var knockback:Bool = false;
	public var deathFlag:Bool = false;
	public var pickup:Bool = false;

	// Timers
	private var _hurtTimer:Float = -1;
	private var _invTimer:Float = 0;
	private var _deadTimer:Float = 0;
	private var _letterTimer:Float = 0;
	public var pickupTimer:Float = 0;
	private var _jump:Float = 0;

	// Invincibility
	private var _invincible:Bool = false;

	// Umbrella/parachute
	private var umbrellaCounter:Int = 0;
	private var _paraFlag:Bool = false;

	// Sound effects
	public var walkSFX:FlxSound;
	private var _jumpSFX:FlxSound;
	private var _slideSFX:FlxSound;
	private var _jumpSFXflag:Bool = false;
	private var _deathSFXflag:Bool = false;

	// Movement values (dynamic, from Registry)
	public var accel:Float;
	private var decel:Float;
	public var speed:Float;

	// Starting position
	private var startPos:FlxPoint;

	// Max health
	private var _maxHealth:Int = 100;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		startPos = FlxPoint.get(x, y);

		// Load player sprite based on character selection (40x60 for girl, 14x32 for bot)
		if (Registry.character == "girl")
		{
			loadGraphic(AssetPaths.PLAYER, true, 40, 60);

			// Set up animations (frame indices from Flash original)
			animation.add("idle", [0], 0, false);
			animation.add("walk", [1, 0, 2, 0], 7, true);
			animation.add("run", [8, 9, 7, 9], 9, true);
			animation.add("jump", [11], 2, false);
			animation.add("fall", [12, 13], 15, true);
			animation.add("duck", [14], 0, false);
			animation.add("slide", [20], 0, false);
			animation.add("flip", [3, 4, 5, 6, 12, 12], 12, true);
			animation.add("hurt", [10], 1, true);
			animation.add("dead", [15], 0, false);
			animation.add("pickup", [19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19], 3, false);
			animation.add("parachute", [24, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23], 24, false);
			animation.add("letter", [26, 27, 28, 29, 30, 31, 32, 33, 0, 0], 18, false);
			animation.add("letterIdle", [26], 0, false);
			animation.add("hatIdle", [16, 17, 18, 40], 8, false);
			animation.add("hatAway", [41, 42, 43, 44, 45, 46, 0], 12, false);
			animation.add("pumpBrakes", [48], 0, false);

			// Collision box (from Flash original)
			width = 12;
			height = 32;
			offset.set(15, 24);
		}
		else // bot character
		{
			loadGraphic(AssetPaths.PLAYER_BOT, true, 14, 32);

			animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 16, true);
			animation.add("pumpBrakes", [0], 0, true);
			animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 16, true);
			animation.add("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 16, true);
			animation.add("jump", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 32, true);
			animation.add("fall", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 32, true);
			animation.add("duck", [11, 12], 16, true);
			animation.add("slide", [11, 12], 16, true);
			animation.add("flip", [14, 15, 16, 3], 12, true);
			animation.add("hurt", [10], 0, true);
			animation.add("dead", [17], 0, false);
			animation.add("pickup", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13], 16, false);
			animation.add("parachute", [19, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18], 24, false);

			width = 8;
			height = 32;
			offset.set(3, 0);
		}

		animation.play("idle");

		// Initialize sound effects
		walkSFX = new FlxSound();
		walkSFX.loadEmbedded(AssetPaths.FOOTSTEP, true);
		walkSFX.volume = 0.9;

		_jumpSFX = new FlxSound();
		_jumpSFX.loadEmbedded(AssetPaths.JUMP_SFX3, false);
		_jumpSFX.volume = 0.2;

		_slideSFX = new FlxSound();
		_slideSFX.loadEmbedded(AssetPaths.SLIDE_SFX, false);
		_slideSFX.volume = 0.5;

		// Physics setup
		acceleration.y = GRAVITY;
		maxVelocity.set(MAX_VELOCITY_X, MAX_VELOCITY_Y);
		drag.x = GROUND_DRAG;
		speed = MAX_VELOCITY_X;

		// Initialize health
		health = 100;

		// Enable collision
		solid = true;

		// Set up sprite flipping based on facing direction
		setFacingFlip(RIGHT, false, false);
		setFacingFlip(LEFT, true, false);
	}

	override public function update(elapsed:Float):Void
	{
		// Check if player is disabled
		if (Registry.disablePlayer)
		{
			canPunch = false;
			_canJump = false;
			canDuck = false;
			velocity.x = 0;
			super.update(elapsed);
			return;
		}

		// Handle timers
		updateTimers(elapsed);

		// Movement input (only if not dead/hurt)
		if (_deadTimer <= 0 && _hurtTimer <= 0)
		{
			handleMovement(elapsed);
		}

		// Handle jump separately (variable height)
		handleJump(elapsed);

		// Death check
		if (health <= 0)
		{
			dead();
		}

		// Fall death check
		if (Registry.gameLevel != null && y > Registry.gameLevel.height)
		{
			if (walkSFX != null) walkSFX.stop();
			dead();
		}

		// Boundary checks
		if (x < 0) x = 0;
		if (Registry.gameLevel != null)
		{
			if (x > Registry.gameLevel.width - width) x = Registry.gameLevel.width - width;
		}
		if (x < Registry.noGoingBack) x = Registry.noGoingBack;

		// Animation selection
		selectAnimation();

		super.update(elapsed);
	}

	private function updateTimers(elapsed:Float):Void
	{
		// Invincibility timer
		if (_invTimer > 0)
		{
			_invincible = true;
			// In HaxeFlixel, use FlxFlicker for invincibility flashing
			if (!flixel.effects.FlxFlicker.isFlickering(this))
			{
				flixel.effects.FlxFlicker.flicker(this, _invTimer);
			}
			_invTimer -= elapsed;
		}
		else
		{
			_invincible = false;
		}

		// Hurt timer
		if (_hurtTimer > 0)
		{
			_hurtTimer -= elapsed;
			animation.play("hurt");
			if (!knockback) velocity.x = 0;
		}
		else if (_hurtTimer < 0)
		{
			_hurtTimer = 0;
		}

		// Clear knockback when landing
		if (isTouching(FLOOR) && _invTimer <= 0)
		{
			knockback = false;
		}

		// Death timer
		if (_deadTimer > 0)
		{
			_deadTimer -= elapsed;
			_invincible = true;
			facing = RIGHT;
			animation.play("dead");
			if (Registry.character == "girl")
				offset.y = 28;
			else
				offset.y = 8;
			angle = 270;
			velocity.x = 0;
			height = 14;
			solid = false;
			isDying = true;
			_canJump = false;
			canPunch = false;
		}

		if (_deadTimer < 0 && deathFlag)
		{
			// Fade and respawn
			FlxG.camera.fade(0xFF000000, 0.1, false, onFade);
			_deadTimer = 0;
		}

		// Pickup timer
		if (pickupTimer > 0)
		{
			canIdle = false;
			_canJump = false;
			canPunch = false;
			animation.play("pickup");
			pickupTimer -= elapsed;
		}
		if (pickupTimer < 0)
		{
			canIdle = true;
			_canJump = true;
			canPunch = true;
			pickupTimer = 0;
		}

		// Letter timer
		if (_letterTimer > 0)
		{
			_letterTimer -= elapsed;
		}
		else if (_letterTimer < 0)
		{
			_letterTimer = 0;
			canIdle = true;
			canPunch = true;
		}
	}

	private function handleMovement(elapsed:Float):Void
	{
		// Reset umbrella counter on ground
		if (isTouching(FLOOR))
		{
			_jump = 0;
			umbrellaCounter = 0;
		}

		// Determine acceleration based on turn-around
		if ((facing == LEFT && velocity.x > 0) || (facing == RIGHT && velocity.x < 0))
		{
			accel = Registry.playerTurnAroundAccel;
			if (isTouching(FLOOR))
			{
				isPumpingBrakes = true;
			}
		}
		else
		{
			if (isPumpingBrakes && facing == RIGHT)
				facing = LEFT;
			else if (isPumpingBrakes)
				facing = RIGHT;
			isPumpingBrakes = false;
			accel = Registry.playerNormalAccel;
		}

		// Ground vs air physics
		if (isTouching(FLOOR))
		{
			speed = MAX_VELOCITY_X;

			// Ducking/sliding
			if (FlxG.keys.pressed.DOWN && !isDying && canDuck)
			{
				isDucking = true;
				acceleration.x = 0;
				canIdle = false;
				if (walkSFX != null) walkSFX.stop();
				walkingFlag = false;

				if (Math.abs(velocity.x) > 100)
					decel = Registry.playerInitialSlideDecel;
				else
					decel = Registry.playerSlideDecel;

				if (Math.abs(velocity.x) > 50)
				{
					isSliding = true;
					if (_slideSFX != null && !_slideSFX.playing)
						_slideSFX.play();
				}
				else
				{
					isSliding = false;
					if (_slideSFX != null) _slideSFX.stop();
				}
			}
			else
			{
				if (_slideSFX != null) _slideSFX.stop();
				isDucking = false;
				isSliding = false;
				canIdle = true;
				decel = Registry.playerNormalDecel;
			}
		}
		else
		{
			// Air physics
			if (_slideSFX != null) _slideSFX.stop();
			accel = Registry.playerAirAccel;
			if (!(FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT))
				decel = Registry.playerAirDecel;
			else
				decel = 0;
		}

		// Apply movement (if not ducking)
		if (!isDying && !isDucking)
		{
			if (FlxG.keys.pressed.LEFT)
			{
				acceleration.x = -accel;
				facing = LEFT;
			}
			else if (FlxG.keys.pressed.RIGHT)
			{
				acceleration.x = accel;
				facing = RIGHT;
			}
			else
			{
				acceleration.x = 0;
			}
		}

		// Update max velocity and drag
		maxVelocity.x = speed;
		drag.x = decel > 0 ? decel : GROUND_DRAG;

		// Walking sound handling
		handleWalkingSound();
	}

	private function handleWalkingSound():Void
	{
		if (isTouching(FLOOR) && velocity.x != 0 && !isDucking)
		{
			if (!walkingFlag && Math.abs(velocity.x) > 50)
			{
				if (Registry.stageCount != 5 && walkSFX != null)
				{
					walkSFX.play(true);
				}
				walkingFlag = true;
			}

			// Adjust volume based on speed
			if (walkSFX != null)
			{
				if (Math.abs(velocity.x) > 100)
					walkSFX.volume = 1.0;
				else
					walkSFX.volume = 0.5;
			}
		}
		else
		{
			if (walkSFX != null) walkSFX.stop();
			walkingFlag = false;
		}
	}

	private function handleJump(elapsed:Float):Void
	{
		// Variable height jump system
		if (_jump >= 0 && (FlxG.keys.pressed.Z || FlxG.keys.pressed.UP || FlxG.keys.pressed.SPACE) && _letterTimer <= 0 && _canJump)
		{
			_jump += elapsed;

			if (Math.abs(velocity.x) >= MAX_VELOCITY_X)
			{
				// Fast jump = flip animation with longer duration
				if (_jump > 0.22)
				{
					_jump = -1;
					_canJump = false;
				}
			}
			else
			{
				// Normal jump
				if (_jump > 0.15)
				{
					_canJump = false;
					_jump = -1;
				}
			}
		}
		else
		{
			_jump = -1;
		}

		// Apply jump velocity
		if (_jump > 0)
		{
			if (_jump < 0.13)
			{
				velocity.y = -200; // Minimum jump speed

				// Play jump sound once
				if (!_jumpSFXflag)
				{
					if (Registry.stageCount != 5 && _jumpSFX != null)
						_jumpSFX.play();
					_jumpSFXflag = true;
					if (walkSFX != null) walkSFX.stop();
				}
			}
		}
		else
		{
			// Parachute/umbrella mechanic
			if ((FlxG.keys.pressed.Z || FlxG.keys.pressed.UP || FlxG.keys.pressed.SPACE) &&
				_letterTimer <= 0 && velocity.y > 10 && _hurtTimer <= 0 && Registry.hasUmbrella)
			{
				acceleration.y = 100;
				if (!_paraFlag)
				{
					if (umbrellaCounter <= 3)
					{
						velocity.y = 10;
						umbrellaCounter += 1;
						animation.play("parachute");
						if (Registry.stageCount != 5)
							FlxG.sound.play(AssetPaths.UMBRELLA_SFX);
						_paraFlag = true;
					}
					else
					{
						acceleration.y = GRAVITY;
						_paraFlag = false;
					}
				}
			}
			else
			{
				acceleration.y = GRAVITY;
				_paraFlag = false;
			}
		}

		// Reset jump flag when key released
		if (!(FlxG.keys.pressed.Z || FlxG.keys.pressed.UP || FlxG.keys.pressed.SPACE))
			_canJump = true;

		// Prevent re-jump while falling
		if ((FlxG.keys.pressed.Z || FlxG.keys.pressed.UP || FlxG.keys.pressed.SPACE) && velocity.y > 30)
			_canJump = false;

		// Clear jump sound flag when falling
		if (velocity.y > 0)
		{
			if (_jumpSFX != null) _jumpSFX.stop();
			_jumpSFXflag = false;
		}
	}

	private function selectAnimation():Void
	{
		// Death animation handled by timer
		if (isDying || _deadTimer > 0)
		{
			return;
		}

		// Hurt animation handled by timer
		if (_hurtTimer > 0)
		{
			return;
		}

		// Pickup animation
		if (pickupTimer > 0)
		{
			return;
		}

		// Parachute animation
		if (_paraFlag)
		{
			return;
		}

		// Use both isTouching and wasTouching for more reliable ground detection
		var onGround = isTouching(FLOOR) || wasTouching.has(FLOOR);

		// Determine which animation should play
		var anim:String = "idle";

		if (isDucking)
		{
			if (isSliding)
			{
				anim = "slide";
			}
			else
			{
				anim = "duck";
			}
		}
		else if (!onGround)
		{
			if (velocity.y < 0)
			{
				// Flip animation when jumping at max speed
				if (Math.abs(velocity.x) >= MAX_VELOCITY_X && _jump > 0.10)
				{
					anim = "flip";
				}
				else
				{
					anim = "jump";
				}
			}
			else
			{
				anim = "fall";
			}
		}
		else if (velocity.x != 0)
		{
			if (isPumpingBrakes)
			{
				anim = "pumpBrakes";
			}
			else if (Math.abs(velocity.x) >= MAX_VELOCITY_X)
			{
				anim = "run";
			}
			else
			{
				anim = "walk";
			}
		}
		else if (canIdle && _letterTimer <= 0 && !Registry.letterSequence)
		{
			anim = "idle";
		}

		// Only change animation if different
		if (animation.name != anim)
		{
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

	/**
	 * Called when player takes damage from enemies/hazards
	 * @param damage Amount of damage to take
	 * @param invTimerDuration How long to be invincible after (default 0.8s)
	 */
	public function ouch(damage:Int, invTimerDuration:Float = 0.8):Void
	{
		if (_invincible)
		{
			return;
		}

		animation.play("hurt");

		// Play hurt sound based on character
		if (Registry.character == "girl")
		{
			if (Registry.stageCount != 5)
				FlxG.sound.play(AssetPaths.HURT_SFX);
		}
		else
		{
			if (Registry.stageCount != 5)
				FlxG.sound.play(AssetPaths.HURT_BOT_SFX);
		}

		// Screen shake
		FlxG.camera.shake(0.03, 0.02);

		// Apply damage and start timers
		health -= damage;
		_hurtTimer = 0.3;
		_invincible = true;
		_invTimer = invTimerDuration;
	}

	/**
	 * Alias for ouch() for compatibility
	 */
	public function takeDamage(amount:Int = 1):Void
	{
		ouch(amount);
	}

	/**
	 * Called when player bounces on an enemy
	 */
	public function bounce(bounceAmount:Int):Void
	{
		velocity.y = -bounceAmount;
		umbrellaCounter = 0; // Same as landing on ground
		animation.play("flip");
	}

	/**
	 * Called when player dies (health <= 0 or falls off level)
	 */
	public function dead():Bool
	{
		if (!deathFlag)
		{
			_deadTimer = 0.1;

			Registry.totalDeaths += 1;
			Registry.deaths += 1;

			// Screen shake
			FlxG.camera.shake(0.02, 0.1);

			canIdle = false;
			if (walkSFX != null) walkSFX.stop();

			// Play death sound
			if (!_deathSFXflag)
			{
				if (Registry.stageCount != 5)
					FlxG.sound.play(AssetPaths.DEATH);
				_deathSFXflag = true;

				if (Registry.deathCount < 16)
					Registry.deathCount += 1;
				else
					Registry.deathCount = 1;
			}
		}

		deathFlag = true;
		return true;
	}

	/**
	 * Alias for dead() for compatibility
	 */
	public function die():Void
	{
		dead();
	}

	/**
	 * Called when death fade completes - restart level
	 */
	private function onFade():Void
	{
		FlxG.switchState(new PlayState());
	}

	/**
	 * Called when player picks up a letter/item
	 */
	public function putAway():Void
	{
		if (Registry.stageCount != 5)
		{
			FlxG.sound.play(AssetPaths.FOLD_PAPER_SFX);
			animation.play("letter");
		}
		else
		{
			animation.play("hatAway");
		}
		canIdle = false;
		_letterTimer = 0.7;

		if (Registry.gameLevel != null && Registry.gameLevel.letterMsg != null)
		{
			Registry.gameLevel.letterMsg.visible = false;
		}
	}

	/**
	 * Set the letter timer (for cutscenes)
	 */
	public function setLetterTimer(lt:Float):Void
	{
		_letterTimer = lt;
	}

	/**
	 * Get invincibility status
	 */
	public function getInvincible():Bool
	{
		return _invincible;
	}

	override public function destroy():Void
	{
		if (startPos != null)
		{
			startPos.put();
		}
		startPos = null;

		// Clean up sounds
		if (walkSFX != null)
		{
			walkSFX.stop();
			walkSFX.destroy();
			walkSFX = null;
		}
		if (_jumpSFX != null)
		{
			_jumpSFX.stop();
			_jumpSFX.destroy();
			_jumpSFX = null;
		}
		if (_slideSFX != null)
		{
			_slideSFX.stop();
			_slideSFX.destroy();
			_slideSFX = null;
		}

		super.destroy();
	}
}
