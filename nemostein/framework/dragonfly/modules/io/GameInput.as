package nemostein.framework.dragonfly.modules.io
{
	import flash.events.MouseEvent;
	import nemostein.framework.dragonfly.Game;
	import sourbit.library.io.Input;
	import sourbit.library.io.Keys;
	
	public class GameInput extends Input
	{
		private var _game:Game;
		
		public function GameInput(game:Game)
		{
			super(Game.stage);
			
			_game = game;
		}
		
		override protected function onLeftMouseDown(event:MouseEvent):void
		{
			super.onLeftMouseDown(event);
			_game.signalMouseDown(Keys.LEFT_MOUSE, leftMouseDown);
		}
		
		override protected function onLeftMouseUp(event:MouseEvent):void
		{
			super.onLeftMouseUp(event);
			_game.signalMouseUp(Keys.LEFT_MOUSE, leftMouseUp);
		}
		
		override protected function onRightMouseDown(event:MouseEvent):void
		{
			super.onRightMouseDown(event);
			_game.signalMouseDown(Keys.RIGHT_MOUSE, rightMouseDown);
		}
		
		override protected function onRightMouseUp(event:MouseEvent):void
		{
			super.onRightMouseUp(event);
			_game.signalMouseUp(Keys.RIGHT_MOUSE, rightMouseUp);
		}
		
		override protected function onMiddleMouseDown(event:MouseEvent):void
		{
			super.onMiddleMouseDown(event);
			_game.signalMouseDown(Keys.MIDDLE_MOUSE, middleMouseDown);
		}
		
		override protected function onMiddleMouseUp(event:MouseEvent):void
		{
			super.onMiddleMouseUp(event);
			_game.signalMouseUp(Keys.MIDDLE_MOUSE, middleMouseUp);
		}
	}
}