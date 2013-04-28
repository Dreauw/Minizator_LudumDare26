package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import worlds.WorldGame

	public class Box extends Entity{
		public function Box(x:Number, y:Number) {
			super(x, y, new Image(Assets.BOX), new Hitbox(14, 14))
			type = "solid";
			min = false;
		}
		
		override public function update():void {
			super.update();
			if (WorldGame.mView) return;
			moveBy(0, 2, "solid");
		}
		
	}

}