package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Star extends FlxSprite
	{
		[Embed(source = "../assets/star.png")] private var starPNG:Class;
		
		// private var sparkleTime:Number;
		// private var sparkleFlag:Boolean = false;
		
		public function Star(i_x:int, i_y:int)
		{
			var randNum:int = FlxMath.rand(1, 250);
			var randNum2:int = FlxMath.rand(0, 500);
			// sparkleTime = .1 * randNum;
			
			x=randNum2;
			y=randNum;

			super(x, y);

			solid = false;
		
			loadGraphic(starPNG, true, true, 1, 1);
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			active = true;
			
			// visible = false;
			

			addAnimation("star", [4,3,2,1,0,1,2,3], 40, false);
			// addAnimation("slowSparkle", [4,3,2,1,0,1,2,3], 8, false);
			// dieTimer = 0;
		}
		
		// override public function kill():void
		// {		
		// 	isDying = true;
			
		// 	acceleration.x = 0;
		// 	drag.x = 100;
		
		// 	removeSprite();
		// }
		
		
		// private function removeSprite():void
		// {
		// 	dieTimer = 3;
			
		// }
		
		override public function update():void
		{
			super.update();
			velocity.x = -500;
			if (x < 0) 
			{
				// FlxG.log("x < 0");
				var randNum:int = FlxMath.rand(500, 1000);
				x = randNum;
			}
		}
		
		// public function jumpAround():void
		// {
		// 	sparkleTime -= FlxG.elapsed;
		// 	if(sparkleTime < 0)
		// 	{
		// 		sparkleTime = 1;
		// 		play("slowSparkle");
		// 		x = Registry.gameLevel.player.x + FlxMath.rand(-500, 500);
		// 		y = Registry.gameLevel.player.y + FlxMath.rand(-500, 500);
		// 	}
		// }
	}

}