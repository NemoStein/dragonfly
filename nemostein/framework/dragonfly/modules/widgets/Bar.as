package nemostein.framework.dragonfly.modules.widgets
{
	import nemostein.framework.dragonfly.modules.container.entity.Entity;
	import nemostein.utils.ErrorUtils;
	
	public class Bar extends Entity
	{
		private var _getValueCallback:Function;
		private var _getMaxValueCallback:Function;
		private var _vertical:Boolean;
		private var _reverse:Boolean;
		private var _x:Number;
		private var _y:Number;
		
		public function Bar(getValueCallback:Function, getMaxValueCallback:Function, vertical:Boolean = false, reverse:Boolean = false)
		{
			_getValueCallback = getValueCallback;
			_getMaxValueCallback = getMaxValueCallback;
			_vertical = vertical;
			_reverse = reverse;
			
			super();
		}
		
		override protected function update():void
		{
			super.update();
			
			var totalLength:Number = getLength();
			var length:int = _getValueCallback() / _getMaxValueCallback() * totalLength;
			
			if (!_vertical)
			{
				width = length;
				
				if (_reverse)
				{
					super.x = _x + (totalLength - length);
				}
				else
				{
					super.x = _x;
				}
				
				super.y = _y;
			}
			else
			{
				height = length;
				
				if (!_reverse)
				{
					super.y = _y + (totalLength - length);
				}
				else
				{
					super.y = _y;
				}
				
				super.x = _x;
			}
		}
		
		protected function getLength():Number
		{
			throw ErrorUtils.abstractMethod(this, "Bar", "getLength");
		}
		
		override public function get x():Number
		{
			return _x;
		}
		
		override public function set x(value:Number):void
		{
			_x = value;
		}
		
		override public function get y():Number
		{
			return _y;
		}
		
		override public function set y(value:Number):void
		{
			_y = value;
		}
	}
}