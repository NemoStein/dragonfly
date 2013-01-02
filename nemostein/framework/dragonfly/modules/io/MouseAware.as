package nemostein.framework.dragonfly.modules.io
{
	import flash.geom.Point;
	
	public interface MouseAware 
	{
		function onMouseDown(key:int, mouse:Point):Boolean
		function onMouseUp(key:int, mouse:Point):Boolean
	}
}