/**
 * FlexGame 网页游戏引擎
 * 卡马克地图算法
 * Author:D5Power
 * Ver: 1.0
 */ 
package com.D5Power.map
{
    import com.D5Power.D5Game;
    import com.D5Power.Controler.Actions;
    import com.D5Power.core.SilzAstar;
    import com.D5Power.loader.DLoader;
    import com.D5Power.ns.D5Map;
    import com.D5Power.ns.NSCamera;
    import com.D5Power.utils.XYArray;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.Shape;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    use namespace D5Map;
    use namespace NSCamera;
    
    public class WorldMap implements IEventDispatcher
    {
        /**
         * 地图ID
         */ 
        private var _mapid:uint = 0;
        
        public var hasTile:uint = 0;
        
        public static var LIB_DIR:String = 'asset/';
        
        /**
         * 常量 寻路格子宽度
         */
        public static var tileWidth:uint = 15;
        /**
         * 常量 寻路格子高度
         */ 
        public static var tileHeight:uint = 15;
        
        /**
         * 寻路
         */ 
        private static var _AStar:SilzAstar;
        
        /**
         * 摄像机范围扩展
         */ 
        public static var cameraAdd:uint = 100;
        
        /**
         * 大地图循环块的格式
         */ 
        private var _tileFormat:String = '';
        
        /**
         * 是否有新数据
         */ 
        private var _hasData:Boolean=false;
        /**
         * 数据资源加载 或者用XML
         */
        private var _urlLoad:URLLoader;
        
        /**
         * 地图数组
         */ 
        private var _arry:Array;
        
        /**
         * 地图缓冲区（源地图）
         */
        protected var buffer:BitmapData;
        
        /**
         * 地图绘制区
         */ 
        protected var _dbuffer:Shape;
        
        /**
         * 偏移量X
         */ 
        private var _offsetX:int=0;
        
        /**
         * 偏移量Y
         */ 
        private var _offsetY:int=0;
        
        /**
         * 显示区域X数量
         */
        private var _areaX:uint;
        
        /**
         *	显示区域Y数量
         */ 
        private var _areaY:uint;
        
        /**
         * 缓冲尺寸
         */ 
        private var buffSize:XYArray;
        
        /**
         * 角色初始坐标 
         */
        private var start:XYArray;
        
        /**
         * 地图的移动目标
         */ 
        private var target:XYArray;
        
        /**
         * 地图卷动速度
         */ 
        private var speed:uint=1;
        
        /**
         * 当前屏幕正在渲染的坐标记录
         */ 
        private var posFlush:Array;
        
        /**
         * 路点位图
         */ 
        private var _roadMap:BitmapData;
        
        /**
         * 路点位图与地图总尺寸的比例
         */  
        private var _roadK:Number;
        
        /**
         * 用于返回数据的点对象，已防止转换坐标的时候重复进行new操作
         */ 
        private var _turnResult:Point;
        
        protected var eventSender:EventDispatcher;		
        
        /**
         * 循环背景
         */ 
        protected var _loopbg:String;
        
        /**
         * 循环背景数据
         */ 
        protected var _loop_bg_data:BitmapData;
        
        /**
         * 缓存起始X位置，在makeData中放置多次生成占用过多CPU
         */ 
        protected var _nowStartX:uint;
        /**
         * 缓存起始Y位置，在makeData中放置多次生成占用过多CPU
         */
        protected var _nowStartY:uint;
        
        protected var _smallMap:BitmapData;
        
        protected var _scache:BitmapData
        
        protected var _mapComplate:Function;
        
        protected var MapResource:Object;
        
        NSCamera var rendSwitch:Boolean=true;
        
        private var _loadList:Vector.<DLoader> = new Vector.<DLoader>;
        
        private static var _me:WorldMap;
        
        public static function get me():WorldMap
        {
            return _me;
        }
        
        /**
         * @param		mid		地图编号
         */ 
        public function WorldMap(mid:uint)
        {
            if(_me) _me.dispose();
            _me = this;
            _mapid = mid;
            
            eventSender = new EventDispatcher();
            _turnResult = new Point();
            MapResource = {tiles:new Object()};
        }
        
        public function get mapid():uint
        {
            return _mapid;
        }
        
        public function dispose():void
        {
            eventSender = null;
            _turnResult = null;
            MapResource = null;
            
        }
        
        public function resize():void
        {
            if(buffer) buffer.dispose();
            buffer=new BitmapData(Global.W+Global.TILE_SIZE.x,Global.H+Global.TILE_SIZE.y,false);
            
            if(_smallMap)
            {
                var per:Number = _smallMap.width/Global.MAPSIZE.x;
                _scache = new BitmapData(buffer.width*per,buffer.height*per,false,0);
            }
            
            
            // 根据宽高自动计算所能容纳的最大地图数
            _areaX = Math.ceil(Global.W/Global.TILE_SIZE.x)+1;
            _areaY = Math.ceil(Global.H/Global.TILE_SIZE.y)+1;
            
            if(_dbuffer)
            {
                _dbuffer.graphics.clear();
                _dbuffer.graphics.beginBitmapFill(buffer);
                _dbuffer.graphics.drawRect(0,0,buffer.width,buffer.height);
                render(true);
            }
        }
        
        /**
         * 获得某点的地图路点坐标
         */ 
        public function getRoadMapColor(px:uint,py:uint):uint
        {
            px = int(_roadK*px);
            py = int(_roadK*py);
            
            return _roadMap.getPixel(px,py);
        }
        
        /**
         * 获得系列点的坐标是否与某点颜色匹配
         */
        public function roadPointCanPass(color:uint,...args):Boolean
        {
            var count:uint = args.length%2;
            if(count!=0)
            {
                throw new Error("[WorldMap] 坐标队列的个数必须可以被2整除");
            }
            
            var px:uint;
            var py:uint;
            var k:uint;
            
            count = args.length>>1;
            for(var i:uint=0;i<count;i++)
            {
                k = i*2;
                px = int(_roadK*args[k]);
                py = int(_roadK*args[k+1]);
                if(_roadMap.getPixel(px,py)!=color) return false;
            }
            
            return true;
        }
        
        public function setRoadByPoint(color:uint,...args):Boolean
        {
            var count:uint = args.length%2;
            
            if(count!=0 || args.length<6)
            {
                throw new Error("[WorldMap] 坐标队列的个数必须大于3个而且可以被2整除");
            }
            
            var shape:Shape= new Shape();
            shape.graphics.beginFill(color);
            var px:uint;
            var py:uint;
            var k:uint;
            var sx:uint;
            var sy:uint;
            
            // 开始转换坐标
            count = args.length>>1;
            
            for(var i:uint=0;i<count;i++)
            {
                k = i*2;
                px = int(_roadK*args[k]);
                py = int(_roadK*args[k+1]);
                
                
                if(k==0)
                {
                    shape.graphics.moveTo(px,py);
                }else{
                    shape.graphics.lineTo(px,py);
                }
                
            }
            shape.graphics.moveTo(sx,sy);
            shape.graphics.endFill();
            
            if(_roadMap!=null) _roadMap.draw(shape);
            shape.graphics.clear();
            shape = null;
            
            updateAstar();
            
            return true;
        }
        
        D5Map function get roadMapData():BitmapData
        {
            return _roadMap;
        }
        
        /**
         * 获取缩略图
         */ 
        public function get smallMap():BitmapData
        {
            return _smallMap;
        }
        
        /**
         * 设置小地图数据加载完成后的响应函数
         * 
         */ 
        public function set mapComplate(f:Function):void
        {
            _mapComplate = f;
        }
        
        /**
         * 更改地图大循环块格式
         */ 
        public function set tileFormat(s:String):void
        {
            _tileFormat = s;
        }
        
        public function get tileFormat():String
        {
            return _tileFormat;
        }
        
        /**
         * 当前地图的路径地图数组
         */ 
        public function get roadMap():Array
        {
            return _arry;
        }
        
        /**
         * 当前地图的路径地图数组
         */ 
        public function set roadMap(arr:Array):void
        {
            _arry = arr;	
        }
        
        
        public function set loopBG(s:String):void
        {
            _loopbg = String(s);
            if(_loopbg=='null' || _loopbg=='') return;
            var loader:DLoader = new DLoader();
            loader.name = LIB_DIR+_loopbg;
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,updateLoopBg);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
            loader.load(new URLRequest(LIB_DIR+_loopbg));
            
            //trace(LIB_DIR+_loopbg);
        }
        
        public function get loopBG():String
        {
            return _loopbg;
        }
        
        /**
         * 获取寻路对象
         */ 
        public static function get AStar():SilzAstar
        {
            return _AStar;
        }
        
        D5Map function flushMap():void
        {
            if(posFlush!=null) posFlush.splice(0,posFlush.length);
            posFlush=null;
            loadSmallMap();
        }
        
        /**
         * 判断是否在透明碰撞区域
         */ 
        public function isInAlphaArea(wx:uint,wy:uint):Boolean
        {
            if(_roadMap==null) return false;
            return _roadMap.getPixel(int(_roadMap.width/Global.MAPSIZE.x*wx),int(_roadMap.height/Global.MAPSIZE.y*wy))==0xff00ff;
        }
        
        
        /**
         * 根据屏幕某点坐标获取其在世界（全地图）内的坐标
         */ 
        public function getWorldPostion(x:Number,y:Number):Point
        {
            _turnResult.x = D5Game.me.camera.zeroX+x;
            _turnResult.y = D5Game.me.camera.zeroY+y;
            
            return _turnResult;
        }
        
        /**
         * 根据世界坐标获取在屏幕内的坐标
         */ 
        public function getScreenPostion(x:Number,y:Number):Point
        {			
            _turnResult.x = x-D5Game.me.camera.zeroX;
            _turnResult.y = y-D5Game.me.camera.zeroY;
            return _turnResult;
        }
        
        /**
         * 根据路点获得世界（全地图）内的坐标
         */ 
        public function tile2WorldPostion(x:Number,y:Number):Point
        {
            _turnResult.x = x*tileWidth+tileWidth*.5;
            _turnResult.y = y*tileHeight+tileHeight*.5;
            return _turnResult;
        }
        
        /**
         * 世界地图到路点的转换
         */ 
        public function Postion2Tile(px:uint,py:uint):Point
        {
            _turnResult.x = int(px/tileWidth);
            _turnResult.y = int(py/tileHeight);
            return _turnResult;
        }
        
        public function set dbuffer(v:Shape):void
        {
            _dbuffer = v;
        }
        
        /**
         * 渲染
         */ 
        public function render(mustFlush:Boolean=false):void
        {
            if(D5Game.me.camera.focusObject!=null && D5Game.me.camera.focusObject.action==Actions.Wait && !mustFlush) return;
            
            var startx:int = int(D5Game.me.camera.zeroX/Global.TILE_SIZE.x);
            var starty:int = int(D5Game.me.camera.zeroY/Global.TILE_SIZE.y);
            
            makeData(startx,starty,mustFlush); // 只有在采用大地图背景的前提下才不断修正数据
            
            if(_nowStartX==startx && _nowStartY==starty && posFlush!=null)
            {
                var zero_x:int = D5Game.me.camera.zeroX%Global.TILE_SIZE.x;
                var zero_y:int = D5Game.me.camera.zeroY%Global.TILE_SIZE.y;
                _dbuffer.x = -zero_x;
                _dbuffer.y = -zero_y;
            }
            
            rendSwitch = false;
            renderAction();
        }
        
        public function reset():void
        {
            clear();
            buffer.fillRect(buffer.rect,0);
        }
        
        /**
         * 初始化地图
         */ 
        public function install():void
        {
            // 读取地图缩略
            loadSmallMap();
        }
        
        protected function renderAction():void
        {
            
        }
        
        /**
         * 读取地图缩略图
         */ 
        protected function loadSmallMap():void
        {
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onSmallMapLoaded);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,smallMapError);
            loader.load(new URLRequest(Global.httpServer+LIB_DIR+'tiles/'+_mapid+'/s.jpg'));
        }
        
        /**
         * 读取地图路点图
         */ 
        protected function loadRoadMap():void
        {
            // 根据宽高自动计算所能容纳的最大地图数
            resize();
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,configRoadMap);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,RoadLoadError);
            loader.load(new URLRequest(LIB_DIR+"RoadMap/map"+_mapid+".png"));
        }
        
        /**
         * 重置地图数据
         */ 
        protected function resetRoad():void
        {
            _arry=[];
            // 定义临时地图数据
            var h:int =int(Global.MAPSIZE.y/tileHeight);
            var w:int = int(Global.MAPSIZE.x/tileWidth);
            for(var y:uint = 0;y<h;y++)
            {
                var arr:Array = new Array();
                for(var x:uint = 0;x<w;x++)
                {
                    arr.push(0);
                }
                _arry.push(arr);
            }
        }
        
        private function smallMapError(e:IOErrorEvent):void
        {
            var loadinfo:LoaderInfo = e.target as LoaderInfo;
            
            loadinfo.removeEventListener(Event.COMPLETE,onSmallMapLoaded);
            loadinfo.removeEventListener(IOErrorEvent.IO_ERROR,smallMapError);
            //trace("Small map load error.url is "+(e.target as LoaderInfo).loaderURL);
            loadRoadMap();
        }
        
        /**
         * 路点加载完成，更新路点
         */ 
        private function configRoadMap(e:Event):void
        {
            var loadinfo:LoaderInfo = e.target as LoaderInfo;
            
            loadinfo.removeEventListener(Event.COMPLETE,configRoadMap);
            loadinfo.removeEventListener(IOErrorEvent.IO_ERROR,RoadLoadError);
            
            resetRoad();
            _roadMap = (loadinfo.content as Bitmap).bitmapData;
            _roadK =  _roadMap.width/Global.MAPSIZE.x;
            
            loadinfo.loader.unload();
            updateAstar();
            
            dispatchEvent(new Event(Event.COMPLETE));
            if(_mapComplate!=null) _mapComplate();
        }
        
        /**
         * 路点不存在，设置路点可行
         */ 
        private function RoadLoadError(e:ErrorEvent):void
        {
            var loadinfo:LoaderInfo = e.target as LoaderInfo;
            
            loadinfo.removeEventListener(Event.COMPLETE,configRoadMap);
            loadinfo.removeEventListener(IOErrorEvent.IO_ERROR,RoadLoadError);
            
            resetRoad();
            
            _roadMap = new BitmapData(int(Global.MAPSIZE.x*.1),int(Global.MAPSIZE.y*.1),false,0xffffff);
            _roadK =  _roadMap.width/Global.MAPSIZE.x;
            
            updateAstar();
            
            dispatchEvent(new Event(Event.COMPLETE));
            if(_mapComplate!=null) _mapComplate();
        }
        
        private function updateAstar():void
        {
            var h:int = int(Global.MAPSIZE.y/tileHeight);
            var w:int = int(Global.MAPSIZE.x/tileWidth);
            
            for(var y:uint = 0;y<h;y++)
            {
                for(var x:uint = 0;x<w;x++)
                {
                    _arry[y][x] = _roadMap.getPixel(int(tileWidth*x*_roadK),int(tileHeight*y*_roadK))==0 ? 1 : 0;
                }
            }
            
            
            _AStar = new SilzAstar(_arry);
        }
        
        /**
         * 缩略图加载完成
         */ 
        private function onSmallMapLoaded(e:Event):void
        {
            var loadinfo:LoaderInfo = e.target as LoaderInfo;
            
            loadinfo.removeEventListener(Event.COMPLETE,onSmallMapLoaded);
            loadinfo.removeEventListener(IOErrorEvent.IO_ERROR,smallMapError);
            
            _smallMap = (loadinfo.content as Bitmap).bitmapData;
            
            loadinfo.loader.unload();
            loadinfo = null;
            
            makeData();
            loadRoadMap();
        }
        
        /**
         * 更新当前需要读取的地图数据
         * @param	mustFlush	强制刷新
         */ 
        protected function makeData(startx:int=-1,starty:int=-1,mustFlush:Boolean=false):void
        {
            // 根据00点坐标，计算地图渲染的开始区块坐标
            if(startx==-1)
            {
                startx = int(D5Game.me.camera.zeroX/Global.TILE_SIZE.x);
                starty = int(D5Game.me.camera.zeroY/Global.TILE_SIZE.y);
            }
            
            
            if(_nowStartX==startx && _nowStartY==starty && posFlush!=null && !mustFlush) return;
            
            _nowStartX = startx;
            _nowStartY = starty;
            
            if(posFlush!=null)
            {
                posFlush.splice(0,posFlush.length);
            }else{
                posFlush = new Array();
            }
            
            fillSmallMap(startx,starty);
            
            var maxY:uint = Math.min(starty+_areaY,int(Global.MAPSIZE.y/Global.TILE_SIZE.y));
            var maxX:uint = Math.min(startx+_areaX,int(Global.MAPSIZE.x/Global.TILE_SIZE.x));
            
            for(var y:int=starty;y<maxY;y++)
            {
                var temp:Array = new Array();
                for(var x:int=startx;x<maxX;x++)
                {
                    if(x<0 || y<0)
                    {
                        temp.push(null);
                    }else{
                        temp.push(y+'_'+x);
                    }
                }
                posFlush.push(temp);
            }
            
            loadTites();
            
        }
        
        protected function fillSmallMap(startx:uint,starty:uint):void
        {
            if(_smallMap==null || _scache==null) return;
            
            // 使用缩略图进行填充
            var per:Number = _smallMap.width/Global.MAPSIZE.x;
            _scache.fillRect(_scache.rect,0);
            _scache.copyPixels(_smallMap,new Rectangle(startx*Global.TILE_SIZE.x*per,starty*Global.TILE_SIZE.y*per,_scache.width,_scache.height),new Point());
            per = Global.MAPSIZE.x/_smallMap.width;
            
            buffer.draw(_scache,new Matrix(per,0,0,per),null,null,null,true);
        }
        
        protected function flushAstar():void
        {
            _AStar = new SilzAstar(_arry);
        }
        
        /**
         * 加载当前需要渲染的地图素材
         */ 
        protected function loadTites():void
        {
            var arr:Array;
            
            var y:uint = 0;
            
            _dbuffer.cacheAsBitmap=false;
            for(var k:String in posFlush)
            {
                var _data:Array = posFlush[k];
                var x:uint = 0;
                
                for(var m:String in _data)
                {
                    try
                    {
                        // 先复制循环背景图
                        arr = _data[m].split('_');
                        
                        if(_data[m]==null) continue;
                        if(_tileFormat!='' && MapResource.tiles[_data[m]]==null)
                        {
                            var load:DLoader=new DLoader();
                            load.name = Global.httpServer+LIB_DIR+"tiles/"+_mapid+"/"+_data[m]+"."+_tileFormat;
                            //							trace("tiles/"+_mapid);
                            load.data = _data[m];
                            _loadList.push(load);
                        }else if(MapResource.tiles[_data[m]]!=null){
                            buffer.copyPixels(MapResource.tiles[_data[m]],MapResource.tiles[_data[m]].rect,new Point(x*Global.TILE_SIZE.x,y*Global.TILE_SIZE.y));
                        }
                        
                    }catch(e:Error){
                        
                    }
                    x++;
                }
                y++;
            }
            
            drawLoopGround();
            startLoad();
        }
        
        private function startLoad():void
        {
            if(_loadList.length==0) return;
            var loader:DLoader = _loadList[0];
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,tilesCompele);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
            loader.load(new URLRequest(loader.name));
            
            _loadList.splice(0,1);
        }
        
        /**
         * 数据加载结束后入库
         * 
         */ 
        private function tilesCompele(e:Event):void
        {
            var l:LoaderInfo=e.target as LoaderInfo;
            var loader:DLoader = l.loader as DLoader;
            
            MapResource.tiles[loader.data]= (l.content as Bitmap).bitmapData;
            
            l.removeEventListener(Event.COMPLETE,tilesCompele);
            l.removeEventListener(IOErrorEvent.IO_ERROR,error);
            loader.unload();
            
            var pos:Array = loader.data.split('_');
            buffer.copyPixels(MapResource.tiles[loader.data],MapResource.tiles[loader.data].rect,new Point(int(pos[1]-_nowStartX)*Global.TILE_SIZE.x,int(pos[0]-_nowStartY)*Global.TILE_SIZE.y));
            
            if(_loadList.length>0)
            {
                startLoad();
            }else{
                _dbuffer.cacheAsBitmap=true;
            }
        }		
        
        private function updateLoopBg(e:Event):void
        {
            var l:LoaderInfo=e.target as LoaderInfo;
            var loader:DLoader = l.loader as DLoader;
            
            l.removeEventListener(Event.COMPLETE,tilesCompele);
            l.removeEventListener(IOErrorEvent.IO_ERROR,error);
            
            var img:Bitmap = l.content as Bitmap;
            if(_loop_bg_data!=null) _loop_bg_data.dispose();
            _loop_bg_data = new BitmapData(Global.TILE_SIZE.x,Global.TILE_SIZE.y,false,0);
            _loop_bg_data.draw(img,new Matrix(_loop_bg_data.width/img.width,0,0,_loop_bg_data.height/img.height),null,null,null,true);
            img.bitmapData = null;
            img = null;
            loader.unload();
            
            drawLoopGround();
        }
        
        private function drawLoopGround():void
        {
            if(_loop_bg_data==null) return;
            
            buffer.fillRect(buffer.rect,0);
            for(var i:uint=0,j:uint=Math.ceil(buffer.width/Global.TILE_SIZE.x);i<j;i++)
            {
                for(var m:uint=0,n:uint=Math.ceil(buffer.height/Global.TILE_SIZE.y);m<n;m++)
                {
                    buffer.copyPixels(_loop_bg_data,_loop_bg_data.rect,new Point(Global.TILE_SIZE.x*i,Global.TILE_SIZE.y*m));
                }
            }
        }
        
        private function error(e:IOErrorEvent):void
        {
            try
            {
                var l:LoaderInfo=e.target as LoaderInfo;
                l.removeEventListener(Event.COMPLETE,tilesCompele);
                l.removeEventListener(IOErrorEvent.IO_ERROR,error);
            }catch(e:Error){
                
            }
            trace("加载出错:"+l.loader.name);
        }
        
        /**
         * 清空内存
         */ 
        private function clear():void
        {
            while(posFlush.length) posFlush.shift();
            while(_arry.length) _arry.shift();
            Global.CLEAR();
        }
        
        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
            eventSender.addEventListener(type, listener, useCapture, priority);
        }
        
        public function dispatchEvent(evt:Event):Boolean{
            return eventSender.dispatchEvent(evt);
        }
        
        public function hasEventListener(type:String):Boolean{
            return eventSender.hasEventListener(type);
        }
        
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
            eventSender.removeEventListener(type, listener, useCapture);
        }
        
        public function willTrigger(type:String):Boolean {
            return eventSender.willTrigger(type);
        }
    }
}