package sourbit.library.dragonfly.modules.particles.helpers.graphics
{
	import flash.display.BitmapData;
	import sourbit.library.dragonfly.modules.particles.helpers.Graphic;
	
	public class SquareGraphic implements Graphic
	{
		private var _bitmapData:BitmapData;
		
		public function SquareGraphic(side:Number = 10, color:uint = 0xffffdc00)
		{
			_bitmapData = new BitmapData(side, side, true, color);
		}
		
		public function get data():BitmapData
		{
			return _bitmapData;
		}
	}
}