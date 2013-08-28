package sourbit.library.dragonfly.modules.uihelper 
{
	import sourbit.library.dragonfly.modules.text.ShadowedText;
	
	public class ScreenTitle extends ShadowedText 
	{
		private var _label:String;
		
		public function ScreenTitle(label:String) 
		{
			_label = label;
			
			super();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			text = _label;
			
			x = 10;
			y = 10;
		}
	}
}