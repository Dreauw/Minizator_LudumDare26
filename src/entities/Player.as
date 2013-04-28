package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.FlickerTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import utils.Assets;
	import utils.gui.Bar;
	import utils.WorldBase;
	import worlds.WorldBonus;
	import worlds.WorldGame;
	import utils.SyParticle;
	import utils.Audio;
	import worlds.WorldTitle;

	public class Player extends Character {
		private const SPEED:int = 20;
		private var speedX:Number = 0;
		private var speedY:Number = 0;
		private var jumpHigh:Number = 0;
		private var mapWidth:uint = 0;
		private var mapHeight:uint = 0;
		private var img:Spritemap;
		private var reloadTimer:Number = 0;
		private var mode2:Boolean = false;
		private var lifeMax:uint = 5;
		private var life:uint = 0;
		private var lifeBar:Bar;
		private var invTimer:Number = 0;
		private var tw:FlickerTween;
		
		public function Player(x:Number, y:Number, mapWidth:uint, mapHeight:uint) {
			super(x, y - 4);
			this.mapWidth = mapWidth;
		    this.mapHeight = mapHeight;
			img = new Spritemap(Assets.PLAYER, 17, 19);
			img.add("stand", [0]);
			img.add("stand2", [3]);
			img.add("walk", [0, 1, 0, 2], 10);
			img.add("walk2", [3, 4, 3, 5], 8);
			img.play("stand");
			graphic = img;
			mask = new Hitbox(12, 16);
			img.x = width / 2;
			img.y = height / 2 - 1;
			img.centerOrigin();
			layer = 2;
			type = "player";
			life = lifeMax;
			lifeBar = new Bar(x, y, 13, 2, 0xCC0000);
			lifeBar.min = false;
			tw = new FlickerTween(resetAlpha);
			Input.define("Jump", Key.UP, Key.W);
			Input.define("Left", Key.LEFT, Key.A);
			Input.define("Right", Key.RIGHT, Key.D);
			Audio.registerSound("damage", "3,,0.0355,,0.1444,0.3305,,-0.3767,,,,,,,,,,,1,,,0.034,,0.3");
			Audio.registerSound("shoot", "0,,0.1957,0.111,0.3367,0.8164,0.0483,-0.4213,,,,,,0.351,0.065,,,,1,,,0.0499,,0.3");
		}
		
		override public function die():void {
			super.die();
			world.remove(this);
			if (world is WorldBonus) {
				(world as WorldBonus).switchWorld(WorldTitle);
			} else {
				(world as WorldGame).reloadLevel();
			}
		}
		
		public function resetAlpha() : void {
			tw.alpha = 1;
			img.alpha = 1;
		}
		
		override public function added():void {
			super.added();
			lifeBar.visible = !WorldGame.mView;
			world.add(lifeBar);
			world.addTween(tw);
		}
		
		public function centerCamera() : void {
			FP.camera.x = x - FP.screen.width / (2 * FP.screen.scale);
			FP.camera.y = y - FP.screen.height / (2 * FP.screen.scale);
			if (FP.camera.x < 0) FP.camera.x = 0;
			if (FP.camera.y < 0) FP.camera.y = 0;
			if (x + FP.screen.width / (2 * FP.screen.scale) > mapWidth) FP.camera.x = mapWidth - FP.screen.width / 2;
			if (y + FP.screen.height / (2 * FP.screen.scale) > mapHeight) FP.camera.y = mapHeight - FP.screen.height / 2;
		}
		
		
		public function damage(dam:uint) : void {
			if (invTimer > 0 ) return;
			Audio.playSound("damage");
			if (!mode2) SyParticle.emit("blood", x, y, 5);
			invTimer = 1;
			tw.tween(1, 0.05);
			tw.start();
			life -= 1;
			lifeBar.changeValue(life + 1, lifeMax + 1);
			if (life <= 0) {
				die();
				world.remove(lifeBar);
				world.remove(this);
				world.removeTween(tw);
			}
		}
		
		override public function update():void {
			super.update();
			if (WorldGame.mView != mode2) {
				mode2 = WorldGame.mView; 
				img.play((mode2 ? "stand2" : "stand"));
			}
			if (!mode2) img.flipped = FP.camera.x + Input.mouseX < x;
			
			reloadTimer -= FP.elapsed;
			if (Input.mouseDown && !mode2 && reloadTimer <= 0) {
				Audio.playSound("shoot");
				var bullet:Bullet = world.create(Bullet) as Bullet;
				SyParticle.emit("ammo", x+5, y+6, 1);
				if (img.flipped) {
					bullet.initialize(x-9, y+6, FP.camera.x+Input.mouseX, FP.camera.y+Input.mouseY);
				} else {
					bullet.initialize(x+15, y+6, FP.camera.x+Input.mouseX, FP.camera.y+Input.mouseY);
				}
				reloadTimer = 0.2;
			}
			if (WorldGame.mView) {
				if (Input.pressed("Jump") && jumpHigh <= 6 && speedY >= -1) {
					speedY = -6;
					jumpHigh += 6;
				}
			} else {
				if (Input.check("Jump") && jumpHigh <= 6 && speedY <= 0) {
					speedY -= 2;
					jumpHigh += 2;
				}
			}
			
			
			if (Input.check("Left")) {
				speedX -= 40 * FP.elapsed;
				if (jumpHigh == 0 && speedY == 0) {
					img.play((mode2 ? "walk2" : "walk"));
					if (!mode2) SyParticle.emit("dust", x, y + height, 1);
				}
				if (mode2) img.flipped = true;
			} else if (Input.check("Right")) {
				speedX += 40 * FP.elapsed;
				if (jumpHigh == 0 && speedY == 0) {
					img.play((mode2 ? "walk2" : "walk"));
					if (!mode2) SyParticle.emit("dust", x, y + height-2, 1);
				}
				if (mode2) img.flipped = false;
			} else {
				speedX = 0;
				img.play((mode2 ? "stand2" : "stand"));
			}
			speedY += SPEED * FP.elapsed;
			if (speedY > 15) speedY = 15;
			if (speedY < -6) speedY = -6;
			if (speedX > 2) speedX = 2;
			if (speedX < -2) speedX = -2;
			moveBy(speedX, speedY, "solid");
			if (x < 0) x = 0;
			if (x + width > mapWidth) x = mapWidth - width;
			lifeBar.x = x-2;
			lifeBar.y = y-11;
			centerCamera();
			img.alpha = tw.alpha;
			invTimer -= FP.elapsed;
			
			if (y > mapHeight + 32) die();
			if (invTimer <= 0 && (collide("zombie", x, y) || collide("zombie_bonus", x, y))) {
				damage(1);
			}
		}
		
		override public function moveCollideY(e:Entity):Boolean {
			if (speedY >= 0) jumpHigh = 0;
			
			if (!e.min || e is SolidTile) {
				if (collideRect(x, y, e.x, e.y, e.width, e.height)) damage(1);
			}
			speedY = 0;
			return super.moveCollideY(e);
		}
		
		override public function moveCollideX(e:Entity):Boolean {
			speedX = 0;
			return super.moveCollideX(e);
		}
	}

}