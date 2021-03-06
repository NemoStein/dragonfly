package sourbit.library.dragonfly.modules.particles.helpers.locations
{
	import sourbit.library.dragonfly.modules.container.entity.Entity;
	import sourbit.library.dragonfly.modules.particles.helpers.Location;
	
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