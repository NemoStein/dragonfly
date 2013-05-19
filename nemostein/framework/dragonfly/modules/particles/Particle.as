package nemostein.framework.dragonfly.modules.particles
{
	import nemostein.framework.dragonfly.modules.container.entity.AnchorAlign;
	import nemostein.framework.dragonfly.modules.particles.helpers.Force;
	import nemostein.framework.dragonfly.modules.particles.helpers.Test;
	
	public class Particle extends ParticlePool
	{
		public var emitter:Emitter;
		
		public var age:Number;
		
		public var life:Number;
		public var direction:Number;
		public var speed:Number;
		
		private var forces:Vector.<Force>;
		private var tests:Vector.<Test>;
		
		public var onBirth:Function;
		public var onDeath:Function;
		public var onIterate:Function;
		
		public function Particle()
		{
			super();
		}
		
		public function configure(emitter:Emitter):void
		{
			this.emitter = emitter;
			
			revive();
			
			// TODO: Add animation to the particles
			draw(emitter.particleGraphic.data);
			alignAnchor(AnchorAlign.CENTER, AnchorAlign.CENTER);
			
			position.x = emitter.emissionLocation.x;
			position.y = emitter.emissionLocation.y;
			
			life = emitter.particleLife.value;
			direction = emitter.particleDirection.value;
			speed = emitter.particleSpeed.value;
			//angle = emitter.particleAngle.value;
			//scaleX = emitter.particleScaleX.value;
			//scaleY = emitter.particleScaleY.value;
			
			forces = emitter.forces;
			tests = emitter.tests;
			
			onBirth = emitter.onParticleBirth;
			onDeath = emitter.onParticleDeath;
			onIterate = emitter.onParticleIterate;
			
			age = 0;
		}
		
		override protected function update():void
		{
			age += time;
			
			position.x += Math.cos(direction) * speed * time;
			position.y += Math.sin(direction) * speed * time;
			
			var i:int;
			
			var forcesCount:int = forces.length;
			for (i = 0; i < forcesCount; ++i)
			{
				var force:Force = forces[i];
				force.apply(this);
			}
			
			var testsCount:int = tests.length;
			for (i = 0; i < testsCount; ++i)
			{
				var test:Test = tests[i];
				test.evaluate(this);
			}
			
			if (age == 0 && onBirth)
			{
				onBirth(this);
			}
			
			if (onIterate)
			{
				onIterate(this);
			}
			
			if (age >= life)
			{
				die();
				
				if (onDeath)
				{
					onDeath(this);
				}
			}
			
			super.update();
		}
		
		override public function die():void
		{
			keep(this);
			
			super.die();
		}
		
		public function get delay():Number
		{
			return time;
		}
	}
}