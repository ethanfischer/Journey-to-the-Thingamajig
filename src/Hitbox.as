package 
{
	import adobe.utils.CustomActions;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Hitbox extends FlxSprite
	{
		[Embed(source = "../assets/hitbox.png")] private var _hitboxPNG:Class;
		
		public function Hitbox() 
		{
			//hitbox
			loadGraphic(_hitboxPNG, true, true, 34, 20, true);
			width = 38;
			height = 20;
			exists = true;
			immovable = true;
			visible = false;
		}
		
		override public function update():void
		{
			//////////////////////
			//		HITBOX		//
			//////////////////////
			//super.update();
			
			if (Registry.character == "girl") y = Registry.gameLevel.player.y + 10;
			else if (Registry.character == "bot") y = Registry.gameLevel.player.y;
			
			if (Registry.gameLevel.player.facing == RIGHT)
			{
				x = Registry.gameLevel.player.x + 8;
			}
			else
			{
				x = Registry.gameLevel.player.x - 32;
			}
		}
		
	}

}