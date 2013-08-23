package inoah.game.ro.modules.map.view
{
    import flash.display.Bitmap;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import inoah.core.Global;
    import inoah.core.SilzAstar;
    import inoah.core.loaders.JpgLoader;
    import inoah.data.map.MapInfo;
    import inoah.data.map.MapLayerInfo;
    import inoah.data.map.MapTileSetInfo;
    import inoah.game.ro.modules.map.view.events.SceneEvent;
    import inoah.interfaces.ICamera;
    import inoah.interfaces.IViewObject;
    import inoah.interfaces.base.ILoader;
    import inoah.interfaces.managers.IAssetMgr;
    import inoah.interfaces.managers.IDisplayMgr;
    import inoah.interfaces.map.IMapInfo;
    import inoah.interfaces.map.IMapLevel;
    import inoah.interfaces.map.IScene;
    import inoah.utils.Counter;
    
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.api.ILogger;
    
    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    public class BaseScene extends starling.display.Sprite implements IScene
    {
        [Inject]
        public var displayMgr:IDisplayMgr;
        
        [Inject]
        public var assetMgr:IAssetMgr;
        
        [Inject]
        public var logger:ILogger;
        
        [Inject]
        public var injector:IInjector;
        
        protected var _mapInfo:MapInfo;
        
        protected var _astar:SilzAstar;
        
        protected var _container:DisplayObjectContainer;
        
        protected var _currentResIndexList:Vector.<String>;
        protected var _currentResList:Vector.<Bitmap>;
        
        protected var _currentTextureAtlasIndexList:Vector.<int>;
        protected var _currentTextureAtlasList:Vector.<TextureAtlas>;
        
        protected var _levelList:Vector.<IMapLevel>;
        protected var _mapImageList:Vector.<Image>;
        
        protected var _drawTileObjList:Vector.<DrawTileObj>;
        protected var _couldTick:Boolean;
        protected var _drawCounter:Counter;
        
        //地图元素
        public var bgLayer : starling.display.Sprite;  //背景层
        public var buildingLayer:starling.display.Sprite;
        public var bgImg : Bitmap; //地表
        protected var cue : Bitmap; //测试用
        public var actLayer : starling.display.Sprite; //动作层  
        private var debugLayer : starling.display.Sprite;
        private var debugMode : Boolean = false; 
        //
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
        
        //        private var mapBg:Bitmap;
        //        public var mapContainer:flash.display.Sprite;
        
        //
        private var m_mapWid:int = 0;
        private var m_mapHei:int = 0;
        
        private var m_orgX:Number = 0;
        private var m_orgY:Number = 0;
        
        private var m_xincX:Number = 0;
        private var m_xincY:Number = 0;
        private var m_yincX:Number = 0;
        private var m_yincY:Number = 0;
        private var lightBlockSp:Shape;
        private var _roadMap:Vector.<Point>;
        private var _startPos:Point;
        private var _endPos:Point;
        private var _eventLayer:starling.display.Sprite;
        
        
        public function BaseScene()
        {
            super();
        }
        
        public function initScene( container:DisplayObjectContainer , mapInfo:IMapInfo ):void
        {
            _container = container;
            
            _eventLayer = new starling.display.Sprite();
            _container.addChild( _eventLayer );
            
            bgLayer = new starling.display.Sprite();
            //            bgLayer.touchable = false;
            _container.addChild( bgLayer );
            
            buildingLayer = new starling.display.Sprite();
            _container.addChild( buildingLayer );
            
            _levelList = new Vector.<IMapLevel>();
            _currentResIndexList = new Vector.<String>();
            _currentResList = new Vector.<Bitmap>();
            _currentTextureAtlasIndexList = new Vector.<int>();
            _currentTextureAtlasList = new Vector.<TextureAtlas>();
            _mapImageList = new Vector.<Image>();
            _drawCounter = new Counter();
            _drawCounter.initialize();
            
            _mapInfo = mapInfo as MapInfo;
            
            var count:Number = _mapInfo.width + _mapInfo.height
            var mapRange:Rectangle = new Rectangle( 0 , 0 , _mapInfo.tilewidth * _mapInfo.width , _mapInfo.tileheight * _mapInfo.height );
            m_orgX = mapRange.left + mapRange.width / count;
            m_orgY = mapRange.top + _mapInfo.height * mapRange.height / count;
            m_xincX = mapRange.width / count;
            m_xincY = - mapRange.height / count;
            m_yincX = mapRange.width / count;
            m_yincY = mapRange.height / count;
            
            var mapLayerInfo:MapLayerInfo = _mapInfo.layers[1];
            //生成寻路层
            
            makeRoadMap( mapLayerInfo );
            
            //            var mapBgSp:Shape = new Shape();
            //            for( var xx:int = 0; xx < 50 ; xx ++ )
            //            {
            //                for( var yy:int = 0; yy< 50; yy++)
            //                {
            //                    drawTile( mapBgSp ,  GridToView( xx , yy ).x , GridToView( xx,  yy).y );
            //                }
            //            }
            //            mapBg = new Bitmap( new BitmapData( Global.MAP_W , Global.MAP_H , true , 0x0 ) );
            //            mapContainer = new flash.display.Sprite();
            //            Starling.current.nativeOverlay.addChild( mapContainer );
            //            mapContainer.addChild( mapBg );
            //            mapBg.bitmapData.draw( mapBgSp );
            
            var resList:Vector.<String> = new Vector.<String>();
            var len:int = _mapInfo.tilesets.length;
            for( var i:int =0;i<len;i++)
            {
                resList.push( "map/" + _mapInfo.tilesets[i].image );
                _currentResIndexList.push( "map/" + _mapInfo.tilesets[i].image );
            }
            assetMgr.getResList( resList , onLoadMapRes );
            
            _container.addEventListener( TouchEvent.TOUCH , onTouch );
        }
        
        private function onTouch( e:TouchEvent ):void
        {
            var touch:Touch = e.getTouch( _container );
            if( touch && touch.phase == TouchPhase.BEGAN )
            {
                var pos:Point = touch.getLocation( _container );
                var touchGrid:Point = ViewToGrid(pos.x , pos.y );
                dispatchEvent( new SceneEvent( SceneEvent.MAP_TOUCH , touchGrid ) );
            }
        }
        
        private function makeRoadMap( mapLayerInfo:MapLayerInfo ):void
        {
            var p:Point;
            p = new Point( _mapInfo.layers[2].objects[0].x / _mapInfo.tileheight , _mapInfo.layers[2].objects[0].y / _mapInfo.tileheight );
            _startPos = new Point( _mapInfo.height - p.y , p.x );
            p = new Point( _mapInfo.layers[2].objects[1].x / _mapInfo.tileheight , _mapInfo.layers[2].objects[1].y / _mapInfo.tileheight );
            _endPos =  new Point( _mapInfo.height - p.y , p.x );
            
            var arr:Array = [];
            for( var _YY:int = 0;_YY < mapLayerInfo.height ; _YY++)
            {
                arr[_YY] = [];
                var str:String = "";
                for( var _XX:int = 0;_XX < mapLayerInfo.width ; _XX++)
                {
                    arr[_YY][_XX] = mapLayerInfo.data[ mapLayerInfo.width * ( mapLayerInfo.height - 1 - _XX ) + _YY  ] != 0 ? 0 : 1;
                    str += arr[_YY][_XX];
                }
            }
            
            var astarCon:flash.display.Sprite = new flash.display.Sprite();
            astarCon.mouseChildren = false;
            astarCon.mouseEnabled = false;
            Starling.current.nativeStage.addChild( astarCon );
            
            _astar = new SilzAstar( arr );
            //            _astar = new SilzAstar( arr , astarCon );
            _roadMap = new Vector.<Point>()
            var nodeArr:Array = _astar.find( _startPos.x , _startPos.y , _endPos.x, _endPos.y );
            if(nodeArr)
            {
                for(var i:int=0,j:int=nodeArr.length;i<j;i++)
                {
                    _roadMap.push( new Point( nodeArr[i].x,nodeArr[i].y ) );
                }
            }
        }
        
        private function onLoadMapRes( loader:ILoader ):void
        {
            var tileSetList:Vector.<MapTileSetInfo> = _mapInfo.tilesets;
            var tileSet:MapTileSetInfo;
            var len:int = tileSetList.length;
            var iCount:int = 1;
            _currentTextureAtlasIndexList.push( int.MAX_VALUE );
            for( var i:int =0;i<len;i++)
            {
                tileSet = tileSetList[i];
                //get bitmap
                _currentResList.push( (assetMgr.getRes( "map/" + tileSet.image ,null ) as JpgLoader).displayObj as Bitmap );
                //get textureAtlas
                var texture:Texture = Texture.fromBitmap( _currentResList[i], false );
                var atlasXml:XML = XML('<texture id="'+tileSet.name+'" width="'+2048+'" height="'+2048+'"></texture>');
                var sequenceCount:int = tileSet.imagewidth / tileSet.tilewidth * tileSet.imageheight / tileSet.tileheight;
                var subTexture:XML;
                var sx:int = 0;
                var sy:int = 0;
                var soffx:int = 0;
                var soffy:int = 0;
                for(var j:int = 0; j<sequenceCount; j++)
                {
                    subTexture = XML(<SubTexture />);
                    _currentTextureAtlasIndexList[iCount] = i;
                    subTexture.@name =  iCount.toString();
                    iCount ++;
                    subTexture.@width = tileSet.tilewidth;
                    subTexture.@height = tileSet.tileheight;
                    subTexture.@x = sx;
                    subTexture.@y = sy;
                    subTexture.@frameX = 0;
                    subTexture.@frameY = 0;
                    subTexture.@frameWidth = tileSet.tilewidth;
                    subTexture.@frameHeight = tileSet.tileheight;
                    atlasXml.appendChild(subTexture);
                    sx += tileSet.tilewidth;
                    if( sx >= tileSet.imagewidth )
                    {
                        sx = 0
                        sy += tileSet.tileheight;
                    }
                }
                _currentTextureAtlasList.push( new TextureAtlas( texture, atlasXml ) );
            }
            
            updateMap();
        }
        
        public function tick( delta:Number ):void
        {
            if( !_couldTick )
            {
                return;
            }
        }
        
        public function updateMap():void
        {
            var camera:ICamera = injector.getInstance(ICamera) as ICamera;
            //            var cp : Point = relToAbs( camera.zeroX + 480, camera.zeroY + 320 );
            //屏幕中心点sPos
            var centerPos:Point = new Point( camera.zeroX + 960 / 2 , camera.zeroY + 640 / 2 );
            var cp:Point = ViewToGrid( centerPos.x , centerPos.y );
            //屏幕中心点bPos
            var lightBlock:Point = ViewToGrid( centerPos.x, centerPos.y );
            
            //            if( !lightBlockSp )
            //            {
            //                lightBlockSp = new Shape();
            //                mapContainer.addChild(lightBlockSp);
            //            }
            //            else
            //            {
            //                lightBlockSp.graphics.clear();
            //                
            //                var drawBlockPos:Point = GridToView( lightBlock.x , lightBlock.y );
            //                drawTile( lightBlockSp , drawBlockPos.x , drawBlockPos.y , 0x00ff00 );
            //            }
            var area : int = Global.redrawW + Global.redrawH;
            var newTileDict : Object = {};
            //            for(var _XX :int = cp.x - area; _XX  <= cp.x + area ; _XX ++)
            //            {
            //                for(var _YY :int = cp.y - area ; _YY  <= cp.y + area ; _YY ++)
            for(var _XX :int = cp.x + area; _XX  > cp.x - area ; _XX --)
            {
                for(var _YY :int = cp.y - area ; _YY  <= cp.y + area ; _YY ++)
                {
                    if(_XX  >= 0 && _XX  < _mapInfo.layers[0].width && _YY  >= 0 && _YY  < _mapInfo.layers[0].height)
                    {
                        if(Math.abs((_YY  - cp.y - _XX  + cp.x) / 2) <= Global.redrawH && Math.abs((_XX  - cp.x + _YY  - cp.y) / 2) <= Global.redrawW)
                        {
                            //                            if(lightBlockSp)
                            //                            {
                            //                                var pos:Point = GridToView( _XX, _YY);
                            //                                drawTile( lightBlockSp , pos.x , pos.y , 0x999999 );
                            //                            }
                            
                            if( _mapInfo.layers[0].type == "tilelayer" )
                            {
                                addTile( _XX  , _YY  );
                            }
                            newTileDict[ _XX  + "," + _YY ] = true;
                            //                            else if( _mapInfo.layers[0].type == "objectgroup" )
                            //                            {
                            //                                addObj
                            //                            }
                        }
                    }
                }
            }
            for(var k:String in nowTileDict)
            {
                newTileDict[k] || delTile(k); 
            }
            _couldTick = true;
            //            for( k in nowObjectDict)
            //            {
            //                newTileDict[k] || delObj(k);
            //            }
            
            //            var len:int = _mapInfo.layers.length;
        }
        
        /**
         * 
         */        
        protected function addTile( _XX  : int, _YY : int ) : void
        {  
            var tileImage:TileImage;
            if( nowTileDict[_XX  + "," + _YY] )
            {
                bgLayer.addChild( nowTileDict[_XX  + "," + _YY] );
                return;
            }
            else
            {
                //                tileImage = new TileImage( 0 , _currentTextureAtlasList[0].getTexture( _mapInfo.layers[0].data[ _YY * _mapInfo.width + _XX  ].toString() ));  
                tileImage = new TileImage( 0 , _currentTextureAtlasList[0].getTexture( _mapInfo.layers[0].data[ _mapInfo.layers[0].width * ( _mapInfo.layers[0].height - 1 - _XX ) + _YY  ].toString() ));  
                bgLayer.addChild( tileImage );
                
                var pt : Point = GridToView(_XX , _YY);  
                tileImage.x = pt.x - Global.TILE_W / 2;
                tileImage.y = pt.y - Global.TILE_H * 3 / 2; 
                nowTileDict[_XX  + "," + _YY] = tileImage;
            }
        }
        
        public function addBuilding( _XX:int , _YY:int , id:int , textureStr:String ):IViewObject
        {
            var building:TileBuilding = new TileBuilding( id , _currentTextureAtlasList[1].getTexture( textureStr ) );
//            buildingLayer.addChild( building );
            var pt : Point = GridToView(_XX , _YY); 
            building.x = pt.x - Global.TILE_W / 2;
            building.y = pt.y - Global.TILE_H  * 7 / 2  ; 
            return building;
        }
        
        private function delTile(k : String) : void
        {  
            nowTileDict[k].removeFromParent();
            //            bgLayer.removeChild( nowTileDict[k] );
            delete nowTileDict[k];
        } 
        
        //重设地图原点位置的偏移（用于地图滑动）
        public function SetOrgin( xpos:Number, ypos:Number ):void
        {
            m_orgX = xpos;
            m_orgY = ypos;
        }
        
        //地图网格坐标转换到屏幕显示坐标（用于提供给描画用）
        public function GridToView( xpos:int, ypos:int ):Point
        {
            var pos:Point = new Point();
            
            pos.x = m_orgX + m_xincX * xpos + m_yincX * ypos;
            pos.y = m_orgY + m_xincY * xpos + m_yincY * ypos;
            
            return pos;
        }
        
        //屏幕坐标转换到地图网格坐标（比如在即时战略中用于确定鼠标点击的是哪一块）
        public function ViewToGrid( xpos:Number, ypos:Number ):Point
        {
            var pos:Point = new Point();
            
            var coordX:Number = xpos - m_orgX;
            var coordY:Number = ypos - m_orgY;
            
            pos.x = ( coordX * m_yincY - coordY * m_yincX ) / ( m_xincX * m_yincY - m_xincY * m_yincX );
            pos.y = ( coordX - m_xincX * pos.x ) / m_yincX;
            
            pos.x = Math.round( pos.x );
            pos.y = Math.round( pos.y );
            
            return pos;
        }
        
        //判断网格坐标是否在地图范围内
        public function LegalGridCoord( xpos:int, ypos:int ):Boolean
        {
            if ( xpos < 0 || ypos < 0 || xpos >= m_mapWid || ypos >= m_mapHei )
            {
                return false;
            }
            
            return true;
        }
        
        //判断屏幕坐标是否在地图范围内
        public function LegalViewCoord( xpos:Number, ypos:Number ):Boolean
        {
            var pos:Point = ViewToGrid( xpos, ypos );
            
            return LegalGridCoord( pos.x, pos.y );
        }
        
        //格式化屏幕坐标，即返回最接近该坐标的一个格子的标准屏幕坐标（通常用于在地图中拖动建筑物对齐网格用）
        public function FormatViewPos( xpos:Number, ypos:Number ):Point
        {
            var pos:Point = ViewToGrid( xpos, ypos );
            
            if ( LegalGridCoord( pos.x, pos.y ) )
            {
                pos = GridToView( pos.x, pos.y );
            }else
            {
                pos.x = xpos;
                pos.y = ypos;
            }
            
            return pos;
        }
        
        //        protected function drawTile( shape:Shape, x:int , y:int , color:int = -1 ):void
        //        {
        //            if(color!= -1)
        //            {
        //                shape.graphics.beginFill( color , 0.5 );
        //            }
        //            else
        //            {
        //                shape.graphics.beginFill( 0x0 , 0 );
        //            }
        //            shape.graphics.lineStyle( 1 , 0xffffff , 0.5 );
        //            shape.graphics.moveTo( x , y - Global.TILE_H/2 );
        //            shape.graphics.lineTo( x + Global.TILE_W/2 , y );
        //            shape.graphics.lineTo( x , y + Global.TILE_H/2 );
        //            shape.graphics.lineTo( x - Global.TILE_W/2, y );
        //            shape.graphics.lineTo( x , y - Global.TILE_H/2 );
        //            shape.graphics.endFill();
        //        }
        
        public function get roadMap():Vector.<Point>
        {
            return _roadMap;
        }
        
        public function get couldTick():Boolean
        {
            return _couldTick;
        }
    }
}