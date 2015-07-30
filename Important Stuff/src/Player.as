package
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.system.FlxReplay;
	
	public class Player extends FlxSprite
	{
		[Embed(source = "../assets/player_40x40(letter).png")] private var _girlPNG:Class; //normal
		[Embed(source = "../assets/egg(2).png")] private var _botPNG:Class; //robot
		[Embed(source = "../assets/player_hurt.png")] private var _playerHurtPNG:Class;
		[Embed(source = "../assets/hitbox.png")] private var _hitboxPNG:Class;
		[Embed(source="../assets/footstep.mp3")] private var _girlwalkSound:Class; //normal walk sound
		[Embed(source = "../assets/faststep.mp3")] private var _fastgirlwalkSound:Class;//faster
		[Embed(source = "../assets/Wowiwiw.mp3")] private var _botwalkSound:Class; //bot walk sound
		[Embed(source = "../assets/jumpSFX3.mp3")] private var _jumpSoundEffect:Class;
		[Embed(source="../assets/slide.mp3")] private var _slideSoundEffect:Class;
		[Embed(source = "../assets/hurtSFX.mp3")] private var _ouchSFX:Class;
		[Embed(source = "../assets/hurtSFX(bot).mp3")] private var _ouchBotSFX:Class;
		[Embed(source = "../assets/land.mp3")] private var _land:Class;
		
		private var _deathSFX:Class;
		
		
		[Embed(source = "../assets/slidewhistle.mp3")] private var _slideWhistle:Class;
	
		[Embed(source = "../assets/umbrella.mp3")] private var _umbrellaSFX:Class;
		[Embed(source = "../assets/foldpaper.mp3")] private var _foldPaperSFX:Class;
		
		
		private var _paraFlag:Boolean;
		private var _deathSFXflag:Boolean;
		
		private var _jumpSFX:FlxSound;
		private var _fadeoutFlag:Boolean= false;
		private var _footage:String;
		
		public var walkSFX:FlxSound;
		private var _jumpSFXflag:Boolean;
		private var _slideSFX:FlxSound;
		
		private var _start:FlxPoint;
		private var _maxHealth:int;
		private var _hurtTimer:Number = -1;
		private var _invTimer:Number;
		public var pickup:Boolean = false;
		private var _invincible:Boolean;
		private var _deadTimer:Number = 0;
		public var pickupTimer:Number;
		private var _letterTimer:Number;
		public var deathFlag:Boolean;
		public var _canJump:Boolean = true;
		private var _jump:Number;
		private const MAXSPEED:Number = 170;
		public var hitBox:FlxSprite;
		public var screen:FlxSprite; //for updating things off screen
		public var screen2:FlxSprite; //for updating things that visible on screen
		public var canIdle:Boolean = true;
		public var canPunch:Boolean = true;
		public var isDying:Boolean = false;
		public var isDucking:Boolean = false;
		private var umbrellaCounter:int; //when you first open the umbrella, it slows you down. Only let this happen a few times so players cant abuse this power
		
		public var walkingFlag:Boolean = false;
		public var halted:Boolean;
		public var facingFlag:Boolean;
		private var _flag497:Boolean; //why the fuck would I name something this??
		
		public var knockback:Boolean = false;
		
		
		public var accel:Number;
		private	var decel:Number;
		public	var speed:Number;
		
		public function Player(X:Number, Y:Number)
		{	
			
			
			//	As this extends FlxSprite we need to call super() to ensure all of the parent variables we need are created
			super(X, Y);
			
			_start = new FlxPoint(x, y);
			
			//	Load the player.png into this sprite.
			//	The 2nd parameter tells Flixel it's a sprite sheet and it should chop it up into 16x18 sized frames.
			
			////////////////////////////////////
			//				GIRL			  //
			////////////////////////////////////
			
			if (Registry.character == "girl")
			{
				loadGraphic(_girlPNG, true, true, 40, 60, true);
			
				addAnimation("idle", [0], 0, false);
				addAnimation("walk", [1, 0, 2, 0], 7, true);
				addAnimation("run", [8, 9, 7, 9], 7, true);
				addAnimation("jump", [11], 2, false);
				addAnimation("fall", [12, 13], 15, true);
				addAnimation("duck", [14], 0, true);
				addAnimation("slide", [20], 0, false);
				addAnimation("flip", [3, 4, 5, 6, 12, 12], 12, true);
				addAnimation("hurt", [10], 1, true);
				addAnimation("dead", [15], 0, false);
				addAnimation("pickup", [19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19], 3, false);
				addAnimation("parachute", [24, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23, 23], 24, false);
				addAnimation("letter", [26, 27,28,29,30,31,32,33,0,0], 18, false);
				
				//handle walking Soundeffect stuff here
				walkSFX = new FlxSound();
				if (Registry.mode == "normal") walkSFX.loadEmbedded(_girlwalkSound, true, false);
				else if (Registry.mode == "caffeinated") walkSFX.loadEmbedded(_fastgirlwalkSound, true, false);
				else if (Registry.mode == "high") 
				{
					walkSFX.loadEmbedded(_girlwalkSound, true, false);
					walkSFX.volume = 0.9;
				}
	
				_jumpSFX = new FlxSound;
				_jumpSFX.loadEmbedded(_jumpSoundEffect, false, true);
				_jumpSFX.volume = .01;
				
				_slideSFX = new FlxSound;
				_slideSFX.loadEmbedded(_slideSoundEffect, false, false);
				_slideSFX.volume = .5;
					
				width = 12;
				height = 32;
				
				//	Because we've shaved a few pixels off, we need to offset the sprite to compensate
				offset.x = 15;
				offset.y = 24;	
			}
			
			/////////////////////////////////////////////
			//				BOT						   //
			/////////////////////////////////////////////
			
			else if (Registry.character == "bot")
			{
				loadGraphic(_botPNG, true, true, 14, 32, true);
				
				addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 16, true);
				addAnimation("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 16, true);
				addAnimation("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 16, true);
				addAnimation("jump", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 32, true);
				addAnimation("fall", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 32, true);
				addAnimation("duck", [11, 12], 16, true);
				addAnimation("slide", [11, 12], 16, true);
				addAnimation("flip", [14, 15, 16, 3], 12, true);
				addAnimation("hurt", [10], 0, true);
				addAnimation("dead", [17], 0, false);
				addAnimation("pickup", [0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13], 16, false);
				addAnimation("parachute", [19, 18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18], 24, false);
				
				
				//handle walking Soundeffect stuff here
				walkSFX = new FlxSound();
				walkSFX.loadEmbedded(_botwalkSound, true, false);
				walkSFX.volume = .09;
				
				_jumpSFX = new FlxSound;
				_jumpSFX.loadEmbedded(_jumpSoundEffect, false, true);
				_jumpSFX.volume = .2;
				
				_slideSFX = new FlxSound;
				_slideSFX.loadEmbedded(_slideSoundEffect, false, false);
				_slideSFX.volume = .5;
				
				width = 8;
				height = 32;
				
				//	Because we've shaved a few pixels off, we need to offset the sprite to compensate
				offset.x = 3;
				offset.y = 0;
				
				
			}
			
			//hitbox
			hitBox = new FlxSprite(x + 14, y);
			hitBox.loadGraphic(_hitboxPNG, true, true, 34, 20, true);
			hitBox.width = 38;
			hitBox.height = 20;
			hitBox.exists = true;
			hitBox.visible = false;
		
			//screen
			screen = new FlxSprite(x - 500, y - 250);
			screen.width = 2000;
			screen.height = 500;
			screen.exists = true;
			screen.visible = false;
			
			//screen2
			screen2 = new FlxSprite(x, y - 250);
			screen2.width = Registry.screenWidth;
			screen2.height = 500;
			screen2.exists = true;
			screen2.visible = false;
		
			health = 100;
			_maxHealth = 100;
			
			//	Enable the Controls plugin - you only need do this once (unless you destroy the plugin)
			if (FlxG.getPlugin(FlxControl) == null)
			{
				FlxG.addPlugin(new FlxControl);
			}
			
			//	Add this sprite to the FlxControl plugin and tell it we want the sprite to accelerate and decelerate smoothly
			FlxControl.create(this, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, true, false);
			
			//	By default the sprite is facing to the right.
			//	Changing this tells Flixel to flip the sprite frames to show the left-facing ones instead.
			facing = FlxObject.RIGHT;
		}
		
		override public function update():void
		{
			super.update();
			
			//////////////////////////////////////////////////////////////////////////////////////
			//      								TIMERS										// 
			//////////////////////////////////////////////////////////////////////////////////////
			//while the _invTimer is on, set _invincible to true
			if (_invTimer > 0)
			{
				_invincible = true;
				flicker(_invTimer);
				_invTimer -= FlxG.elapsed;
			}
			else
			{
				_invincible = false;
			}
			//-----------------------------------------------------------------------------------//
			if (_hurtTimer > 0)
			{
				_hurtTimer -= FlxG.elapsed;
				play("hurt")
				FlxControl.player1.setCursorControl(false, false, false, false);
				if (!knockback) velocity.x = 0;
			}
			else if (_hurtTimer < 0)
			{
				FlxControl.player1.setCursorControl(false, false, true, true);
				_hurtTimer = 0;
			}
			
			if (isTouching(FLOOR) && _invTimer < 0) knockback = false;
			//----------------------------------------------------------------------------------//
			if (_deadTimer > 0)
			{
				_deadTimer -= FlxG.elapsed;
				_invincible = true;
				facing = RIGHT;
				play("dead");
				if (Registry.character == "girl") offset.y = 28;
				else if (Registry.character == "bot") offset.y = 8;
				angle = 270;
				velocity.x = 0;
				height = 14;
				solid = false;
				isDying = true;
				_canJump = false;
				canPunch = false;
				FlxControl.player1.setCursorControl(false, false, false, false);
			}
			
			//----------------------------------------------------------------------------------//
			if (pickupTimer > 0)
			{
				canIdle = false;
				_canJump = false;
				canPunch = false;
				play("pickup");
				pickupTimer -= FlxG.elapsed;
				FlxControl.player1.setCursorControl(false, false, false, false);
			}
			if (pickupTimer < 0)
			{
				canIdle = true;
				_canJump = true;
				canPunch = true;
				pickupTimer = 0;
				FlxControl.player1.setCursorControl(false, false, true, true);
			}
			//--------------------------------------------------------------------------------------//
			if (_letterTimer > 0)
			{
				_letterTimer -= FlxG.elapsed;
				FlxControl.player1.setCursorControl(false, false, false, false);
			}
			else if (_letterTimer < 0)
			{
				_letterTimer = 0;
				moves = true;
				canIdle = true;
				FlxControl.player1.setCursorControl(false, false, true, true);
			}
			
	
			///////////////////////////////////////////////////////////////////////////////////////
			//                                         ?                                         //
			///////////////////////////////////////////////////////////////////////////////////////
			
			//not exactly sure what this does. Left boundary maybe?
			if (x < 0) x = 0;
			if (x > Registry.gameLevel.end.x) x = Registry.gameLevel.end.x;
			if (x < Registry.noGoingBack) x = Registry.noGoingBack;
			
			////////////////////////////////////////////////////////////////////////////////////
			//								Idle, Walk, Run, Duck, and Jump					  //
			////////////////////////////////////////////////////////////////////////////////////
		
			//if (justTouched(FlxObject.FLOOR)) FlxG.play(land, 1, false);
			
			if (isTouching(FlxObject.FLOOR))
			{
				_jump = 0;
				umbrellaCounter = 0; //so that you can slow down again
				
				if (velocity.x != 0)
				{
					if (Math.abs(velocity.x) >= MAXSPEED)
					{
						play("run");
						
						if (!walkingFlag)
						{
							walkSFX.play(true);
							walkingFlag = true;
							_fadeoutFlag = false;
						}
					}
					else
					{
						play("walk");
						
						if (!walkingFlag)
						{
							walkSFX.play(true);
							_fadeoutFlag = false;
							walkingFlag = true;
						}
					}
				}
				else
				{
					//don't play walkingSFX if you're not walking
					if (this.velocity.x == 0)
					{
						/*if (!_fadeoutFlag)
						{
						walkSFX.fadeOut(.1, true);
						_fadeoutFlag = true;
						} */
						walkSFX.stop();
						walkingFlag = false;
					}
					
					
					if (canIdle)
					{
						play("idle");
					}
				}
			}
			else if (velocity.y < 0)
			{	
				walkingFlag = false;
				
				if (Math.abs(velocity.x) >= MAXSPEED)
				{
					//play("flip");
					if (!_jumpSFXflag)
					{
					_jumpSFX.play();
					_jumpSFXflag = true;
					walkSFX.stop();
					}
				}
				else
				{
					//play("jump");
					walkSFX.stop();
					
					if (!_jumpSFXflag)
					{
					_jumpSFX.play();
					_jumpSFXflag = true;
					}
				}
			}
			else if (velocity.y > 0) 
			{
				if(!_paraFlag)play("fall");
				_jumpSFX.stop();
				_jumpSFXflag = false;
			}
			
			//JUMP
			jump();
			
			//////////////////////
			//		HITBOX		//
			//////////////////////
			if (Registry.character == "girl") hitBox.y = this.y + 10;
			else if (Registry.character == "bot") hitBox.y = this.y;
			
			
			if (_facing == RIGHT)
			{
				hitBox.x = this.x + 8;
			}
			else
			{
				hitBox.x = this.x - 32;
			}
			
			//////////////////////
			//		SCREEN		//
			//////////////////////
			screen.y = this.y - 250;
			screen.x = this.x - 1500;
			screen2.x = x - Registry.screenWidth/2.5;
			screen2.y = y - Registry.screenHeight/2;			
			/////////////////////
			//		SPEED	   //
			/////////////////////
			if (isTouching(FLOOR))
			{
				speed = MAXSPEED;
			}
			
			
			
			//////////////////////
			//	ACCEL & DECEL   //
			//////////////////////
			
					if ((facing == LEFT && velocity.x > 0) || (facing == RIGHT && velocity.x < 0))
					{
						accel = 1000;
					}
					else
					{
						accel = 550;
					}
					
					if (touching == FlxObject.FLOOR)
					{
						
						if (FlxG.keys.DOWN && !isDying)
						{
							_flag497 = false;
							isDucking = true;
							acceleration.x = 0;
							canIdle = false;
							walkSFX.stop()
							walkingFlag = false;
							if (Math.abs(velocity.x) > 100) decel = 70
							else decel = 150;
							
							if (Math.abs(velocity.x) > 50)
							{
								play("slide");
								_slideSFX.play();
							}
							
							else 
							{
								play("duck");
								_slideSFX.stop();
							}
						}
						else
						{
							_slideSFX.stop();
							isDucking = false;
							if (!_flag497)
							{
								canIdle = true;
								_flag497 = true;
							}
							decel = 1500;
						}
					}
					else
					{
						_slideSFX.stop();
						if(!(FlxG.keys.LEFT || FlxG.keys.RIGHT)) decel = 200
						else decel = 0;
					}
				//}
			FlxControl.player1.setAdvancedMovementSpeed(accel, accel, 400, 400, speed, 800, decel, 0);
			
			
			/////////////
			//  DEATH  //
			/////////////
			if (health <= 0)
			{
				dead();
			}
			if (y > Registry.gameLevel.height)
			{
				walkSFX.stop();
				dead();
			}
			
			// PAUSE SOUNDS
			if (Registry.pauseSounds)
			{
				walkSFX.volume = 0;
				_jumpSFX.volume = 0;
				_slideSFX.volume = 0;
				_deathSFX = null;
				_ouchSFX = null;
			}
			else if (!Registry.pauseSounds)
			{
				walkSFX.volume = 0.9;
				_jumpSFX.volume = 0.2;
				_slideSFX.volume = 0.5;
				_deathSFX = _slideWhistle;
			} 
			
		}
	
		///////////////////////////////////////////////////////////////////////////////////////////
		//										OTHER METHODS									 //
		///////////////////////////////////////////////////////////////////////////////////////////
				
		private function jump():void
		{
			_jump:Number;
				if((_jump >= 0) && (FlxG.keys.Z || FlxG.keys.UP) && (_canJump)) //You can also use space or any other key you want
				{	
					_jump += FlxG.elapsed;
					if (Math.abs(velocity.x) >= MAXSPEED)
					{
						if (_jump > 0.10) play("flip");
						
						if (_jump > 0.22)
						{
							_jump = -1; //You can't jump for more than 0.25 seconds
							_canJump = false;
						}
					}
					else
					{
						if (_jump > 0.15)
							{
								_canJump = false;
								play("jump");
								_jump = -1; //You can't jump for more than 0.25 seconds
							}
				}
            }
            else 
			{
				_jump = -1;
			}
 
            if (_jump > 0)
            {
                if (_jump < 0.13)
				{
					play("jump")
                    velocity.y = -200; //This is the minimum speed of the jump
				}
                //else
                    //velocity.y = -200; //The general acceleration of the jump
            } else
            {
				if ((FlxG.keys.Z || FlxG.keys.UP) && velocity.y > 10 && _hurtTimer <= 0 && Registry.hasUmbrella) 
				{
					acceleration.y = 100;
					if(!_paraFlag)
					{
						if (umbrellaCounter <= 3) 
						{
							velocity.y = 10;
							umbrellaCounter += 1;
							play("parachute");
							FlxG.play(_umbrellaSFX);
							_paraFlag = true;
						}
						else
						{
							acceleration.y = 1000;
							_paraFlag = false;
						}
					}
				}
				else 
				{
					acceleration.y = 1000;
					_paraFlag = false;
				}
            }
			
			if (!FlxG.keys.Z) _canJump = true;
			if (FlxG.keys.Z && velocity.y > 30) _canJump = false;
		}
		
		public function bounce(bounceAmount:int):void
		{
			velocity.y = -bounceAmount;
			umbrellaCounter = 0; // same as landing on the ground
			play("flip");
		}
		
		
		public function ouch(damage:int):void
		{
			if (_invincible)
			{
				return;
			}
			else
			{
				play("hurt");
				if (Registry.character == "girl") FlxG.play(_ouchSFX);
				else if (Registry.character == "bot") FlxG.play(_ouchBotSFX);
				FlxG.shake(.03, .02);
				health -= damage;
				_hurtTimer = .3;
				_invincible = true;
				_invTimer = .8;
				
			}
		}
		
		public function dead():Boolean
		{
			//death
			if (!deathFlag)
			{
				_deadTimer = .2;
						
				Registry.totalDeaths += 1;
				Registry.deaths += 1;
				FlxG.shake(.02, .1);
			
				//FlxG.music.stop();      //if forest sounds, comment this out. If beats, leave uncommented
				canIdle = false;
				walkSFX.stop();
				
				if (!_deathSFXflag)
				{
					FlxG.play(_deathSFX);
					_deathSFXflag = true;
					if (Registry.deathCount < 16) Registry.deathCount += 1;
					else Registry.deathCount = 1;
				}
				
			}
			
			if (_deadTimer < 0)
			{
				FlxG.fade(0x00000000, .2, onFade);	
			}
			deathFlag = true;
			return true;
		}
	
		public function get getInvincible():Boolean
		{
			return _invincible;
		}
		
		public function get getFacing():uint
		{
			return _facing;
		}
		
		public function onFade():void
		{
			FlxG.switchState(new PlayState);
		}
		
		public function putAway():void
		{
			FlxG.play(_foldPaperSFX, 1);
			canIdle = false;
			_letterTimer = .7;
			play("letter");
		}
		
	}
}
