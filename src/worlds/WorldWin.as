package worlds {
	import net.flashpunk.graphics.Image;
	import utils.WorldBase;
	import utils.Assets;
	import net.flashpunk.graphics.Text;
	import flash.filters.GlowFilter;
	import net.flashpunk.FP;
	import utils.gui.Button;
	import flash.ui.Mouse;

	public class WorldWin extends WorldBase{
		
		public function WorldWin() {
			var continueButton:Button = new Button(0, 170, "  Continue  ", startContinue, null, 0xFF4444, 2, 16);
			continueButton.x = (FP.screen.width / 2 - continueButton.width) / 2 + 3;
			var text:Text = new Text("Congratulation", 0, 0, { size: 32, outlineSize:2, outlineColor:0x387EA5, color:0xB6D6E7 } );
			text.filters = [new GlowFilter(0x387EA5)];
			text.x = (FP.screen.width / 2 - text.textWidth) / 2;
			text.y = 32;
			addGraphic(new Image(Assets.WIN));
			add(continueButton);
			addGraphic(text);
			Mouse.show();
		}
		
		public function startContinue(o:Object = null):void {
			switchWorld(WorldTitle);
		}
		
	}

}