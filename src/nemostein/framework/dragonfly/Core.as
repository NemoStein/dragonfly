package nemostein.framework.dragonfly
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The highest (and most abstract) class that can be used in the framework
	 * Every other class that goes to the main stage are descendents of this one
	 */
	public class Core
	{
		/**
		 * [read-only] The time (in ms) of the current frame
		 */
		protected static var now:int;
		
		/**
		 * [read-only] The time (in ms) that passed between the current frame and the last one
		 */
		protected static var early:int;
		
		/**
		 * [read-only] The time (in ms) of the last frame
		 */
		protected static var elapsed:int;
		
		/**
		 * [read-only] The canvas where the current object will be drawn
		 */
		protected static var canvas:BitmapData;
		
		/**
		 * The sprite of the current object that will be drawn on cavas
		 */
		protected var sprite:BitmapData;
		
		/**
		 * The width and height of the current object and its position in the sprite
		 */
		protected var frame:Rectangle;
		
		/**
		 * The achor point (offset) of the current object
		 */
		protected var achor:Point;
		
		/**
		 * The position of the current object relative to it's parent
		 */
		protected var position:Point;
		
		/**
		 * The position of the current object in the canvas
		 */
		protected var canvasPosition:Point;
		
		/**
		 * The angle (z-axis) that the current object is looking to
		 */
		protected var rotation:Number;
		
		/**
		 * The id of the current object
		 * Can be any string or null
		 */
		public var id:String;
		
		/**
		 * [read-only] Tells if the object is active (and can be updated) or not
		 */
		public var active:Boolean;
		
		/**
		 * [read-only] Tells if the object is visible (and can be rendered) or not
		 */
		public var visible:Boolean;
		
		/**
		 * Tells if the object's position and rotation is relative to it's parent or not
		 */
		public var relative:Boolean;
		
		/**
		 * Tells if the children of the current object have a relative position and rotation or not
		 */
		public var relativeChildren:Boolean;
		
		private var _parent:Core;
		private var _children:Vector.<Core>; // TODO: Use a linked list
		private var _childrenCount:int;
		
		public function Core(contents:BitmapData = null)
		{
			if (contents)
			{
				draw(contents, true);
			}
			
			initialize();
		}
		
		/**
		 * Initializes the object with default values and any neccessary aditional data
		 *
		 * note: always call super when overriding
		 */
		protected function initialize():void
		{
			active = true;
			visible = true;
			
			_children = new <Core>[];
			
			if (!frame)
			{
				frame = new Rectangle();
			}
			achor = new Point();
			position = new Point();
			canvasPosition = new Point();
			rotation = 0;
		
			//sprite = new BitmapData(1, 1, true, 0);
		}
		
		/**
		 * Add a child to the current object
		 *
		 * @param	child
		 */
		public final function add(child:Core):void
		{
			child._parent = this;
			_children.push(child);
			++_childrenCount;
		}
		
		/**
		 * Removes a child to the current object
		 *
		 * @param	child
		 */
		public final function remove(child:Core):void
		{
			child._parent = null;
			_children.splice(_children.indexOf(child), 1);
			--_childrenCount;
		}
		
		/**
		 * Return a child Core of the current object specified by the index
		 *
		 * @param	index
		 * @return	a child Core
		 * @throws	RangeError if index is out of bounds (0 > index >= _children)
		 */
		public final function getChildAt(index:int):Core
		{
			return _children[index];
		}
		
		/**
		 * Return a child Core of the current object where the specified id meets
		 * If more than one child have the same id, the first one found will be returned
		 *
		 * @param	id
		 * @return	a child Core or null
		 */
		public final function getChildById(id:String):Core
		{
			for (var i:int = 0; i < _childrenCount; ++i)
			{
				var child:Core = _children[i];
				if (child.id == id)
				{
					return child;
				}
			}
			
			return null;
		}
		
		/**
		 * Draws a BitmapData into the sprite
		 */
		public function draw(data:BitmapData, useSize:Boolean = false):void
		{
			sprite = data.clone();
			
			if (useSize)
			{
				frame = data.rect.clone();
			}
		}
		
		/**
		 * Activate the current object
		 *
		 * note: always call super when overriding
		 */
		public function activate():void
		{
			active = true;
		}
		
		/**
		 * Deactivate the current object
		 *
		 * note: always call super when overriding
		 */
		public function deactivate():void
		{
			active = false;
		}
		
		/**
		 * Shows the current object
		 *
		 * note: always call super when overriding
		 */
		public function show():void
		{
			visible = true;
		}
		
		/**
		 * Hides the current object
		 *
		 * note: always call super when overriding
		 */
		public function hide():void
		{
			visible = false;
		}
		
		/**
		 * Change the achor point alignment of the current object
		 * 
		 * @param	horizontal
		 * @param	vertical
		 * @param	toX
		 * @param	toY
		 */
		public function alignAnchor(horizontal:String, vertical:String, toX:Number = 0, toY:Number = 0):void
		{
			if (horizontal == AnchorAlign.LEFT)
			{
				achor.x = 0;
			}
			else if (horizontal == AnchorAlign.CENTER)
			{
				achor.x = frame.width / 2;
			}
			else if (horizontal == AnchorAlign.RIGHT)
			{
				achor.x = frame.width;
			}
			else if (horizontal == AnchorAlign.CUSTOM)
			{
				achor.x = toX;
			}
			
			if (vertical == AnchorAlign.TOP)
			{
				achor.y = 0;
			}
			else if (vertical == AnchorAlign.CENTER)
			{
				achor.y = frame.height / 2;
			}
			else if (vertical == AnchorAlign.BOTTOM)
			{
				achor.y = frame.height;
			}
			else if (vertical == AnchorAlign.CUSTOM)
			{
				achor.y = toY;
			}
		}
		
		/**
		 * Update the current object and calls the update method in each children
		 *
		 * note: always call super when overriding
		 * Calling super at the start of the override will cause the children to be updated before after the current object
		 * This can have undesired effects (e.g.: the child can access old and invalid data of the current object)
		 */
		protected function update():void
		{
			if (parent && (relative || parent.relativeChildren))
			{
				canvasPosition.x = position.x + parent.canvasPosition.x - achor.x;
				canvasPosition.y = position.y + parent.canvasPosition.y - achor.y;
			}
			else
			{
				canvasPosition.x = position.x - achor.x;
				canvasPosition.y = position.y - achor.y;
			}
			
			for (var i:int = 0; i < _childrenCount; ++i)
			{
				var child:Core = _children[i];
				if (child.active)
				{
					child.update();
				}
			}
		}
		
		/**
		 * Render the current object and calls the render method in each children
		 *
		 * note: always call super when overriding
		 * Calling super at the start of the override will cause the children to be draw below the current object
		 * This can have undesired effects (e.g.: the child can be hidden below the current object)
		 */
		protected function render():void
		{
			if (sprite && frame)
			{
				if (rotation != 0)
				{
					var matrix:Matrix = new Matrix();
					
					var halfWidth:Number = frame.width / 2;
					var halfHeight:Number = frame.height / 2;
					
					matrix.translate(-halfWidth, -halfHeight);
					matrix.rotate(rotation);
					matrix.translate(canvasPosition.x + halfWidth, canvasPosition.y + halfHeight);
					
					canvas.draw(sprite, matrix, null, null, null, true);
				}
				else
				{
					canvas.copyPixels(sprite, frame, canvasPosition, null, null, true);
				}
			}
			
			for (var i:int = 0; i < _childrenCount; ++i)
			{
				var child:Core = _children[i];
				if (child.visible)
				{
					child.render();
				}
			}
		}
		
		/**
		 * The parent of the current object
		 */
		public final function get parent():Core
		{
			return _parent;
		}
		
		/**
		 * The total number of children that the current object have
		 */
		public final function get childrenCount():int
		{
			return _childrenCount;
		}
		
		/**
		 * Gets the x postion of the current object in the canvas
		 */
		public function get x():Number
		{
			return position.x;
		}
		
		/**
		 * Sets the x postion of the current object in the canvas
		 */
		public function set x(value:Number):void
		{
			position.x = value;
		}
		
		/**
		 * Gets the y postion of the current object in the canvas
		 */
		public function get y():Number
		{
			return position.y;
		}
		
		/**
		 * Sets the y postion of the current object in the canvas
		 */
		public function set y(value:Number):void
		{
			position.y = value;
		}
		
		/**
		 * Gets the angle (z-axis) that the current object is looking to
		 */
		public function get angle():Number
		{
			return rotation;
		}
		
		/**
		 * Sets the angle (z-axis) that the current object is looking to
		 */
		public function set angle(value:Number):void
		{
			rotation = value;
		}
		
		/**
		 * Gets the width of the current object
		 */
		public function get width():Number
		{
			return frame.width;
		}
		
		/**
		 * Gets the height of the current object
		 */
		public function get height():Number
		{
			return frame.height;
		}
	}
}