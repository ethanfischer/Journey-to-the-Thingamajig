package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * Main gameplay state
 * Manages level loading, UI, and game flow
 */
class PlayState extends FlxState
{
	private var currentLevel:GameLevel;
	private var levelButton:FlxButton;
	private var debugText:FlxText;

	override public function create():Void
	{
		super.create();

		// Set up mouse cursor
		#if !FLX_NO_MOUSE
		FlxG.mouse.load(Registry.cursor, 1, 0, 0);
		FlxG.mouse.visible = true;
		#end

		// Load Level1
		loadLevel(1);

		// Set world bounds to level dimensions
		if (currentLevel != null) {
			FlxG.worldBounds.set(0, 0, currentLevel.width, currentLevel.height);
		}

		// Create UI buttons
		createUI();
	}

	private function loadLevel(levelNum:Int):Void
	{
		// Clear existing level
		if (currentLevel != null)
		{
			remove(currentLevel);
			currentLevel.destroy();
			currentLevel = null;
		}

		// Create new level based on level number
		switch (levelNum)
		{
			case 1:
				currentLevel = new Level1();
			default:
				trace("Level " + levelNum + " not implemented yet");
				currentLevel = new Level1(); // Default to Level1
		}

		// Add level to state
		add(currentLevel);

		// Update Registry
		Registry.gameLevel = currentLevel;
		Registry.stageCount = levelNum - 1;
	}

	private function createUI():Void
	{
		// "Levels" button to return to menu
		levelButton = new FlxButton(2, 1, "Levels", goToMainMenu);
		levelButton.label.color = FlxColor.GRAY;
		levelButton.scrollFactor.set(0, 0); // Fixed to camera
		add(levelButton);

		// Debug text for animation info
		debugText = new FlxText(2, 20, 300, "");
		debugText.scrollFactor.set(0, 0);
		debugText.color = FlxColor.WHITE;
		add(debugText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Collide player with foreground tilemap
		if (currentLevel != null && currentLevel.player != null)
		{
			if (currentLevel.foreground != null) {
				FlxG.collide(currentLevel.foreground, currentLevel.player);
			}

			// Update debug text
			var p = currentLevel.player;
			var animName = p.animation.name != null ? p.animation.name : "null";
			var curAnim = p.animation.curAnim;
			var frame = curAnim != null ? curAnim.curFrame : -1;
			var frameIdx = p.animation.frameIndex;
			debugText.text = "Anim: " + animName + " frame:" + frame + " idx:" + frameIdx + "\nvel.x: " + Std.int(p.velocity.x);
		}

		// ESC key to return to menu
		if (FlxG.keys.justPressed.ESCAPE)
		{
			goToMainMenu();
		}

		// Debug: R to restart level
		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}
	}

	private function goToMainMenu():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.3, false, function()
		{
			FlxG.switchState(new MainMenuState());
		});
	}

	override public function destroy():Void
	{
		currentLevel = null;
		levelButton = null;

		super.destroy();
	}
}
