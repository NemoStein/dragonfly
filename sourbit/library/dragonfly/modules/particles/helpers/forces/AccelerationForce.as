package  sourbit.library.dragonfly.modules.particles.helpers.forces
{
	import sourbit.library.dragonfly.modules.particles.helpers.Force;
	import sourbit.library.dragonfly.modules.particles.Particle;
	
	public class AccelerationForce implements Force 
	{
		private var _value:Number;
		
		public function AccelerationForce(value:Number) 
		{
			_value = value;
		}
		
		public function apply(particle:Particle):void 
		{
			particle.speed *= _value * particle.delay + 1;
		}
	}
}