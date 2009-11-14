package org.Tutorial
{
	import org.flixel.*;
	
	public class Grapple extends FlxSprite
	{
		[Embed (source = '../../data/grapple.png')] private var ImgGrapple:Class;
		[Embed (source = '../../data/rope.png')] private var ImgRope:Class;
		
		public function Grapple(X:Number, Y:Number, XVelocity:Number, YVelocity:Number):void
		{
			super(ImgGrapple, X, Y, true, true);
			trace('created');
			
			//Movements and speeds
			maxVelocity.x = 200;
			maxVelocity.y = 200;
			//bounding box tweaks
			width = 5;
			height = 5;
			offset.x = 6;
			offset.y = 6;
			//Animation
			addAnimation("normal", [0]);
			facing = true;
			exists = false;
			
			velocity.x = XVelocity;
			velocity.y = YVelocity;
			trace('speed x =' + velocity.x)
			
		}
		override public function hitFloor():Boolean
		{
			velocity.x = 0;
			velocity. y = 0;
			return super.hitFloor();
			trace('hit');
		}
		override public function hitWall():Boolean
		{
			velocity.x = 0;
			velocity. y = 0;
			return super.hitWall();
			trace('hit');			
		}
		override public function hitCeiling():Boolean
		{
			velocity.x = 0;
			velocity. y = 0;
			return super.hitCeiling();
			trace('hit');
		}
		
	}
}