/*
package entities {
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.FP;
	import utils.Assets;

	public class Bullet extends Entity{
		protected var duration :Number = 2;
		protected var speed:Number = 4;
		public function Bullet() {
			super(0, 0, new Image(Assets.BULLET), new Hitbox(4, 4));
			type = "bullet";
		}
		
		public function initialize(x:Number, y:Number, speed:Number = 4) : void {
			duration = 2;
			this.speed = speed;
			(graphic as Image).flipped = speed < 0;
			this.x = x;
			this.y = y;
		}
		
		override public function update():void {
			super.update();
			moveBy(speed, 0, "solid");
			duration -= FP.elapsed;
			if (duration <= 0) {
				world.recycle(this)
				return;
			}
			
			var zombie:Zombie = collide("zombie", x, y) as Zombie;
			if (zombie) {
				zombie.damage(1);
				world.recycle(this)
			}
			
		}
		
		override public function moveCollideX(e:Entity):Boolean {
			world.recycle(this);
			return super.moveCollideX(e);
		}
		
		override public function moveCollideY(e:Entity):Boolean {
			world.recycle(this);
			return super.moveCollideY(e);
		}
		
	}

}
*/



package entities {
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.FP;
	import utils.Assets;
	import flash.filters.GlowFilter;
	import utils.SyParticle;

	public class Bullet extends Entity{
		private var dir:Point;
		protected var duration :Number = 2;
		public var speed:Number = 5;
		public function Bullet() {
			super(0, 0, new Image(Assets.BULLET), new Hitbox(4, 4));
			(graphic as Image).filters = [new GlowFilter(0xC66709)]
			type = "bullet";
		}
		
		public function initialize(x:Number, y:Number, targetX:Number, targetY:Number, type:String = "bullet") : void {
			this.type = type;
			duration = 2;
			this.x = x;
			this.y = y;
			this.dir = new Point(targetX - x, targetY - y);
		}
		
		public function destroy() : void {
			SyParticle.emit("bullet", x, y, 5);
			world.recycle(this);
		}
		
		override public function update():void {
			super.update();
			if (dir) {
				dir.normalize(speed);
				moveBy(dir.x, dir.y, "solid");
				duration -= FP.elapsed;
				if (duration <= 0) {
					destroy();
					return;
				}
			}
			if (type == "bullet") {
				var zombie:Zombie = collide("zombie", x, y) as Zombie;
				if (zombie) {
					zombie.damage(1);
					world.recycle(this);
				}
				var zombieb:ZombieBonus = collide("zombie_bonus", x, y) as ZombieBonus;
				if (zombieb) {
					zombieb.damage(1);
					world.recycle(this);
				}
				var spider:Spider = collide("spider", x, y) as Spider;
				if (spider) {
					spider.damage(1);
					world.recycle(this);
				}
			} else {
				var player:Player = collide("player", x, y) as Player;
				if (player) {
					player.damage(1);
					world.recycle(this);
				}
			}
			
			
		}
		
		override public function moveCollideX(e:Entity):Boolean {
			destroy();
			return super.moveCollideX(e);
		}
		
		override public function moveCollideY(e:Entity):Boolean {
			destroy();
			return super.moveCollideY(e);
		}
		
	}

}
