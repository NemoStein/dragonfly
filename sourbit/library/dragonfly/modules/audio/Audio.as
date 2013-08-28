package sourbit.library.dragonfly.modules.audio 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class Audio 
	{
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _position:Number;
		
		public var loop:Boolean;
		
		public function Audio(SoundClass:Class, loop:Boolean = false)
		{
			_sound = new SoundClass();
			this.loop = loop;
		}
		
		public function play():void 
		{
			_channel = _sound.play(_position);
			
			if (loop)
			{
				_channel.addEventListener(Event.SOUND_COMPLETE, onChannelSoundComplete);
			}
		}
		
		public function pause():void 
		{
			_position = _channel.position;
			_channel.stop();
		}
		
		public function stop():void 
		{
			_position = 0;
			_channel.stop();
		}
		
		private function onChannelSoundComplete(event:Event):void 
		{
			_position = 0;
			play();
		}
	}
}