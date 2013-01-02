package nemostein.framework.dragonfly.modules.particles
{
	import nemostein.framework.dragonfly.Core;
	import nemostein.framework.dragonfly.plugins.particles.helpers.Force;
	import nemostein.framework.dragonfly.plugins.particles.helpers.Graphic;
	import nemostein.framework.dragonfly.plugins.particles.helpers.Location;
	import nemostein.framework.dragonfly.plugins.particles.helpers.Numeric;
	import nemostein.framework.dragonfly.plugins.particles.helpers.Test;
	
	public class Emitter extends ParticlePool
	{
		public var emissionLocation:Location;
		public var emissionCount:Numeric;
		public var emissionDuration:Numeric;
		
		// Particle
		public var particleGraphic:Graphic;
		public var particleLife:Numeric;
		public var particleDirection:Numeric;
		public var particleSpeed:Numeric;
		public var particleAngle:Numeric;
		public var particleScaleX:Numeric;
		public var particleScaleY:Numeric;
		
		public var forces:Vector.<Force>;
		public var tests:Vector.<Test>;
		
		// Events
		public var onParticleBirth:Function;
		public var onParticleDeath:Function;
		public var onParticleIterate:Function;
		
		private var _ready:Boolean;
		private var _started:Boolean;
		private var _dispatchDelay:Number;
		private var _delay:Number;
		private var _duration:Number;
		
		public function Emitter()
		{
			forces = new Vector.<Force>();
			tests = new Vector.<Test>();
		}
		
		public function addForce(force:Force):void
		{
			forces.push(force);
		}
		
		public function addTest(test:Test):void
		{
			tests.push(test);
		}
		
		public function bake():void
		{
			reset();
			
			_dispatchDelay = emissionDuration.value / emissionCount.value;
			
			_ready = true;
		}
		
		public function start(resetEmitter:Boolean = false):void
		{
			if (!_started)
			{
				if (!_ready)
				{
					bake();
				}
				
				if (resetEmitter)
				{
					reset();
				}
				
				_started = true;
			}
		}
		
		private function reset():void 
		{
			_delay = 0;
			_duration = 0;
		}
		
		override protected function update():void 
		{
			if (_started)
			{
				_delay += time;
				_duration += time;
				
				while (_delay >= _dispatchDelay)
				{
					_delay -= _dispatchDelay;
					
					var particle:Particle = find(this);
					add(particle);
				}
				
				if (_duration > emissionDuration.value)
				{
					stop();
				}
			}
			
			super.update();
		}
		
		private function stop():void 
		{
			_started = false;
		}
	}
}