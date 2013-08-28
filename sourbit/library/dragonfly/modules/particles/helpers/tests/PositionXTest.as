package sourbit.library.dragonfly.modules.particles.helpers.tests
{
	import sourbit.library.dragonfly.plugins.particles.Particle;
	
	public class PositionXTest extends NumericTest
	{
		
		public function PositionXTest(action:Function)
		{
			super(action);
		}
		
		override public function evaluate(particle:Particle):void 
		{
			testValue(particle, particle.x);
		}
	}
}