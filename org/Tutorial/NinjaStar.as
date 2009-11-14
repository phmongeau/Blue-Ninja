package org.Invader
{
	import org.flixel.*;
	
	public class Bullet extends FlxSprite
	{
		[Embed (source = '../../data/bullet.png')] private var ImgBullet:Class;
				
		public function Bullet(X:Number, Y:Number, XVelocity:Number, YVelocity:Number):void
		{
			super(ImgBullet, X, Y, true, true);
			//Movements and speeds
			maxVelocity.x = 200;
			maxVelocity.y = 200;
			//bounding box tweaks
			width = 3;
			height = 10;
			offset.x = 4;
			offset.y = 11;
			//Animations
			addAnimation("normal", [0, 1]);
			_sparks = FlxG.state.add(new FlxEmitter(0, 0, 0, 0, null, -0.1, -150, 150, -200, 0, -720, 720, 400, 0, ImgSpark, 10, true, PlayState.lyrSprites)) as FlxEmitter;
			facing = true;
			exists = false;
		}
		
		override public function hitFloor():Boolean
		{
			kill();
			return super.hitFloor();
		}
		override public function hitWall():Boolean
		{
			kill();
			return super.hitWall();
		}
		override public function hitCeiling():Boolean
		{
			kill();
			return super.hitCeiling();
		}
		
		override public function kill():void
		{
			if(dead)
				return;
			_sparks.x = x + 5;
			_sparks.y = y +5;
			_sparks.reset();
			super.kill();
		}
		public function reset(X:Number, Y:Number, XVelocity:Number, YVelocity:Number):void
		{
			x = X;
			y = Y + 7;
			dead = false;
			exists = true;
			visible = true;
			velocity.x = XVelocity;
			play("normal");
		}
	}
}