package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import utils.gui.Bar;
	import worlds.WorldBonus;
	import worlds.WorldGame;
	import utils.SyParticle;
	import net.flashpunk.FP;
	import utils.Audio;

	public class ZombieBonus extends Character{
		private var img:Spritemap;
		private var lifeMax:uint = 5;
		private var life:uint;
		private var lifeBar:Bar;
		private var move:Boolean = true;
		public var dir:uint = 1;
		private var speedX:Number = 0;
		private var speedY:Number = 0;
		public function ZombieBonus(x:Number, y:Number, move:Boolean) {
			img = new Spritemap(Assets.ZOMBIE, 13, 27);
			super(x, y - 16, img, new Hitbox(13, 18, 0, 1));
			img.add("stand", [0]);
			img.add("stand2", [3]);
			img.add("walk", [0, 1, 0, 2], 10);
			img.add("walk2", [3, 4, 3, 5], 8);
			img.play("stand");
			life = lifeMax;
			type = "zombie_bonus";
			layer = 2;
			this.move = move;
		}
		
		override public function added():void {
			super.added();
			lifeBar = new Bar(x, y + height, 13, 2, 0xCC0000);
			lifeBar.min = false;
			lifeBar.visible = !WorldGame.mView;
			world.add(lifeBar);
		}
		
		public function damage(dam:uint) : void {
			life -= dam;
			lifeBar.changeValue(life + 1, lifeMax + 1);
			SyParticle.emit("blood", x + width / 2, y + height / 2, 5);
			if (life <= 0) {
				(world as WorldBonus).addKill();
				die();
				world.remove(lifeBar);
				world.remove(this);
			}
		}
		
		
		override public function update():void {
			super.update();
			if (move) {
				img.play((WorldGame.mView ? "walk2" : "walk"));
				speedX = (dir  == 0 ? 0.5 : -0.5);
				img.flipped = dir == 1;
			}
			speedY += 20 * FP.elapsed;
			if (speedY > 15) speedY = 15;
			moveBy(speedX, speedY, "solid");
			lifeBar.x = x-1;
			lifeBar.y = y - 8;
			if (x < 0 || x > FP.screen.width/2) {
				world.remove(this);
				world.remove(lifeBar);
			}
		}
		
		override public function moveCollideX(e:Entity):Boolean {
			dir = (dir == 0 ? 1 : 0);
			return super.moveCollideX(e);
		}
		
		override public function moveCollideY(e:Entity):Boolean { 
			speedY = 0;
			return super.moveCollideY(e);
		}
		
		
	}

}