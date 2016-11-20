package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
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
		public var checkpoint2:Checkpoint; // for the last level you need 2 checkpoints!
		public var end:Checkpoint;
		public var spring:Spring;
		public var spring2:Spring;
		public var streams:FlxGroup;
		public var waterSFX:FlxSound;
		public var lilguy:LilGuy = new LilGuy(100, 500);
		public var reinforcementMap:FlxTilemap;
		public var bird:Bird = new Bird();
		public var butt:Butt = new Butt(Registry.screenWidth/2 -16, 0);
		public var walkSFX:FlxSound;
		public var cutscene:FlxSprite;
		public var letterMsg:FlxText;
		public var wizHat:FlxSprite;
		[Embed(source = "../assets/umbrella.png")] private var _umbrellaPNG:Class;
		[Embed(source = "../assets/cutscene.png")] private var cutscenePNG:Class;
		[Embed(source = "../assets/blue.png")] private var bluePNG:Class;
		[Embed(source = "../assets/black.png")] private var blackPNG:Class;
		// [Embed(source = "../assets/stars.png")] private var starsPNG:Class;



		public var blue:FlxSprite;
		public var black:FlxSprite;
		public var umbrella:FlxSprite = new FlxSprite(23, 375);	
		public var beats:Array;
		public var worm1:Worm;
		public var worm2:Worm;
		public var worm3:Worm;
		public var mail:Mail;
		public var hitBox:Hitbox;
		public var wiz:Wiz;
		public var focusPoint:FlxSprite; //what the camera focuses on when moving in cutscenes
		public var focusDestination:FlxPoint; //where the camera should stop moving
		public var smokelets:Smokelets;
		public var particles:Particles;
		public var volcano:FlxSprite;
		public var boulder:Boulder;
		public var bouldlets:FlxGroup; 
		public var pointsMessage:FlxText;
		public var thingamajig:FlxSprite;
		public var frog:Frog;
		public var _levelNumber:FlxText; //this can't be static so it has to be in this class
		public var _playerSpawn:FlxPoint;
		public var sparkle:Sparkle;
		public var sparkle2:Sparkle;
		public var sparkle3:Sparkle;
		public var sparkle4:Sparkle;
		public var sparkle5:Sparkle;
		public var sparkle6:Sparkle;
		public var sparkle7:Sparkle;
		public var sparkle8:Sparkle;
		public var sparkle9:Sparkle;
		public var sparkle10:Sparkle;
		public var sparkle11:Sparkle;
		public var sparkle12:Sparkle;
		public var sparkle13:Sparkle;
		public var sparkle14:Sparkle;
		public var sparkle15:Sparkle;
		public var sparkle16:Sparkle;
		public var sparkle17:Sparkle;
		public var sparkle18:Sparkle;
		public var stars:Stars;


		[Embed(source = "../assets/canopy.png")] private var canopyPNG:Class;
		[Embed(source = "../assets/canopy6.png")] private var canopy6PNG:Class;
		public var canopy:FlxSprite = new FlxSprite(0, 0);
		
		public var supportMap:FlxTilemap;
		
		[Embed(source = "../assets/water.mp3")] private var water:Class;
		
		public function GameLevel() 
		{
			super();
		
			bots2 = new Bots2(); //why do I have only these two variables initiated here?
			poofs = new Poofs(); //idk wtf poofs are
			borgs = new Borgs();
			worm1 = new Worm(FlxMath.rand(700, 3400), 0);
			worm2 = new Worm(FlxMath.rand(worm1.x + 700, 3400), 0); 
			worm2 = new Worm(FlxMath.rand(worm2.x + 700, 3400), 0); 
			hitBox = new Hitbox();

			sparkle = new Sparkle(10, 10);
			sparkle2 = new Sparkle(30, 30);
			sparkle3 = new Sparkle(50, 50);
			sparkle4 = new Sparkle(10, 10);
			sparkle5 = new Sparkle(30, 30);
			sparkle6 = new Sparkle(50, 50);
			sparkle7= new Sparkle(10, 10);
			sparkle8 = new Sparkle(30, 30);
			sparkle9 = new Sparkle(50, 50);
			sparkle10 = new Sparkle(10, 10);
			sparkle11 = new Sparkle(30, 30);
			sparkle12 = new Sparkle(50, 50);
			sparkle13= new Sparkle(10, 10);
			sparkle14 = new Sparkle(30, 30);
			sparkle15= new Sparkle(50, 50);
			sparkle16= new Sparkle(10, 10);
			sparkle17 = new Sparkle(30, 30);
			sparkle18 = new Sparkle(50, 50);
			
			
			//umbrella
			umbrella.loadGraphic(_umbrellaPNG, false, false, 18, 21);
		
			cutscene = new FlxSprite(0, 0);
			cutscene.loadGraphic(cutscenePNG, false, false, 600, 300);
			cutscene.scrollFactor.x = 0;
			cutscene.scrollFactor.y = 0;
			cutscene.alpha = 0;
			
			
			umbrella.visible = false;
			
			blue = new FlxSprite(0, 0);
			blue.loadGraphic(bluePNG, false, false, 600, 300);
			blue.visible = false;


			black = new FlxSprite(0, 0);
			black.loadGraphic(blackPNG, false, false, 600, 300);
			black.scrollFactor.x = 0;
			black.scrollFactor.y = 0;
			black.alpha = .3;			
			//black.visible = false;
			
		}
		
		public function makeLevelNumber():void
		{
			//
			_levelNumber = new FlxText( -20, player.y - 160, 200, Registry.stageCount.toString());
			if (Registry.stageCount == 6) _levelNumber.y = player.y - 60;
			_levelNumber.size = 200;
		}
	}
}