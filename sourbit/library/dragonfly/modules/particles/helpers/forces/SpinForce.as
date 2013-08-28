package sourbit.library.dragonfly.modules.particles.helpers.forces
{
	import sourbit.library.dragonfly.plugins.particles.helpers.Force;
	import sourbit.library.dragonfly.plugins.particles.Particle;
	
	public class SpinForce implements Force
	{
		private var _value:Number;
		
		public function SpinForce(value:Number)
		{
			_value = value;
		}
		
		public function apply(particle:Particle):void
		{
			particle.angle += _value * particle.delay;
		}
	}
}