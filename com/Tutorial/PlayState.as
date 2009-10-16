package com.Tutorial
{
	import com.adamatomic.flixel.*;
	
	public class PlayState extends FlxState
	{
		[Embed(source = '../../data/Tiles.png')] private var ImgTiles:Class;
		[Embed(source = '../../data/map.txt', mimeType = "application/octet-stream")] private var DataMap:Class;
		[Embed(source = '../../data/map2.txt', mimeType = "application/octet-stream")] private var DataMap2:Class;
		[Embed(source = '../../data/map3.txt', mimeType = "application/octet-stream")] private var DataMap3:Class;
		[Embed(source = '../../data/map4.txt', mimeType = "application/octet-stream")] private var DataMap4:Class;
		[Embed(source = '../../data/backgroundTiles.png')] private var ImgBackground:Class;
		[Embed(source = '../../data/health.png')] private var ImgHearts:Class;
		[Embed(source = '../../data/cursor.png')] private var ImgCursor:Class;	
	    
		private var _p:Player;
		private var _g:FlxSprite;
		private var _goal:FlxSprite;
		private var _goals:FlxArray;
		private var _map:FlxTilemap;
		private var _back:FlxTilemap;
		private var _e:FlxArray;
		private var _pStars:FlxArray;
		private var _eStars:FlxArray
		private var _scoreDisplay:FlxText;
		private var _hearts:FlxArray;
		private var _spawners:FlxArray;
		public var _e_count:int;
		public var _maps:FlxArray;
		public var _level:uint = 0;
		public var _old_level:uint = 0;
		private var _k:uint = 0;

		
		public static var lyrStage:FlxLayer;
		public static var lyrSprites:FlxLayer;
		public static var lyrHUD:FlxLayer;
		
		public function PlayState():void
		{
			
			super();
						
			lyrStage = new FlxLayer;
			lyrSprites = new FlxLayer;
			lyrHUD = new FlxLayer;
			
			_scoreDisplay = new FlxText(FlxG.width - 50, 2, 48, 40, FlxG.score.toString(), 0xFFFFFFFF, null, 16, "right");
			_scoreDisplay.scrollFactor.x = _scoreDisplay.scrollFactor.y = 0
			lyrHUD.add(_scoreDisplay);
			
			_pStars = new FlxArray;
			for (var n:int = 0; n < 40; n++)
			{
				_pStars.add(lyrSprites.add(new NinjaStar(0, 0, 0, 0)));
			}

			_eStars = new FlxArray;
			for (var en:int = 0; en < 40; en++)
			{
				_eStars.add(lyrSprites.add(new NinjaStar(0, 0, 0, 0)));
			}
			
			_p = new Player(48, 448, _pStars);
			lyrSprites.add(_p);

			_goals = new FlxArray;
			_goals.add(new Goal(560, 64))
			_goals.add(new Goal(624, 400));
			_goals.add(new Goal(463, 304));
			_goals.add(new Goal(48, 80));
			_goals.add(new Goal(520, 112));
			lyrStage.add(_goals[_level]);

			_hearts = new FlxArray();
			var tmpH:FlxSprite
			for (var hCount:Number = 0; hCount < _p._max_health; hCount++)
			{
				tmpH = new FlxSprite(ImgHearts, 2 + (hCount * 10), 2, true, false);
				tmpH.scrollFactor.x = tmpH.scrollFactor.y = 0
				tmpH.addAnimation("on", [0]);
				tmpH.addAnimation("off", [1]);
				tmpH.play("on");
				_hearts.add(lyrHUD.add(tmpH));
			}
			
			_e = new FlxArray;
			_e.add(lyrSprites.add(new Enemy(432, 320, _p, _eStars)));
			
			_spawners = new FlxArray;
			_spawners.add(new Spawner(432, 304, _e, _p, _eStars));
			_spawners.add(new Spawner(432, 320, _e, _p, _eStars));
			_spawners.add(new Spawner(656, 496, _e, _p, _eStars));
			_spawners.add(new Spawner(208, 224, _e, _p, _eStars));			
			_spawners.add(new Spawner(432, 320, _e, _p, _eStars));
			lyrStage.add(_spawners[_level])

			
			FlxG.follow(_p,2.5);
			FlxG.followAdjust(0.5, 0.5);
			FlxG.followBounds(1,1,640-1,480-1);
			
			_maps = new FlxArray;
			_maps.add(new FlxTilemap(new DataMap, ImgTiles, 1));
			_maps.add(new FlxTilemap(new DataMap2, ImgTiles, 1));
			_maps.add(new FlxTilemap(new DataMap3, ImgBackground, 1));
			_maps.add(new FlxTilemap(new DataMap4, ImgBackground, 1));
			_maps.add(new FlxTilemap(new DataMap2, ImgTiles, 1));			

			_map = _maps[_level];
			lyrStage.add(_maps[_level]);
			
			this.add(lyrStage);
			this.add(lyrSprites);
			this.add(lyrHUD);
			FlxG.setCursor(ImgCursor);
		}
		
		override public function update():void
		{
			var _old_health:uint = _p.health;
			var _old_score:uint = FlxG.score;		
			super.update();
			_map.collide(_p);
			
			if (_goals[_level].overlapsPoint(_p.x, _p.y))
			{
				if (_level < _maps.length - 1)
				{ 
					_level += 1;
					FlxG.score += 10;
				}
				else
				{
					FlxG.flash(0xFFFFFFFF, 0.75);
					FlxG.fade(0xFF000000, 1, win);
				}
			}
			
			FlxG.collideArray2(_map, _e);
			FlxG.overlapArray(_e, _p, EnemyHit);
			
			FlxG.collideArray2(_map, _pStars);
			FlxG.overlapArrays(_pStars, _e, StarHitEnemy);
			
			FlxG.collideArray2(_map, _eStars);
			FlxG.overlapArray(_eStars, _p, StarHitPlayer)
			
			//Konami Code :D
			if (FlxG.kUp)
				if (_k <= 0 || _k == 1) _k++;
			if (FlxG.kDown)
				if (_k == 2 || _k == 3) _k++;
			if (FlxG.kLeft)
				if (_k == 4 || _k == 6) _k++;
			if (FlxG.kRight)
				if (_k == 5 || _k == 7) _k++;
			if (FlxG.kB)
				if (_k == 8) _k++;
			if (FlxG.kA)
				if(_k == 9) _k++;
			if (_k == 10)
			{
				_p.health = 10;
				_k = 0;
				trace('life = ' + _p.health); 
				trace('yay!');
			}		
			
			if (_p.health != _old_health)
			{
				for (var i:Number = 0; i < _p._max_health; i++)
				{
					if (i >= _p.health)
						_hearts[i].play("off");
					else
						_hearts[i].play("on");
				}
			}
			
			if(_p.dead)
			{
				FlxG.score = 0;

/*				if (FlxG.kong)
				{
					FlxG.kong.API.stats.submitArray
					([
						{name:"Score", value:FlxG.score},
						{name:"Body Count", value:1}
					])
				}
*/							
				FlxG.switchState(DeathState);
			}
			if(_old_score != FlxG.score)
			{
				_scoreDisplay.setText(FlxG.score.toString());
			}
			if (_old_level != _level)
			{
				FlxG.flash(0xFFFFFFFF, 0.75);
				lyrStage.destroy();
				_map = _maps[_level];
				_p.x = 48;
				_p.y = 448;
				_e.clear();
				lyrStage.add(_goals[_level]);
				lyrStage.add(_maps[_level]);
				lyrStage.add(_spawners[_level]);
			}
			_old_level = _level;
		}
		
		private function StarHitPlayer(colStar:FlxSprite, P:Player):void
		{
			if (P._hurt_counter <= 0)
			{
				if (colStar.x > P.x)
				{
					P.velocity.x = -100;
				}
				else
				{
					P.velocity.x = 100
				}
				P.hurt(1);
				colStar.kill();
			}
		}
		private function EnemyHit(E:Enemy, P:Player):void
		{
			FlxG.log(P._hurt_counter.toString());
			if(P._hurt_counter <= 0)
			{
				if (E.x > P.x)
				{
					P.velocity.x = -100
					E.velocity.x = 100;
				}
				else
				{
					P.velocity.x = 100;
					E.velocity.x = -100
				}
				P.hurt(1);
			}
		}
		private function StarHitEnemy(colStar:FlxSprite, colEnemy:FlxSprite):void
		{
			colStar.kill();
			colEnemy.hurt(1);
		}
		private function win():void
		{
			FlxG.score = 0;
			FlxG.switchState(MenuState);
		}
		
	}
}