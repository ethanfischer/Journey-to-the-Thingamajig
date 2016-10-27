package  
{
	import org.flixel.*;

	public class Bot extends FlxSprite
	{
		[Embed(source = "../map/bot.png")] private var botPNG:Class;
		[Embed(source = "../assets/eject.mp3")] private var ejectSFX:Class;
		[Embed(source = "../assets/wilhelm_scream.mp3")] private var scream:Class;
		
		public var isDying:Boolean = false;
		private var dieTimer:Number;
		private var bounceTimer:Number;
		private var turnAroundTimer:Number;
		private var knockBackTimer:Number;
		private var player:Player;
		private var canKnockback:Boolean = false;
		private var retreatFlag:Boolean = false;
		public var specialOne:Boolean; //if true, this is the bot that the lilguy will retreat from
		public var dTurnFlag:Boolean = false;
		private var suicidal:Boolean = false;
		private var id:Number;	
		private var isSuiciding:Boolean = false;
		
		public function Bot(x:int, y:int, i_player:Player, i_facing:uint, i_suicidal:Boolean = false)
		{
			super(x * 16, y * 16);
			
			id = x;

			retreatFlag = false;
			player = i_player;
			
			loadGraphic(botPNG, true, true, 16, 24);
			
			facing = i_facing;
			
			solid = true;
			active = false;
			suicidal = i_suicidal;

			
			addAnimation("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, true);
			addAnimation("idleRight", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 20, true);
			addAnimation("idleLeft", [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 20, true);
			addAnimation("stop", [0,1,2,3,4,5,6,7,8,9,10], 10, true);
			addAnimation("dead", [0, 11, 12, 13], 40, false);
			addAnimation("retreat", [14, 15, 16, 17, 16, 17, 16, 17] , 20, false);
			
			
			play("walk");
			
			dieTimer = 0;
			
			this.offset.y = 0;
			acceleration.y = 500;
			velocity.x = 20;
		}
		
		override public function kill():void
		{		
			isDying = true;
			
			acceleration.x = 0;
			drag.x = 100;
		
			removeSprite();
		}
		
		
		private function removeSprite():void
		{
			dieTimer = 3;
			play("dead");
		}
		
		override public function update():void
		{
			super.update();

			suicide();
			
			if (Registry.totalDeaths % 12 != 0 || Registry.totalDeaths == 0) this.specialOne = false;
			
			if (specialOne && onScreen() && player.x > x - 50 && player.x < x && player.y > y - 100 && player.y < y + 100 && Registry.character != "bot") 
			{		
				retreat();	
			}
			
			//if colliding with Rocks or other things, turn around! (yay! this was surprisingly easy)
			if (isTouching(RIGHT))
			{
				turnAround();
			}
			if (isTouching(LEFT))
			{
				turnAround();
			}
			
			//wtf is this?
			/*if (player.x > x - 250 && player.x < x + 250)
			{
				if (player.x < x && facing == RIGHT && (Registry.map.getTile(tx - .2, ty + 1.5) > 23)) turnAround();
				else if (player.x > x && facing == LEFT && (Registry.map.getTile(tx + 1, ty + 1.5) > 23)) turnAround();
			} */
			
			
			////////////////////////////
			//		   TIMERS		  //
			////////////////////////////
			if (dieTimer > 0)															
			{																			
				dieTimer -= FlxG.elapsed;												
				if (dieTimer < 1) this.alpha -= FlxG.elapsed * 5;						
			}
			if (dieTimer < 0)
			{	
				exists = false;
			}
			
			if (knockBackTimer > 0)
			{
				knockBackTimer -= FlxG.elapsed;
			}
			if (knockBackTimer < 0)
			{
				//FlxG.timeScale = Registry.nmlTimescale;
				knockBackTimer = 0;
				canKnockback = true;
			
				
				velocity.y = -75;
				drag.x = 200;
				
				if (x > player.x)
				{
					velocity.x =  400;
					angle += 20;
				}
				else
				{
					if (Registry.stageCount == 2) velocity.x = -600;
					else velocity.x = -400;
					angle -= 20;
				}
			}
		
			if (bounceTimer > 0)
			{
				bounceTimer -= FlxG.elapsed;
			}
			else if (bounceTimer < 0)
			{
				bounceTimer = 0;
				//FlxG.timeScale = Registry.nmlTimescale;
				
				velocity.y = -75;
				drag.x = 1000;
			}
			
			if (turnAroundTimer > 0)
			{
				turnAroundTimer -= FlxG.elapsed;
			}
			else if (turnAroundTimer < 0)
			{
				turnAroundTimer = 0;
				dTurnFlag = false;
				turnAround();
			}
			
			if (!canKnockback) //don't allow bots to turn around when they have been knocked back
			{
				var tx:Number = Number(x / 16);
				var ty:Number = Number(y / 15.5);
			
			
				 if (facing == FlxObject.LEFT)
				{
					//31 is the Collide Index of our Tilemap (which sadly isn't exposed in Flixel 2.5, so is hard-coded here. Not ideal I appreciate)
					if (Registry.map.getTile(tx - .2, ty + 1.5) <= 23)
					{
						delayedTurnaround(.25);
						//turnAround();
						return;
					}
					
				}
				else
				{
					//31 is the Collide Index of our Tilemap (which sadly isn't exposed in Flixel 2.5, so is hard-coded here. Not ideal I appreciate)
					if (Registry.map.getTile(tx + 1, ty + 1.5) <= 23)
					{
						
						delayedTurnaround(.25);
						//turnAround();
						return;
					}
				} 
			}
		}
		
		public function turnAround():void
		{
			if (!isDying && !isSuiciding)
			{
				if (facing == FlxObject.RIGHT)
				{
					
					facing = FlxObject.LEFT;
					////IMPLEMENT A PAUSED TURN AROUND/////////////////////////////////////////////////////////
					velocity.x = -30;
					play("idleRight");
				}
				else
				{
					facing = FlxObject.RIGHT;
					velocity.x = 30;
					play("idleLeft");
				}
			}
		}
		
		public function bounce():void
		{
			kill();
		
			//Registry.nmlTimescale = FlxG.timeScale;
			//FlxG.timeScale = .3;
			bounceTimer = .1;
			FlxG.shake(.04, .15, null, true, 2);
		}
		
		public function knockback():void
		{		
			kill();
			
			//if(FlxG.timeScale > .1) Registry.nmlTimescale = FlxG.timeScale;
			//FlxG.timeScale = .14;
			FlxG.shake(.03, .1, null, true, 1);
			knockBackTimer = .01;
		
			
		}

		public function suicide():void
		{
			//check if suicidal
			if(suicidal == true)
			{
				//FlxG.log("suicidal");
			//make it uncollidable
				if(onScreen() && 
					Registry.gameLevel.player.isTouching(FlxObject.FLOOR)
						/*&& player.x > x - 200 &&*/
							//&& Registry.playtime % 5500 > 0 
								//&& Registry.playtime % 5500 < 0.5
							&& Registry.playtime % 20 > 0 //for testing purposes
								&& Registry.playtime % 20 < 0.5
									&& Registry.playtime > 0) 
				{
					velocity.y = -150;
					velocity.x = 60;
					solid = false;
					suicidal = false;
					isSuiciding = true;
					//FlxG.play(scream);
					FlxG.play(ejectSFX);
					FlxG.play(scream);


				}
				
			//jump off the screen	
			}
			

		}

		public function hop():void
		{
			if (bounceTimer == 0)
			{
				bounceTimer = .1;
			}
		}
		
		public function retreat():void
		{
			if (!retreatFlag)
			{
				FlxG.play(ejectSFX);
				play("retreat");
				drag.x = 200;
				Registry.gameLevel.lilguy.active = true;
				Registry.gameLevel.lilguy.x = x + 7;
				Registry.gameLevel.lilguy.y = y;
				Registry.gameLevel.lilguy.velocity.y -= 250;
				Registry.gameLevel.lilguy.aliveTimer = 8;
				retreatFlag = true;
			}
			active = false;
		}
		
		public function delayedTurnaround(delay:Number):void
		{
			if (!dTurnFlag && !isDying && !isSuiciding)
			{
			velocity.x = 0;
			play("stop");
			turnAroundTimer = delay;
			dTurnFlag = true;
			}
		}
	}

}