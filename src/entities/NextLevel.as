package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.masks.Hitbox;
	import worlds.WorldGame;

	public class NextLevel extends Entity {
		
		public function NextLevel(x:Number, y:Number) {
			super(x, y, null, new Hitbox(16, 16));
		}
		
		
		override public function update():void {
			super.update();
			if (collide("player", x, y)) {
				(world as WorldGame).executeTransition((world as WorldGame).nextLevel);
			}
		}
		
	}

}