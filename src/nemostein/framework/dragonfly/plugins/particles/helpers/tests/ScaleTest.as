package nemostein.framework.dragonfly.plugins.particles.helpers.tests
{
	import nemostein.framework.dragonfly.plugins.particles.Particle;
	
	public class ScaleTest extends NumericTest
	{
		
		public function ScaleTest(action:Function)
		{
			super(action);
		}
		
		override public function evaluate(particle:Particle):void 
		{
			testValue(particle, particle.scale);
		}
	}
}