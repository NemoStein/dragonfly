package nemostein.framework.dragonfly.modules.particles.helpers.numerics
{
	import nemostein.framework.dragonfly.plugins.particles.helpers.Numeric;
	
	public class NumericVariance implements Numeric
	{
		private var _value:Number;
		private var _variance:Number;
		
		public function NumericVariance(value:Number, variance:Number)
		{
			_variance = variance;
			_value = value;
		}
		
		public function get value():Number
		{
			return _value + (Math.random() * _variance - _variance / 2);
		}
	}
}