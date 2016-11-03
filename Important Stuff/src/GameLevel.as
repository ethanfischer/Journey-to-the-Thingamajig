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