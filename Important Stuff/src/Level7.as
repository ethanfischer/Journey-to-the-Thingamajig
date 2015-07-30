package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Level7 extends GameLevel
	{
		[Embed(source="../map/mapCSV_Level7_Background.csv", mimeType="application/octet-stream")] public var backgroundCSV:Class;
		[Embed(source="../map/mapCSV_Level7_Back_Background.csv", mimeType="application/octet-stream")] public var backbackgroundCSV:Class;
		[Embed(source="../map/mapCSV_Level7_Foreground.csv", mimeType="application/octet-stream")] public var foregroundCSV:Class;
		[Embed(source = "../map/mapCSV_Level7_Fore-Foreground.csv", mimeType = "application/octet-stream")] public var foreforegroundCSV:Class;
		
													//[Embed(source = "../map/underground.png")] public var backgroundTilesPNG:Class; //normal mode
														[Embed(source = "../map/grass_field_sunset.png")]public var backgroundTilesPNG:Class;    //mountain mode
		
														[Embed(source = "../map/mountains_sunset.png")] public var backbackgroundTilesPNG:Class  //mountain mode
		
		
													[Embed(source="../map/forest_tiles_sunset.png")]public var foregroundTilesPNG:Class;      // mountain mode
										[Embed(source = "../map/forest_tiles_foreground_sunset.png")] public var foreforegroundTilesPNG:Class;
															[Embed(source = "../map/botlet(2).png")] public var botletPNG:Class;
																[Embed(source = "../map/star.png")] public var nomNomPNG:Class;
																
				[Embed(source="../map/mapCSV_Level7_Bots.csv", mimeType="application/octet-stream")] public var botsCSV:Class;
		[Embed(source = "../map/mapCSV_Level7_Bots(2).csv", mimeType = "application/octet-stream")] public var bots2CSV:Class;
		[Embed(source="../map/mapCSV_Level7_Bots(3).csv", mimeType="application/octet-stream")]       public var bots3CSV:Class;
				[Embed(source="../map/mapCSV_Level7_Borgs.csv", mimeType="application/octet-stream")] public var borgsCSV:Class;
				[Embed(source="../map/mapCSV_Level7_Rocks.csv", mimeType="application/octet-stream")] public var rocksCSV:Class;
		[Embed(source = "../map/mapCSV_Level7_CrumbleRocks.csv", mimeType = "application/octet-stream")] public var crumbleRocksCSV:Class;
[Embed(source = "../map/mapCSV_Level7_FadeBlocks.csv", mimeType = "application/octet-stream")]       public var fadeBlocksCSV:Class;
		  [Embed(source = "../map/mapCSV_Level7_Torch.csv", mimeType = "application/octet-stream")] public var torchesCSV:Class;
	 [Embed(source = "../map/mapCSV_Level7_Supports.csv", mimeType = "application/octet-stream")]   public var supportsCSV:Class;
	 [Embed(source = "../map/mapCSV_Level7_Checkpoint.csv", mimeType = "application/octet-stream")] public var checkpointCSV:Class;
			[Embed(source = "../assets/stars.png")] public var starsPNG:Class;
																[Embed(source = "../map/rock.png")] public var rockPNG:Class;
													[Embed(source = "../map/crumbleRock_grey.png")] public var crumbleRockPNG:Class;
											    	   [Embed(source = "../map/fadeRock.png")]      public var fadeBlockPNG:Class;
															[Embed(source = "../assets/torch.png")] public var torchPNG:Class;
		[Embed(source = "../map/mapCSV_Level7_NomNoms.csv", mimeType = "application/octet-stream")] public var nomNomsCSV:Class;
															[Embed(source = "../assets/stream.png")] public var streamPNG:Class;
		[Embed(source = "../map/mapCSV_Level7_Streams.csv", mimeType = "application/octet-stream")] public var streamsCSV:Class;
		[Embed(source = "../map/mapCSV_Level7_Reinforcements.csv", mimeType = "application/octet-stream")] public var reinforcementsCSV:Class;
		[Embed(source = "../assets/smoke.png")] private var smokePNG:Class;
		
		[Embed(source = "../assets/distant_thunder.mp3")] public var dwarfDance:Class; //mountain ambience mode
		[Embed(source = "../assets/volcano.png")] public var volcanoPNG:Class;
		[Embed(source="../assets/thingamajig.png")] public var thingPNG:Class;
		//[Embed(source="../assets/02_Open_Eye_Signal.mp3")] public var dwarfDance:Class; //music mode
		//[Embed(source="../assets/Native American video game music test.mp3")] public var dwarfDance:Class;
		//[Embed(source = "../assets/water.mp3")] private var water:Class;
		
		//public var waterSFX:FlxSound = new FlxSound();
		public var rockMap:FlxTilemap;	
		public var crumbleRockMap:FlxTilemap;
		public var fadeBlockMap:FlxTilemap;
		
		public function Level7() 
		{
			super();
		
			Registry.hasUmbrella = true;
			smokelets = new Smokelets();
			particles = new Particles();
			volcano = new FlxSprite(442, 180);
			volcano.loadGraphic(volcanoPNG, false, false, 74, 60);
			volcano.scrollFactor.x = 0;
			volcano.scrollFactor.y = 0;
			boulder = new Boulder();
			bouldlets = new FlxGroup(30);
			thingamajig = new FlxSprite(11100, 405);
			thingamajig.loadGraphic(thingPNG, false, false, 64, 64);
			add(thingamajig);
			
			
			for (var j:int = 0; j < 30; j++)
			{
				var x:int = (Math.random() * 600);
				var y:int = -400 + (Math.random() * 400);
				var velocity:int = 500 + (Math.random() * 200);
				var temp:Bouldlet = new Bouldlet(x, y, velocity);
				bouldlets.add(temp);
			}
			
			Registry.fstPlace = 120;
			Registry.sndPlace = 220;
			Registry.thdPlace = 420;
			
			
			
			wiz = new Wiz(10000, 415);
			focusDestination = new FlxPoint(wiz.x-220, wiz.y); //where the camera should stop in the last level
			
			focusPoint = new FlxSprite(wiz.x - 455, 430);
			focusPoint.visible = false;
			focusPoint.scrollFactor.x = 0;
			Registry.hasFlower = true;
			Registry.meetingAdjourned = true;
			
			backbackground = new FlxTilemap;
			backbackground.loadMap(new backbackgroundCSV, backbackgroundTilesPNG, 768, 384);
			backbackground.setTileProperties(1, FlxObject.NONE);
			backbackground.scrollFactor.x = 0;
			backbackground.scrollFactor.y = .1;
			backbackground.y -= 20;
			
			foreground = new FlxTilemap;
			foreground.loadMap(new foregroundCSV, foregroundTilesPNG, 16, 16, 0, 0, 1, 24);
			//	Makes these tiles non collidable)
			foreground.setTileProperties(53, FlxObject.NONE, null, null, 2);
			foreground.setTileProperties(57, FlxObject.NONE, null, null, 6);
			foreground.setTileProperties(27, FlxObject.UP, null, null, 0);
			foreground.setTileProperties(34, FlxObject.NONE, null, null, 4);
			foreground.setTileProperties(33, FlxObject.NONE, null, null, 4);
			foreground.setTileProperties(52, FlxObject.NONE, null, null, 4);
			foreground.setTileProperties(90, FlxObject.NONE, null, null, 4);
			
			foreforeground = new FlxTilemap;
			foreforeground.loadMap(new foreforegroundCSV, foreforegroundTilesPNG, 16, 16, 0, 0, 1, 64);
			foreforeground.scrollFactor.x = 1;
			foreforeground.y += 160;
	
		
			Registry.map = foreground;
			
			width = foreground.width;
			height = foreground.height;
			
		///////////////////////////////////////////////////////
		//					 CHECKPOINT						 //
		///////////////////////////////////////////////////////
		parseCheckpoint();
		
		if (Registry.checkpointFlag) 
		{	
			if (Registry.checkpointFlag2)
			{	
				player = new Player(Registry.checkpoint2.x + 5, Registry.checkpoint2.y - 5);
				Registry.torchesOn = true;
			}
			else
			{
				player = new Player(Registry.checkpoint.x + 5, Registry.checkpoint.y - 5);
				Registry.torchesOn = true;
			}
		}
		else 
		{
			//player = new Player(10, 65);
			player = new Player(10700, 350); //for testing ending sequence
			Registry.torchesOn = true;
		}
		var rand1:int;
		var rand2:int;
		for (var i:int = 0; i < 100; i++)
		{
			rand1 = (((Math.random() + .5) * 3) + ((Math.random() + .5) * 3)) * 4;
			rand2 = (((Math.random()+.5) * 3) + ((Math.random()+.5) * 3)) * 10;
			smokelets.addSmokelet(445 + rand1, 140+ rand2);
		}
		for (var p:int = 0; p < 10; p++)
		{
			rand1 = (((Math.random() + .5) * 3) + ((Math.random() + .5) * 3)) * 4;
			rand2 = (((Math.random()+.5) * 3) + ((Math.random()+.5) * 3)) * 10;
			particles.addParticle(455 + rand1, 140+ rand2);
		}
		
		Registry.player = player;
			
			not_a_flower = new NotAFlower(260, height - 48, player);
			
			
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
			parseReinforcements();
			
			
			Registry.crumbleRockMap = crumbleRockMap;
			Registry.crumbleRocks = crumbleRocks;
			
			spring = new Spring(2832, 378, 900);

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
					if (streamMap.getTile(tx, ty) == 1) streams.add(new Stream(tx, ty, true, "normal"));
					else if(streamMap.getTile(tx, ty) == 2) streams.add(new Stream(tx, ty, false, "normal"));
					else if (streamMap.getTile(tx, ty) == 4) streams.add(new Stream(tx, ty, false, "fall"));
					else if (streamMap.getTile(tx, ty) == 12) streams.add(new Stream(tx, ty, false, "fallRight"));
					else if (streamMap.getTile(tx, ty) == 5) streams.add(new Stream(tx, ty, false, "drop"));
					else if (streamMap.getTile(tx, ty) == 16) streams.add(new Stream(tx, ty, false, "dropRight"));
					else if (streamMap.getTile(tx, ty) == 10) streams.add(new Stream(tx, ty, true, "crash"));
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
					else if (checkpointMap.getTile(tx, ty) == 2)
					{
						checkpoint2 = new Checkpoint(tx, ty);
						checkpoint2.second = true;
						Registry.checkpoint2 = checkpoint2;
						add(checkpoint2);
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
						bots2.addBot2(tx, ty, player, FlxObject.RIGHT, 300, true, 3);
					}
					else if (bot2Map.getTile(tx, ty) == 3)
					{
						bots2.addBot2(tx, ty, player, FlxObject.RIGHT, 120, true, 2, 8);
					}
					else if (bot2Map.getTile(tx, ty) == 4)
					{
						bots2.addBot2(tx, ty, player, FlxObject.RIGHT, 500, true, 10, 7, true);
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
		
		private function parseFadeBlocks():void
		{			
			fadeBlockMap = new FlxTilemap();
			
			fadeBlockMap.loadMap(new fadeBlocksCSV, fadeBlockPNG, 16, 16);
			
			fadeBlocks = new FadeBlocks;
			
			for (var ty:Number = 0; ty < fadeBlockMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < fadeBlockMap.widthInTiles; tx++)
				{
					if (fadeBlockMap.getTile(tx, ty) == 1)
					{
						fadeBlocks.addFadeBlock(tx, ty, 0, 1);
					}
					else if (fadeBlockMap.getTile(tx, ty) == 2)
					{
						fadeBlocks.addFadeBlock(tx, ty, .25, 1);
					}
					else if (fadeBlockMap.getTile(tx, ty) == 3)
					{
						fadeBlocks.addFadeBlock(tx, ty, .50, 1);
					}
					else if (fadeBlockMap.getTile(tx, ty) == 4)
					{
						fadeBlocks.addFadeBlock(tx, ty, 1, 1);
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