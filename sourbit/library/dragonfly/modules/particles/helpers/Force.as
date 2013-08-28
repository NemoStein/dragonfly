package sourbit.library.dragonfly.modules.particles.helpers
{
	import sourbit.library.dragonfly.modules.particles.Particle;
	
	public interface Force
	{
		function apply(particle:Particle):void;
	}
}