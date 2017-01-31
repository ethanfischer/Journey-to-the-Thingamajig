package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxColor;

	public class NomNom extends FlxSprite
	{
		[Embed(source = '../map/star.png')] private var nomNomPNG:Class;
		
		
		private var tempWhere:String = "left";
		private var where:String = "left";
		public var crossedIt:Boolean = false;
		public var spinTimer:Number;
		
		public function NomNom(X:int, Y:int)
		{
			super(X * 16, Y * 16);
			
			loadGraphic(nomNomPNG, true, false, 16, 20);
			width = 6;
			height = 10;
			offset.x = 5;
			offset.y = 5;
		
			
			addAnimation("idle", [1, 2, 1, 3], 4, true);
			addAnimation("spin", [1, 7], 18, true);
			
		}
		
		override public function update():void
		{
			
			if (Registry.torchesOn) 
			{
				this.color = 0xFFFFFF;
			}
			else 
			{
				this.color = 0x696969;
			}
			
			//spin when crossed
			if (spinTimer > 0) 
			{
				play("spin");
				spinTimer -= FlxG.elapsed;
			}
			else
			{
				play("idle");
			}
			
			//use two variables to track players movement
			if (Registry.gameLevel.player.x < x + width/2) tempWhere = "left";
			else if (Registry.gameLevel.player.x > x + width/2) tempWhere = "right";
			
			//player crosses nomNom when previously on left but now on right, or vice versa
			if (where != tempWhere)
			{
				crossedIt = true;
			}
			else crossedIt = false;
			
			where = tempWhere //update where
		}
		
	}

}