package org.Tutorial
{
	import org.flixel.*;
	public class Goal extends FlxSprite
	{
		[Embed(source = '../../data/goal.png')] private var ImgGoal:Class;
	
		public function Goal(X:Number, Y:Number)
		{
			super(ImgGoal, X, Y, true, true);
		}
	}
}	