package  
{
	import org.flixel.FlxSprite;
	import org.flixel.*;

	public class Sign extends FlxGroup
	{	
		public var message:FlxText;
		private var player:Player;
		private var x:int;
		private var y:int;
		
		public function Sign(i_x:int, i_y:int, text:String, i_player:Player, m_x:int, m_y:int )
		{
			super();
			
			player = i_player;
			x = i_x;
			y = i_y;
			
			message = new FlxText(m_x, m_y, 150, text);
			//message.alignment = "center";
			//message.scrollFactor.x = 0;
			//message.scrollFactor.y = 0;
			add(message);
		}
		
		override public function update():void
		{
			if (player.x > x - 34 && player.x < x + 50
			&& player.y > y - 50 && player.y < y + 50)
			{
				message.visible = true;
			}
			else
			{
				message.visible = false;
			}
		}
		
	}

}