package nemostein.framework.dragonfly.modules.particles.helpers.tests
{
	import nemostein.framework.dragonfly.plugins.particles.Particle;
	
	public class DirectionTest extends NumericTest
	{
		
		public function DirectionTest(action:Function)
		{
			super(action);
		}
		
		override public function evaluate(particle:Particle):void 
		{
			testValue(particle, particle.direction);
		}
	}
}