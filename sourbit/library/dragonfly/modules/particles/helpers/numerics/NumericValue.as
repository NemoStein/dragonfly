package sourbit.library.dragonfly.modules.particles.helpers.numerics
{
	import sourbit.library.dragonfly.modules.particles.helpers.Numeric;
	
	public class NumericValue implements Numeric
	{
		private var _value:Number;
		
		public function NumericValue(value:Number)
		{
			_value = value;
		}
		
		public function get value():Number
		{
			return _value;
		}
	}
}