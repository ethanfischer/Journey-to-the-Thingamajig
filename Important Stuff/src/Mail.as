package  
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Mail extends FlxSprite
	{
		[Embed(source = "../assets/mail.png")] private var mailPNG:Class;
		
		public function Mail(x:int, y:int) 
		{
			super(x, y);
			loadGraphic(mailPNG, true, true, 8, 4);
			
		}
		
	}

}