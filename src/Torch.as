package  
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Ethan Fischer
	 */
	public class Torch extends FlxSprite
	{
		[Embed(source = "../assets/torch.png")] private var torchPNG:Class;
		
		public var flameOn:Boolean = false;
		private var flameDance:int;
		
		public function Torch(x:Number, y:Number, i_flameDance:int) 
		{
			super(x * 16, y * 16);
			
			active = false;
			
			flameDance = i_flameDance;
			width = 1;
			offset.y = 1;
			
			loadGraphic(torchPNG, true, true, 16, 24);
			addAnimation("flameOn1", [0, 1, 2, 3, 4, 5, 6, 0, 2, 4, 5, 3, 6, 2, 4, 1, 5, 0, 6, 4, 2], 7, true);
			addAnimation("flameOn2", [4, 5, 6, 0, 2, 4, 5, 3, 6, 2, 4, 1, 5, 0, 6, 4, 2, 0, 1, 2, 3], 8, true);
			addAnimation("flameOn3", [3, 6, 2, 4, 1, 5, 0, 6, 4, 2, 0, 1, 2, 3, 4, 5, 6, 0, 2, 4, 5], 6, true);
			addAnimation("flameOff", [7], 0, false);	
		}

		override public function update():void
		{
			super.update();
			
			if (flameOn) 
			{
				if (flameDance == 1) play("flameOn1");
				else if (flameDance == 2) play("flameOn2");
				else play("flameOn3");
			}
			else play("flameOff");
		}
	}

}