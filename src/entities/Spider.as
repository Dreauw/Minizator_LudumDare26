package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import utils.gui.Bar;
	import utils.SyParticle;
	import worlds.WorldGame;
	import utils.Audio;
	import net.flashpunk.FP;

	public class Spider extends Entity {
		private var lifeMax:uint = 3;
		private var life:uint;
		private var lifeBar:Bar;
		private var reloadTimer:Number = 0;
		private var img:Spritemap;
		public function Spider(x:Number, y:Number) {
			img = new Spritemap(Assets.SPIDER, 19, 21);
			super(x, y, img, new Hitbox(9, 11, 5, 8));
			life = lifeMax;
			lifeBar = new Bar(x+3, y+1, 9, 2, 0xCC0000);
			lifeBar.min = false;
			type = "spider";
			Audio.registerSound("dieSpider", "3,,0.1901,0.6148,0.3998,0.2952,,-0.3758,,,,0.1619,0.7948,,,,0.1359,-0.2341,1,,,,,0.3");
		}
		
		override public function added():void {
			super.added();
			lifeBar.visible = !WorldGame.mView;
			world.add(lifeBar);
		}
		
		public function damage(dam:uint) : void {
			life -= dam;
			lifeBar.changeValue(life + 1, lifeMax + 1);
			SyParticle.emit("blood", x + width / 2, y + height / 2, 5);
			if (life <= 0) {
				Audio.playSound("dieSpider");
				world.remove(lifeBar);
				world.remove(this);
			}
		}
		
		override public function update():void {
			super.update();
			img.frame = (WorldGame.mView ? 1 : 0);
			reloadTimer -= FP.elapsed;
			if (reloadTimer <= 0 && !WorldGame.mView) {
				var player:Player = (world as WorldGame).player;
				if (FP.distance(x, y, player.x, player.y) > 180) return;
				reloadTimer = 2;
				var bullet:Bullet = world.create(Bullet) as Bullet;
				bullet.initialize(x+8, y+20, player.x, player.y, "spider_bullet");
			}
		}
		
	}

}