package nemostein.framework.dragonfly.modules.particles.helpers
{
	import nemostein.framework.dragonfly.modules.particles.Particle;
	
	public interface Force
	{
		function apply(particle:Particle):void;
	}
}