package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Hitbox;
	import utils.gui.Window;
	import utils.Assets;
	import net.flashpunk.FP;
	import worlds.WorldGame;

	public class Sign extends Entity {
		private var window:Window;
		private var img:Spritemap;
		public function Sign(x:Number, y:Number, txt:String) {
			window = new Window(0, 0, 0, 0, txt);
			window.visible = false;
			window.x = (FP.screen.width / 2 - window.width) / 2
			window.y = 32;
			window.graphic.scrollX = window.graphic.scrollY = 0;
			img = new Spritemap(Assets.SIGN, 17, 17);
			super(x, y-1, img, new Hitbox(17, 17));
		}
		
		override public function added():void {
			super.added();
			world.add(window);
		}
		
		override public function update():void {
			super.update();
			img.frame = (WorldGame.mView ? 1 : 0);
			if (collide("player", x, y)) {
				window.visible = true;
			} else if (window.visible) {
				window.visible = false;
			}
		}
		
	}

}