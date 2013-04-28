package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import utils.gui.Bar;
	import utils.SyParticle;
	import net.flashpunk.FP;
	import worlds.WorldGame;
	import utils.Audio;

	public class Boss extends Entity {
		private var img:Spritemap;
		private var life:uint = 170;
		private var phase:uint = 0;
		private var lifeBar:Bar;
		private var reload:Number = 0;
		private var phaseTimer:Number = 3;
		private var posx:Number = 0;
		private var dir:Number = 0;
		public function Boss(x:Number, y:Number) {
			img = new Spritemap(Assets.BOSS, 29, 41);
			img.frame = 0;
			lifeBar = new Bar(0, 0, 50, 5, 0xCC0000);
			lifeBar.x = (FP.screen.width / 2 - lifeBar.width) / 2 - 4;
			lifeBar.y = 16;
			Audio.registerSound("boss", "3,,0.365,0.6038,0.1735,0.091,,-0.263,,,,,,,,,0.0311,-0.253,1,,,,,0.5", false);
			super(x, y, img, new Hitbox(15, 32, 7, 5));
		}
		
		override public function added():void {
			super.added();
			world.add(lifeBar);
		}
		
		override public function update():void {
			super.update();
			var bullet:Bullet = collide("bullet", x, y) as Bullet;
			if (bullet) {
				SyParticle.emit("blood", bullet.x, bullet.y,  1);
				world.recycle(bullet);
				life -= 1;
				lifeBar.changeValue(life, 170);
				if (life <= 0) {
					Audio.playSound("boss");
					world.remove(this);
					SyParticle.emit("brain", x, y, 3);
					SyParticle.emit("blood", x, y, 10);
					SyParticle.emit("bone", x, y, 4);
					SyParticle.emit("bone_flesh", x, y, 4);
					(world as WorldGame).executeTransition((world as WorldGame).nextLevel);
				}
			}
			phaseTimer -= FP.elapsed;
			if (phaseTimer <= 0) {
				phase += 1;
				if (phase == 1) {
					img.frame = 0;
					phaseTimer = 5;
				} else if (phase == 2) {
					img.frame = 1;
					phaseTimer = 5;
				}  else if (phase == 3) {
					img.frame = 0;
					phaseTimer = 5;
				}  else if (phase > 3) {
					phase = 1;
					img.frame = 0;
					phaseTimer = 5;
				}
			}
			
			reload -= FP.elapsed;
			if (reload <= 0) {
				if (phase == 1) {
					var xs:Number = -FP.rand(40);
					for (var xx:uint = 0; xx < 9; xx++) {
						var bull:Bullet =  world.create(Bullet) as Bullet;
						bull.initialize(x + width / 2+5, y + height, xs + xx * 60 - 50, FP.screen.height / 2, "spider_bullet");
						bull.speed = 2;
						world.add(bull);
					}
					reload = 0.5;
				} else if (phase == 2) {
					posx += dir;
					if (posx < 8) dir = 40;
					if (posx > FP.screen.width/2-8) dir = -40;
					var bul:Bullet =  world.create(Bullet) as Bullet;
					bul.initialize(x + width / 2+5, y + height, posx, FP.screen.height / 2, "spider_bullet");
					bul.speed = 2;
					world.add(bul);
					bul =  world.create(Bullet) as Bullet;
					bul.initialize(x + width / 2+5, y + height, FP.screen.width/2-posx, FP.screen.height / 2, "spider_bullet");
					bul.speed = 2;
					world.add(bul);
					reload = 0.2;
				} else if (phase == 3) {
					var player:Player = (world as WorldGame).player;
					var bu:Bullet = world.create(Bullet) as Bullet;
					bu.initialize(x + 8, y + 20, player.x, player.y, "spider_bullet");
					bu.speed = 2;
					world.add(bu);
					reload = 0.5;
				}
			}
		}
		
	}

}