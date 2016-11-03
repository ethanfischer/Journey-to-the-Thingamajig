package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Butt extends FlxSprite
	{
		[Embed(source = "../assets/butt.png")] private var buttPNG:Class;	
		
		public function Butt(x:int, y:int)
		{
			super(x, y);
			loadGraphic(buttPNG, true, true, 32, 32);
			addAnimation("crap", [0,1,2,3,4,5,6,7,8,9,10,11,12], 4, true);	
			play("crap");
			//acceleration.y = 800;
			facing = FlxObject.LEFT;
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			//velocity.x = -5;
			//offset.y = -2;
		}
		
		override public function update():void
		{
			super.update();
			FlxG.log("buttTime!");
			//if (velocity.y > 0) visible = false;
			//else visible = true;
			//if (isTouching(LEFT || RIGHT)) kill();
		}

	
	}
}