package nemostein.framework.dragonfly.modules.particles.helpers.locations
{
	import nemostein.framework.dragonfly.modules.container.entity.Entity;
	import nemostein.framework.dragonfly.modules.particles.helpers.Location;
	
	public class TargetLocation implements Location
	{
		private var _target:Entity;
		
		public function TargetLocation(target:Entity)
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