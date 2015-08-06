package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Level6 extends GameLevel
	{
		[Embed(source="../map/mapCSV_Level6_Background.csv", mimeType="application/octet-stream")] public var backgroundCSV:Class;
		[Embed(source="../map/mapCSV_Level6_Back_Background.csv", mimeType="application/octet-stream")] public var backbackgroundCSV:Class;
		[Embed(source="../map/mapCSV_Level6_Foreground.csv", mimeType="application/octet-stream")] public var foregroundCSV:Class;
		[Embed(source = "../map/mapCSV_Level6_Fore-Foreground.csv", mimeType = "application/octet-stream")] public var foreforegroundCSV:Class;
		
													//[Embed(source = "../map/underground.png")] public var backgroundTilesPNG:Class; //normal mode
														[Embed(source = "../map/grass_field.png")]public var backgroundTilesPNG:Class;    //mountain mode
		
														[Embed(source = "../map/mountains(dim).png")] public var backbackgroundTilesPNG:Class  //mountain mode
		
		
												//[Embed(source = "../map/dark_forest_tiles.png")] public var foregroundTilesPNG:Class; //normal mode
													[Embed(source="../map/forest_tiles_grey.png")]public var foregroundTilesPNG:Class;      // mountain mode
		
												[Embed(source = "../map/forest_tiles_foreground(grey).png")] public var foreforegroundTilesPNG:Class;
															[Embed(source = "../map/botlet(2).png")] public var botletPNG:Class;
																[Embed(source = "../map/star.png")] public var nomNomPNG:Class;
																
				[Embed(source="../map/mapCSV_Level6_Bots.csv", mimeType="application/octet-stream")] public var botsCSV:Class;
		[Embed(source = "../map/mapCSV_Level6_Bots(2).csv", mimeType = "application/octet-stream")] public var bots2CSV:Class;
				[Embed(source="../map/mapCSV_Level6_Borgs.csv", mimeType="application/octet-stream")] public var borgsCSV:Class;
				[Embed(source="../map/mapCSV_Level6_Rocks.csv", mimeType="application/octet-stream")] public var rocksCSV:Class;
		[Embed(source = "../map/mapCSV_Level6_CrumbleRocks.csv", mimeType = "application/octet-stream")] public var crumbleRocksCSV:Class;
		[Embed(source = "../map/mapCSV_Level6_FadeBlocks.csv", mimeType = "application/octet-stream")]       public var fadeBlocksCSV:Class;
			[Embed(source = "../map/mapCSV_Level6_Torch.csv", mimeType = "application/octet-stream")] public var torchesCSV:Class;
			[Embed(source = "../map/mapCSV_Level6_Supports.csv", mimeType = "application/octet-stream")]   public var supportsCSV:Class;
			[Embed(source = "../map/mapCSV_Level6_Checkpoint.csv", mimeType = "application/octet-stream")] public var checkpointCSV:Class;
			
																[Embed(source = "../map/rock.png")] public var rockPNG:Class;
															[Embed(source = "../map/crumbleRock_grey.png")] public var crumbleRockPNG:Class;
															[Embed(source = "../map/fadeRock.png")]      public var fadeBlockPNG:Class;
															[Embed(source = "../assets/torch.png")] public var torchPNG:Class;
		[Embed(source = "../map/mapCSV_Level6_NomNoms.csv", mimeType = "application/octet-stream")] public var nomNomsCSV:Class;
															[Embed(source = "../assets/stream.png")] public var streamPNG:Class;
		[Embed(source = "../map/mapCSV_Level6_Streams.csv", mimeType = "application/octet-stream")] public var streamsCSV:Class;
		
		[Embed(source="../assets/distant_thunder.mp3")] public var dwarfDance:Class; //mountain ambience mode
		//[Embed(source="../assets/02_Open_Eye_Signal.mp3")] public var dwarfDance:Class; //music mode
		//[Embed(source="../assets/Native American video game music test.mp3")] public var dwarfDance:Class;
		//[Embed(source = "../assets/water.mp3")] private var water:Class;
		
		//public var waterSFX:FlxSound = new FlxSound();
		public var rockMap:FlxTilemap;	
		public var crumbleRockMap:FlxTilemap;
		public var fadeBlockMap:FlxTilemap;
		//public var borgs:Borgs;
		
		public function Level6() 
		{
			super();
		
			Registry.hasUmbrella = true;
			
			//Registry.musix = dwarfDance;
			
			Registry.fstPlace = 120;
			Registry.sndPlace = 150;
			Registry.thdPlace = 180;
			
			Registry.hasFlower = true;
			Registry.meetingAdjourned = true;
			
			backbackground = new FlxTilemap;
			backbackground.loadMap(new backbackgroundCSV, backbackgroundTilesPNG, 256, 384);
			backbackground.setTileProperties(1, FlxObject.NONE);
			backbackground.scrollFactor.x = .05;
			backbackground.scrollFactor.y = .1;
			backbackground.y -= 20; /* */
			
			background = new FlxTilemap;
			background.loadMap(new backgroundCSV, backgroundTilesPNG, 256, 384);
			background.setTileProperties(1, FlxObject.NONE);
			background.scrollFactor.x = .5;
			background.scrollFactor.y = .9;
			background.y += 160; /**/
			
			
			foreground = new FlxTilemap;
			foreground.loadMap(new foregroundCSV, foregroundTilesPNG, 16, 16, 0, 0, 1, 24);
			
			foreforeground = new FlxTilemap;
			foreforeground.loadMap(new foreforegroundCSV, foreforegroundTilesPNG, 16, 16, 0, 0, 1, 64);
			foreforeground.scrollFactor.x = 1;
			foreforeground.y += 160;
			
			
			
			//	Makes these tiles non collidable)
			foreground.setTileProperties(57, FlxObject.NONE, null, null, 6);
			foreground.setTileProperties(27, FlxObject.UP, null, null, 0);
			
			//waterSFX.loadEmbedded(water, true, false);
			//waterSFX.volume = 0.2;
			//waterSFX.play();
			
			Registry.map = foreground;
			
			width = foreground.width;
			height = foreground.height;
			//Registry.checkpointFlag = true;
		
			
		///////////////////////////////////////////////////////
		//					 CHECKPOINT						 //
		///////////////////////////////////////////////////////
		
		if (Registry.checkpointFlag) 
		{
			player = new Player(Registry.checkpoint.x + 5, Registry.checkpoint.y - 5);
			frog = new Frog(623, 432);
			Registry.torchesOn = true;
		}
		else 
		{
			player = new Player(40, 410);
			frog = new Frog(1309, 112);
			Registry.torchesOn = true;
		}
		
		
		Registry.player = player;
			
			not_a_flower = new NotAFlower(260, height - 48, player);
			
			sign = new Sign(103, 300, "PUNCH LIKE NOBODY'S WATCHING", player, 93, 385);		
			
			parseBots(player);
			parseBots2(player);
			parseBorgs(player);
			parseTorches();
			parseRocks(player);
			parseCrumbleRocks(player);
			parseSupports();
			parseFadeBlocks();
			
			parseNomNoms();
			parseStreams();
			parseCheckpoint();
			
			Registry.crumbleRockMap = crumbleRockMap;
			Registry.crumbleRocks = crumbleRocks;
		
			spring = new Spring(528, 249, 500);
			spring2 = new Spring(1201, 443, 600);
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
				}
			
			}
			Registry.bots = bots;
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
		
		private function parseBorgs(player:Player):void
		{			
			var borgMap:FlxTilemap = new FlxTilemap();
			
			borgMap.loadMap(new borgsCSV, botletPNG, 16, 16);
			
			borgs = new Borgs;			
			
			for (var ty:Number = 0; ty < borgMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < borgMap.widthInTiles; tx++)
				{
					if (borgMap.getTile(tx, ty) == 1)
					{
						borgs.addBorg(tx, ty, player, FlxObject.RIGHT);
					}
					else if (borgMap.getTile(tx, ty) == 3)
					{
						borgs.addBorg(tx, ty, player, FlxObject.LEFT);
					}
				}
			}
			Registry.borgs = borgs;
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
						bots2.addBot2(tx, ty, player, FlxObject.RIGHT, 400);
					}
					else if (bot2Map.getTile(tx, ty) == 3)
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
		
		private function parseFadeBlocks():void
		{			
			fadeBlockMap = new FlxTilemap();
			
			fadeBlockMap.loadMap(new fadeBlocksCSV, fadeBlockPNG, 16, 16);
			//fadeBlockMap.y += 160; //because in DAME they're 10 blocks higher than usual
			
			
			fadeBlocks = new FadeBlocks;
			
			for (var ty:Number = 0; ty < fadeBlockMap.heightInTiles; ty++ )
			{
				for (var tx:int = 0; tx < fadeBlockMap.widthInTiles; tx++)
				{
					if (fadeBlockMap.getTile(tx, ty) == 1)
					{
						fadeBlocks.addFadeBlock(tx, ty-10, 0, 1);
					}
					else if (fadeBlockMap.getTile(tx, ty) == 2)
					{
						fadeBlocks.addFadeBlock(tx, ty-10, .5, 1);
					}
					else if (fadeBlockMap.getTile(tx, ty) == 3)
					{
						fadeBlocks.addFadeBlock(tx, ty-10, 1.5, 1);
					}
					else if (fadeBlockMap.getTile(tx, ty) == 4)
					{
						fadeBlocks.addFadeBlock(tx, ty-10, 1, 1);
					}
				}
			}
			
		}
		
		private function parseSupports():void
		{			
			supportMap = new FlxTilemap();
			
			supportMap.loadMap(new supportsCSV, fadeBlockPNG, 16, 16);
			
			supports = new Supports;
			
			for (var ty:Number = 0; ty < supportMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < supportMap.widthInTiles; tx++)
				{
					if (supportMap.getTile(tx, ty) == 1)
					{
						supports.addSupport(tx, ty);
					}
				}
			}
		}
	}
}