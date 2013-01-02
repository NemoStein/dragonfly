package nemostein.framework.dragonfly.modules.particles.helpers
{
	import nemostein.framework.dragonfly.plugins.particles.Particle;
	
	public interface Force
	{
		function apply(particle:Particle):void;
	}
}