package com.Tutorial
{
	import com.adamatomic.flixel.*;
    
	public class Player extends FlxSprite
	{
		[Embed(source='../../data/Player.png')] private var ImgPlayer:Class;
		
		private var _move_speed:int = 400;
		private var _jump_power:int = 800;   
		public var _max_health:int = 10;
		public var _hurt_counter:Number = 0;
		private var _stars:FlxArray;
		private var _attack_counter:Number = 0;
		private var _g:FlxSprite;
		private var _grapple_counter:Number = 0;
		private var _wallHang:Boolean;
		
		public function Player(X:Number,Y:Number, Stars:FlxArray):void
		{
			super(ImgPlayer, X, Y, true, true);//Max speeds
			maxVelocity.x = 200;
			maxVelocity.y = 200;
			//stars
			_stars = Stars;
			//Set the player health
			health = 10;
			//Gravity
			acceleration.y = 420;            
			//Friction
			drag.x = 300;
			//bounding box tweaks
			width = 8;
			height = 14;
			offset.x = 4;
			offset.y = 2;
			addAnimation("normal", [0, 1, 2, 3], 10);
			addAnimation("jump", [2]);
			addAnimation("attack", [4,5,6],10);
			addAnimation("stopped", [0]);
			addAnimation("hurt", [2,7],10);
			addAnimation("dead", [7, 7, 7], 5);
		}
		
		override public function update():void
		{
		
			if(dead)
			{
			    if(finished) exists = false;
				else
					super.update();				
				return;
			}
			if (_hurt_counter > 0)
			{
				_hurt_counter -= FlxG.elapsed*3;
			}
			if (_attack_counter > 0)
			{
				_attack_counter -= FlxG.elapsed*3
			}
			if (_grapple_counter > 0)
				_grapple_counter -= FlxG.elapsed*3
			
			if(FlxG.kLeft)
			{
				facing = false;
				velocity.x -= _move_speed * FlxG.elapsed;
			}
			else if (FlxG.kRight)
			{
				facing = true;
				velocity.x += _move_speed * FlxG.elapsed;                
			}
			if(_wallHang)
			{
				velocity.y = 0;
				if(FlxG.justPressed(FlxG.A))
				{
					velocity.y = -_jump_power;
					if (facing)
						velocity.x -= _move_speed;
					else
						velocity.x += _move_speed; 
				}
			}
			else if(FlxG.justPressed(FlxG.A) && velocity.y == 0)
			{
				velocity.y = -_jump_power;
			}
			if(FlxG.justPressed(FlxG.B) && _attack_counter <= 0)
			{
				_attack_counter = 1;
				play("attack");
				throwStar(facing);
			}
			if(FlxG.kMouse && _grapple_counter == 0)
			{
				_grapple_counter = 1;
				play("jump");
				throwGrapple();
			}
			//Animations
			if (_hurt_counter > 0)
			{
				play("hurt");
			}
			else if (_attack_counter > 0)
			{
				play("attack");
			}
			else if (_grapple_counter > 0)
				play('jump');
			else            
			{
				if (velocity.y != 0)
				{
					play("jump");
				}
				else
				{
					if (velocity.x == 0)
					{
						play("stopped");
					}
					else
					{
						play("normal");
					}
				}
			}
			_wallHang = false;
			super.update();
		}
		
		override public function hitWall():Boolean
		{
			if (velocity.y != 0)
			{
				_wallHang = true;
				trace('hung')
			}
			return super.hitWall();
		}
		
		override public function hitFloor():Boolean
		{
			_wallHang = false;
			return super.hitFloor();
		}

		
		override public function hurt(Damage:Number):void
		{
			_hurt_counter = 1;
			return super.hurt(Damage);
		}
		private function throwStar(dir:Boolean):void
		{
			var XVelocity:Number;
			
			if (dir) XVelocity = 200;
			else XVelocity = -200;
			
			for (var i:uint = 0; i < _stars.length; i++)
			{
				if (!_stars[i].exists)
				{
					_stars[i].reset(x, y + 2, XVelocity, 0);
					return;
				}
			}
			var star:NinjaStar = new NinjaStar(x, y + 2, XVelocity, 0);
			star.reset(x, y, XVelocity, 0);
			_stars.add(PlayState.lyrSprites.add(star));		 
		}
		private function throwGrapple():void
		{
			var XVelocity:int = (FlxG.mouse.x - x)/2;
			var YVelocity:int = (FlxG.mouse.y - y)/2;
			
			trace('throw');
			
			var grapple:Grapple = new Grapple(x, y, XVelocity, YVelocity);
			PlayState.lyrSprites.add(grapple);
		}
	}
}