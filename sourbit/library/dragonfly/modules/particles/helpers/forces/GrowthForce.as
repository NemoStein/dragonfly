package sourbit.library.dragonfly.modules.particles.helpers.forces
{
	import sourbit.library.dragonfly.plugins.particles.helpers.Force;
	import sourbit.library.dragonfly.plugins.particles.Particle;
	
	public class GrowthForce implements Force
	{
		private var _value:Number;
		
		public function GrowthForce(value:Number)
		{
			_value = value;
		}
		
		public function apply(particle:Particle):void
		{
			particle.scaleX = particle.scaleY *= _value * particle.delay + 1;
		}
	}
}