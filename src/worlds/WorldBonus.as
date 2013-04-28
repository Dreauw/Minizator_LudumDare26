package worlds {
	import entities.Map;
	import entities.ZombieBonus;
	import flash.geom.Point;
	import utils.WorldBase;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;

	public class WorldBonus extends WorldGame {
		private var zombiTimer:Number = 0;
		private var scoret:Text;
		private var kill:uint = 0;
		public function WorldBonus() {
			super();
			scoret = new Text("0", 0, 0, { size:16, outlineSize:1 } );
			scoret.x = (FP.screen.width / 2 - scoret.width) / 2;
			scoret.y = 16;
			addGraphic(scoret);
		}
		
		override public function reloadLevel(b:Object = null):void {
			kill = 0;
			scoret.text = "0";
			scoret.x = (FP.screen.width / 2 - scoret.width) / 2;
			scoret.y = 16;
			super.reloadLevel(b);
		}
		
		public function addKill() : void {
			kill += 1;
			scoret.text = kill.toString();
			scoret.x = (FP.screen.width / 2 - scoret.width) / 2;
		}
		
		
		override public function loadLevel():void {
			lvl = 16;
			super.loadLevel();
		}
		
		override public function update():void {
			super.update();
			zombiTimer -= FP.elapsed;
			if (zombiTimer <= 0) {
				var pos:Point = FP.choose(new Point(0, 3), new Point(19, 3), new Point(0, 9), new Point(0, 13), new Point(19, 13))
				var zombie:ZombieBonus = new ZombieBonus(pos.x * 16, pos.y * 16, true);
				if (zombie.x < 40) zombie.dir = 0;
				add(zombie);
				zombiTimer = 1; 
			}
		}
		
		
		
	}

}