package nemostein.framework.dragonfly
{
	import flash.geom.Point;
	
	public class Container extends Core
	{
		static private var _zero:Point = new Point();
		
		private var _parent:Container;
		private var _children:Vector.<Container>; // TODO: Use a linked list
		private var _childrenCount:int;
		
		override protected function initialize():void
		{
			super.initialize();
			
			_children = new <Container>[];
		}
		
		/**
		 * Add a child to the current object
		 *
		 * @param	child
		 */
		public function add(child:Container):void
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
				var child:Container = _children[i];
				child.addedToGame();
			}
		}
		
		/**
		 * Removes a child to the current object
		 *
		 * @param	child
		 */
		public function remove(child:Container):void
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
				var child:Container = _children[i];
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
		public function getChildAt(index:int):Container
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
		public function getChildById(id:String):Container
		{
			for (var i:int = 0; i < _childrenCount; ++i)
			{
				var child:Container = _children[i];
				if (child.id == id)
				{
					return child;
				}
			}
			
			return null;
		}
		
		/**
		 * The parent of the current object
		 */
		public final function get parent():Container
		{
			return _parent;
		}
		
		/**
		 * The children that the current object have
		 */
		protected function get children():Vector.<Container>
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
				var child:Container = _children[i];
				
				count += child.descendentCount;
			}
			
			return count;
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
			for (var i:int = 0; i < _childrenCount; ++i)
			{
				var child:Container = _children[i];
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
			for (var i:int = 0; i < _childrenCount; ++i)
			{
				var child:Container = _children[i];
				if (child.visible)
				{
					child.render();
				}
			}
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
			else if (_parent)
			{
				return _parent.game;
			}
			else
			{
				return null;
			}
		}
	}
}