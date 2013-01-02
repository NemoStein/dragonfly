package nemostein.framework.dragonfly.modules.particles.helpers.tests
{
	import nemostein.framework.dragonfly.plugins.particles.Particle;
	
	public class AngleTest extends NumericTest
	{
		
		public function AngleTest(action:Function)
		{
			super(action);
		}
		
		override public function evaluate(particle:Particle):void 
		{
			testValue(particle, particle.angle);
		}
	}
}