package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;

	public class Timer extends Entity {
		private var text:Text;
		private var timer:Number = 0;
		
		public function Timer() {
			text = new Text("0", 0, 0, { size:8, outlineSize:1 } );
			layer = 5;
			text.scrollX = text.scrollY = 0;
			super(3, 3, text);
			
		}
		
		override public function update():void {
			super.update();
			timer += FP.elapsed;
			var precision:uint = 0;
			if (timer >= 1) precision = 1;
			if (timer >= 10) precision = 2;
			if (timer >= 100) precision = 3;
			text.text = "Time : " + Math.floor(timer/60).toString() + ":" + Math.floor(timer%60) + ":" + Math.floor((timer - Math.floor(timer))*100);
		}
		
	}

}