package  
{
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author ...
	 */
	public class Smokelets extends FlxGroup
	{
		
		public function Smokelets()
		{
			super();
		}
		
		public function addSmokelet(i_x:int, i_y:int):void
		{	
			var temp:Smokelet = new Smokelet(i_x, i_y);
			add(temp);
		}
		
	}

}