package
{
	import org.flixel.FlxGame;

	[SWF(width = 1000, 500, backgroundColor = "#000000")]
	[Frame(factoryClass="Preloader")] //Tells Flixel to use the default preloader

	public class Main extends FlxGame
	{
		public function Main()
		{
			super(Registry.screenWidth, Registry.screenHeight, MainMenuState, 2, 30, 30);
			
			forceDebugger = true;
		}
	}
}
