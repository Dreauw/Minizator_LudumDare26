package entities {
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import utils.Assets;
	import net.flashpunk.masks.Hitbox;
	import worlds.WorldGame;
	import worlds.WorldWin;

	public class Girl extends Character{
		private var img:Spritemap;
		public function Girl(x:Number, y:Number) {
			img = new Spritemap(Assets.GIRL, 16, 28);
			super(x, y - 28, img, new Hitbox(12, 16, 0, 6));
			type = "girl";
			layer = 1;
			
		}
		
		override public function update():void {
			super.update();
			if (WorldGame.mView) {
				if (img.frame != 1) {
					img.frame = 1;
				}
			} else {
				if (img.frame != 0) {
					img.frame = 0;
				}
			}
			moveBy(0, 2, "solid");
			if (collide("player", x, y)) {
				(world as WorldGame).switchWorld(WorldWin);
			}
		}
		
	}

}