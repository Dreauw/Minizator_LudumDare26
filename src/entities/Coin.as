package entities {
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import utils.Audio;
	import utils.SyParticle;
	import worlds.WorldGame;

	public class Coin extends Entity {
		private var nImage:Image;
		private var mImage:Image;
		private var modeMin:Boolean = false;
		public function Coin(x:Number, y:Number) {
			nImage = new Image(Assets.COIN);
			nImage.filters = [new GlowFilter(0x387EA5)];
			mImage = new Image(Assets.COIN_MINI);
			super(x, y - 3, nImage, new Hitbox(8, 14, 4));
			Audio.registerSound("coin", "0,,0.0745,0.3871,0.2494,0.8573,,,,,,0.3868,0.5764,,,,,,1,,,,,0.3");
		}
		
		override public function update():void {
			super.update();
			if (WorldGame.mView != modeMin) {
				modeMin = WorldGame.mView;
				graphic = (modeMin ? mImage : nImage);
			}
			if (collide("player", x, y)) {
				Audio.playSound("coin");
				if (!modeMin) SyParticle.emit("coin", x, y, 10);
				(world as WorldGame).levelScore += 100;
				world.remove(this);
			}
		}
		
	}

}