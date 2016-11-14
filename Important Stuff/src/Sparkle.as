package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Sparkle extends FlxSprite
	{
		[Embed(source = "../assets/sparkle.png")] private var sparklePNG:Class;
		[Embed(source = "../assets/eject.mp3")] private var ejectSFX:Class;
		
		public var isDying:Boolean = false;
		private var dieTimer:Number;
		private var bounceTimer:Number;
		private var knockBackTimer:Number;
		private var player:Player;
		private var canKnockback:Boolean = false;
		private var retreatFlag:Boolean = false;
		public var specialOne:Boolean; //if true, this is the Bird that the lilguy will retreat from
		
		public var message:FlxText;
		private var messageCount:int = 0;
		private var text:String;
		
		private var sparkleTime:Number;
		private var sparkleFlag:Boolean = false;
		
		
		public function Sparkle(i_x:int, i_y:int)
		{
			x=i_x;
			y=i_x;
			super(x, y);
			var randNum:int = FlxMath.rand(1, 10);
			sparkleTime = .1 * randNum;
			// FlxG.log("sparkleTime" && sparkleTime);
			retreatFlag = false;
			
			solid = false;
			
			// message = new FlxText(x*16, y*16 - 10, 150, "");
		
			loadGraphic(sparklePNG, true, true, 1, 1);
			
			scrollFactor.x = 1;
			scrollFactor.y = 1;
			
			// velocity.x = -800;
			// velocity.y = 30;
			// x = Registry.screenWidth + 30;
			// y = Registry.screenHeight/2 - 70;
			
			
			active = true;
			visible = false;
			// velocity.x = -50;
			velocity.y = 30;

			addAnimation("sparkle", [4,3,2,1,0,1,2,3], 40, false);
			
			addAnimation("slowSparkle", [4,3,2,1,0,1,2,3], 8, false);

			
			
			dieTimer = 0;
			
			this.offset.y = -8;
			//acceleration.y = 1;
			//velocity.x = 40;
			
		
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
			
		}
		
		override public function update():void
		{
			super.update();

			if((Registry.hasFlower && Registry.stageCount == 1) ||(Registry.hasUmbrella && Registry.stageCount == 4))
			{
				visible = true;
			}

			jumpAround();
			// velocity.x = -50;
			
			// if (x < -600) x = 600;
			// if (x > 0) x = -600;	

			// if(FlxG.keys.P)
			// {
			// 	// scrollFactor.x = 1;
			// 	// scrollFactor.y = 1;
			// 	FlxG.log(x && y && "Sparkle position");
			// }
			
			
			////////////////////////////
			//		   TIMERS		  //
			////////////////////////////
			
			// if (dieTimer > 0)
			// {
			// 	dieTimer -= FlxG.elapsed;
			// 	if (dieTimer < 1) this.alpha -= FlxG.elapsed * 5;
			// }
			// if (dieTimer < 0)
			// {	
			// 	exists = false;
			// }
			
			/*if (knockBackTimer > 0)
			{
				knockBackTimer -= FlxG.elapsed;
			}
			if (knockBackTimer < 0)
			{
				FlxG.timeScale = Registry.nmlTimescale;
				knockBackTimer = 0;
				FlxG.shake(.02, .08, null, true, 1);
				canKnockback = true;
			
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
		
		
			
			//if (Registry.gameLevel.player.x > x) facing = FlxObject.RIGHT;
			//else facing = FlxObject.LEFT;
		}
		
		public function jumpAround():void
		{
			sparkleTime -= FlxG.elapsed;
			if(sparkleTime < 0)
			{
				// if(Registry.stageCount == 1)
				// {

				// 	sparkleTime = .25;
				// 	play("sparkle");
				// }
				// else if (Registry.stageCount == 4)
				// {
					sparkleTime = 1;
					play("slowSparkle");
				// }
				x = Registry.gameLevel.player.x + FlxMath.rand(-500, 500);
				y = Registry.gameLevel.player.y + FlxMath.rand(-500, 500);
				
			}
		}
		
		// public function bounce():void
		// {
		// 	kill();
		
		// 	Registry.nmlTimescale = FlxG.timeScale;
		// 	FlxG.timeScale = .3;
		// 	bounceTimer = .01;
		// }
		
		// public function knockback():void
		// {		
		// 	//kill();
		// 	velocity.y = -500;
		// 	if (x > Registry.gameLevel.player.x)
		// 	{
		// 		velocity.x =  900;
		// 		//angle += 20;
		// 	}
		// 	else
		// 	{
		// 		velocity.x = -900;
		// 		//angle -= 20;
		// 	}
	
		// 	//if(FlxG.timeScale > .1) Registry.nmlTimescale = FlxG.timeScale;
		// 	//FlxG.timeScale = .1;
		// 	//knockBackTimer = 1;
		
			
		// }
		
		
		// public function talk():void
		// {
		// 	play("punched");
		// 	if (messageCount == 1)
		// 	{
		// 		message.text = "I SEE YOU'RE ENJOYING THE BOXING GLOVE";
		// 	}
		// 	else if (messageCount == 3) //for some reason when you punch the Bird it calls talk() twice. This is terrible programming, but whatevs
		// 	{
		// 		message.text = "MIND NOT PUNCHING ME?";
		// 	}
		// 	else if (messageCount == 5)
		// 	{
		// 		message.text = "PLEASE. I'LL PAY YOU IF YOU STOP";
		// 	}
		// 	else if (messageCount == 7)
		// 	{
		// 		message.text = "HERE. TAKE THIS AND LEAVE ME ALONE ";
		// 	}
		// 	else if (messageCount == 9)
		// 	{
		// 		message.text = "";
		// 		play("umbrella");
		// 	}
		// 	else if (messageCount > 9)
		// 	{
		// 		immovable = false;
		// 		knockback();
		// 		Registry.hasUmbrella = true;
		// 		//player.bounce(400);
		// 		//message.text = "SHIIIIIIT";
		// 	}
			
		// 	messageCount += 1; 
		// }
	}

}