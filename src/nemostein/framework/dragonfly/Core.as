package nemostein.framework.dragonfly
{
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
		
		private var _parent:Core;
		private var _children:Vector.<Core>; // TODO: Use a linked list
		private var _childrenCount:int;
		
		public function Core()
		{
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
			_children = new <Core>[];
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
	}
}