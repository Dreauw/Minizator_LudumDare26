package utils {
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.ParticleType;
	/**
	* ...
	* @author Dreauw
	*/
	
	public class SyParticle extends Entity {
		static public var instance : SyParticle;
		public function SyParticle() {
			super(0, 0, new Emitter(Assets.PARTICLES, 10, 10));
			layer = 5;
			registerParticle();
		}
		
		public function newType(name:String, frames:Array = null):ParticleType {
			return (graphic as Emitter).newType(name, frames);
		}

		private function registerParticle() : void {
			/*
			newType("foobar", [0])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setGravity(5, 10);
			*/
			newType("blood", [0, 1, 2, 3])
				//.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setAnimation(0.1)
				.setGravity(5, 10);
				
			newType("bone", [4, 5])
				//.setAlpha(1, 0)
				.setMotion(0, 30, 0.7, 360, 0, 0.4)
				.setAnimation(0.1)
				.setGravity(5, 10);
				
			newType("bone_flesh", [6, 7])
				//.setAlpha(1, 0)
				.setMotion(0, 30, 0.7, 360, 0, 0.4)
				.setAnimation(0.1)
				.setGravity(5, 10);
				
			newType("brain", [8, 9, 10, 11])
				//.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setAnimation(0.1)
				.setGravity(5, 10);
				
			newType("ammo", [12])
				//.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setGravity(5, 10);
				
			newType("dust", [13])
				.setAlpha(1, 0)
				.setMotion(0, 5, 0.7, 360, 0, 0.4);
			
			newType("bullet", [14])
				.setAlpha(1, 0)
				.setMotion(0, 10, 0.5, 360, 0, 0.4);
			
			newType("coin", [15])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.3, 360, 0, 0.4);
		}

		static public function emit(name:String, x:Number, y:Number, nbr:Number = 1) : void {
			if (!instance || instance.world != FP.world) {
				instance = new SyParticle();
				if (instance.world) instance.world.remove(instance);
				FP.world.add(instance);
			}
			for (var i : Number = 0; i < nbr ; i++) {(instance.graphic as Emitter).emit(name, x, y);}
		}

	}

}