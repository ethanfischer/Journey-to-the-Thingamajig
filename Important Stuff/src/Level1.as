package  
{
	import flash.display.Sprite;
	import org.flixel.*;

	public class Level1 extends GameLevel
	{
		[Embed(source="../map/mapCSV_Level1_Background.csv", mimeType="application/octet-stream")] public var backgroundCSV:Class;
		[Embed(source="../map/mapCSV_Level1_Back_Background.csv", mimeType="application/octet-stream")] public var backbackgroundCSV:Class;
		[Embed(source="../map/mapCSV_Level1_Foreground.csv", mimeType="application/octet-stream")] public var foregroundCSV:Class;
		[Embed(source="../map/mapCSV_Level1_Fore-Foreground.csv", mimeType="application/octet-stream")] public var foreforegroundCSV:Class;
		[Embed(source = "../map/woody(green).png")] public var backgroundTilesPNG:Class;
		[Embed(source="../map/woody_back_background.png")] public var backbackgroundTilesPNG:Class;
		[Embed(source = "../map/forest_tiles_l1.png")] public var foregroundTilesPNG:Class;
		[Embed(source = "../map/forest_tiles_foregroud_l1.png")] public var foreforegroundTilesPNG:Class;
		[Embed(source = "../map/mapCSV_Level1_Bots.csv", mimeType = "application/octet-stream")] public var botsCSV:Class;
		[Embed(source = "../map/mapCSV_Level1_Rocks.csv", mimeType = "application/octet-stream")] private var _rocksCSV:Class;
		[Embed(source = "../map/mapCSV_Level1_Checkpoint.csv", mimeType = "application/octet-stream")] private var _checkpointCSV:Class;
		[Embed(source = "../map/rock.png")] private var _rockPNG:Class;
		[Embed(source = "../map/botlet(2).png")] public var botletPNG:Class;
		[Embed(source = "../map/mapCSV_Level1_Reinforcements.csv", mimeType = "application/octet-stream")] private var _reinforcementsCSV:Class;
		[Embed(source="../assets/forestsounds.mp3")] public var dwarfDance:Class;
		
		public var rockMap:FlxTilemap;
		
		public function Level1() 
		{
			super();
			
			letterMsg = new FlxText(30, 140, 400);
			letterMsg.text = 
				"I don't know what it is.\n"
				//+"I don't know where it came from.\n\n"
				
				//+"But I know one thing:"
				//+"\n...You have to see it.\n\n"
				
				//+"Come to Level 7\n\n"

				//+"\n"
				//+"";
				
			//letterMsg.loadGraphic(_letterPNG, false, false, 600, 300);
			//letterMsg.scrollFactor.y = 0;
			
			
			//Registry.musix = dwarfDance;
			//Registry.musix.loadEmbedded(dwarfDance, true, false);
			
			backbackground = new FlxTilemap;
			backbackground.loadMap(new backbackgroundCSV, backbackgroundTilesPNG, 252, 300);
			backbackground.setTileProperties(1, FlxObject.NONE);
			backbackground.scrollFactor.x = .2
			
			background = new FlxTilemap;
			background.loadMap(new backgroundCSV, backgroundTilesPNG, 256, 300);
			background.setTileProperties(1, FlxObject.NONE);
			background.scrollFactor.x = .7;
			
			foreground = new FlxTilemap;
			foreground.loadMap(new foregroundCSV, foregroundTilesPNG, 16, 16, 0, 0, 1, 24);
			
			foreforeground = new FlxTilemap;
			foreforeground.loadMap(new foreforegroundCSV, foreforegroundTilesPNG, 16, 16, 0, 0, 1, 64);
			foreforeground.scrollFactor.x = 1;
			
			//	Makes these tiles as allowed to be jumped UP through (but collide at all other angles)
			foreground.setTileProperties(57, FlxObject.NONE, null, null, 6);

			
			Registry.map = foreground;
			Registry.levelExit = new FlxPoint(99 * 16, 16 * 16);
			
			
			Registry.player = player;
			
			Registry.fstPlace = 60;
			Registry.sndPlace = 180;
			Registry.thdPlace = 320;
			
		
			
			width = foreground.width;
			height = foreground.height;
			
			if (Registry.checkpointFlag)
			{
				player = new Player(Registry.checkpoint.x + 5, Registry.checkpoint.y - 5);
				frog = new Frog(1872, 200);
			}
			else 
			{
				player = new Player(50, height - 64);
				frog = new Frog(625, 100);
			}
			
			if (Registry.firstLevel1) 
			{
				player.setLetterTimer(200);
				player.play("letterIdle");

			}
			
			sign = new Sign(135, 240, "PRESS 'Z' TO JUMP", player, 100, 240);
			sign2 = new Sign(1000, 180, "BALL OF POINTLESSNESS!", player, 1080, 180);
			
			parseBots(player);
			parseRocks(player);
			parseReinforcements();
			parseCheckpoint();
			super.makeLevelNumber();
			
			
		}
		
		private function parseBots(player:Player):void
		{			
			var _botMap:FlxTilemap = new FlxTilemap();
			
			_botMap.loadMap(new botsCSV, botletPNG, 16, 16);
			
			bots = new Bots;
			
			for (var ty:Number = 0; ty < _botMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < _botMap.widthInTiles; tx++)
				{
					if (_botMap.getTile(tx, ty) == 1)
					{
						bots.addBot(tx, ty, player, FlxObject.RIGHT);
					}
					else if (_botMap.getTile(tx, ty) == 2)
					{
						bots.addBot(tx, ty, player, FlxObject.LEFT);
					}
					else if (_botMap.getTile(tx, ty) == 3)
					{
						bots.addBot(tx, ty, player, FlxObject.RIGHT, true);
					}
				}
			
			}
			
		}
		
		private function parseRocks(player:Player):void
		{			
			rockMap = new FlxTilemap();
			
			rockMap.loadMap(new _rocksCSV, _rockPNG, 16, 16);
			
			rocks = new Rocks;
			
			for (var ty:Number = rockMap.heightInTiles; ty > 0; ty--)
			{
				for (var tx:int = rockMap.widthInTiles; tx > 0; tx--)
				{
					if (rockMap.getTile(tx, ty) == 1)
					{
						rocks.addRock(tx, ty, player, 1);
					}
					else if (rockMap.getTile(tx, ty) == 2)
					{
						rocks.addRock(tx, ty, player, 2);
					}
				}
			}
		}
		
		private function parseCheckpoint():void
		{			
			var _checkpointMap:FlxTilemap = new FlxTilemap();
			
			_checkpointMap.loadMap(new _checkpointCSV, botletPNG, 16, 16);
			
			for (var ty:Number = 0; ty < _checkpointMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < _checkpointMap.widthInTiles; tx++)
				{
					if (_checkpointMap.getTile(tx, ty) == 1)
					{
						checkpoint = new Checkpoint(tx, ty);
						Registry.checkpoint = checkpoint;
						add(checkpoint);
					}
					else if (_checkpointMap.getTile(tx, ty) == 3)
					{
						end = new Checkpoint(tx, ty, true);
						end.x -=8;
						end.y -=8;
						add(end);
					}
				}
			}
		}
		
		private function parseReinforcements():void
		{			
			reinforcementMap = new FlxTilemap();
			
			reinforcementMap.loadMap(new _reinforcementsCSV, _rockPNG, 16, 16);
			
			reinforcements = new Reinforcements;
			
			for (var ty:Number = reinforcementMap.heightInTiles; ty > 0; ty--)
			{
				for (var tx:int = reinforcementMap.widthInTiles; tx > 0; tx--)
				{
					if (reinforcementMap.getTile(tx, ty) == 1)
					{
						reinforcements.addReinforcement(tx, ty);
					}
				}
			}
		}
	}
}