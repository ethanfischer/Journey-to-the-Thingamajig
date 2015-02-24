package  
{
	import org.flixel.*;

	public class LilGuy extends FlxSprite
	{
		[Embed(source = "../assets/lilGuy.png")] private var lilGuyPNG:Class;
		
		public var isDying:Boolean = false;
		private var dieTimer:Number;
		private var player:Player;
		private var canKnockback:Boolean = false;
		public var aliveTimer:Number = 0;
		public var dieFlag:Boolean = false;
		
		public function LilGuy(x:int, y:int)
		{
			super(x, y);
			
			//player = Registry.gameLevel.player;
			
			loadGraphic(lilGuyPNG, true, true, 8, 16);
			facing = FlxObject.RIGHT;
			width = 4;
			offset.x = 1;
			
			height = 5;
			offset.y = 11;
			
			solid = true;
			active = false;
			
			addAnimation("run", [0, 1], 12, true);
			addAnimation("fall", [2], 12, true);
			addAnimation("poof", [4, 5, 6, 7] , 10, false);
			
			play("run");
			
			dieTimer = 0;
			velocity.x = 80;
			acceleration.y = 200;
			
		}
		
		override public function kill():void
		{		
			if (!dieFlag)
			{
				isDying = true;
				play("poof");
				removeSprite();
				dieFlag = true;
			}
		}
		
		
		private function removeSprite():void
		{
			dieTimer = 1.3;
		}
		
		override public function update():void
		{
			super.update();
			
			//set a downward speed limit
			if (velocity.y > 80) velocity.y = 80;
			
			if (y < 10) y = 10; //stop lilguy from going above the boundaries
			
			if (isTouching(RIGHT || LEFT)) kill();
			
			if (!isTouching(FLOOR)) 
			{
				velocity.x = 60;
			}
			else
			{
				if (Registry.gameLevel.player.x > x - 100) velocity.x = 130;
				else velocity.x =85;
				if(!isDying) play("run");
			}
			
			if (velocity.y > 0)
			{
				if(!isDying) play("fall");
			}
			else
			{
				if (!isDying) play("run");
			}
			
			
			////////////////////////////
			//		   TIMERS		  //
			////////////////////////////
			
			if (dieTimer > 0)
			{
			
				dieTimer -= FlxG.elapsed;
				if(dieTimer < 1) this.alpha -= FlxG.elapsed*5;
			}
			if (dieTimer < 0)
			{	
				exists = false;
			}
		
			if (aliveTimer > 0) aliveTimer -= FlxG.elapsed;
			else if (aliveTimer < 0) 
			{
				kill();
				aliveTimer = 0;
			}
			
		}
		
		
		
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
		}
		
	}

}