package nemostein.framework.dragonfly.plugins.particles.helpers.numerics
{
	import nemostein.framework.dragonfly.plugins.particles.helpers.Numeric;
	
	public class NumericRange implements Numeric
	{
		private var _from:Number;
		private var _to:Number;
		
		public function NumericRange(from:Number, to:Number)
		{
			_from = from;
			_to = to;
		}
		
		public function get value():Number
		{
			return Math.random() * (_from - _to) + _to;
		}
	}
}