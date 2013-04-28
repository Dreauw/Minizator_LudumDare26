package worlds {
	import entities.Map;
	import entities.Player;
	import entities.Timer;
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Particle;
	import utils.gui.Button;
	import utils.WorldBase;
	import net.flashpunk.FP;
	import flash.filters.ColorMatrixFilter;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import utils.SyParticle;
	import utils.Assets;
	import flash.ui.Mouse;
	import utils.Audio;

	public class WorldGame extends WorldBase{
		public var map:Map;
		public var player:Player;
		protected var lvl:uint = 1;
		private var background:Entity;
		private var cursor:Entity;
		public var enableSwitch:Boolean = false;
		static public var mView:Boolean = false;
		private var reloadButton:Button;
		private var muteButton:Button;
		private var timer:Timer;
		public var levelScore:uint = 0;
		public var score:uint = 0;
		public function WorldGame() {
			super();
			map = new Map();
			cursor = new Entity(0, 0, new Image(Assets.CURSOR));
			timer = new Timer();
			muteButton = new Button(FP.screen.width/2 - 22, 0, "M", muteLevel, null, 0xCC4444, 2);
			muteButton.layer = 5;
			reloadButton = new Button(FP.screen.width/2 - 40, 0, "R", reloadLevel, null, 0x16BEFE, 2);
			reloadButton.layer = 5;
			cursor.layer = 6;
			loadLevel();
			Mouse.hide();
			Input.define("Switch", Key.DOWN, Key.S);
			Audio.playMusic(Assets.ZIC);
			Audio.registerSound("switch1", "1,,0.3387,,0.2795,0.2575,,0.0505,,0.4708,0.3603,,,,,,,,1,,,,,0.5");
			Audio.registerSound("switch2", "0,,0.01,,0.383,0.3338,,0.4915,,,,,,0.3843,,0.4935,,,1,,,,,0.5");
		}
		
		public function nextLevel() : void {
			lvl += 1;
			score += levelScore;
			levelScore = 0;
			if (lvl == 13) Audio.stopSfx();
			if (lvl == 14) Audio.playMusic(Assets.BOSS_ZIC);
			loadLevel();
		}
		
		public function reloadLevel(b:Object = null) : void {
			levelScore = 0;
			executeTransition(loadLevel);
		}
		
		public function muteLevel(b:Object = null) : void {
			Audio.mute();
		}
		
		
		public function loadLevel() : void {
			removeAll();
			background = new Entity(0, 0, new Backdrop(Assets.BACKGROUND, true, false));
			background.min = false;
			background.graphic.scrollX = 0.5;
			background.graphic.scrollY = 0;
			add(timer);
			add(background);
			add(cursor);
			add(map);
			add(muteButton);
			add(reloadButton);
			map.loadLevel(lvl - 1, this);
		}
		
		override public function update():void {
			cursor.x = mouseX;
			cursor.y = mouseY;
			background.visible = !mView;
			if (enableSwitch && Input.released("Switch")) {
				switchView();
			}
			if (Input.released(Key.R)) {
				reloadLevel();
			}
			super.update();
		}
		
		public function resetEntity() : void {
			var arr:Array = [];
			this.getAll(arr);
			if (mView) {
				for each(var entity:Entity in arr) {
					if (!entity.min) {
						entity.visible = false;
						entity.collidable = false;
					}
				}
			} else {
				for each(var entity2:Entity in arr) {
					entity2.visible = true;
					entity2.collidable = true;
				}
			}
		}
		
		public function switchView() : void {
			mView = !mView;
			Audio.playSound(mView ? "switch2" : "switch1");
			map.switchView(mView);
			resetEntity();
		}
		
	}

}