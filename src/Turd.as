package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Turd extends FlxSprite
	{
		[Embed(source = "../assets/turd.png")] private var turdPNG:Class;	
		
		public function Turd(x:int, y:int)
		{
			super(x, y);
			loadGraphic(turdPNG, true, true, 4, 8);
			//addAnimation("crap", [0,1,2,3,], 4, true);	
			//play("crap");
			//acceleration.y = 800;
			facing = FlxObject.LEFT;
			//velocity.x = -5;
			//offset.y = -2;
		}
		
		override public function update():void
		{
			super.update();
			acceleration.y = 50;
			//if (velocity.y > 0) visible = false;
			//else visible = true;
			//if (isTouching(LEFT || RIGHT)) kill();
		}

	
	}
}