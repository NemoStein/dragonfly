package nemostein.framework.dragonfly
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import nemostein.framework.dragonfly.modules.io.Input;
	
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
		static public var camera:Rectangle;
		
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
			
		}
	}
}