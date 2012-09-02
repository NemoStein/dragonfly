package nemostein.framework.dragonfly.plugins.particles.helpers.locations
{
	import nemostein.framework.dragonfly.Core;
	import nemostein.framework.dragonfly.plugins.particles.helpers.Location;
	
	public class TargetLocation implements Location
	{
		private var _target:Core;
		
		public function TargetLocation(target:Core)
		{
			_target = target;
		}
		
		public function get x():Number
		{
			return _target.x;
		}
		
		public function get y():Number
		{
			return _target.y;
		}
	}
}