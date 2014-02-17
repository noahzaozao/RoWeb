package cg.game.map 
{
	import cg.com.extra.FPS;
	import cg.game.core.data.warp.MapWarpInfo;
	import cg.game.core.data.warp.MapWarpData;

	import flash.utils.getTimer;

	import cg.com.lib.TransformLib;
	import cg.game.map.player.Player;
	import cg.game.core.data.graphic.GraphicInfo;
	import cg.game.core.data.graphic.GraphicListData;
	import cg.game.map.part.Tile;

	import flash.utils.Endian;
	import flash.utils.ByteArray;

	import cg.com.extra.SoundManager; 
	import cg.game.map.sorter.SortBmp; 

	import flash.geom.Rectangle;
	import flash.display.DisplayObject;

	import cg.com.extra.EventManager;

	import com.greensock.TweenMax;

	import cg.game.core.Tools;

	import flash.events.ProgressEvent;

	import cg.game.core.GlobalSet; 
	import cg.game.core.Core; 

	import flash.geom.Point;

	import cg.game.map.data.MapData;
	import cg.com.extra.DataLite;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author Administrator
	 */
	public class MapReader extends Sprite
	{    

		//地图元素
		public var bgLayer : Sprite;  //背景层 
		public var bgImg : Bitmap; //地表
		protected var cue : Bitmap; //测试用
		public var actLayer : Sprite; //动作层  
		private var debugLayer : Sprite;
		private var debugMode : Boolean = false; 
		//
		public var mapData : MapData;
		public var logX : int = 0;
		public var logY : int = 0;
		public var logDir : int = 0;
		//摄像机跟踪的最小滚动值的高速缓存
		protected var minCameraPos : Point = new Point(0, 0); 
		//集合  
		public var locked : Boolean = true;   
		public var mapCache : Object = {};
		public var sortArr : Array = []; 
		public var npcDict : Object = {}; 
		//
		private var nowTileDict : Object = {}; //当前tile集合
		private var nowObjectDict : Object = {};
		private var nowDebugDict : Object = {}; 
		//
		private var redrawW : int = 7;  //重绘区域
		private var redrawH : int = 7; 

		public function MapReader() : void
		{   
			this.visible = false;
			//创建背景层
			this.bgLayer = new Sprite();
			this.bgLayer.cacheAsBitmap = true;
			this.bgLayer.mouseChildren = false;
			this.bgLayer.mouseEnabled = false;
			this.opaqueBackground = 0x000000; 
			this.addChild(this.bgLayer);
 
	
            
 
            
			//			//鼠标指示 
			//			this.cue = new Bitmap(DataLite.getBmpFromSwf("base/base.swf", "TileCue" ) );
			//			this.addChild(this.cue );
			//创建动态层
			this.actLayer = new Sprite(); 
			this.actLayer.mouseEnabled = false;
			//this.actLayer.cacheAsBitmap = true;
			this.actLayer.mouseChildren = false;
			this.addChild(this.actLayer);
			//创建前层
			this.debugLayer = new Sprite(); 
			this.debugLayer.cacheAsBitmap = true;
			this.debugLayer.mouseEnabled = false;
			this.debugLayer.mouseChildren = false;
			this.debugLayer.alpha = 0.3;
			this.addChild(this.debugLayer);   
		}

		public function loadMap(mapId : int,sx : int,sy : int,logDir : int = 0) : void
		{ 
			Core.ui.clearDebug();
			this.locked = true;
			this.logX = sx;
			this.logY = sy;
			this.logDir = logDir;
			 
			this.clearMap(); 
			Core.ui.showDebug("load map data .. " + mapId);
			if(mapCache[mapId])
			{ 
				
				mapData = mapCache[mapId];
				this.buildMap();
			}
			else
			{	 
				var url : String = "map/0/" + mapId + ".dat";
				mapCache[mapId] = new MapData();
				mapData = mapCache[mapId];
				mapData.mapId = mapId; 
				DataLite.loadSingle(url, readMapData, onLoadMapConf, [url]);
			}
		}

		private function clearMap() : void
		{       
			while(this.actLayer.numChildren)
			{
				this.actLayer.removeChildAt(0);
			}
			trace("动作层已经清理,sort集合剩余" + this.sortArr.length);
			this.sortArr = [];
	  
			while(this.bgLayer.numChildren)
			{ 
				this.bgLayer.removeChildAt(0);
			}    
			while(this.debugLayer.numChildren)
			{ 
				this.debugLayer.removeChildAt(0);
			}   
			this.npcDict = {};
			this.debugMode && (this.nowDebugDict = {});
			this.nowObjectDict = {};
			this.nowTileDict = {};
			Tools.GC();
			//TweenMax.killAll();
			EventManager.traceDebugInfo();
		}

		private function onLoadMapConf(e : ProgressEvent,pro : Number) : void
		{
			//Core.ui.showDebug("载入地图数据" + (pro * 100 >> 0));
		}

		private function readMapData(url : String) : void
		{
			var br : ByteArray = ByteArray(DataLite.getData(url));
			br.endian = Endian.LITTLE_ENDIAN;
			
			Core.ui.showDebug("Start read map data..");
			trace(br.readMultiByte(12, "utf-8"));  
			
			this.mapData.mapWidth = br.readInt();
			this.mapData.mapHeight = br.readInt();
			this.mapData.warpDict = MapWarpData.getWarpInfo(this.mapData.mapId);
			for each(var w:MapWarpInfo in this.mapData.warpDict)
			{
				trace(w.x + "," + w.y + " -> " + w.toMapId);
			}
			var g : GraphicInfo;
			//地板砖
			for(var y : int = 0;y < this.mapData.mapHeight;y++)
			{
				var arr : Array = [];
				for(var x : int = 0;x < this.mapData.mapWidth;x++)
				{
					g = GraphicListData.getGraphicInfoByMapId(br.readShort()); 
					g != null && g.hinder == 0 && (this.mapData.hinder[x + "," + y] = true); 
					arr.push(g);
				}
				this.mapData.tileData.push(arr);
			}
			//物件层 
			for(y = 0;y < this.mapData.mapHeight;y++)
			{
				arr = [];
				for(x = 0;x < this.mapData.mapWidth;x++)
				{
					g = GraphicListData.getGraphicInfoByMapId(br.readShort());
					if(g && g.mapId > 0 && g.hinder == 0)
					{    
						if(g.filt_x > 1 || g.filt_y > 1)
						{
							//trace("大物件:" + x + "," + y + ",占地: " + g.filt_x + "," + g.filt_y );
							for(var tx : int = 0;tx < g.filt_x;tx++)
							{ 
								for(var ty : int = 0;ty < g.filt_y;ty++)
								{ 
									//trace((x + tx) + "," + (y - ty) );
									this.mapData.hinder[(x + tx) + "," + (y - ty) ] = true;
									this.mapData.bigObjData[(x + tx) + "," + (y - ty)] = [x,y];
								}
							}
						}
						else
						{
							this.mapData.hinder[x + "," + y] = true;
						}
					}
					arr.push(g);
				}
				this.mapData.objData.push(arr);
			}
			//标志层 
			for(y = 0;y < this.mapData.mapHeight;y++)
			{
				arr = [];
				for(x = 0;x < this.mapData.mapWidth;x++)
				{
					arr.push(br.readUnsignedShort());
				}
				this.mapData.signData.push(arr);
			}  
			//trace(mapData.signData.join("\n" ) );
			this.buildMap();
		}

		private function loadMapFiles() : void
		{
			DataLite.load(this.mapData.fileList, this.buildMap, onLoadMapFile, null, null, false);
		}

		private function onLoadMapFile(e : ProgressEvent,pro : Number) : void
		{
			//Core.ui.showDebug("载入地图资源" + (pro * 100 >> 0) );
		}

		//全盘创建，大地图会卡死
		private function buildMap() : void
		{
			Core.astar.bindMapData(this.mapData.hinder, this.mapData.mapWidth, this.mapData.mapHeight);
			Core.ui.showDebug("Read Done! Start build tile .."); 
			//debugMode && this.showDebugTile(); 
			Core.ui.showDebug("Build Success."); 
			//this.scaleX = this.scaleY = 0.2;

			FPS.waitFpsBlock(this.enterMap);
		}

		protected function enterMap() : void
		{
			this.visible = true;
			Core.mask.effect.showAlphaEffect(false);              
		}

		//动态创建周边地图
		public function updateMap() : void
		{ 
			//			if(this.redrawItv++ < 5)
			//			{
			//				return;
			//			}
			//			else
			//			{
			//				this.redrawItv = 0;
			//			}

			var cp : Point = this.relToAbs(-this.x + GlobalSet.CemeraPos.x + 32, -this.y + GlobalSet.CemeraPos.y + 24);
		 
			var area : int = redrawW + redrawH;
			//var cp : Point = new Point(Core.me.mx, Core.me.my);
			//trace("redraw ->" + cp);
			var newTileDict : Object = {};
			//var st : int = getTimer(); 
			for(var x : int = cp.x - area;x <= cp.x + area;x++)
			{
				for(var y : int = cp.y - area;y <= cp.y + area;y++)
				{
					if(x > 0 && x < this.mapData.mapWidth && y > 0 && y < this.mapData.mapHeight)
					{
						if(Math.abs((y - cp.y - x + cp.x) / 2) <= redrawH && Math.abs((x - cp.x + y - cp.y) / 2) <= redrawW)
						{
							 
							this.addTile(this.mapData.tileData[y][x], x, y);
							this.addObj(this.mapData.objData[y][x], x, y);  
							if(this.mapData.bigObjData[x + "," + y])
							{   
								var p : Array = this.mapData.bigObjData[x + "," + y]; 
								this.addObj(this.mapData.objData[p[1]][p[0]], p[0], p[1]);
								newTileDict[ p[0] + "," + p[1]] = true;
							}
							newTileDict[x + "," + y] = true;
							debugMode && this.addDebugTile(x, y);
						}
					}
				}
			} 

			//删除多余的
			for(var k:String in this.nowTileDict)
			{
				newTileDict[k] || this.delTile(k); 
			}
			for( k in this.nowObjectDict)
			{
				newTileDict[k] || this.delObj(k);
			}
			if(debugMode)
			{
				for( k in this.nowDebugDict)
				{ 
					newTileDict[k] || this.delDebugTile(k);
				}
			}
			//this.sortAll();
			//trace(this.bgLayer.numChildren + this.actLayer.numChildren);
		}

		private function addTile(g : GraphicInfo,x : int,y : int) : void
		{  
			if(!g || g.mapId == 0 || this.nowTileDict[x + "," + y])
			{
				//trace("已添加过");
				return;
			}
			//g.traceInfo();
			var t : Tile = new Tile(g.index);  
			var pt : Point = this.absToRel(x, y);  
			t.x = pt.x + g.fx + 32;
			t.y = pt.y + g.fy + 24; 
			this.bgLayer.addChild(t);
			
			this.nowTileDict[x + "," + y] = t;
		}

		private function delTile(k : String) : void
		{  
			this.bgLayer.removeChild(this.nowTileDict[k]);
			delete this.nowTileDict[k];
		} 

		private function addObj(g : GraphicInfo,x : int,y : int) : void
		{            
			if(!g || g.mapId == 0 || this.nowObjectDict[x + "," + y])
			{ 
				return;
			} 
			// 
			//物件层只是补充可行走区域，所以为0则可以跳过
			//this.mapData.hinder[x + "," + y] = g.hinder == 0;
			//g.traceInfo();

			var t : Tile = new Tile(g.index); 
			t.mx = x;
			t.my = y;
			t.mz = getIndex(x, y);
			this.sortArr.push(t);
			var pt : Point = this.absToRel(x, y);  
			t.x = pt.x + g.fx + 32;
			t.y = pt.y + g.fy + 24;
			this.actLayer.addChild(t); 
			this.sortObjIndex(t);
			this.nowObjectDict[x + "," + y] = t;
		}

		
		
		private function delObj(k : String) : void
		{	
			this.delSortor(this.nowObjectDict[k]);
			this.actLayer.removeChild(this.nowObjectDict[k]);
			delete this.nowObjectDict[k];
		}

		private function showDebugTile() : void
		{  
			for(var x : int = 0;x < this.mapData.mapWidth;x++)
			{            
				for(var y : int = 0;y < this.mapData.mapHeight;y++)
				{
					this.addDebugTile(x, y);
				}
			}
		} 

		private function addDebugTile(x : int,y : int) : void
		{ 	
			if(this.nowDebugDict[x + "," + y])
			{ 
				return;
			}
			var pt : Point = this.absToRel(x, y);  
			var d : Bitmap = new Bitmap();
			d.bitmapData = DataLite.getBmpFromSwf("base/base.swf", "tile_0");
			d.x = pt.x;
			d.y = pt.y;
			d.transform.colorTransform = this.mapData.hinder[x + "," + y] ? TransformLib.black_classic : TransformLib.normal;
			this.debugLayer.addChild(d); 
			this.nowDebugDict[x + "," + y] = d;
		}

		private function delDebugTile(k : String) : void
		{     
			this.debugLayer.removeChild(this.nowDebugDict[k]);
			delete this.nowDebugDict[k];
		}

		
		//绝对坐标转相对坐标（格子转像素）
		public function absToRel(x : int, y : int) : Point
		{
			var rx : int = this.mapData.sPt.x + (x + y) / 2 * GlobalSet.tileW;
			var ry : int = this.mapData.sPt.y - (x + 1) * ( GlobalSet.tileH / 2) + y * ( GlobalSet.tileH / 2);
        
			return new Point(rx, ry);
		}

		//相对坐标转绝对坐标
		public function relToAbs(x : int, y : int) : Point
		{ 
			var ax : int = ((x - this.mapData.sPt.x) / GlobalSet.tileW - (y - this.mapData.sPt.y) / GlobalSet.tileH );
			var ay : int = ((x - this.mapData.sPt.x) / GlobalSet.tileW + (y - this.mapData.sPt.y) / GlobalSet.tileH );
             
			return new Point(ax, ay);
		}

		//加入排序队列
		public function addSortor(obj : DisplayObject) : void
		{
			if(this.sortArr.indexOf(obj) != -1)
			{
				trace("MapReader -> 重复的排序加入:" + obj);
				return;
			}
			// trace("MapReader -> 加入排序" + obj );
			this.sortArr.push(obj);
		}

		//离开排序队列
		public function delSortor(obj : DisplayObject) : void
		{
			this.sortArr.splice(this.sortArr.indexOf(obj), 1);  
		}

		//根据x,y绝对坐标返回深度
		public function getIndex(x : int, y : int) : int
		{
			return (y - x + this.mapData.mapWidth);
		}

		//排序某个物件
		public function sortObjIndex(obj : DisplayObject) : void
		{ 
			obj["mz"] = this.getIndex(obj["mx"], obj["my"]);
			this.sortArr.sortOn(["mz"], Array.NUMERIC); 
         
			//以下是容错型,防止层级超出范围 
			var z : int = this.sortArr.indexOf(obj);
			if(z == -1)
			{ 
				trace(obj["chName"] + " 不在调整集合内，调整失败！");
				return;
			}
			// trace(obj["chName"] + " 层次调节:" + z + " ，总数" + this.sortArr.length );
			this.actLayer.addChildAt(obj, z);
			return;
			z > this.actLayer.numChildren - 1 ? this.actLayer.addChild(obj) : this.actLayer.addChildAt(obj, z);
		}

		//排序全部
		public function sortAll() : void
		{
			this.sortArr.sortOn(["mz"], Array.NUMERIC);
			for (var i : int = 0;i < this.sortArr.length;i++ ) 
			{ 
				this.actLayer.addChild(this.sortArr[i]); 
			}  
		}
	}
}
