package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Worm extends FlxSprite
	{
		[Embed(source = "../assets/worm.png")] private var WormPNG:Class;	
		
		public function Worm(x:int, y:int)
		{
			super(x, y);
			loadGraphic(WormPNG, true, true, 4, 8);
			addAnimation("idle", [0,1,2,3], 4, true);	
			play("idle");
			acceleration.y = 100;
			facing = FlxObject.LEFT;
			velocity.x = -5;
			offset.y = -2;
		}
		
		override public function update():void
		{
			super.update();
			if (velocity.y > 0) visible = false;
			else visible = true;
			if (isTouching(LEFT || RIGHT)) kill();
		}

	
	}
}