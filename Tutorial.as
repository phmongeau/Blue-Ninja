package
{
	import org.flixel.*;
	import org.Tutorial.MenuState;
	[SWF(width="640", height="480", backgroundColor="#32353A")]
	[Frame(factoryClass = "Preloader")]
		
	public class Tutorial extends FlxGame
	{
		public function Tutorial():void
		{
			super(320, 240, MenuState, 2, 0x464646, true, 0xffffffff);
			help("Jump", "Shoot", "Nothing");
		}
	}
}