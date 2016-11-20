package  
{
	import org.flixel.*;

	public class Borg extends FlxSprite
	{
		[Embed(source = "../map/borg(dark).png")] private var borgPNG:Class;
		
		[Embed(source = "../assets/pig_borg.mp3")] private var growlSFX:Class;
		[Embed(source="../assets/borgDeathSFX.mp3")] private var deathSFX:Class;
		private var growlSFX_flag:Boolean = false;
		
		
		public var isDying:Boolean = false;
		private var dieTimer:Number;
		private var player:Player;
		private var knockedBack:Boolean = false;
		public var chargeDirection:String;
		public var chargeBool:Boolean;
		public var stunTimer:Number;  // when > 0, have the Borg remain motionless, flash, and be harmless
		public var awakeBool:Boolean = true; //when true, have the Borg follow its normal routine
		public var reanimateBool:Boolean = false;
		
		public function Borg(x:int, y:int, i_player:Player, i_facing:uint)
		{
			super(x * 16, y * 16 + 125);
			
			player = i_player;
			facing = i_facing;
			
			loadGraphic(borgPNG, true, true, 48, 48);
			width = 48;
			height = 40;
			offset.x = 4;
			offset.y = 4;
			
			solid = true;
			active = false;
			
			addAnimation("walk", [0, 1, 0, 2], 6, true);
			addAnimation("charge", [3,4,5], 20, false);
			addAnimation("dead", [6,6,6,6,6,7,7,7], 2, false);
			
			play("walk");
			
			dieTimer = 0;
			acceleration.y = 500;
			if      (facing == FlxObject.RIGHT) velocity.x = 35;
			else if (facing == FlxObject.LEFT) velocity.x = -35;

		}
		
		override public function kill():void
		{		
			// FlxG.play(deathSFX);
			play("dead");
			stunTimer = 4;
			
			drag.x = 100;
			//removeSprite();
		}
		
		
		private function removeSprite():void
		{
			dieTimer = 1;
			play("dead");
		}
		
		override public function update():void
		{
			super.update();
		
	
			//if colliding with Rocks or other things, turn around! (yay! this was surprisingly easy)
			if (isTouching(RIGHT))
			{
				turnAround();
			}
			if (isTouching(LEFT))
			{
				turnAround();
			}
			
			////////////////////////////
			//			A.I.		  //
			////////////////////////////
			
			if (((player.y + player.height) == (y + height)) && player.isTouching(FLOOR) && !player.isDying && (((player.x > x - 165) && (player.x < x) && (facing == LEFT)) ||((player.x < x + 165) && (player.x > x) && (facing == RIGHT))) && awakeBool == true)
			{
				if (!knockedBack)
				{
					chargeEm();
				}
			}
			else if (chargeBool == false && awakeBool == true) 
			{
				graze();
			}
			
			////////////////////////////
			//		   TIMERS		  //
			////////////////////////////
			
			if (stunTimer > 0)
			{
				awakeBool = false;
				stunTimer -= FlxG.elapsed;
				isDying = true; //isDying just means the player does not get hurt when touches Borg
				play("dead");
			
			}
			else if (stunTimer < 0)
			{
				awakeBool = true;
				stunTimer = 0;
				isDying = false;
				reanimateBool = true;
				chargeBool = false;
				knockedBack = false;
				growlSFX_flag = false;
				drag.x = 0;
			} 
			
			if (reanimateBool)
			{
				play("walk");
				if (facing == RIGHT)
				{
					velocity.x = 35;
				}
				else
				{
					velocity.x = -35;
				}
				reanimateBool = false;
			}
			
			
			if (!knockedBack) //don't allow borgs to turn around when they have been knocked back
			{
				var tx:Number = Number(x /16);
				var ty:Number = Number(y /15.5);
			
			
				 if (facing == FlxObject.LEFT)
				{
					//31 is the Collide Index of our Tilemap (which sadly isn't exposed in Flixel 2.5, so is hard-coded here. Not ideal I appreciate)
					if (Registry.map.getTile(tx - .2, ty + 2.5) <= 23)
					{
						turnAround();
						return;
					}
					
				}
				else
				{
					//31 is the Collide Index of our Tilemap (which sadly isn't exposed in Flixel 2.5, so is hard-coded here. Not ideal I appreciate)
					if (Registry.map.getTile(tx + 1.8, ty + 2.5) <= 23)
					{
						turnAround();
						return;
					}
				} 
			}
			
		}
		
		public function turnAround():void
		{
			chargeBool = false;
			if (facing == FlxObject.RIGHT)
			{
				facing = FlxObject.LEFT;
				
				velocity.x = -35;
			}
			else
			{
				facing = FlxObject.RIGHT;
				
				velocity.x = 35;
			}
		}
		
		public function knockback():void
		{		
			// FlxG.play(deathSFX);
			play("dead");
			stunTimer = 3;
			drag.x = 2000000000;
			knockedBack = true;
			
			
			velocity.y = -75;
		}
		
		public function graze():void
		{
			if(!isDying) play("walk");
			chargeBool = false;
			chargeDirection = "no";
			growlSFX_flag = false;
		}
		
		public function chargeEm():void
		{
			
			
			if (!growlSFX_flag) 
			{
				if (!isDying) play("charge");
				growlSFX_flag = true;
				// FlxG.play(growlSFX);
			}
			if (!chargeBool)
			{
				chargeBool = true;
				if (player.x > x) chargeDirection = "right";
				else chargeDirection = "left"
			}	
			
			if (chargeDirection == "left")
			{
				facing = FlxObject.LEFT;
				velocity.x = -287;
			}
			else if (chargeDirection == "right")
			{
				facing = FlxObject.RIGHT;
				velocity.x = 287;
			}
			
			
		}
	}

}