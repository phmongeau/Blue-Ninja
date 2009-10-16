package
{
	import com.adamatomic.flixel.*;
	import com.Tutorial.MenuState;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass = "Preloader")]
		
	public class Tutorial extends FlxGame
	{
		public function Tutorial():void
		{
			super(320, 220, MenuState, 2, 0xff000000, true, 0xffffffff);
			help("Jump", "Shoot", "Nothing");
		}
	}
}