package nemostein.framework.dragonfly
{
	import flash.display.BitmapData;
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
		
		private var _deferredAnchorAlignment:DeferredAnchorAlignment;
		
		public function Text(string:String = "")
		{
			text = string;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			textField = new TextField();
			textField.cacheAsBitmap = true;
			textField.autoSize = TextFieldAutoSize.LEFT;
			
			offsetMatrix = new Matrix();
			offsetMatrix.translate(-1, -3);
			
			setFormat("Lead II", 8, 0);
		}
		
		public function setFormat(font:String, size:Number, color:uint, align:String = LEFT):void
		{
			textField.defaultTextFormat = new TextFormat(font, size, color, null, null, null, null, null, align);
			
			invalid = true;
		}
		
		public function get text():String
		{
			return textField.text;
		}
		
		public function set text(value:String):void
		{
			textField.text = value;
			
			invalid = true;
		}
		
		override public function alignAnchor(vertical:String, horizontal:String, to:Point = null):void 
		{
			if (_deferredAnchorAlignment)
			{
				_deferredAnchorAlignment.vertical = vertical;
				_deferredAnchorAlignment.horizontal = horizontal;
				_deferredAnchorAlignment.to = to;
			}
			else
			{
				_deferredAnchorAlignment = new DeferredAnchorAlignment(vertical, horizontal, to);
			}
		}
		
		override protected function update():void 
		{
			if (invalid)
			{
				invalid = false;
				
				var fieldWidth:Number = textField.textWidth;
				var fieldHeight:Number = textField.textHeight - 1;
				
				if (fieldWidth <= 0 || fieldHeight <= 0)
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
						sprite.draw(textField, offsetMatrix);
					}
					else
					{
						sprite.fillRect(frame, 0);
						sprite.draw(textField, offsetMatrix);
					}
				}
			}
			
			if (_deferredAnchorAlignment)
			{
				super.alignAnchor(_deferredAnchorAlignment.vertical, _deferredAnchorAlignment.horizontal, _deferredAnchorAlignment.to);
				
				_deferredAnchorAlignment = null;
			}
			
			super.update();
		}
	}
}

import flash.geom.Point;

internal class DeferredAnchorAlignment
{
	public var vertical:String;
	public var horizontal:String;
	public var to:Point;
	
	public function DeferredAnchorAlignment(vertical:String, horizontal:String, to:Point)
	{
		this.vertical = vertical;
		this.horizontal = horizontal;
		this.to = to;
	}
}
