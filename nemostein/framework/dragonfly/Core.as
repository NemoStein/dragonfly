package nemostein.framework.dragonfly
{
	import flash.display.BitmapData;
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
	}
}