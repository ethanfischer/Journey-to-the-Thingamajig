package  
{
	import flash.display.Sprite;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class GameLevel extends FlxGroup
	{
		public var player:Player;
		public var background:FlxTilemap;
		public var backbackground:FlxTilemap;
		public var foreground:FlxTilemap;
		public var foreforeground:FlxTilemap;
		public var width:int;
		public var height:int;
		public var bots:Bots;
		public var bots2:Bots2;
		public var poofs:Poofs;
		public var npc:NPC;
		public var borgs:Borgs;
		public var rocks:Rocks;
		public var reinforcements:Reinforcements;
		public var supports:Supports;
		public var torches:Torches;
		public var crumbleRocks:CrumbleRocks;
		public var fadeBlocks:FadeBlocks;
		public var nomNoms:FlxGroup;
		public var not_a_flower:NotAFlower;
		//public var musix:FlxSound = new FlxSound();
		public var musix:Class;
		public var sign:Sign;
		public var sign2:Sign;// = new Sign(0, 0, "", player, 0, 0);
		public var checkpoint:Checkpoint;
		public var end:Checkpoint;
		public var spring:Spring;
		public var spring2:Spring;
		public var streams:FlxGroup;
		public var waterSFX:FlxSound;
		public var lilguy:LilGuy = new LilGuy(100, 500);
		public var reinforcementMap:FlxTilemap;
		public var bird:Bird = new Bird();
		public var walkSFX:FlxSound;
		public var cutscene:FlxSprite;
		public var letter:FlxSprite;
		[Embed(source = "../assets/umbrella.png")] private var _umbrellaPNG:Class;
		[Embed(source = "../assets/cutscene.png")] private var cutscenePNG:Class;
		[Embed(source = "../assets/blue.png")] private var bluePNG:Class;
		public var blue:FlxSprite;
		public var umbrella:FlxSprite = new FlxSprite(23, 375);	
		public var beats:Array;
		public var worm1:Worm;
		public var worm2:Worm;
		public var worm3:Worm;
		public var mail:Mail;
		public var wiz:Wiz;
		public var focusPoint:FlxSprite;
		public var meh:FlxPoint;
		public var smokelets:Smokelets;
		public var particles:Particles;
		public var volcano:FlxSprite;
		public var boulder:Boulder;
		public var bouldlets:FlxGroup; 
		public var pointsMessage:FlxText;
	
		[Embed(source = "../assets/canopy.png")] private var canopyPNG:Class;
		[Embed(source = "../assets/canopy6.png")] private var canopy6PNG:Class;
		public var canopy:FlxSprite = new FlxSprite(0, 0);
		
		public var supportMap:FlxTilemap;
		
		[Embed(source = "../assets/water.mp3")] private var water:Class;
		
		public function GameLevel() 
		{
			super();
		
			bots2 = new Bots2(); //why do I have only these two variables initiated here?
			poofs = new Poofs();
			borgs = new Borgs();
			worm1 = new Worm(FlxMath.rand(700, 3400), 0);
			worm2 = new Worm(FlxMath.rand(worm1.x + 700, 3400), 0); 
			worm2 = new Worm(FlxMath.rand(worm2.x + 700, 3400), 0); 
			
			
			
			
			//umbrella
			umbrella.loadGraphic(_umbrellaPNG, false, false, 18, 21);
		
			cutscene = new FlxSprite(0, 0);
			cutscene.loadGraphic(cutscenePNG, false, false, 600, 300);
			cutscene.scrollFactor.x = 0;
			cutscene.scrollFactor.y = 0;
			cutscene.alpha = 0;
			if (Registry.stageCount < 5) canopy.loadGraphic(canopyPNG, false, false, 600, 300);
			else canopy.loadGraphic(canopy6PNG, false, false, 600, 300);
			canopy.scrollFactor.y = 1;
			canopy.scrollFactor.x = 0;
			canopy.y = 180;
			
			umbrella.visible = false;
			
			blue = new FlxSprite(0, 0);
			blue.loadGraphic(bluePNG, false, false, 600, 300);
			blue.visible = false;
			
			/*beat1.loadEmbedded(beet1, true);
			beat2.loadEmbedded(beet2, true);
			beat3.loadEmbedded(beet3, true);
			beat4.loadEmbedded(beet4, true); */
			
			//beats = new Array();
			//beats = [beat2, beat1, beat3, beat4];
			//musix = beats[Registry.deathCount % 4];
			//FlxG.music = musix;
			
			
		
			
		}
	}
}