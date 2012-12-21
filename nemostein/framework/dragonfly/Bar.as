package nemostein.framework.dragonfly
{
	
	public class Bar extends Entity
	{
		private var _content:Entity;
		private var _getValueCallback:Function;
		private var _getMaxValueCallback:Function;
		private var _vertical:Boolean;
		private var _reverse:Boolean;
		
		private var _length:Number;
		private var _initialLocaltion:Number;
		
		public function Bar(content:Entity, getValueCallback:Function, getMaxValueCallback:Function, vertical:Boolean = false, reverse:Boolean = false)
		{
			_content = content;
			_getValueCallback = getValueCallback;
			_getMaxValueCallback = getMaxValueCallback;
			_vertical = vertical;
			_reverse = reverse;
			
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			if (!_vertical)
			{
				_length = _content.width;
				_initialLocaltion = _content.x;
			}
			else
			{
				_length = _content.height;
				_initialLocaltion = _content.y;
			}
			
			add(_content);
		}
		
		override protected function update():void
		{
			super.update();
			
			var length:int = _getValueCallback() / _getMaxValueCallback() * _length;
			
			if (!_vertical)
			{
				_content.width = length;
				
				if (_reverse)
				{
					_content.x = _initialLocaltion + (_length - length);
				}
			}
			else
			{
				_content.height = length;
				
				if (!_reverse)
				{
					_content.y = _initialLocaltion + (_length - length);
				}
			}
		}
	}
}