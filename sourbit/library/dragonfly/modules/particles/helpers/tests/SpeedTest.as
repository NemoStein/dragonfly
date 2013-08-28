package sourbit.library.dragonfly.modules.particles.helpers.tests
{
	import sourbit.library.dragonfly.plugins.particles.Particle;
	
	public class SpeedTest extends NumericTest
	{
		
		public function SpeedTest(action:Function)
		{
			super(action);
		}
		
		override public function evaluate(particle:Particle):void 
		{
			testValue(particle, particle.speed);
		}
	}
}