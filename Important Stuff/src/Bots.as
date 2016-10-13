package  
{
	import org.flixel.*;

	public class Bots extends FlxGroup
	{
		private var x:int;
		private var y:int;
		private var player:Player;
		private var tempBot:Bot;
		public var alltheBots:Array = new Array(); //array of bots used to randomly select a chosen bot for retreat function
		
		
		
		
		public function Bots()
		{
			super();
		}
		
		public function addBot(i_x:int, i_y:int, i_player:Player, i_facing:uint, i_suicidal:Boolean = false):void
		{	
			x = i_x;
			y = i_y;
			player = i_player;
			tempBot = new Bot(x, y, player, i_facing, i_suicidal);
			add(tempBot);
			alltheBots.push(tempBot);
		}
	
		
	}

}