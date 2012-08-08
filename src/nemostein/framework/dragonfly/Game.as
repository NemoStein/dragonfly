package nemostein.framework.dragonfly
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class Game extends Core
	{
		private var _ready:Boolean;
		private var _paused:Boolean;
		private var _stopped:Boolean;
		private var _suspend:Boolean;
		private var _stage:Stage;
		
		private var _fps:Number;
		private var _fpsTicks:int;
		private var _fpsThreshold:int;
		private var _fpsText:Text;
		private var _showFps:Boolean;
		
		private var _suspensionScreen:Sprite;
		
		public function Game()
		{
			
		}
		
		override protected function initialize():void
		{
			_fpsText = new Text();
			_suspensionScreen = new Sprite();
			
			super.initialize();
		}
		
		final override protected function update():void
		{
			now = getTimer();
			elapsed = now - early;
			early = now;
			
			if (_showFps)
			{
				++_fpsTicks;
				_fpsThreshold += elapsed;
				if (_fpsThreshold > 1000)
				{
					_fps = 1000 / _fpsTicks;
					_fpsTicks = 0;
					_fpsThreshold -= 1000;
				}
			}
			
			if (!_stopped)
			{
				if (!_ready)
				{
					// TODO: initialize first frame
				}
				else if (!_suspend)
				{
					if (!_paused)
					{
						// TODO: update game loop
					}
					
					// TODO: render game loop
				}
			}
			
			super.update();
		}
		
		public function pause():void
		{
			_paused = true;
		}
		
		public function resume():void
		{
			_paused = false;
		}
		
		public function start(stage:Stage):void
		{
			if (!_stopped)
			{
				_stage = stage;
				_stopped = false;
				
				_stage.addEventListener(Event.ENTER_FRAME, onStageEnterFrame);
				_stage.addEventListener(Event.DEACTIVATE, onStageDeactivate);
				_stage.addEventListener(Event.ACTIVATE, onStageActivate);
			}
		}
		
		public function stop():void
		{
			if (_stopped)
			{
				_stopped = true;
				_stage.removeEventListener(Event.ENTER_FRAME, onStageEnterFrame);
			}
		}
		
		private function onStageEnterFrame(e:Event):void
		{
			update();
			render();
		}
		
		private function onStageDeactivate(e:Event):void
		{
			if (!_suspend)
			{
				_suspend = true;
				
				_suspensionScreen.graphics.clear();
				_suspensionScreen.graphics.beginFill(0, 0.8);
				_suspensionScreen.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
				_suspensionScreen.graphics.endFill();
				_stage.addChild(_suspensionScreen);
			}
		}
		
		private function onStageActivate(e:Event):void
		{
			if (_suspend)
			{
				_suspend = false;
				
				_stage.removeChild(_suspensionScreen);
			}
		}
		
		public function get paused():Boolean
		{
			return _paused;
		}
		
		public function showFps():void
		{
			_showFps = true;
			
			add(_fpsText);
		}
		
		public function hideFps():void
		{
			_showFps = false;
			
			remove(_fpsText);
		}
	}
}