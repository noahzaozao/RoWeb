package cg.game.map.sorter 
{
	import flash.geom.Point;

	import cg.game.core.Core;

	import flash.events.Event;

	import cg.com.extra.EventManager;

	import flash.display.BitmapData;
	import flash.display.Bitmap;

	/**
	 * @author Administrator
	 */
	public class SortBmp extends Bitmap
	{       

		public var chName: String = "SortBmp_NoName"; //名字   
		public var mx: int = 0; //地图坐标
		public var my: int = 0;  
		public var ind: int = 0;
		private var cx: int = 0;
		private var cy: int = 0;

		public function SortBmp(bmd: BitmapData,cx: int,cy: int)
		{
			this.cx = cx;
			this.cy = cy;
			super(bmd );
			EventManager.AddOnceEventFn(this, Event.ADDED_TO_STAGE, init );
		}     

		public function flyTo(x: int,y: int): void
		{
			this.mx = x;
			this.my = y;
			var pt: Point = Core.map.absToRel(x, y );
			this.x = pt.x + this.cx;
			this.y = pt.y + this.cy;
			Core.map.sortObjIndex(this );
		} 

		private function init(): void
		{   
			Core.map.addSortor(this ); 
			EventManager.AddOnceEventFn(this, Event.REMOVED_FROM_STAGE, die );
		}  

		private function die(): void
		{   
			Core.map.delSortor(this ); 
		}
	}
}
