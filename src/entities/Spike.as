package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import worlds.WorldGame;

	public class Spike extends Entity {
		
		public function Spike(x:Number, y:Number) {
			super(x, y + 9, new Image(Assets.SPIKE), new Hitbox(15, 6));
			min = false;
		}
		
		override public function added():void {
			super.added();
			visible = collidable = !WorldGame.mView;
		}
		
		override public function update():void {
			super.update();
			if (!collidable) return;
			var p:Player = collide("player", x, y) as Player;
			if (p) p.damage(10);
		}
		
	}

}