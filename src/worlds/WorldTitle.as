package worlds {
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import utils.gui.Button;
	import utils.gui.Window;
	import utils.WorldBase;
	import net.flashpunk.FP;
	import utils.Assets;
	import utils.Audio;
	import flash.ui.Mouse;

	public class WorldTitle extends WorldBase{
		public function WorldTitle() {
			super();
			var scoreButton:Button = new Button(0, 200, "   Bonus   ", startBonus, null, 0xFF4444, 2, 16);
			scoreButton.x = (FP.screen.width / 2 - scoreButton.width) / 2 + 3;
			var playButton:Button = new Button(0, 170, "Play", startGame, null, 0x16BEFE, 2, 16, scoreButton.width, scoreButton.height);
			playButton.x = scoreButton.x;
			var text:Text = new Text("Minizator", 0, 0, { size: 32, outlineSize:2, outlineColor:0x387EA5, color:0xB6D6E7 } );
			text.filters = [new GlowFilter(0x387EA5)];
			text.x = (FP.screen.width / 2 - text.textWidth) / 2 + 7;
			text.y = 32;
			var img:Image = new Image(Assets.TITLE);
			addGraphic(img);
			add(playButton);
			add(scoreButton);
			addGraphic(text);
			
			Mouse.show();
			Audio.playMusic(Assets.TITLE_ZIC);
		}
		
		public function startGame(p : Object = null) : void {
			switchWorld(WorldGame);
		}
		
		public function startBonus(p : Object = null) : void {
			switchWorld(WorldBonus);
		}
		
	}

}