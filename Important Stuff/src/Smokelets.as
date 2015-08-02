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
		
		public function addSmokelet(i_x:int, i_y:int, i_wizPoof:Boolean = false, randAclX:int = 0, randVelY:int = 0):void
		{	
			var temp:Smokelet = new Smokelet(i_x, i_y, i_wizPoof, randAclX, randVelY);
			add(temp);
		}
		
	}

}