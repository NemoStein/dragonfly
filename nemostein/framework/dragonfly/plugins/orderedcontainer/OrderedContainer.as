package nemostein.framework.dragonfly.plugins.orderedcontainer
{
	import flash.display.BitmapData;
	import nemostein.framework.dragonfly.Container;
	import nemostein.framework.dragonfly.Core;
	
	public class OrderedContainer extends Container
	{
		public function OrderedContainer(contents:BitmapData = null)
		{
			super(contents);
		}
		
		override protected function update():void 
		{
			quickInsertionSort(children, 0, childrenCount - 1);
			
			super.update();
		}
		
		private function quickInsertionSort(children:Vector.<Core>, left:int, right:int):void 
		{
			var i:int = left;
			var j:int = right;
			var core:Core = children[(left + right) >> 1];
			
			while (i <= j)
			{
				while (children[i].y < core.y)
				{
					++i;
				}
				
				while (children[j].y > core.y)
				{
					--j;
				}
				
				if (i <= j)
				{
					var temp:Core = children[i];
					children[i] = children[j];
					children[j] = temp;
					
					++i;
					--j;
				}
			}
			
			if(right - left < 20)
			{
				for (i = left; i < right; ++i) 
				{
					core = children[i];
					j = i;
					
					while (j > left && children[i - 1].y > core.y)
					{
						children[j] = children[j - 1];
						--j;
					}
					
					children[j] = core;
				}
			}
			else
			{
				if (left < j)
				{
					quickInsertionSort(children, left, j);
				}
				
				if (i < right)
				{
					quickInsertionSort(children, i, right);
				}
			}
		}
	}
}