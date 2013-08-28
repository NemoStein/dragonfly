package sourbit.library.dragonfly.modules.particles.helpers.tests
{
	import sourbit.library.dragonfly.plugins.particles.helpers.Test;
	import sourbit.library.dragonfly.plugins.particles.Particle;
	
	public class NumericTest extends Test
	{
		private var _greaterThanList:Vector.<Number>;
		private var _greaterThanOrEqualToList:Vector.<Number>;
		private var _equalToList:Vector.<Number>;
		private var _notEqualToList:Vector.<Number>;
		private var _lessThanList:Vector.<Number>;
		private var _lessThanOrEqualToList:Vector.<Number>;
		
		private var _greaterThanCount:int;
		private var _greaterThanOrEqualToCount:int;
		private var _equalToCount:int;
		private var _notEqualToCount:int;
		private var _lessThanCount:int;
		private var _lessThanOrEqualToCount:int;
		
		public function NumericTest(action:Function)
		{
			super(action);
			
			_greaterThanList = new <Number>[];
			_greaterThanOrEqualToList = new <Number>[];
			_equalToList = new <Number>[];
			_notEqualToList = new <Number>[];
			_lessThanList = new <Number>[];
			_lessThanOrEqualToList = new <Number>[];
		}
		
		public function greaterThan(value:Number):NumericTest
		{
			_greaterThanList.push(value);
			++_greaterThanCount;
			
			return this;
		}
		
		public function greaterThanOrEqualTo(value:Number):NumericTest
		{
			_greaterThanOrEqualToList.push(value);
			++_greaterThanOrEqualToCount;
			
			return this;
		}
		
		public function equalTo(value:Number):NumericTest
		{
			_equalToList.push(value);
			++_equalToCount;
			
			return this;
		}
		
		public function notEqualTo(value:Number):NumericTest
		{
			_notEqualToList.push(value);
			++_notEqualToCount;
			
			return this;
		}
		
		public function lessThan(value:Number):NumericTest
		{
			_lessThanList.push(value);
			++_lessThanCount;
			
			return this;
		}
		
		public function lessThanOrEqualTo(value:Number):NumericTest
		{
			_lessThanOrEqualToList.push(value);
			++_lessThanOrEqualToCount;
			
			return this;
		}
		
		public function testValue(particle:Particle, value:Number):void
		{
			if (action)
			{
				var i:int;
				var against:Number;
				
				for (i = 0; i < _greaterThanCount; ++i)
				{
					against = _greaterThanList[i];
					
					if (value <= against)
					{
						return;
					}
				}
				
				for (i = 0; i < _greaterThanOrEqualToCount; ++i)
				{
					against = _greaterThanOrEqualToList[i];
					
					if (value < against)
					{
						return;
					}
				}
				
				for (i = 0; i < _equalToCount; ++i)
				{
					against = _equalToList[i];
					
					if (value != against)
					{
						return;
					}
				}
				
				for (i = 0; i < _notEqualToCount; ++i)
				{
					against = _notEqualToList[i];
					
					if (value == against)
					{
						return;
					}
				}
				
				for (i = 0; i < _lessThanCount; ++i)
				{
					against = _lessThanList[i];
					
					if (value >= against)
					{
						return;
					}
				}
				
				for (i = 0; i < _lessThanOrEqualToCount; ++i)
				{
					against = _lessThanOrEqualToList[i];
					
					if (value > against)
					{
						return;
					}
				}
				
				action(particle);
			}
		}
	}
}