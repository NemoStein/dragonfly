package nemostein.framework.dragonfly.modules.container.entity
{
	
	public class Animation
	{
		private var _animated:Entity;
		private var _ended:Boolean;
		
		public var id:String;
		public var frames:Array;
		public var frameRate:Number;
		public var loop:Boolean;
		public var callback:Function;
		
		public var reverse:Boolean;
		
		public var delay:Number;
		public var length:int;
		
		public var keyframe:int;
		public var keyframeTime:Number;
		
		public function Animation(animated:Entity, id:String, frames:Array, frameRate:Number, loop:Boolean = true, callback:Function = null)
		{
			if (frameRate <= 0)
			{
				frameRate = 1;
			}
			
			_animated = animated;
			
			this.id = id;
			this.frames = frames;
			this.frameRate = frameRate;
			this.loop = loop;
			this.callback = callback;
			
			keyframeTime = 0;
			delay = 1 / frameRate;
			length = frames.length;
		}
		
		public function goToFrame(index:int, resetTime:Boolean = false):void
		{
			if (resetTime)
			{
				keyframeTime = 0;
				_ended = false;
			}
			
			var cycle:Boolean = false;
			
			if (loop)
			{
				while (index >= length)
				{
					index = 0;
					cycle = true;
				}
				
				while (index < 0)
				{
					index += length;
					cycle = true;
				}
			}
			else
			{
				if (index >= length)
				{
					index = length - 1;
					cycle = true;
				}
				else if (index < 0)
				{
					index = 0;
					cycle = true;
				}
			}
			
			if (index != keyframe || cycle || resetTime)
			{
				if(loop || !cycle)
				{
					keyframe = index;
					_animated.moveSpriteToFrame(frames[index]);
				}
				else
				{
					_ended = true;
				}
				
				if (callback != null)
				{
					callback(this, index, cycle);
				}
			}
		}
		
		public function update(time:Number):void
		{
			if (!_ended)
			{
				keyframeTime += time;
				
				if (keyframeTime >= delay)
				{
					keyframeTime -= delay;
					goToFrame(keyframe + (reverse ? -1 : 1));
				}
			}
		}
		
		public function setFrameRate(value:Number):void
		{
			frameRate = value;
			delay = 1 / frameRate;
		}
	}
}