package;

/**
 * Asset path constants for Journey to the Thingamajig
 *
 * In HaxeFlixel, we use string paths instead of Flash's [Embed] metadata.
 * All paths are relative to the assets/ directory.
 */
class AssetPaths
{
	// Main Menu Graphics
	public static inline var MENU_LAKE:String = "assets/menulake.png";
	public static inline var MENU_BOX:String = "assets/menuBox.png";
	public static inline var MENU_TREES:String = "assets/menu trees.png";
	public static inline var SELECT_THING:String = "assets/selectthing.png";
	public static inline var TITLE:String = "assets/title.png";
	public static inline var JOURNEY:String = "assets/journey400x200.png";
	public static inline var TO:String = "assets/to400x200.png";
	public static inline var THINGAMAJIG:String = "assets/thingamajig400x200.png";
	public static inline var STARS:String = "assets/stars.png";
	public static inline var BLACK:String = "assets/black.png";
	public static inline var START:String = "assets/start.png";

	// Main Menu Audio
	public static inline var QUACK:String = "assets/quack.mp3";
	public static inline var PUNCH2:String = "assets/punch2.mp3";
	public static inline var TIME_MUSIC:String = "assets/time.mp3";

	// Player Graphics
	public static inline var PLAYER:String = "assets/player.png";
	public static inline var PLAYER_HURT:String = "assets/player_hurt.png";

	// Player Audio
	public static inline var FOOTSTEP:String = "assets/footstep.mp3";
	public static inline var FAST_STEP:String = "assets/faststep.mp3";
	public static inline var JUMP_SFX3:String = "assets/jumpSFX3.mp3";
	public static inline var SLIDE_SFX:String = "assets/slide.mp3";
	public static inline var HURT_SFX:String = "assets/hurtSFX.mp3";
	public static inline var LAND_SFX:String = "assets/land.mp3";

	// Common UI
	public static inline var CURSOR:String = "assets/cursor.png";
	public static inline var MUTE:String = "assets/mute.png";

	// Common Audio
	public static inline var JUMP:String = "assets/jumpSFX.mp3";
	public static inline var LAND:String = "assets/land.mp3";
	public static inline var DEATH:String = "assets/deathSFX.mp3";
	public static inline var HURT:String = "assets/hurtSFX.mp3";

	// Level Assets (to be expanded as needed)
	public static inline var FOREST_TILES:String = "assets/forest_tiles(4).png";

	// Level 1 Assets
	public static inline var L1_FOREGROUND_TILES:String = "assets/forest_tiles_l1.png";
	public static inline var L1_FOREGROUND_CSV:String = "assets/mapCSV_Level1_Foreground.csv";
	public static inline var L1_BACKGROUND_TILES:String = "assets/woody(green).png";
	public static inline var L1_BACKGROUND_CSV:String = "assets/mapCSV_Level1_Background.csv";
	public static inline var L1_BACKBACKGROUND_TILES:String = "assets/woody_back_background.png";
	public static inline var L1_BACKBACKGROUND_CSV:String = "assets/mapCSV_Level1_Back_Background.csv";

	// Particles and Effects
	public static inline var PARTICLE:String = "assets/particle.png";
	public static inline var POOF:String = "assets/poof.png";
	public static inline var SPARKLE:String = "assets/sparkle.png";

	// TODO: Add more asset paths as levels and entities are converted
}
