package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import utils.SyParticle;
	import utils.Audio;

	public class Character extends Entity{
		
		public function Character(x:Number, y:Number, graphic:Graphic = null, mask:Mask = null) {
			super(x, y, graphic, mask);
			Audio.registerSound("die", "3,,0.2142,0.7251,0.2578,0.1202,,-0.0985,,,,0.6971,0.8076,,,,-0.19,-0.2457,1,,,,,0.3");
		}
		
		public function die() : void {
			Audio.playSound("die");
			SyParticle.emit("bone", x, y, 2);
			SyParticle.emit("bone_flesh", x, y, 2);
			SyParticle.emit("brain", x, y - 10, 1);
		}
		
	}

}