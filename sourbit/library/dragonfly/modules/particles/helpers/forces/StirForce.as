package sourbit.library.dragonfly.modules.particles.helpers.forces
{
	import sourbit.library.dragonfly.modules.particles.helpers.Force;
	import sourbit.library.dragonfly.modules.particles.Particle;
	
	public class StirForce implements Force
	{
		private var _value:Number;
		
		public function StirForce(value:Number)
		{
			_value = value;
		}
		
		public function apply(particle:Particle):void
		{
			particle.direction += _value * particle.delay + (Math.random() * 2 - 1) * particle.delay;
		}
	}
}