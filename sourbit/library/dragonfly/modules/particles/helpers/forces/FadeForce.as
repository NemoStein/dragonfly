package  sourbit.library.dragonfly.modules.particles.helpers.forces
{
	import sourbit.library.dragonfly.plugins.particles.helpers.Force;
	import sourbit.library.dragonfly.plugins.particles.Particle;
	
	public class FadeForce implements Force 
	{
		private var _value:Number;
		
		public function FadeForce(value:Number) 
		{
			_value = value;
		}
		
		public function apply(particle:Particle):void 
		{
			particle.alpha += _value * particle.delay;
		}
	}
}