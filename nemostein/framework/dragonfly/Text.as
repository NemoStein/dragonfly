package nemostein.framework.dragonfly
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Text extends Entity
	{
		static public const LEFT:String = TextFormatAlign.LEFT;
		static public const CENTER:String = TextFormatAlign.CENTER;
		static public const RIGHT:String = TextFormatAlign.RIGHT;
		static public const JUSTIFY:String = TextFormatAlign.JUSTIFY;
		
		protected var invalid:Boolean;
		protected var textField:TextField;
		protected var offsetMatrix:Matrix;
		
		private var _deferredAlignment:Boolean;
		private var _deferredAlignmentVertical:String;
		private var _deferredAlignmentHorizontal:String;
		private var _deferredAlignmentTo:Point;
		
		private var _text:String;
		private var _font:String;
		private var _size:Number;
		private var _color:uint;
		private var _alpha:Number;
		private var _align:String;
		
		public function Text(string:String = "", font:String = "Lead III", size:Number = 8, color:uint = 0xffffffff, align:String = LEFT)
		{
			_text = string;
			_font = font;
			_size = size;
			_color = color;
			_align = align;
			
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			textField = new TextField();
			textField.cacheAsBitmap = true;
			textField.autoSize = TextFieldAutoSize.LEFT;
			
			offsetMatrix = new Matrix();
			offsetMatrix.translate(-1, -3);
			
			setFormat(_font, _size, _color, _align);
		}
		
		public function setFormat(font:String, size:Number, color:uint, align:String = LEFT):void
		{
			_font = font;
			_size = size;
			_alpha = (color >> 24 & 0xff) / 0xff;
			_color = color & 0xffffff;
			_align = align;
			
			invalid = true;
		}
		
		override public function alignAnchor(vertical:String, horizontal:String, to:Point = null):void 
		{
			_deferredAlignment = true;
			_deferredAlignmentVertical = vertical;
			_deferredAlignmentHorizontal = horizontal;
			_deferredAlignmentTo = to;
		}
		
		override protected function update():void 
		{
			if (invalid)
			{
				invalid = false;
				redraw();
			}
			
			if (_deferredAlignment)
			{
				super.alignAnchor(_deferredAlignmentVertical, _deferredAlignmentHorizontal, _deferredAlignmentTo);
				
				_deferredAlignment = false;
			}
			
			super.update();
		}
		
		protected function redraw():void 
		{
			if (!_text)
			{
				visible = false;
			}
			else
			{
				visible = true;
				
				var colorTransform:ColorTransform = new ColorTransform(1, 1, 1, _alpha);
				
				textField.defaultTextFormat = new TextFormat(_font, _size, _color, null, null, null, null, null, _align);
				textField.text = _text;
				
				var fieldWidth:Number = textField.textWidth;
				var fieldHeight:Number = textField.textHeight - 1;
				
				if (fieldWidth != frame.width || fieldHeight != frame.height)
				{
					sprite && sprite.dispose();
					
					frame = new Rectangle(0, 0, fieldWidth, fieldHeight);
					sprite = new BitmapData(fieldWidth, fieldHeight, true, 0);
					sprite.draw(textField, offsetMatrix, colorTransform);
				}
				else
				{
					sprite.fillRect(frame, 0);
					sprite.draw(textField, offsetMatrix, colorTransform);
				}
			}
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			_text = value;
			invalid = true;
		}
		
		public function get font():String 
		{
			return _font;
		}
		
		public function set font(value:String):void 
		{
			_font = value;
			setFormat(value, _size, _color, _align);
		}
		
		public function get size():Number 
		{
			return _size;
		}
		
		public function set size(value:Number):void 
		{
			_size = value;
			setFormat(_font, value, _color, _align);
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
		public function set color(value:uint):void 
		{
			_color = value;
			setFormat(_font, _size, value, _align);
		}
		
		public function get align():String 
		{
			return _align;
		}
		
		public function set align(value:String):void 
		{
			_align = value;
			setFormat(_font, _size, _color, value);
		}
	}
}