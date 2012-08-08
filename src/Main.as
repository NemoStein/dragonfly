package
{
	import flash.display.Sprite;
	import nemostein.Game;
	
	public class Main extends Sprite
	{
		public function Main():void
		{
			var game:Game = new Game();
			game.start(stage);
		}
	}
}