package nemostein.framework.dragonfly
{
	
	public class Animation
	{
		public var id:String;
		public var frames:Array;
		public var frameRate:Number;
		public var loop:Boolean;
		public var callback:Function;
		public var delay:Number;
		public var lenght:int;
		
		public var frame:int;
		public var frameIndex:int;
		public var frameTime:Number;
		
		public function Animation(id:String, frames:Array, frameRate:Number, loop:Boolean = true, callback:Function = null)
		{
			this.id = id;
			this.frames = frames;
			this.frameRate = frameRate;
			this.loop = loop;
			this.callback = callback;
			
			delay = 1 / frameRate;
			lenght = frames.length;
		}
		
		public function nextFrame():Boolean
		{	
			if (frameIndex < lenght - 1 || loop)
			{
				++frameIndex;
				
				if (frameIndex == lenght)
				{
					frameIndex = 0;
				}
				
				if(callback != null)
				{
					callback(this, frameIndex);
				}
				
				frame = frames[frameIndex];
				
				return true;
			}
			
			frame = frames[frameIndex];
			
			return false;
		}
	}
}