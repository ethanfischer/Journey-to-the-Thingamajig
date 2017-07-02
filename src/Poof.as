package  
{
	import org.flixel.*;

	public class Poof extends FlxSprite
	{
		[Embed(source = "../assets/Poof.png")] private var PoofPNG:Class;
		
	
		public function Poof(i_x:int, i_y:int)
		{
			super(x * 16, y * 16);
			
			loadGraphic(PoofPNG, true, false, 32, 32);
			x = i_x;
			y = i_y;
			scrollFactor.x = 1;
			scrollFactor.y = 1;
			active = true;
			solid = false;
			addAnimation("poof", [0, 1, 2, 3], 12, false);	
			play("poof");
		}
		
	
		
		
		
		override public function update():void
		{
			super.update();
			if (this.frame == 3) kill();
		}
		

	}

}