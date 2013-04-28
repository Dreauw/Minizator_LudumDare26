package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import utils.gui.Window;
	import worlds.WorldGame;
	import utils.Audio;
	import net.flashpunk.FP;

	public class Chest extends Entity {
		private var opened:Boolean = false;
		private var window:Window;
		private var window2:Window;
		public function Chest(x:Number, y:Number) {
			super(x, y + 3, new Image(Assets.CHEST), new Hitbox(16, 16));
			Audio.registerSound("chest", "0,,0.0699,,0.4806,0.3995,,0.2385,,,,,,0.4537,,0.4438,,,1,,,,,0.5", false);
			window = new Window(0, 0, 0, 0, "You got the <red>book of minimalism</red> !\nPress the DOWN arrow or S\nto discover another world");
			window.x = (FP.screen.width / 2 - window.width) / 2;
			window.y = 32;
			window.visible = false;
			window2 = new Window(0, 0, 0, 0, "Re-press DOWN or S to go back to the \"normal\" world");
			window.graphic.scrollX = window.graphic.scrollY = 0;
			window2.graphic.scrollX = window2.graphic.scrollY = 0;
			window2.x = (FP.screen.width / 2 - window2.width) / 2;
			window2.y = 32;
			window2.visible = false;
		}
		
		override public function added():void {
			super.added();
			window.visible = false;
			window2.visible = false;
			if ((world as WorldGame).enableSwitch) {
				opened = true
				visible = collidable = false;
			}
			
			world.add(window);
			world.add(window2);
		}
		
		override public function update():void {
			super.update();
			if (!opened && collide("player", x, y)) {
				Audio.playSound("chest");
				opened = true;
				(world as WorldGame).enableSwitch = true;
				window.visible = true;
				visible = false;
				collidable = false;
			}
			collidable = visible = !opened;
			if (opened) {
				if (WorldGame.mView) {
					window.visible = false;
					window2.visible = true
				} else {
					window.visible = true;
					window2.visible = false
				}
				
			}
		}
		
	}

}