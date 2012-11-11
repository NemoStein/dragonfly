package nemostein.framework.dragonfly
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import nemostein.framework.dragonfly.io.Input;
	
	/**
	 * The highest (and most abstract) class that can be used in the framework
	 * Every other class that goes to the main stage are descendents of this one
	 */
	public class Core
	{
		/**
		 * [read-only] The time (in ms) of the current frame
		 */
		static public var now:int;
		
		/**
		 * [read-only] The time (in ms) that passed between the current frame and the last one
		 */
		static public var early:int;
		
		/**
		 * [read-only] The time (in ms) of the last frame
		 */
		static public var elapsed:int;
		
		/**
		 * [read-only] The time (in s) of the last frame
		 */
		static public var time:Number;
		
		/**
		 * [read-only] The canvas where the current object will be drawn
		 */
		static protected var canvas:BitmapData;
		
		/**
		 * [read-only] The camera
		 */
		static protected var camera:Rectangle;
		
		/**
		 * [read-only] The bounds of the camera
		 */
		static protected var bounds:Rectangle;
		
		/**
		 * [read-only] The global input
		 */
		static protected var input:Input;
		
		/**
		 * The sprite of the current object that will be drawn on cavas
		 */
		protected var sprite:BitmapData;
		
		/**
		 * The width and height of the current object and its position in the sprite
		 */
		protected var frame:Rectangle;
		
		/**
		 * The anchor point (offset) of the current object
		 */
		protected var anchor:Point;
		
		/**
		 * How much parallax the current object have (related to the camera)
		 * Relative objects aren't affected by this
		 */
		protected var parallax:Point;
		
		/**
		 * The position of the current object relative to the canvas
		 */
		protected var canvasPosition:Point;
		
		/**
		 * The position of the current object relative to it's parent
		 */
		protected var position:Point;
		
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
		 * [read-only] The current playing (or last played) animation
		 */
		public var animation:Animation;
		
		static private var _zero:Point = new Point();
		
		private var _parent:Core;
		private var _children:Vector.<Core>; // TODO: Use a linked list
		private var _childrenCount:int;
		private var _animations:Vector.<Animation>;
		private var _colorTransform:ColorTransform;
		private var _flipped:Boolean;
		private var _currentFrame:int;
		
		public function Core()
		{
			create();
		}
		
		/**
		 * Creates the Core object with essential values
		 */
		private function create():void
		{
			active = true;
			visible = true;
			
			_children = new <Core>[];
			
			frame = new Rectangle();
			anchor = new Point();
			position = new Point();
			canvasPosition = new Point();
			parallax = new Point(1, 1);
			_animations = new Vector.<Animation>();
			_colorTransform = new ColorTransform(1, 1, 1, 1);
			
			relative = true;
			
			initialize();
		}
		
		/**
		 * Initializes the object with default values and any neccessary aditional data
		 *
		 * note: always call super when overriding
		 */
		protected function initialize():void
		{
		
		}
		
		/**
		 * Add a child to the current object
		 *
		 * @param	child
		 */
		public function add(child:Core):void
		{
			if (child._parent)
			{
				child._parent.remove(child);
			}
			
			child._parent = this;
			child.added();
			_children.push(child);
			++_childrenCount;
		}
		
		/**
		 * Called when the current object is added into another
		 */
		protected function added():void
		{
			if (game)
			{
				addedToGame();
			}
		}
		
		/**
		 * Called when the current object is added into the game
		 */
		protected function addedToGame():void
		{
			for (var i:int = 0; i < _childrenCount; ++i)
			{
				var child:Core = _children[i];
				child.addedToGame();
			}
		}
		
		/**
		 * Removes a child to the current object
		 *
		 * @param	child
		 */
		public function remove(child:Core):void
		{
			var fromGame:Boolean = Boolean(game);
			
			child._parent = null;
			child.removed();
			if (fromGame)
			{
				child.removedfromGame();
			}
			_children.splice(_children.indexOf(child), 1);
			--_childrenCount;
		}
		
		/**
		 * Called when the current object is removed from another
		 */
		protected function removed():void
		{
		
		}
		
		/**
		 * Called when the current object is removed from the game
		 */
		protected function removedfromGame():void
		{
			for (var i:int = 0; i < _childrenCount; ++i)
			{
				var child:Core = _children[i];
				child.removedfromGame();
			}
		}
		
		/**
		 * Return a child Core of the current object specified by the index
		 *
		 * @param	index
		 * @return	a child Core
		 * @throws	RangeError if index is out of bounds (0 > index >= _children)
		 */
		public function getChildAt(index:int):Core
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
		public function getChildById(id:String):Core
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
		public function draw(data:BitmapData, width:int = -1, height:int = -1, canFlip:Boolean = false):void
		{
			sprite = data.clone();
			
			if (canFlip)
			{
				var bitmapData:BitmapData = new BitmapData(sprite.width << 1, sprite.height, true, 0);
				bitmapData.draw(sprite);
				
				var matrix:Matrix = new Matrix();
				matrix.scale(-1, 1);
				matrix.translate(bitmapData.width, 0);
				
				bitmapData.draw(sprite, matrix);
				
				sprite = bitmapData;
			}
			
			frame.x = 0;
			frame.y = 0;
			
			if (width == -1)
			{
				frame.width = data.width;
			}
			else
			{
				frame.width = width;
				
			}
			
			if (height == -1)
			{
				frame.height = data.height;
			}
			else
			{
				frame.height = height;
			}
		}
		
		/**
		 * Draws a rectangle into the sprite
		 */
		public function drawRectangle(width:Number, height:Number, color:uint):void
		{
			draw(new BitmapData(width, height, true, color), width, height);
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
		 * Calls hide() and deactivate() in the current object
		 *
		 * note: always call super when overriding
		 */
		public function die():void
		{
			hide();
			deactivate();
		}
		
		/**
		 * Calls show() and activate() in the current object
		 *
		 * note: always call super when overriding
		 */
		public function revive():void
		{
			show();
			activate();
		}
		
		/**
		 * Attach a new animation to the current object
		 *
		 * @param	id
		 * @param	frames
		 * @param	frameRate
		 * @param	loop
		 * @param	callback	function(animation:Animation, keyframe:int):void
		 * @return
		 */
		public function addAnimation(id:String, frames:Array, frameRate:Number, loop:Boolean = true, callback:Function = null):Animation
		{
			var animation:Animation = new Animation(this, id, frames, frameRate, loop, callback);
			
			_animations.push(animation);
			
			return animation;
		}
		
		/**
		 * Finds a previously attached animation by its ID
		 */
		public function getAnimation(id:String):Animation
		{
			for each (var animation:Animation in _animations)
			{
				if (animation.id == id)
				{
					return animation;
				}
			}
			
			return null;
		}
		
		/**
		 * Plays a previously attached animation
		 */
		public function playAnimation(id:String, reset:Boolean = true, reverse:Boolean = false):void
		{
			var animation:Animation = getAnimation(id);
			if (animation)
			{
				if (reset)
				{
					animation.goToFrame(0, true);
				}
				
				animation.reverse = reverse;
				
				this.animation = animation;
			}
		}
		
		/**
		 * Renders the frame specified by the index
		 */
		public function moveSpriteToFrame(index:int):void
		{
			_currentFrame = index;
			
			if (_flipped)
			{
				frame.x = sprite.width - (index + 1) * frame.width;
			}
			else
			{
				frame.x = index * frame.width;
			}
		}
		
		/**
		 * Change the anchor point alignment of the current object
		 *
		 * @param	horizontal
		 * @param	vertical
		 * @param	to
		 */
		public function alignAnchor(vertical:String, horizontal:String, to:Point = null):void
		{
			if (horizontal == AnchorAlign.LEFT)
			{
				anchor.x = 0;
			}
			else if (horizontal == AnchorAlign.CENTER)
			{
				anchor.x = frame.width / 2;
			}
			else if (horizontal == AnchorAlign.RIGHT)
			{
				anchor.x = frame.width;
			}
			else if (horizontal == AnchorAlign.CUSTOM)
			{
				anchor.x = to.x;
			}
			
			if (vertical == AnchorAlign.TOP)
			{
				anchor.y = 0;
			}
			else if (vertical == AnchorAlign.CENTER)
			{
				anchor.y = frame.height / 2;
			}
			else if (vertical == AnchorAlign.BOTTOM)
			{
				anchor.y = frame.height;
			}
			else if (vertical == AnchorAlign.CUSTOM)
			{
				anchor.y = to.y;
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
			if (animation)
			{
				animation.update(time);
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
			canvasPosition.x = position.x - anchor.x;
			canvasPosition.y = position.y - anchor.y;
			
			if (relative && parent)
			{
				canvasPosition.x += parent.canvasPosition.x + parent.anchor.x;
				canvasPosition.y += parent.canvasPosition.y + parent.anchor.y;
			}
			else
			{
				canvasPosition.x -= parallax.x * camera.x;
				canvasPosition.y -= parallax.y * camera.y;
			}
			
			if (sprite && frame)
			{
				canvas.copyPixels(sprite, frame, canvasPosition, null, null, true);
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
		 * Checks if a point is inside the bounding box of the current object
		 *
		 * @param	point
		 * @return true if point is inside, false otherwise
		 */
		public function isInside(point:Point):Boolean
		{
			return !(canvasPosition.x > point.x || canvasPosition.x + width < point.x || canvasPosition.y > point.y || canvasPosition.y + height < point.y);
		}
		
		/**
		 * Checks if an object's bounding box collides with the bounding box of the current object
		 *
		 * @param	core
		 * @return true if point is inside, false otherwise
		 */
		public function isColliding(core:Core):Boolean
		{
			if (core.active)
			{
				var selfTop:Number = canvasPosition.y;
				var selfLeft:Number = canvasPosition.x;
				var selfBottom:Number = selfTop + height;
				var selfRight:Number = selfLeft + width;
				
				var coreTop:Number = core.canvasPosition.y;
				var coreLeft:Number = core.canvasPosition.x;
				var coreBottom:Number = coreTop + core.height;
				var coreRight:Number = coreLeft + core.width;
				
				return !(selfTop > coreBottom || selfBottom < coreTop || selfLeft > coreRight || selfRight < coreLeft);
			}
			
			return false;
		}
		
		/**
		 * If sprite of the current object can flip, shows fliped version
		 */
		public function flip():void 
		{
			_flipped = !_flipped;
			moveSpriteToFrame(_currentFrame);
		}
		
		/**
		 * The parent of the current object
		 */
		public final function get parent():Core
		{
			return _parent;
		}
		
		/**
		 * The children that the current object have
		 */
		protected function get children():Vector.<Core>
		{
			return _children;
		}
		
		/**
		 * The total number of children that the current object have
		 */
		public function get childrenCount():int
		{
			return _childrenCount;
		}
		
		/**
		 * The total number of children that the current object have
		 */
		public final function get descendentCount():int
		{
			var count:int = _childrenCount;
			
			for (var i:int = 0; i < _childrenCount; ++i)
			{
				var child:Core = _children[i];
				
				count += child.descendentCount;
			}
			
			return count;
		}
		
		/**
		 * Sets the parallax of the current object in each axis
		 */
		public function setParallax(x:Number = 1, y:Number = 1, uncheckRelative:Boolean = true):void
		{
			parallax.x = x;
			parallax.y = y;
			
			if (uncheckRelative)
			{
				relative = false;
			}
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
		 * Gets the width of the current object
		 */
		public function get width():Number
		{
			return frame.width;
		}
		
		/**
		 * Sets the width of the current object
		 */
		public function set width(value:Number):void
		{
			frame.width = value;
		}
		
		/**
		 * Gets the height of the current object
		 */
		public function get height():Number
		{
			return frame.height;
		}
		
		/**
		 * Sets the height of the current object
		 */
		public function set height(value:Number):void
		{
			frame.height = value;
		}
		
		/**
		 * Gets the game instance that the current object was added to
		 */
		public function get game():Game
		{
			if (this is Game)
			{
				return Game(this);
			}
			else if (parent)
			{
				return parent.game;
			}
			else
			{
				return null;
			}
		}
	}
}