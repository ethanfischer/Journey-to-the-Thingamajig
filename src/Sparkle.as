package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Sparkle extends FlxSprite
	{
		[Embed(source = "../assets/sparkle.png")] private var sparklePNG:Class;
		
		private var sparkleTime:Number;
		private var sparkleFlag:Boolean = false;
		
		public function Sparkle(i_x:int, i_y:int)
		{
			x=i_x;
			y=i_x;
			super(x, y);
			var randNum:int = FlxMath.rand(1, 10);
			sparkleTime = .1 * randNum;
			
			solid = false;
		
			loadGraphic(sparklePNG, true, true, 1, 1);
			
			scrollFactor.x = 1;
			scrollFactor.y = 1;
			
			active = true;
			visible = false;
			velocity.y = 30;

			addAnimation("sparkle", [4,3,2,1,0,1,2,3], 40, false);
			addAnimation("slowSparkle", [4,3,2,1,0,1,2,3], 8, false);
			
			// this.offset.y = -8;
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

			if((Registry.hasFlower && Registry.stageCount == 1) ||(Registry.hasUmbrella && Registry.stageCount == 4))
			{
				visible = true;
			}

			jumpAround();
		}
		
		public function jumpAround():void
		{
			sparkleTime -= FlxG.elapsed;
			if(sparkleTime < 0)
			{
				sparkleTime = 1;
				play("slowSparkle");
				x = Registry.gameLevel.player.x + FlxMath.rand(-500, 500);
				y = Registry.gameLevel.player.y + FlxMath.rand(-500, 500);
			}
		}
	}

}