package  nemostein.framework.dragonfly.modules.particles.helpers.forces
{
	import nemostein.framework.dragonfly.modules.particles.helpers.Force;
	import nemostein.framework.dragonfly.modules.particles.Particle;
	
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