package  
{
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author ...
	 */
	public class Particles extends FlxGroup
	{
		
		public function Particles()
		{
			super();
		}
		
		public function addParticle(i_x:int, i_y:int):void
		{	
			var temp:Particle = new Particle(i_x, i_y);
			add(temp);
		}
		
	}

}