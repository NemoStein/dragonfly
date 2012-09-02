package nemostein.framework.dragonfly.plugins.particles.helpers.graphics
{
	import flash.display.BitmapData;
	import nemostein.framework.dragonfly.plugins.particles.helpers.Graphic;
	
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