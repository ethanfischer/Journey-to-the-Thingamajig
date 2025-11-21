package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MainMenuState extends FlxState
{
	// Sprites and UI elements
	private var title:FlxSprite;
	private var quest:FlxSprite;
	private var to:FlxSprite;
	private var thingamajig:FlxSprite;
	private var stars:FlxSprite;
	private var stars2:FlxSprite;
	private var black:FlxSprite;
	private var menuTrees:FlxSprite;
	private var startButton:FlxButton;
	private var levelsButton:FlxButton;

	// State variables
	private var selector:Int = 1;
	private var punchFlag:Bool = false;
	private var timer:Float = 8;

	override public function create():Void
	{
		super.create();

		// Set up mouse cursor
		#if !FLX_NO_MOUSE
		FlxG.mouse.load(Registry.cursor, 1, 0, 0);
		FlxG.mouse.visible = true;
		#end

		// Handle mute mode
		if (Registry.muteMode)
		{
			FlxG.sound.volume = 0;
		}

		Registry.checkpointFlag = false;
		Registry.firstTimePlayingLevel = true;

		// Play menu music
		FlxG.sound.playMusic(AssetPaths.TIME_MUSIC, 1);

		// Title page background
		var titlePage:FlxSprite = new FlxSprite(0, 0);
		titlePage.loadGraphic(AssetPaths.MENU_LAKE);

		// Title text sprites with fade-in animation
		quest = new FlxSprite(0, 0);
		quest.loadGraphic(AssetPaths.JOURNEY, false, 600, 300);
		quest.alpha = 0;

		to = new FlxSprite(0, 0);
		to.loadGraphic(AssetPaths.TO, false, 600, 300);
		to.alpha = 0;

		thingamajig = new FlxSprite(0, 0);
		thingamajig.loadGraphic(AssetPaths.THINGAMAJIG, false, 600, 300);
		thingamajig.alpha = 0;

		// Scrolling menu trees
		menuTrees = new FlxSprite(0, 0);
		menuTrees.loadGraphic(AssetPaths.MENU_TREES, false, 1200, 300);
		menuTrees.velocity.x = -30;

		// Star backgrounds
		stars = new FlxSprite(0, 0);
		stars.loadGraphic(AssetPaths.STARS, false, 1200, 300);
		stars.velocity.x = -200;

		stars2 = new FlxSprite(0, 0);
		stars2.loadGraphic(AssetPaths.STARS, false, 1200, 300);
		stars2.velocity.x = 200;

		// Black overlay for transitions
		black = new FlxSprite(0, 0);
		black.loadGraphic(AssetPaths.BLACK, false, 600, 300);
		black.alpha = 0;

		Registry.stageCount = 0;

		// Create menu buttons
		levelsButton = new FlxButton(Registry.screenWidth / 2 - 29, Registry.screenHeight - 35, "LEVELS", goToLevelMenu);
		startButton = new FlxButton(Registry.screenWidth / 2 - 30, Registry.screenHeight - 50, "START", startIt);

		levelsButton.makeGraphic(64, 20, FlxColor.TRANSPARENT);
		startButton.makeGraphic(64, 20, FlxColor.TRANSPARENT);

		levelsButton.label.color = FlxColor.WHITE;
		levelsButton.alpha = 0;
		levelsButton.visible = false;

		startButton.label.color = FlxColor.WHITE;
		startButton.alpha = 0;
		startButton.visible = false;

		// Add everything to the scene
		add(black);
		add(titlePage);
		add(stars);
		add(stars2);
		add(menuTrees);
		add(quest);
		add(to);
		add(thingamajig);
		add(startButton);
		add(levelsButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Wrap scrolling stars and trees
		if (stars.x < -600) stars.x = 0;
		if (stars2.x > 0) stars2.x = -600;
		if (menuTrees.x < -600) menuTrees.x = 0;

		// Title animation sequence
		if (timer > 0)
		{
			if (timer < 8)
			{
				quest.alpha += 0.5 * elapsed;
				if (timer < 6)
				{
					to.alpha += 0.5 * elapsed;
					if (timer < 4)
					{
						thingamajig.alpha += 0.01;
					}
				}
			}
			timer -= elapsed;
		}
		else if (timer < 0 && startButton.alpha < 1)
		{
			// Fade in buttons
			startButton.alpha += 0.02;
			levelsButton.alpha += 0.02;
			startButton.visible = true;
			levelsButton.visible = true;
		}

		// Keyboard navigation
		if (FlxG.keys.justPressed.DOWN && selector < 2)
		{
			selector++;
			FlxG.sound.play(AssetPaths.QUACK);
		}
		else if (FlxG.keys.justPressed.UP && selector > 1)
		{
			selector--;
			FlxG.sound.play(AssetPaths.QUACK);
		}

		// Selection input
		if (FlxG.keys.justPressed.Z || FlxG.keys.justPressed.X ||
		    FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER)
		{
			if (selector == 1)
			{
				FlxG.camera.flash(0x99999900, 0.1);
				if (!punchFlag)
				{
					FlxG.sound.play(AssetPaths.PUNCH2, 1, false, null, true);
					punchFlag = true;
				}
				FlxG.camera.shake(0.03, 0.1);
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, changeState);
			}
			else if (selector == 2)
			{
				FlxG.camera.fade(FlxColor.BLACK, 0.2, false, changeState);
			}
		}
	}

	private function changeState():Void
	{
		if (selector == 1)
		{
			FlxG.switchState(new PlayState());
		}
		else if (selector == 2)
		{
			// TODO: Convert LevelMenuState before uncommenting
			// FlxG.switchState(new LevelMenuState());
			trace("LevelMenuState not yet converted - staying on MainMenuState");
		}
	}

	override public function destroy():Void
	{
		// HaxeFlixel doesn't have FlxSpecialFX - effects are handled differently
		super.destroy();
	}

	private function goToLevelMenu():Void
	{
		// TODO: Convert LevelMenuState before uncommenting
		// FlxG.switchState(new LevelMenuState());
		trace("LevelMenuState not yet converted - staying on MainMenuState");
	}

	private function startIt():Void
	{
		Registry.stageCount = 0;
		Registry.musixFlag = true;
		FlxG.camera.flash(FlxColor.BLACK, 1);
		Registry.chkptsUsed = 0;

		FlxG.switchState(new PlayState());
	}
}
