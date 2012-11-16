package nemostein.framework.dragonfly
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Entity extends Container
	{
		
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
		 * Tells if the object's position is relative to it's parent or not
		 */
		public var relative:Boolean;
		
		/**
		 * [read-only] The current playing (or last played) animation
		 */
		public var animation:Animation;
		
		private var _animations:Vector.<Animation>;
		private var _flipped:Boolean;
		private var _currentFrame:int;
		
		override protected function initialize():void 
		{
			super.initialize();
			
			frame = new Rectangle();
			anchor = new Point();
			position = new Point();
			canvasPosition = new Point();
			parallax = new Point(1, 1);
			_animations = new Vector.<Animation>();
			
			relative = true;
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
		public function isColliding(entity:Entity):Boolean
		{
			if (entity.active)
			{
				var selfTop:Number = canvasPosition.y;
				var selfLeft:Number = canvasPosition.x;
				var selfBottom:Number = selfTop + height;
				var selfRight:Number = selfLeft + width;
				
				var entityTop:Number = entity.canvasPosition.y;
				var entityLeft:Number = entity.canvasPosition.x;
				var entityBottom:Number = entityTop + entity.height;
				var entityRight:Number = entityLeft + entity.width;
				
				return !(selfTop > entityBottom || selfBottom < entityTop || selfLeft > entityRight || selfRight < entityLeft);
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
		 * Tells if the current object is fliped
		 */
		public function get flipped():Boolean 
		{
			return _flipped;
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
		
		override protected function update():void 
		{
			if (animation)
			{
				animation.update(time);
			}
			
			super.update();
		}
		
		override protected function render():void 
		{
			canvasPosition.x = position.x - anchor.x;
			canvasPosition.y = position.y - anchor.y;
			
			if (relative && parent && parent is Entity)
			{
				var parentEntity:Entity = parent as Entity;
				
				canvasPosition.x += parentEntity.canvasPosition.x + parentEntity.anchor.x;
				canvasPosition.y += parentEntity.canvasPosition.y + parentEntity.anchor.y;
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
			
			super.render();
		}
	}
}