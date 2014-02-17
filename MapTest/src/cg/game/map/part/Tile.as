package cg.game.map.part 
{
	import cg.game.core.Core;
	import cg.com.extra.DataLite;

	import flash.display.BitmapData;
	import flash.display.Bitmap;

	/**
	 * @author Administrator
	 */
	public class Tile extends Bitmap
	{

		private static var tileCache: Object = {};
		public var id: int = 0;
		public var mx: int = 0;
		public var my: int = 0; 
		public var mz: int = 0;

		public function Tile(id: int)
		{
			this.id = id;
			if(tileCache[id])
			{
				this.bitmapData = tileCache[id] as BitmapData;
			}
			else
			{
				var url: String = "tile/" + getFileName(id ) + ".gif";
				DataLite.loadSingle(url, onLoaded, null, [url] );
			}
		}

		private static function getFileName(id: int): String
		{
			var str: String = "000000" + id;
			return "CG" + str.substr(str.length - 7, 7 );
		}

		private function onLoaded(url: String): void
		{
			tileCache[id] = DataLite.getBmpData(url );
			this.bitmapData = tileCache[id] as BitmapData; 
		}
	}
}
