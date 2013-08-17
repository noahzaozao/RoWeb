package inoah.data.map
{
    import flash.geom.Point;
    
    import inoah.interfaces.map.IMapInfo;
    
    public class MapInfo implements IMapInfo
    {
        protected var _mapId:int;
        protected var _mapName:String = "";
        
        protected var _w:int;
        protected var _h:int;
        protected var _layers:Vector.<MapLayerInfo>;
        protected var _orientation:String;
        protected var _properties:Object;
        protected var _tilewidth:int;
        protected var _tileheight:int;
        protected var _tilesets:Vector.<MapTileSetInfo>;
        protected var _version:int;
        
        //        protected var tileData : Array = []; //地图数据,2维数组 
        //        protected var objData : Array = []; //物件数据
        //        protected var bigObjData : Array = []; //大物件数据
        //        protected var signData : Array = []; //逻辑数据
        //        protected var npcDict : Object = {}; //动态NPC数据
        //        protected var warpDict : Object = {}; //跳转点
        //        protected var hinder : Object = { };  
        //        protected var bgmName : String = ""; //BGM 
        protected var _sPt : Point = new Point(0, 0); //00点位置
        //        protected var fileList : Array = [];
        
        public function MapInfo( jsonObj:Object )
        {
            _w = jsonObj.width;
            _h = jsonObj.height;
            _orientation = jsonObj.orientation;
            _properties = jsonObj.properties;
            _tilewidth = jsonObj.tilewidth;
            _tileheight = jsonObj.tileheight;
            _version = jsonObj.version;
            _sPt.x = _w * _tilewidth / 2;
            _sPt.y = _h * _tileheight / 2;
            
            _layers = new Vector.<MapLayerInfo>();
            var layerArr:Array = jsonObj.layers;
            var len:int = layerArr.length;
            for ( var i:int=0;i<len;i++)
            {
                _layers[i] = new MapLayerInfo( layerArr[i] );
            }
            
            _tilesets = new Vector.<MapTileSetInfo>();
            var tilesetArr:Array = jsonObj.tilesets;
            len = tilesetArr.length;
            for( i=0;i<len;i++)
            {
                _tilesets[i] = new MapTileSetInfo( tilesetArr[i] );
            }
        }
        
        public function get width():int
        {
            return _w;
        }
        
        public function get height():int
        {
            return _h;
        }
        
        public function get layers():Vector.<MapLayerInfo>
        {
            return _layers;
        }
        
        public function get orientation():String
        {
            return _orientation;
        }
        
        public function get tilewidth():int
        {
            return _tilewidth;
        }
        
        public function get tileheight():int
        {
            return _tileheight;
        }
        
        public function get tilesets():Vector.<MapTileSetInfo>
        {
            return _tilesets;
        }
        
        public function get version():int
        {
            return _version;
        }
        
        public function get properties():Object
        {
            return _properties;
        }
        
        public function get sPt():Point
        {
            return _sPt;
        }
    }
}