package nemostein.framework.dragonfly.modules.particles
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import nemostein.framework.dragonfly.Entity;
	
	internal class ParticlePool extends Entity
	{
		static protected var created:int;
		static protected var pooled:int;
		
		static protected var pool:Array;
		{
			pool = [];
		}
		
		static protected function keep(particle:Particle):void
		{
			++pooled;
			particle.parent.remove(particle);
			pool.push(particle);
		}
		
		static protected function find(emitter:Emitter):Particle
		{
			var particle:Particle;
			
			if(pooled)
			{
				particle = pool.pop();
				particle.configure(emitter);
				--pooled;
			}
			else
			{
				particle = new Particle();
				particle.configure(emitter);
			}
			
			return particle;
		}
	}
}