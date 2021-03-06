package sourbit.library.dragonfly.modules.text
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ShadowedText extends Text
	{
		private var _shadowOffset:Point;
		private var _shadowTextField:TextField;
		private var _shadowColor:uint;
		private var _shadowAlpha:Number;
		
		public function ShadowedText(string:String = "", font:String = "Lead III", size:Number = 8, color:uint = 0xffffffff, align:String = LEFT)
		{
			super(string, font, size, color, align);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			_shadowTextField = new TextField();
			_shadowTextField.cacheAsBitmap = true;
			_shadowTextField.autoSize = TextFieldAutoSize.LEFT;
			
			_shadowOffset = new Point();
			setShadow();
		}
		
		public function setShadow(offsetX:Number = -1, offsetY:Number = 1, color:uint = 0xcc000000):void
		{
			_shadowOffset.x = offsetX;
			_shadowOffset.y = offsetY;
			
			_shadowAlpha = (color >> 24 & 0xff) / 0xff;
			_shadowColor = color & 0xffffff;
			
			invalid = true;
		}
		
		override protected function redraw():void 
		{
			super.redraw();
			
			if (visible)
			{
				invalid = false;
				
				var colorTransform:ColorTransform = _shadowTextField.transform.colorTransform;
				colorTransform.alphaMultiplier = _shadowAlpha;
				
				var shadowTextFormat:TextFormat = textField.defaultTextFormat;
				shadowTextFormat.color = _shadowColor;
				
				_shadowTextField.defaultTextFormat = shadowTextFormat;
				_shadowTextField.transform.colorTransform = colorTransform;
				_shadowTextField.text = textField.text;
				
				var absoluteShadowOffsetX:Number = _shadowOffset.x < 0 ? -_shadowOffset.x : _shadowOffset.x;
				var absoluteShadowOffsetY:Number = _shadowOffset.y < 0 ? -_shadowOffset.y : _shadowOffset.y;
				
				var textOffsetMatrix:Matrix = offsetMatrix.clone();
				var shadowOffsetMatrix:Matrix = offsetMatrix.clone();
				
				if (_shadowOffset.x < 0)
				{
					textOffsetMatrix.tx += absoluteShadowOffsetX;
				}
				else
				{
					shadowOffsetMatrix.tx += absoluteShadowOffsetX;
				}
				
				if (_shadowOffset.y < 0)
				{
					textOffsetMatrix.ty += absoluteShadowOffsetY;
				}
				else
				{
					shadowOffsetMatrix.ty += absoluteShadowOffsetY;
				}
				
				var fieldWidth:Number = absoluteShadowOffsetX + textField.textWidth;
				var fieldHeight:Number = absoluteShadowOffsetY + textField.textHeight - 1;
				
				if(fieldWidth > 0 && fieldHeight > 0)
				{
					if (fieldWidth != frame.width || fieldHeight != frame.height)
					{
						if (sprite)
						{
							sprite.dispose();
						}
						
						frame = new Rectangle(0, 0, fieldWidth, fieldHeight);
						sprite = new BitmapData(fieldWidth, fieldHeight, true, 0);
						sprite.draw(_shadowTextField, shadowOffsetMatrix, _shadowTextField.transform.colorTransform);
						sprite.draw(textField, textOffsetMatrix);
					}
					else
					{
						sprite.fillRect(frame, 0);
						sprite.draw(_shadowTextField, shadowOffsetMatrix, _shadowTextField.transform.colorTransform);
						sprite.draw(textField, textOffsetMatrix);
					}
				}
			}
		}
	}
}