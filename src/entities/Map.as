package entities {
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import utils.Assets;
	import utils.gui.Window;
	import worlds.WorldGame;
	import net.flashpunk.FP;

	public class Map extends Entity{
		private var tilemap:Tilemap;
		private var tilemapMin:Tilemap;
		private var grid:Grid;
		private var worldGame:WorldGame;
		private var img:Image;
		private var levelRect:Array = new Array();
		private var switchFade:Boolean = false;
		public function Map() {
			type = "solid";
			img = new Image(Assets.LEVEL);
			var starty:int = -1;
			var endx:int = -1;
			for (var y:int = 0 ; y < img.height ; y++) {
				if (img.getPixel(1, y) == 0) {
					if (starty >= 0) {
						levelRect.push(new Rectangle(1, starty, endx, y - starty));
					}
					starty = y + 1;
					for (var x:int = 1 ; x < img.width ; x++) {
						if (img.getPixel(x, y + 1) == 0) {
							endx = x - 1;
							break;
						}
					}
				}
			}
		}
		
		public function diffPixel(col:uint, colo:Object) : Boolean {
			for each(var color:uint in colo) {
				if (color == col) return false;
			}
			return true;
		}
		
		public function loadLevel(level:uint, worldGame:WorldGame) : void {
			FP.camera.x = FP.camera.y;
			var rect:Rectangle = levelRect[level];
			tilemap = new Tilemap(Assets.TILESET, rect.width * 16, rect.height * 16, 16, 16);
			tilemapMin = new Tilemap(Assets.TILESET_MIN, rect.width * 16, rect.height * 16, 16, 16);
			grid = new Grid(rect.width * 16, rect.height * 16, 16, 16);
			for (var x:int = rect.x; x < rect.x+rect.width ; x++) {
				for (var y:int = rect.y ; y < rect.y+rect.height ; y++) {
					var col:uint = img.getPixel(x, y)
					var id:uint = 0;
					var diffPix:Object = [0xFFFFFF, 0xDA5302, 0x18C442, 1, 0xDA0205, 0xBFDA02, 0xDA02A7, 2, 3, 4, 5, 42, 0xFFC90E, 0x00A2E8, 0x011D6D, 0x70B3DA, 0x8C8C8C];
					var diffPix2:Object = [0xFFFFFF, 0xDA5302, 0x18C442, 1, 0xDA0205, 0xBFDA02, 0xDA02A7, 2, 3, 4, 5, 42, 0xFFC90E, 0x00A2E8, 0x011D6D, 0x70B3DA, 0x6F452F, 0x8C8C8C];
					var l:Boolean = diffPixel(img.getPixel(x - 1, y), diffPix);
					var r:Boolean = diffPixel(img.getPixel(x + 1, y), diffPix);
					var u:Boolean = diffPixel(img.getPixel(x, y - 1), diffPix); 
					var d:Boolean = diffPixel(img.getPixel(x, y + 1), diffPix);
					var posx:Number = x - rect.x;
					var posy:Number = y - rect.y;
					if (col == 0xB97A57) {
						var l2:Boolean = diffPixel(img.getPixel(x - 1, y), diffPix2);
						var r2:Boolean = diffPixel(img.getPixel(x + 1, y), diffPix2);
						var u2:Boolean = diffPixel(img.getPixel(x, y - 1), diffPix2); 
						var d2:Boolean = diffPixel(img.getPixel(x, y + 1), diffPix2);
						id = getTileId(l, r, u, d);
						if (id <= 5 && img.getPixel(x, y-1) != 0xDA0205) {
							tilemap.setTile(posx, posy-1, FP.choose(6, 7, 8, 6, 7, 8, 9));
						}
						tilemap.setTile(posx, posy, id);
						tilemapMin.setTile(posx, posy, getTileId(l2, r2, u2, d2));
						grid.setTile(posx, posy, true);
					} else if (col == 0x6F452F) {
						id = getTileId(l, r, u, d);
						if (id <= 5) tilemap.setTile(posx, posy-1, FP.choose(6, 7, 8, 6, 7, 8, 9));
						tilemap.setTile(posx, posy, id);
						worldGame.add(new SolidTile(posx * 16, posy * 16, false));
					}  else if (col == 0x8C8C8C) {
						var l3:Boolean = img.getPixel(x - 1, y) == 0x8C8C8C;
						var r3:Boolean = img.getPixel(x + 1, y) == 0x8C8C8C;
						var u3:Boolean = img.getPixel(x, y - 1) == 0x8C8C8C; 
						var d3:Boolean = img.getPixel(x, y + 1) == 0x8C8C8C;
						id = getTileId(l3, r3, u3, d3);
						tilemapMin.setTile(posx, posy, id);
						worldGame.add(new SolidTile(posx * 16, posy * 16, true));
					} else if (col == 0xBFDA02) {
						worldGame.add(worldGame.player = new Player(posx * 16, posy * 16, rect.width*16, rect.height*16));
					} else if (col == 0xDA5302) {
						worldGame.add(new Box(posx * 16, posy * 16));
					} else if (col == 0xDA02A7) {
						worldGame.add(new Girl(posx * 16, posy * 16));
					} else if (col == 0x18C442) {
						worldGame.add(new Zombie(posx * 16, posy * 16, true));
					} else if (col == 0xDA0205) {
						worldGame.add(new Spike(posx * 16, posy * 16));
					} else if (col == 0xFFC90E) {
						worldGame.add(new Chest(posx * 16, posy * 16));
					} else if (col == 0x00A2E8) {
						worldGame.add(new NextLevel(posx * 16, posy * 16));
					} else if (col == 0x011D6D) {
						worldGame.add(new Spider(posx * 16, posy * 16));
					} else if (col == 0x70B3DA) {
						worldGame.add(new Coin(posx * 16, posy * 16));
					} else if (col == 42) {
						worldGame.add(new Boss(posx * 16, posy * 16));
					} else if (col == 1) {
						worldGame.add(new Sign(posx * 16, posy * 16, "Try to save the princess from the zombies\nMove with the arrow key or WASD\n"));
					} else if (col == 2) {
						worldGame.add(new Sign(posx * 16, posy * 16, "Jump with the UP arrow or W\n"));
					} else if (col == 3) {
						worldGame.add(new Sign(posx * 16, posy * 16, "Shoot by pressing the left button of the mouse\n"));
					} else if (col == 4) {
						worldGame.add(new Sign(posx * 16, posy * 16, "Sometimes, the minimalist world has differences\nwith de normal world."));
					} else if (col == (5)) {
						worldGame.add(new Sign(posx * 16, posy * 16, "In your minimalism form\nyou can go higher\nby doing a double jump."));
					}
				}
			}	
			graphic = tilemap;
			addGraphic(tilemapMin);
			tilemapMin.alpha = 0;
			mask = grid;
		}
		
		public function getTile(x:Number, y:Number) : Boolean {
			return grid.getTile(x, y);
		}
		
		public function switchView(v:Boolean) : void {
			switchFade = true;
			//tilemapMin.alpha = (v ? 1 : 0);
			//tilemap.alpha = (v ? 0 : 1);
		}
		
		override public function update():void {
			super.update();
			if (switchFade) {
				if (WorldGame.mView) {
					tilemap.alpha -= 0.1;
					tilemapMin.alpha += 0.1;
				} else {
					tilemapMin.alpha -= 0.1;
					tilemap.alpha += 0.1;
				}
			}
		}
		
		
		public function getTileId(left:Boolean, right:Boolean, up:Boolean, down:Boolean, idBase:int = 0) : int {
			if (left && right && down && !up) {
				return idBase + 1;
			} else if (left && !right && up && down) {
				return idBase + 22;
			} else if (down && right && !left && !up) {
				return idBase + 0;
			} else if (up && down && left && right) {
				return idBase + 21;
			} else if (left && down && !right && !up) {
				return idBase + 2;
			} else if (right && up && !left && down) {
				return idBase + 20;
			} else if (!left && up && right && !down) {
				return idBase + 40;
			} else if (left && up && right && !down) {
				return idBase + 41;
			} else if (left && up && !right && !down) {
				return idBase + 42;
			} else if (!left && !up && right && !down) {
				return idBase + 3;
			} else if (left && !up && !right && !down) {
				return idBase + 5;
			} else if (left && !up && right && !down) {
				return idBase + 4;
			} else if (!left && !right && !down && up) {
				return idBase + 63;
			} else if (!left && !right && down && up) {
				return idBase + 43;
			} else if (!left && !right && down && !up) {
				return idBase + 23;
			} else if (!left && !right && !up && !down) {
				return idBase + 24;
			}
			return idBase + 1;
		}
		
	}

}