package sourbit.library.dragonfly.modules.widgets
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import sourbit.library.dragonfly.modules.container.Container;
	import sourbit.library.dragonfly.modules.container.entity.Entity;
	import nemostein.io.Keys;
	import nemostein.utils.MathUtils;
	
	public class Button extends Entity
	{
		private var _hitArea:Vector.<Point>;
		private var _relativeHitArea:Vector.<Point>;
		
		public var isPressed:Boolean;
		public var isHovered:Boolean;
		
		public var onPress:Function;
		public var onRelease:Function;
		public var onExecute:Function;
		public var onEnter:Function;
		public var onLeave:Function;
		
		/**
		 * The position, width and height of the bounding box representing the hit area
		 */
		protected var hitAreaRect:Rectangle;
		
		/**
		 * A reference to a list of vertices (Points) that draws the hit area.
		 * MUST be ordered clockwise or counter-clockwise (not shuffled) AND convex
		 */
		override protected function initialize():void
		{
			super.initialize();
			
			_relativeHitArea = new <Point>[];
		}
		
		protected function drawHitArea(... vertices:Array):void
		{
			_hitArea = new Vector.<Point>();
			
			var count:int = vertices.length;
			
			var areaTop:Number = Infinity;
			var areaBottom:Number = -Infinity;
			var areaLeft:Number = Infinity;
			var areaRight:Number = -Infinity;
			
			for (var i:int = 0; i < count; i++)
			{
				var vertex:Point = vertices[i];
				
				_hitArea.push(vertex.clone());
				_relativeHitArea.push(vertex.clone());
				
				if (vertex.y < areaTop)
				{
					areaTop = vertex.y;
				}
				
				if (vertex.y > areaBottom)
				{
					areaBottom = vertex.y;
				}
				
				if (vertex.x < areaLeft)
				{
					areaLeft = vertex.x;
				}
				
				if (vertex.x > areaRight)
				{
					areaRight = vertex.x;
				}
			}
			
			hitAreaRect = new Rectangle(areaLeft, areaTop, areaRight - areaLeft, areaBottom - areaTop);
		}
		
		public function pressed(point:Point = null):void
		{
			isPressed = true;
			
			if (onPress)
			{
				switch (onPress.length)
				{
					case 0: 
					{
						onPress();
						break;
					}
					
					case 1: 
					{
						onPress(point);
						break;
					}
				}
			}
		}
		
		public function released(point:Point = null):void
		{
			isPressed = false;
			
			if (onRelease)
			{
				switch (onRelease.length)
				{
					case 0: 
					{
						onRelease();
						break;
					}
					
					case 1: 
					{
						onRelease(point);
						break;
					}
				}
			}
		}
		
		public function executed(point:Point = null):void
		{
			if (onExecute)
			{
				switch (onExecute.length)
				{
					case 0: 
					{
						onExecute();
						break;
					}
					
					case 1: 
					{
						onExecute(point);
						break;
					}
				}
			}
		}
		
		public function entered(point:Point = null):void
		{
			isHovered = true;
			
			if (onEnter)
			{
				switch (onEnter.length)
				{
					case 0: 
					{
						onEnter();
						break;
					}
					
					case 1: 
					{
						onEnter(point);
						break;
					}
				}
			}
		}
		
		public function leaved(point:Point = null):void
		{
			isHovered = false;
			
			if (onLeave)
			{
				switch (onLeave.length)
				{
					case 0: 
					{
						onLeave();
						break;
					}
					
					case 1: 
					{
						onLeave(point);
						break;
					}
				}
			}
		}
		
		override protected function update():void
		{
			var mousePosition:Point = input.mouse;
			var mouseInside:Boolean;
			
			if (_hitArea)
			{
				var count:int = _hitArea.length;
				for (var i:int = 0; i < count; i++)
				{
					var areaVertex:Point = _hitArea[i];
					var relativeVertex:Point = _relativeHitArea[i];
					
					if (relativeVertex)
					{
						relativeVertex.x = areaVertex.x + canvasPosition.x;
						relativeVertex.y = areaVertex.y + canvasPosition.y;
					}
					else
					{
						relativeVertex.x = areaVertex.x;
						relativeVertex.y = areaVertex.y;
					}
				}
				
				mouseInside = MathUtils.isInsidePolygon(_relativeHitArea, mousePosition);
			}
			else
			{
				mouseInside = isInside(mousePosition);
			}
			
			if (!isHovered && mouseInside)
			{
				entered(mousePosition);
			}
			else if (isHovered)
			{
				if (!mouseInside)
				{
					if (isPressed)
					{
						released(mousePosition);
					}
					
					leaved(mousePosition);
				}
				else if (!isPressed && input.justPressed(Keys.LEFT_MOUSE))
				{
					pressed(mousePosition);
				}
				else if (isPressed && input.justReleased(Keys.LEFT_MOUSE))
				{
					executed(mousePosition);
					released(mousePosition);
				}
			}
			
			super.update();
		}
	}
}