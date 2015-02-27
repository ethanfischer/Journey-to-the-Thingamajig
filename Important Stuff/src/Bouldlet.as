package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author ...
	 */
	public class Bouldlet extends FlxSprite
	{
		[Embed(source = "../assets/bouldlet.png")] public var bouldletPNG:Class;
		[Embed(source = "../assets/bouldletmini.png")] public var bouldletminiPNG:Class;
		private var images:Array = new Array();
		private var lifetime:Number;
		private var falls:int = 0;
		private var b_x:int;
		private var b_y:int;
		private var b_velocityX:int;
		private var b_velocityY:int;
		
		public function Bouldlet(i_x:int, i_y:int, i_velocityY:int, i_velocityX:int = 0) 
		{
			super(i_x, i_y);
		
			velocity.y = i_velocityY;
			velocity.x = i_velocityX;
			solid = false;
			maxVelocity.y = 700;
			
			images[0] = bouldletminiPNG;
			images[1] = bouldletminiPNG;
			var rand:int = Math.random();
			loadGraphic(images[rand], false, false, 8, 8);
			scrollFactor.x = 0;
			scrollFactor.y = 0;
		}
		override public function update():void
		{
			super.update();
			
			if (y > 600)
			{
				x = (Math.random() * 600);
				y = -400 + (Math.random() * 400);
				falls++;
			}
			
			if (falls >= 5)
			{
				kill();
			}
		}
	}

}