package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Level4 extends GameLevel
	{
		[Embed(source="../map/mapCSV_Level4_Background.csv", mimeType="application/octet-stream")] public var backgroundCSV:Class;
		[Embed(source="../map/mapCSV_Level4_Back_Background.csv", mimeType="application/octet-stream")] public var backbackgroundCSV:Class;
		[Embed(source="../map/mapCSV_Level4_Foreground.csv", mimeType="application/octet-stream")] public var foregroundCSV:Class;
		[Embed(source="../map/mapCSV_Level4_Fore-Foreground.csv", mimeType="application/octet-stream")] public var foreforegroundCSV:Class;
		[Embed(source = "../map/mapCSV_Level4_Checkpoint.csv", mimeType = "application/octet-stream")] public var checkpointCSV:Class;
		[Embed(source="../map/forecave(red).png")] public var backgroundTilesPNG:Class;
		[Embed(source="../map/underground(grey).png")] public var backbackgroundTilesPNG:Class;
		//[Embed(source="../map/forecave(red).png")] public var backbackgroundTilesPNG:Class;
		[Embed(source = "../map/forest_tiles(red).png")] public var foregroundTilesPNG:Class;
		[Embed(source = "../map/forest_tiles_foregroud(2).png")] public var foreforegroundTilesPNG:Class;
		[Embed(source = "../map/botlet(2).png")] public var botletPNG:Class;
		[Embed(source = "../map/star.png")] public var nomNomPNG:Class;
		[Embed(source="../map/mapCSV_Level4_Bots.csv", mimeType="application/octet-stream")] public var botsCSV:Class;
		[Embed(source = "../map/mapCSV_Level4_Bots(2).csv", mimeType = "application/octet-stream")] public var bots2CSV:Class;
		[Embed(source = "../map/mapCSV_Level4_NPC.csv", mimeType = "application/octet-stream")] public var NPCCSV:Class;
		[Embed(source="../map/mapCSV_Level4_Rocks.csv", mimeType="application/octet-stream")] public var rocksCSV:Class;
		[Embed(source = "../map/mapCSV_Level4_CrumbleRocks.csv", mimeType = "application/octet-stream")] public var crumbleRocksCSV:Class;
		[Embed(source = "../map/mapCSV_Level4_Torch.csv", mimeType = "application/octet-stream")] public var torchesCSV:Class;
		[Embed(source = "../map/rock.png")] public var rockPNG:Class;
		[Embed(source = "../map/crumbleRock.png")] public var crumbleRockPNG:Class;
		[Embed(source = "../assets/torch.png")] public var torchPNG:Class;
		[Embed(source = "../map/mapCSV_Level4_NomNoms.csv", mimeType = "application/octet-stream")] public var nomNomsCSV:Class;
		[Embed(source = "../assets/stream.png")] public var streamPNG:Class;
		[Embed(source = "../map/mapCSV_Level4_Streams.csv", mimeType = "application/octet-stream")] public var streamsCSV:Class;
		[Embed(source = "../map/mapCSV_Level4_Reinforcements.csv", mimeType = "application/octet-stream")] public var reinforcementsCSV:Class;
		[Embed(source = "../assets/letter(level4).png")] private var letterPNG:Class;
		
		//[Embed(source="../assets/river.mp3")] private var water:Class;
		
		public var rockMap:FlxTilemap;	
		public var crumbleRockMap:FlxTilemap;
		
		public function Level4() 
		{
			super();
			
			//MUSIC IS TAKEN CARE OF IN DEATHMENUSTATE. THIS IS CONFUSING, BAD CODING AND IS AN EXAMPLE OF WHY YOU ENCAPSULATE and KEEP YOUR PROGRAM HIGH IN MODULARITY
		
			
			letterMsg = new FlxText(40, 100, 300);
			letterMsg.text = "";
			//letterMsg.loadGraphic(letterPNG, false, false, 600, 300);
			letterMsg.scrollFactor.y = 0;
			letterMsg.visible = false;
			
			Registry.fstPlace = 120;
			Registry.sndPlace = 220;
			Registry.thdPlace = 420;
			
			Registry.hasFlower = true;
			Registry.meetingAdjourned = true;
			
			backbackground = new FlxTilemap;
			backbackground.loadMap(new backbackgroundCSV, backbackgroundTilesPNG, 256, 600);
			backbackground.setTileProperties(1, FlxObject.NONE);
			backbackground.scrollFactor.x = .2; 
			
			
			background = new FlxTilemap;
			background.loadMap(new backgroundCSV, backgroundTilesPNG, 256, 600);
			background.setTileProperties(1, FlxObject.NONE);
			background.scrollFactor.x = .6;
			background.scrollFactor.y = 1;
			background.y = -100; 
			
			foreground = new FlxTilemap;
			foreground.loadMap(new foregroundCSV, foregroundTilesPNG, 16, 16, 0, 0, 1, 24);
			
			//	Makes these tiles non collidable)
			foreground.setTileProperties(57, FlxObject.NONE, null, null, 6);
			foreground.setTileProperties(27, FlxObject.ANY, null, null, 0);
			
			Registry.map = foreground;
			
			width = foreground.width;
			height = foreground.height;
			
			if(Registry.firstLevel4) mail = new Mail(130, 430);
			
			canopy.visible = false;
			
			
			///////////////////////////////////////////////////////
			//					 CHECKPOINT						 //
			///////////////////////////////////////////////////////

			if (Registry.checkpointFlag) 
			{
				player = new Player(Registry.checkpoint.x + 5, Registry.checkpoint.y - 5);
				frog = new Frog(2000, 336);
				Registry.torchesOn = true;
			}
			else 
			{
				if (Registry.firstLevel4) player = new Player(40, 150);
				else player = new Player(40, 350);
				frog = new Frog(177, 400);
				Registry.torchesOn = true;
			}
			
			Registry.player = player;
			
			not_a_flower = new NotAFlower(260, height - 48, player);
			
			//sign = new Sign(135, 300,"DON'T TOUCH TORCHES", player, 105, 386);		
			
			parseBots(player);
			parseBots2(player);
			parseReinforcements();
			parseTorches();
			parseRocks(player);
			parseCrumbleRocks(player);
			parseNomNoms();
			parseStreams();
			parseCheckpoint();
			
			Registry.crumbleRockMap = crumbleRockMap;
			Registry.crumbleRocks = crumbleRocks;
			
			spring = new Spring(2696, 426, 700);
			spring2 = new Spring(1340, 378, 800);
			
			super.makeLevelNumber();
		}
			
		private function parseNomNoms():void
		{
			var nomNomMap:FlxTilemap = new FlxTilemap();
			
			nomNomMap.loadMap(new nomNomsCSV, nomNomPNG, 16, 16);
			
			nomNoms = new FlxGroup();
			
			for (var ty:int = 0; ty < nomNomMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < nomNomMap.widthInTiles; tx++)
				{
					if (nomNomMap.getTile(tx, ty) == 1)
					{
						nomNoms.add(new NomNom(tx, ty));
					}
				}
			}
		}
		
		private function parseReinforcements():void
		{			
			reinforcementMap = new FlxTilemap();
			
			reinforcementMap.loadMap(new reinforcementsCSV, rockPNG, 16, 16);
			
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
		
		private function parseTorches():void
		{
			var torchMap:FlxTilemap = new FlxTilemap();
			
			torchMap.loadMap(new torchesCSV, torchPNG, 16, 16);
			
			torches = new Torches();
			
			for (var ty:int = 0; ty < torchMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < torchMap.widthInTiles; tx++)
				{
					if (torchMap.getTile(tx, ty) == 1)
					{
						torches.add(new Torch(tx, ty, 1));
					}
					else if (torchMap.getTile(tx, ty) == 2)
					{
						torches.add(new Torch(tx, ty, 2));
					}
					else if (torchMap.getTile(tx, ty) == 3)
					{
						torches.add(new Torch(tx, ty, 3));
					}
				}
			}
		}
		
		private function parseCheckpoint():void
		{			
			var checkpointMap:FlxTilemap = new FlxTilemap();
			
			checkpointMap.loadMap(new checkpointCSV, botletPNG, 16, 16);
			
			for (var ty:Number = 0; ty < checkpointMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < checkpointMap.widthInTiles; tx++)
				{
					if (checkpointMap.getTile(tx, ty) == 1)
					{
						checkpoint = new Checkpoint(tx, ty);
						Registry.checkpoint = checkpoint;
						add(checkpoint);
					}
					else if (checkpointMap.getTile(tx, ty) == 3)
					{
						end = new Checkpoint(tx, ty, true);
						end.x -8;
						end.y -8;
						add(end);
					}
				}
			}
		}
		
		private function parseStreams():void
		{
			var streamMap:FlxTilemap = new FlxTilemap();
			
			streamMap.loadMap(new streamsCSV, streamPNG, 16, 16);
			
			streams = new FlxGroup();
			
			for (var ty:int = 0; ty < streamMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < streamMap.widthInTiles; tx++)
				{
					if (streamMap.getTile(tx, ty) == 1)
					{
						streams.add(new Stream(tx, ty, true, "normal"));
					}
					else if(streamMap.getTile(tx, ty) == 2)
					{
						streams.add(new Stream(tx, ty, false, "normal"));
					}
					else if (streamMap.getTile(tx, ty) == 3)
					{
						streams.add(new Stream(tx, ty, false, "fast"));
					}
					else if (streamMap.getTile(tx, ty) == 4)
					{
						streams.add(new Stream(tx, ty, false, "fall"));
					}
					else if (streamMap.getTile(tx, ty) == 5)
					{
						streams.add(new Stream(tx, ty, false, "drop"));
					}
					else if (streamMap.getTile(tx, ty) == 10)
					{
						streams.add(new Stream(tx, ty, true, "crash"));
					}
				}
			}
		}
		
		private function parseBots(player:Player):void
		{			
			var botMap:FlxTilemap = new FlxTilemap();
			
			botMap.loadMap(new botsCSV, botletPNG, 16, 16);
			
			bots = new Bots;
			
			for (var ty:Number = 0; ty < botMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < botMap.widthInTiles; tx++)
				{
					if (botMap.getTile(tx, ty) == 1)
					{
						bots.addBot(tx, ty, player, FlxObject.RIGHT);
					}
					else if (botMap.getTile(tx, ty) == 2)
					{
						bots.addBot(tx, ty, player, FlxObject.LEFT);
					}
					else if (botMap.getTile(tx, ty) == 3)
					{
						bots.addBot(tx, ty, player, FlxObject.RIGHT, true);
					}
				}
			}
			Registry.bots = bots;
		}
		
		private function parseBots2(player:Player):void
		{			
			var bot2Map:FlxTilemap = new FlxTilemap();
			
			bot2Map.loadMap(new bots2CSV, botletPNG, 16, 16);
			
			bots2 = new Bots2;	
			
			for (var ty:Number = 0; ty < bot2Map.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < bot2Map.widthInTiles; tx++)
				{
					if (bot2Map.getTile(tx, ty) == 1)
					{
						bots2.addBot2(tx, ty, player, FlxObject.LEFT, 80);
					}
					else if (bot2Map.getTile(tx, ty) == 2)
					{
						bots2.addBot2(tx, ty, player, FlxObject.RIGHT, 80);
					}
				}
			}
			Registry.bots2 = bots2;
		}
		
	
		private function parseRocks(player:Player):void
		{			
			rockMap = new FlxTilemap();
			
			rockMap.loadMap(new rocksCSV, rockPNG, 16, 16);
			
			rocks = new Rocks;
			
			for (var ty:Number = 0; ty < rockMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < rockMap.widthInTiles; tx++)
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
		
		private function parseCrumbleRocks(player:Player):void
		{			
			crumbleRockMap = new FlxTilemap();
			
			crumbleRockMap.loadMap(new crumbleRocksCSV, crumbleRockPNG, 16, 16);
			
			crumbleRocks = new CrumbleRocks;
			
			for (var ty:Number = 0; ty < crumbleRockMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < crumbleRockMap.widthInTiles; tx++)
				{
					if (crumbleRockMap.getTile(tx, ty) == 1)
					{
						crumbleRocks.addCrumbleRock(tx, ty);
					}
				}
			}
		}
		
	}
}
