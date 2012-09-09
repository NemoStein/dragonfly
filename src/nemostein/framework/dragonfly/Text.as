package nemostein.framework.dragonfly
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Text extends Core
	{
		private var _textField:TextField;
		private var _offsetMatrix:Matrix;
		
		public function Text(string:String = "")
		{
			text = string;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.defaultTextFormat = new TextFormat("Lead II", 8, 0xffffff);
			_textField.cacheAsBitmap = true;
			
			_offsetMatrix = new Matrix();
			_offsetMatrix.translate(-1, -3);
		}
		
		public function get text():String
		{
			return _textField.text;
		}
		
		public function set text(value:String):void
		{
			_textField.text = value;
			
			var fieldWidth:Number = _textField.textWidth;
			var fieldHeight:Number = _textField.textHeight - 1;
			
			if(fieldWidth <= 0 || fieldHeight <= 0)
			{
				visible = false;
			}
			else
			{
				visible = true;
				
				if (fieldWidth != frame.width || fieldHeight != frame.height)
				{
					sprite && sprite.dispose();
					
					frame = new Rectangle(0, 0, fieldWidth, fieldHeight);
					sprite = new BitmapData(fieldWidth, fieldHeight, true, 0);
					sprite.draw(_textField, _offsetMatrix);
				}
				else
				{
					sprite.fillRect(frame, 0);
					sprite.draw(_textField, _offsetMatrix);
				}
			}
		}
	}
}
