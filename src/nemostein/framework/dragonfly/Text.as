package nemostein.framework.dragonfly
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Text extends Core
	{
		private var _textField:TextField;
		
		public function Text()
		{
			
		}
		
		override protected function initialize():void
		{
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.defaultTextFormat = new TextFormat("Lead II", 8);
			_textField.cacheAsBitmap = true;
			
			super.initialize();
		}
		
		public function get text():String 
		{
			return _textField.text;
		}
		
		public function set text(value:String):void 
		{
			_textField.text = value;
		}
	}
}