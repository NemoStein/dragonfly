package nemostein.framework.dragonfly.plugins.particles.helpers.tests
{
	import nemostein.framework.dragonfly.plugins.particles.Particle;
	
	public class AgeTest extends NumericTest
	{
		
		public function AgeTest(action:Function)
		{
			super(action);
		}
		
		override public function evaluate(particle:Particle):void 
		{
			testValue(particle, particle.age);
		}
	}
}