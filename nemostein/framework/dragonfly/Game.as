package nemostein.framework.dragonfly
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import nemostein.framework.dragonfly.io.MouseAware;
	import nemostein.framework.dragonfly.io.Input;
	
	public class Game extends Container
	{
		/**
		 * [read-only]
		 */
		static public var stage:Stage;
		
		private var _started:Boolean;
		private var _suspend:Boolean;
		
		private var _fps:Number;
		private var _fpsTicks:int;
		private var _fpsThreshold:int;
		private var _fpsThresholdLimit:int;
		private var _fpsText:Text;
		private var _showFps:Boolean;
		
		private var _suspensionScreen:Shape;
		private var _display:Bitmap;
		private var _width:int;
		private var _height:int;
		private var _color:uint;
		private var _redrawArea:Rectangle;
		
		private var _contents:Container;
		private var _cursor:Entity;
		private var _defaultCursor:Boolean;
		private var _following:Entity;
		
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
			
			_contents = new Container();
			super.add(_contents);
			
			_fpsThresholdLimit = 333;
			_fpsText = new Text();
			_fpsText.setParallax(0, 0);
			_fpsText.x = 1;
			
			_suspensionScreen = new Shape();
			
			bounds = new Rectangle(0, 0, _width, _height);
			camera = new Rectangle(0, 0, _width, _height);
			
			_redrawArea = new Rectangle(0, 0, _width, _height);
			canvas = new BitmapData(_width, _height, true, 0);
			_display = new Bitmap(canvas);
			
			now = getTimer();
			elapsed = 0;
			time = 0;
			early = now;
		}
		
		public function start(stage:Stage, container:DisplayObjectContainer = null):void
		{
			if (!_started)
			{
				Game.stage = stage;
				_started = false;
				
				input = new Input(this);
				
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
				if (!_suspend)
				{
					if (_cursor)
					{
						_cursor.x = stage.mouseX + camera.x;
						_cursor.y = stage.mouseY + camera.y;
					}
					
					update();
					render();
				}
				
				input.update();
			}
			
			if (_showFps)
			{
				++_fpsTicks;
				_fpsThreshold += elapsed;
				if (_fpsThreshold > _fpsThresholdLimit)
				{
					_fps = int(_fpsTicks / _fpsThresholdLimit * 1000 + 0.5);
					_fpsTicks = 0;
					_fpsThreshold -= _fpsThresholdLimit;
					
					_fpsText.text = _fps + "fps\r" + (System.totalMemory / 1024 / 1024).toFixed(2) + "Mbps - (" + (System.freeMemory / 1024 / 1024).toFixed(2) + ")" + "\r" + descendentCount + " descendents";
				}
			}
		}
		
		override protected function update():void
		{
			if (_following)
			{
				var cameraDistanceX:Number = _following.x - camera.x - camera.width / 2;
				var cameraDistanceY:Number = _following.y - camera.y - camera.height / 2;
				
				if (cameraDistanceX || cameraDistanceY)
				{
					// TODO: Ajust the camera ease
					camera.x += cameraDistanceX / 10;
					camera.y += cameraDistanceY / 10;
				}
			}
			
			super.update();
			
			if (camera.x < bounds.x)
			{
				camera.x = bounds.x;
			}
			else if (camera.x + camera.width > bounds.x + bounds.width)
			{
				camera.x = bounds.x + bounds.width - camera.width;
			}
			
			if (camera.y < bounds.y)
			{
				camera.y = bounds.y;
			}
			else if (camera.y + camera.height > bounds.y + bounds.height)
			{
				camera.y = bounds.y + bounds.height - camera.height;
			}
		}
		
		override protected function render():void
		{
			canvas.lock();
			canvas.fillRect(_redrawArea, _color);
			
			super.render();
			canvas.unlock();
		}
		
		override public function add(child:Container):void
		{
			_contents.add(child);
		}
		
		override public function remove(child:Container):void
		{
			_contents.remove(child);
		}
		
		override public function getChildAt(index:int):Container
		{
			return _contents.getChildAt(index);
		}
		
		override public function getChildById(id:String):Container
		{
			return _contents.getChildById(id);
		}
		
		override public function get childrenCount():int
		{
			return _contents.childrenCount;
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
				
				hideCustomCursor();
				
				stage.addChild(_suspensionScreen);
			}
		}
		
		private function onStageActivate(event:Event):void
		{
			if (_suspend)
			{
				_suspend = false;
				
				showCustomCursor();
				
				stage.removeChild(_suspensionScreen);
			}
		}
		
		public function changeCursor(entity:Entity = null):void
		{
			if (_cursor)
			{
				remove(_cursor);
			}
			
			_cursor = entity;
			_defaultCursor = !_cursor;
			
			if (_defaultCursor)
			{
				hideCustomCursor();
			}
			else
			{
				showCustomCursor();
			}
		}
		
		private function showCustomCursor():void
		{
			if (_cursor)
			{
				Mouse.hide();
				super.add(_cursor);
			}
		}
		
		private function hideCustomCursor():void 
		{
			if (_cursor)
			{
				super.remove(_cursor);
				Mouse.show();
			}
		}
		
		public function follow(entity:Entity):void
		{
			_following = entity;
		}
		
		public function stopFollowing():void
		{
			_following = null;
		}
		
		public function cameraLookAt(targetX:Number, targetY:Number):void
		{
			camera.x = targetX - camera.width / 2;
			camera.y = targetY - camera.height / 2;
			
			if (camera.x < bounds.x)
			{
				camera.x = bounds.x;
			}
			else if (camera.x + camera.width > bounds.x + bounds.width)
			{
				camera.x = bounds.x + bounds.width - camera.width;
			}
			
			if (camera.y < bounds.y)
			{
				camera.y = bounds.y;
			}
			else if (camera.y + camera.height > bounds.y + bounds.height)
			{
				camera.y = bounds.y + bounds.height - camera.height;
			}
		}
		
		public function showFps():void
		{
			_showFps = true;
			
			super.add(_fpsText);
		}
		
		public function hideFps():void
		{
			_showFps = false;
			
			super.remove(_fpsText);
		}
		
		public function signalMouseDown(key:int, mouse:Point):void
		{
			propagateMouseSignal(this, key, mouse, true);
		}
		
		public function signalMouseUp(key:int, mouse:Point):void
		{
			propagateMouseSignal(this, key, mouse, false);
		}
		
		private function propagateMouseSignal(entity:Container, key:int, mouse:Point, down:Boolean):Boolean
		{
			var chain:Boolean = true;
			
			for (var i:int = entity.childrenCount - 1; i >= 0; --i)
			{
				var child:Container = entity.getChildAt(i);
				if (child.active && child.visible)
				{
					chain = propagateMouseSignal(child, key, mouse, down);
					
					if (!chain)
					{
						return false;
					}
				}
			}
			
			var aware:MouseAware = entity as MouseAware;
			if (aware)
			{
				if (down)
				{
					chain = aware.onMouseDown(key, mouse);
				}
				else
				{
					chain = aware.onMouseUp(key, mouse);
				}
			}
			
			return chain;
		}
		
		public function get gameBounds():Rectangle
		{
			return bounds.clone();
		}
		
		public function get cursor():Entity 
		{
			return _cursor;
		}
	}
}