package sourbit.library.dragonfly.modules.particles.helpers.graphics
{
	import flash.display.BitmapData;
	import sourbit.library.dragonfly.modules.particles.helpers.Graphic;
	
	public class SpriteGraphic implements Graphic
	{
		private var _bitmapData:BitmapData;
		
		public function SpriteGraphic(bitmapData:BitmapData)
		{
			_bitmapData = bitmapData;
		}
		
		public function get data():BitmapData
		{
			return _bitmapData;
		}
	}
}