package sourbit.library.dragonfly.modules.particles.helpers.locations
{
	import sourbit.library.dragonfly.modules.particles.helpers.Location;
	
	public class FixedLocation implements Location
	{
		private var _x:Number;
		private var _y:Number;
		
		public function FixedLocation(x:Number, y:Number)
		{
			_y = y;
			_x = x;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
	}
}