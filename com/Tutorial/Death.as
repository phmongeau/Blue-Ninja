package com.Tutorial
{
	import com.adamatomic.flixel.*;
	
	public class MenuState extends FlxState
	{
		override public function MenuState():void
		{
			this.add(new FlxText(0, (FlxG.width/2) - 80, FlxG.width, 80, "Game Over", 0xFFFFFFFF, null, 16, "center")) as FlxText;
			this.add(new FlxText(0, FlxG.height - 24, FlxG.width, 8, "Press X to Restart", 0xFFFFFFFF, null, 8, "center"));
		}
		
		private function onFade():void
		{
			FlxG.switchState(PlayState);
		}
		
		override public function update():void
		{
			if (FlxG.kA)
			{
				FlxG.flash(0xFFFFFFFF, 0.75);
				FlxG.fade(0xFF000000, 1, onFade);
			}
			super.update();
		}
	}
}