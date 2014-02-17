package cg.game.map.sorter 
{	import cg.com.ui.UiLite;
  

	/**
	 * @author Administrator
	 */
	public class SortPane extends UiLite
	{  

		public var chName: String = "NoName"; //名字   
		public var mx: int = 0; //地图坐标
		public var my: int = 0;  
		public var mz: int = 0;

//		public function SortPane()
//		{
//			this.mouseEnabled = false;    
//			EventManager.AddEventFn(this, Event.ADDED_TO_STAGE, init );
//			EventManager.AddEventFn(this, Event.REMOVED_FROM_STAGE, die );
//		}
//
//		//将自己加入深度数组（换地图记得清理） 
//		private function init(): void
//		{    
//			Core.map.sortArr.push(this ); //将自己加入深度数组    
//		} 
//
//		//重置自己的
//		public function resetInd(): void
//		{    
//			if(! this.parent)
//			{ 
//				trace(this.chName + " - 无父容器，放弃调整！" );
//				return;
//			}
//			Core.map.sortArr.sortOn(["my"], Array.NUMERIC ); 
//         
//			//以下是容错型,防止层级超出范围 
//			var z: int = Core.map.sortArr.indexOf(this );    
//			z > Core.map.actLayer.numChildren - 1 ? Core.map.actLayer.addChild(this ):Core.map.actLayer.addChildAt(this, z );
//		}
//
//		//
//		protected function die(): void
//		{  
//			Core.map.sortArr.splice(Core.map.sortArr.indexOf(this ), 1 );  
//		}
	}
}
