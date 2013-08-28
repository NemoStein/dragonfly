package sourbit.library.dragonfly.modules.particles.helpers.tests
{
	import sourbit.library.dragonfly.plugins.particles.Particle;
	
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