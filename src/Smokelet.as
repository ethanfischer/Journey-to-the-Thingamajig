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
		[Embed(source = "../assets/wizpoof.png")] private var bluePoofPNG:Class;
		[Embed(source = "../assets/wizpoof(white).png")] private var whitePoofPNG:Class;
		[Embed(source = "../assets/wizpoof(yellow).png")] private var yellowPoofPNG:Class;
		private var rand1:int;
		private var rand2:int;
		private var wizPoof:Boolean;
		private var poofPNG:Class; //holder for randomly selected blue OR white poof image
		private var poofArray:Array
		
		public function Smokelet(i_x:int, i_y:int, i_wizPoof:Boolean = false, randAclX:int = 0, randVelY:int = 0) 
		{
			super(i_x, i_y);
			wizPoof = i_wizPoof;
			poofArray = new Array();
			poofArray.push(bluePoofPNG, whitePoofPNG, yellowPoofPNG);
			
			if (wizPoof)
			{
				poofPNG = randomPoof();
				loadGraphic(poofPNG, false, false, 2, 2);
				velocity.y = randVelY; //~-5 value assigned in Wiz
				acceleration.x = randAclX; //~50 value assigned in Wiz
				scrollFactor.x = 1;
				scrollFactor.y = 1;
			}
			else
			{
				loadGraphic(smokeletPNG, false, false, 16, 16);
				acceleration.y = ((Math.random()+.5) * 2.5) * -2;
				acceleration.x = .1;
				scrollFactor.x = 0;
				scrollFactor.y = .1;
			}
			
			rand1 = (((Math.random()+.5) * 3) + (Math.random() * 3)) * 4;
			rand2 = (((Math.random()+.5) * 3)) * 4;
		}
		
		override public function update():void
		{
			if (wizPoof)  
			{
				if (!onScreen())
				{
					kill();
				}
			}
			else
			{
				if(y < 130)
				{
					velocity.y = 0;
					y = 190;
					velocity.x = 0;
					acceleration.x = ((int(Math.random()*3))-1)*2;
					x = 450 + rand1;
					acceleration.y = ((Math.random() + .5) * 3) * -2;
				}
			}
			
		}
		
		private function randomPoof():Class
		{
			var idx:int=Math.floor(Math.random() * poofArray.length);
			return poofArray[idx];
		}
		
	}

}