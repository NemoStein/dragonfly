package nemostein.framework.dragonfly.plugins.particles.helpers.forces
{
	import nemostein.framework.dragonfly.plugins.particles.helpers.Force;
	import nemostein.framework.dragonfly.plugins.particles.Particle;
	
	public class GrowthForce implements Force
	{
		private var _value:Number;
		
		public function GrowthForce(value:Number)
		{
			_value = value;
		}
		
		public function apply(particle:Particle):void
		{
		
		}
	}
}