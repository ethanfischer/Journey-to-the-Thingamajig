package  
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Smokelet extends FlxSprite
	{
		[Embed(source = "../assets/smokelet.png")] private var smokeletPNG:Class;
		private var rand1:int;
		private var rand2:int;
		
		public function Smokelet(i_x:int, i_y:int) 
		{
			super(i_x, i_y);
			
			
			loadGraphic(smokeletPNG, false, false, 16, 16);
			acceleration.y = ((Math.random()+.5) * 2.5) * -2;
			acceleration.x = .1;
			scrollFactor.x = 0;
			scrollFactor.y = .1;
			rand1 = (((Math.random()+.5) * 3) + (Math.random() * 3)) * 4;
			rand2 = (((Math.random()+.5) * 3)) * 4;
			
		}
		
		override public function update():void
		{
			if (y < 130) 
			{
				velocity.y = 0;
				y = 190;
				velocity.x = 0;
				acceleration.x = ((int(Math.random()*3))-1)*2;
				x = 450 + rand1;
				acceleration.y = ((Math.random()+.5) * 3) * -2;
			}
			
		}
		
	}

}