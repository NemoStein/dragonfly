package sourbit.library.dragonfly.modules.container.entity
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class AlphaEntity extends Entity
	{
		private var _zero:Point;
		private var _alpha:Number;
		private var _alphaBitmapData:BitmapData;
		private var _invalid:Boolean;
		
		override protected function initialize():void
		{
			super.initialize();
			
			_alpha = 1;
			_zero = new Point();
			_invalid = true;
		}
		
		override protected function render():void
		{
			if (_invalid)
			{
				_invalid = false;
				_alphaBitmapData.fillRect(_alphaBitmapData.rect, (0xff * _alpha) << 24);
				//_alphaBitmapData = new BitmapData(frame.width, frame.height, true, (0xff * _alpha) << 24);
			}
			
			super.render();
		}
		
		override protected function drawPixels():void
		{
			canvas.copyPixels(sprite, frame, canvasPosition, _alphaBitmapData, _zero, true);
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			_invalid = true;
			_alpha = value > 1 ? 1 : value < 0 ? 0 : value;
		}
		
		override public function set width(value:Number):void
		{
			_invalid = true;
			super.width = value;
		}
		
		override public function set height(value:Number):void
		{
			_invalid = true;
			super.height = value;
		}
	}
}