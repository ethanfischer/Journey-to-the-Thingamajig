package;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;

class Registry
{

	public static var screenWidth:Int = 400;
	public static var screenHeight:Int = 200;



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
	public static var hasFlower:Bool; //= true;
	public static var hasUmbrella:Bool = false;
	public static var meetingAdjourned:Bool; //= true;
	//public static var musix:FlxSound;
	public static var musix:Class<Dynamic>;
	public static var gameLevel:GameLevel;
	public static var stageCount:Int = 0;
	public static var checkpointFlag:Bool = false;
	public static var checkpointFlag2:Bool = false;
	public static var checkpoint:Checkpoint;
	public static var checkpoint2:Checkpoint;
	public static var ezchkpt:FlxPoint;
	public static var deathMessageFlag:Bool = false;
	public static var levelDeathMessage:String;
	public static var musixFlag:Bool = false;
	public static var gameStart:Bool = true;
	public static var deathCount:Int = 1; // used for three different deathSFX
	public static var deaths:Int = 0;     // used to count the overall amount of deaths
	public static var totalDeaths:Int = 0;
	public static var torchesOn:Bool = false;
	public static var torchesCheckpoint:Bool;
	public static var totalChkptsUsed:Int = 0;
	public static var chkptsUsed:Int = 0;
	public static var easyMode:Bool = false; //in easy mode, you can place a checkpoint wherever, otherwise they are predetermined
	public static var hmodeChkpt:Int; //in not easy mode, where you have to cross to activate the checkpoint
	public static var character:String = "girl";
	public static var swap:Bool = false; //used to indicate whether there has been a character change
	public static var swapX:Int;
	public static var swapY:Int;
	public static var swapVelX:Int;
	public static var swapVelY:Int;
	public static var mode:String = "high";
	public static var nmlTimescale:Float;
	public static var playtime:Float = 0;
	public static var totalPlaytime:Float = 0;
	public static var footage:String;
	public static var pauseSounds:Bool = false;
	public static var letterSequence:Bool = false;
	public static var thdPlace:Int;
	public static var sndPlace:Int;
	public static var fstPlace:Int;
	public static var fx:Fx = new Fx();

	// Asset paths (converted from AS3 [Embed] metadata)
	public static var cursor:String = "assets/cursor.png";

	public static var firstLevel1:Bool = true;
	public static var firstLevel2:Bool = true;
	public static var firstLevel3:Bool = true;
	public static var firstLevel4:Bool = true;
	public static var firstLevel5:Bool = true;
	public static var firstLevel6:Bool = true;
	public static var firstLevel7:Bool = true;

	public static var firstTimePlayingLevel:Bool = true;
	// public static var volume:Float = .5;
	public static var volume:Float = 0;


	public static var dropBouldlets:Bool = false;
	public static var wizUnfreeze:Bool = false;
	public static var wizUnfreeze2:Bool = false;
	public static var noGoingBack:Int = 0; //in level 7 after wiz dies you shouldn't be able to go back (11170 is BEHINDGIFT)
	public static var theEnd:Bool;
	public static var ballsCollected:Int = 0;
	public static var buttAppeared:Bool = false;
	public static var textCounter:Int = 0;
	public static var tmpTxt:String = "";

	//cutscenes
	//NOTE: because every cutscene in my game should only happen once (no one wants to go through a cutscene over and over again
	//cutscene booleans are put in Registry (this class) because we want them to happen permanently (or as long as the user is playing the game)

	public static var giftExchange:Bool = false; //when you see the present, stop the camera from following player
	public static var giftHasBeenExchanged:Bool = false; //set to true after the wiz and gift disappear
	public static var metWiz:Bool = false;
	public static var wizGiftFlag:Bool = false; //once set, camera stays stationary with wiz and gift on right side of screen (set true in Playstate)


	public static var playerNormalAccel:Int = 600;
	public static var playerTurnAroundAccel:Int = 2000;
	public static var playerAirAccel:Int = 1500;

	public static var playerAirDecel:Int = 300;
	public static var playerNormalDecel:Int = 600;
	public static var playerInitialSlideDecel:Int = 80;
	public static var playerSlideDecel:Int = 280;

	public static var controlsDescriptor:String = "normal";

	/*
		Registry.playerNormalAccel = 600;
		Registry.playerTurnAroundAccel = 2000;
		Registry.playerAirAccel = 1500;

		Registry.playerAirDecel = 300;
		Registry.playerNormalDecel = 600;
		Registry.playerInitialSlideDecel = 140;
		Registry.playerSlideDecel = 300;
	*/

	public static var muteMode:Bool = false;
	// public static var muteMode:Bool = true;

	public static var disablePlayer:Bool = false;
	public static var muteBots:Bool = false;

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//															musicRepository															  //
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Audio asset paths (converted from AS3 [Embed] metadata)
	public static var quack:String = "assets/quack.mp3";
	public static var writing:String = "assets/writing.mp3";

	// Level music
	public static var l2msc:String = "assets/Playhouse.mp3";
	public static var l3msc:String = "assets/WeInsist.mp3";
	public static var l4msc:String = "assets/MindOnTheFritz.mp3";
	public static var l5msc:String = "assets/A_Wonderful_Guy.mp3";
	public static var l6msc:String = "assets/TheHoliday.mp3";
	public static var l7msc:String = "assets/l7msc.mp3";

	// Other music
	public static var falseHopeMsc:String = "assets/DwarfDance.mp3";
	public static var silence:String = "assets/silence.mp3";
	public static var endMsc:String = "assets/endingSong.mp3";

	public function new()
	{
		// FlxControl plugin equivalent in HaxeFlixel will be handled differently
		// HaxeFlixel doesn't use the same plugin system as AS3 Flixel
		// Input handling is built into FlxG.keys, FlxG.mouse, etc.
	}

}
