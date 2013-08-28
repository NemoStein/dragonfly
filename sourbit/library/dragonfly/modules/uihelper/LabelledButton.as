package sourbit.library.dragonfly.modules.uihelper 
{
	import sourbit.library.dragonfly.modules.text.Text;
	import sourbit.library.dragonfly.modules.widgets.Button;
	
	public class LabelledButton extends Button 
	{
		private var _label:String;
		private var _x:Number;
		private var _y:Number;
		private var _callback:Function;
		
		public function LabelledButton(label:String, x:Number, y:Number, callback:Function)
		{
			_label = label;
			_x = x;
			_y = y;
			_callback = callback;
			
			super();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			drawRectangle(140, 40, Math.random() * 0xffffff + 0xff000000);
			
			var text:Text = new Text(_label);
			
			text.x = 10;
			text.y = 10;
			
			add(text);
			
			x = _x;
			y = _y;
			
			onExecute = _callback;
		}
	}
}