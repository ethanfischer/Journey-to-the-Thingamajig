package  
{
	import org.flixel.*;

	public class Bot3 extends Bot
	{
		[Embed(source = "../map/bot3.png")] private var botPNG:Class;
		
		//public var isDying:Boolean = false;
		private var dieTimer:Number;
		private var player:Player;
		private var canKnockback:Boolean = false;
		private var haltTimer:Number = -1;
		private var haltTimerFlag:Boolean = false;
		
		public function Bot3(x:int, y:int, i_player:Player)
		{
			super(x, y,  i_player, FlxObject.RIGHT);
			
			player = i_player;
			
			
			loadGraphic(botPNG, true, true, 16, 36);
			offset.y = -4;
			facing = FlxObject.RIGHT;
			
			solid = true;
			active = true;
			
			addAnimation("walk3", [0, 1, 2, 3, 4, 5, 3, 1, 4, 0, 5, 3], 5, true);
			
			play("walk3");
			
			dieTimer = 0;
			
			acceleration.y = 300;
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
			dieTimer = 1;
			play("dead");
		}
		
		override public function update():void
		{
			//TIMER
			if (haltTimer > 0)
			{
				haltTimerFlag = true;
				haltTimer -= FlxG.elapsed;
				velocity.x = 0
			}
			else if (haltTimer < 0)
			{
				haltTimerFlag = false;
			}
			
			
			/*var tx:Number = Number(x / 16);
			var ty:Number = Number(y / 15.5);
			if (facing == FlxObject.LEFT)
				{
					//31 is the Collide Index of our Tilemap (which sadly isn't exposed in Flixel 2.5, so is hard-coded here. Not ideal I appreciate)
					if (Registry.map.getTile(tx - .2, ty + 1.5) <= 23)
					{
						turnAround();
						return;
					}
					
				}
				else
				{
					//31 is the Collide Index of our Tilemap (which sadly isn't exposed in Flixel 2.5, so is hard-coded here. Not ideal I appreciate)
					if (Registry.map.getTile(tx + 1, ty + 1.5) <= 23)
					{
						turnAround();
						return;
					}
				} 
				*/
				
				//if (isTouching(RIGHT)) turnAround();
				//else if (isTouching(LEFT)) turnAround();
				
				//////////////////////
				//		A.I.		//
				//////////////////////
				if ((x > player.x && velocity.x > 0))
				{
					turnAround();
				}
		}
		
		
		override public function turnAround():void
		{
			if (facing == FlxObject.RIGHT)
			{	
				if (!haltTimerFlag)
				{
					haltTimer = 1;
				}
				if (haltTimer < 0)
				{	
					velocity.x = -20;
					facing = FlxObject.LEFT;
					haltTimerFlag = false;
				}
			}
			else
			{
				if (!haltTimerFlag)
				{
					haltTimer = 1;
				}	
				if (haltTimer < 0)
				{	
					velocity.x = 20;
					facing = FlxObject.RIGHT;
				}
			}
		}
		
		/*
		public function knockback():void
		{		
			kill();
			canKnockback = true;
			
			
			velocity.y = -75;
		
			if (x > player.x)
			{
				velocity.x =  200;
				angle += 20;
			}
			else
			{
				velocity.x = -200;
				angle -= 20;
			}
		} */
	} 

}