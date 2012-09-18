package nemostein.framework.dragonfly.plugins.particles.helpers.tests
{
	import nemostein.framework.dragonfly.plugins.particles.Particle;
	
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