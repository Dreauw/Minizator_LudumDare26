package {
	import net.flashpunk.FP;
	import net.flashpunk.Engine;
	import net.flashpunk.utils.Key;
	import worlds.WorldGame;
	import worlds.WorldTitle;
	import worlds.WorldWin;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	[SWF(backgroundColor="#202020", width="640", height="480")]
	[Frame(factoryClass = "Preloader")]
	public class Main extends Engine {
		public function Main() {
			super(640, 480, 60, false);
			FP.screen.color = 0x525252;
			FP.screen.scale = 2;
			FP.world = new WorldTitle();
		}
	}
}