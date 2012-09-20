package nemostein.framework.dragonfly
{
	
	public class Animation
	{
		private var _animated:Core;
		
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
		
		public function Animation(animated:Core, id:String, frames:Array, frameRate:Number, loop:Boolean = true, callback:Function = null)
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
			}
			
			if (loop)
			{
				while (index >= length)
				{
					index -= length;
				}
				
				while (index < 0)
				{
					index += length;
				}
			}
			else
			{
				if (index >= length)
				{
					index = length - 1;
				}
				else if (index < 0)
				{
					index = 0;
				}
			}
			
			if (index != keyframe)
			{
				keyframe = index;
				
				if (callback != null)
				{
					callback(this, index);
				}
				
				_animated.moveSpriteToFrame(frames[index]);
			}
		}
		
		public function update(time:Number):void
		{
			keyframeTime += time;
			
			if (keyframeTime >= delay)
			{
				keyframeTime -= delay;
				goToFrame(keyframe + (reverse ? -1 : 1));
			}
		}
	}
}