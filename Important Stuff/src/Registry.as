package  
{
	import flash.system.Capabilities;
	import flash.concurrent.Condition;
	import flash.geom.Point;
	import org.flixel.*;
	
	public class Registry 
	{
		
		public static var screenWidth:int = 500;
		public static var screenHeight:int = 250;
		
		
		
		public static var map:FlxTilemap;
		public static var crumbleRockMap:FlxTilemap;
		public static var crumbleRocks:CrumbleRocks;
		public static var levelExit:FlxPoint;
		public static var player:Player;
		public static var bots:Bots;
		public static var bots2:Bots2;
		public static var borgs:Borgs;
		public static var rock:Rock;
		public static var level2:Level2;
		public static var hasFlower:Boolean //= true;
		public static var hasUmbrella:Boolean = false;
		public static var meetingAdjourned:Boolean //= true;
		//public static var musix:FlxSound;
		public static var musix:Class;
		public static var gameLevel:GameLevel;
		public static var stageCount:int = 0;
		public static var checkpointFlag:Boolean = false;
		public static var checkpointFlag2:Boolean = false;
		public static var checkpoint:Checkpoint;
		public static var checkpoint2:Checkpoint;
		public static var ezchkpt:FlxPoint;
		public static var deathMessageFlag:Boolean = false;
		public static var levelDeathMessage:String;
		public static var musixFlag:Boolean = false;
		public static var gameStart:Boolean = true;
		public static var deathCount:int = 1; // used for three different deathSFX
		public static var deaths:int = 0;     // used to count the overall amount of deaths
		public static var totalDeaths:int = 0;
		public static var torchesOn:Boolean = false;
		public static var torchesCheckpoint:Boolean;
		public static var totalChkptsUsed: int = 0;
		public static var chkptsUsed:int = 0;
		public static var easyMode:Boolean = false; //in easy mode, you can place a checkpoint wherever, otherwise they are predetermined
		public static var hmodeChkpt:int; //in not easy mode, where you have to cross to activate the checkpoint
		public static var character:String = "girl";
		public static var swap:Boolean = false; //used to indicate whether there has been a character change
		public static var swapX:int;
		public static var swapY:int;
		public static var swapVelX:int;
		public static var swapVelY:int;
		public static var mode:String = "high";
		public static var nmlTimescale:Number;
		public static var playtime:Number = 0;
		public static var totalPlaytime:Number = 0;
		public static var footage:String;
		public static var pauseSounds:Boolean = false;
		public static var letterSequence:Boolean = false;;
		public static var thdPlace:int;
		public static var sndPlace:int;
		public static var fstPlace:int;
		public static var fx:Fx = new Fx;
		
		public static var firstLevel1:Boolean = true;
		public static var firstLevel4:Boolean = true;
		public static var firstTimePlayingLevel:Boolean = true;
		
		public static var dropBouldlets:Boolean = false;
		public static var wizUnfreeze:Boolean = false;
		public static var wizUnfreeze2:Boolean = false;
		public static var noGoingBack:int = 0; //in level 7 after wiz dies you shouldn't be able to go back (11170 is BEHINDGIFT)
		public static var theEnd:Boolean;
		public static var ballsCollected:int = 0;
		
		//cutscenes
		//NOTE: because every cutscene in my game should only happen once (no one wants to go through a cutscene over and over again
		//cutscene booleans are put in Registry (this class) because we want them to happen permanently (or as long as the user is playing the game)
		
		public static var giftExchange:Boolean = false; //when you see the present, stop the camera from following player
		public static var giftHasBeenExchanged:Boolean = false; //set to true after the wiz and gift disappear
		public static var metWiz:Boolean = false;
		public static var wizGiftFlag:Boolean = false; //once set, camera stays stationary with wiz and gift on right side of screen (set true in Playstate)
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//															musicRepository															  //
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		[Embed(source = "../assets/quack.mp3")] public static var quack:Class;
		[Embed(source = "../assets/writing.mp3")] public static var writing:Class;
		//Level1,3
		[Embed(source = "../assets/forestsounds.mp3")] public static var forestSounds:Class;
		//Level2
		[Embed(source = "../assets/forestsounds2.mp3")] public static var forestSounds2:Class;
		//Level4
		[Embed(source = "../assets/river.mp3")] public static var water:Class;
		//Level 5
		[Embed(source="../assets/howler_monkeys_thunder.mp3")]public static var dwarfDance:Class;
		[Embed(source = "../assets/rumble.mp3")] public static var rumble:Class;
		
		
		public function Registry() 
		{
		}
		
	}

}