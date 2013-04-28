package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.masks.Hitbox;
	import worlds.WorldGame;

	public class SolidTile extends Entity{
		
		public function SolidTile(x:Number, y:Number, min:Boolean = false) {
			super(x, y, null, new Hitbox(16, 16));
			this.min = min;
			type = "solid";
		}
		
		override public function update():void {
			super.update();
			collidable = min == WorldGame.mView;
		}
		
	}

}