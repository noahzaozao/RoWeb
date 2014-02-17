package cg.game.map.data 
{
	import flash.geom.Point;

	/**
	 * @author Administrator
	 */
	public class MapData 
	{

		public var mapId : int = 0;  //唯一编号
		public var mapName : String = "";  //地图中文名
		public var mapCode : String = ""; //地图ID  
		public var tileData : Array = []; //地图数据,2维数组 
		public var objData : Array = []; //物件数据
		public var bigObjData : Array = []; //大物件数据
		public var signData : Array = []; //逻辑数据
		public var npcDict : Object = {}; //动态NPC数据
		public var warpDict : Object = {}; //跳转点
		public var hinder : Object = { };  
		public var bgmName : String = ""; //BGM 
		public var sPt : Point = new Point(0, 0); //00点位置
		public var mapWidth : int = 0; //地图宽,单位tile
		public var mapHeight : int = 0; //地图高,单位tile
		public var fileList : Array = [];
		//
		public var exit : Object = {}; 
		public var tMap : String = "";

		//
		public function addToFileList(url : String) : void
		{
			if(this.fileList.indexOf(url) == -1)
			{
				this.fileList.push(url);
			}
		}
	}
}
