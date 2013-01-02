package nemostein.framework.dragonfly.modules.container
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import nemostein.framework.dragonfly.Container;
	import nemostein.framework.dragonfly.Core;
	
	public class OrderedContainer extends Container
	{
		override protected function update():void 
		{
			if(childrenCount)
			{
				quickInsertionSort(children, 0, childrenCount - 1);
			}
			
			super.update();
		}
		
		private function quickInsertionSort(children:Vector.<Container>, left:int, right:int):void 
		{
			//var i:int = left;
			//var j:int = right;
			//var core:Container = children[(left + right) >> 1];
			//
			//while (i <= j)
			//{
				//while (children[i].y < core.y)
				//{
					//++i;
				//}
				//
				//while (children[j].y > core.y)
				//{
					//--j;
				//}
				//
				//if (i <= j)
				//{
					//var temp:Container = children[i];
					//children[i] = children[j];
					//children[j] = temp;
					//
					//++i;
					//--j;
				//}
			//}
			//
			//if(right - left < 20)
			//{
				//for (i = left; i < right; ++i) 
				//{
					//core = children[i];
					//j = i;
					//
					//while (j > left && children[i - 1].y > core.y)
					//{
						//children[j] = children[j - 1];
						//--j;
					//}
					//
					//children[j] = core;
				//}
			//}
			//else
			//{
				//if (left < j)
				//{
					//quickInsertionSort(children, left, j);
				//}
				//
				//if (i < right)
				//{
					//quickInsertionSort(children, i, right);
				//}
			//}
		}
	}
}