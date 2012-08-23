package nemostein.framework.dragonfly
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import nemostein.io.Input;
	
	public class Game extends Core
	{
		/**
		 * [read-only]
		 */
		static public var stage:Stage;
		
		private var _ready:Boolean;
		private var _started:Boolean;
		private var _suspend:Boolean;
		
		private var _fps:Number;
		private var _fpsTicks:int;
		private var _fpsThreshold:int;
		private var _fpsText:Text;
		private var _showFps:Boolean;
		
		private var _suspensionScreen:Shape;
		private var _display:Bitmap;
		private var _width:int;
		private var _height:int;
		private var _color:uint;
		
		public function Game(width:int, height:int, color:uint = 0xffdadfef)
		{
			_width = width;
			_height = height;
			_color = color;
			
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_fpsText = new Text();
			_fpsText.x = _width - 31;
			
			_suspensionScreen = new Shape();
			
			frame = new Rectangle(0, 0, _width, _height);
			sprite = new BitmapData(_width, _height, true, 0);
			
			canvas = sprite;
			_display = new Bitmap(canvas);
		}
		
		override protected function render():void
		{
			canvas.fillRect(frame, _color);
			
			super.render();
		}
		
		public function start(stage:Stage, container:DisplayObjectContainer = null):void
		{
			if (!_started)
			{
				Game.stage = stage;
				_started = false;
				
				input = new Input(stage);
				
				stage.addEventListener(Event.ENTER_FRAME, onStageEnterFrame);
				stage.addEventListener(Event.DEACTIVATE, onStageDeactivate);
				stage.addEventListener(Event.ACTIVATE, onStageActivate);
				
				if (container)
				{
					container.addChild(_display);
				}
				else
				{
					stage.addChild(_display);
				}
			}
		}
		
		public function stop():void
		{
			if (_started)
			{
				_started = true;
				
				stage.removeEventListener(Event.ENTER_FRAME, onStageEnterFrame);
				stage.removeEventListener(Event.DEACTIVATE, onStageDeactivate);
				stage.removeEventListener(Event.ACTIVATE, onStageActivate);
				
				_display.parent.removeChild(_display);
			}
		}
		
		private function onStageEnterFrame(event:Event):void
		{
			now = getTimer();
			elapsed = now - early;
			time = elapsed / 1000;
			early = now;
			
			if (!_started)
			{
				if (!_ready)
				{
					// TODO: initialize first frame
					_ready = true;
				}
				else if (!_suspend)
				{
					update();
					render();
				}
				
				input.update();
			}
			
			if (_showFps)
			{
				++_fpsTicks;
				_fpsThreshold += elapsed;
				if (_fpsThreshold > 1000)
				{
					_fps = _fpsTicks;
					_fpsTicks = 0;
					_fpsThreshold -= 1000;
					
					_fpsText.text = _fps + "fps";
					
					// TODO: Find a better way to render the FPS
					hideFps();
					showFps();
				}
			}
		}
		
		private function onStageDeactivate(event:Event):void
		{
			if (!_suspend)
			{
				_suspend = true;
				
				_suspensionScreen.graphics.clear();
				_suspensionScreen.graphics.beginFill(0, 0.8);
				_suspensionScreen.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				_suspensionScreen.graphics.endFill();
				
				stage.addChild(_suspensionScreen);
			}
		}
		
		private function onStageActivate(event:Event):void
		{
			if (_suspend)
			{
				_suspend = false;
				
				stage.removeChild(_suspensionScreen);
			}
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