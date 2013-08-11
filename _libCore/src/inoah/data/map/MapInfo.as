package inoah.data.map
{
    import inoah.interfaces.map.IMapInfo;

    public class MapInfo implements IMapInfo
    {
        private var _w:int;
        private var _h:int;
        private var _layers:Vector.<MapLayerInfo>;
        private var _orientation:String;
        private var _properties:Object;
        private var _tilewidth:int;
        private var _tileheight:int;
        private var _tilesets:Vector.<MapTileSetInfo>;
        private var _version:int;
        
        public function MapInfo( jsonObj:Object )
        {
            _w = jsonObj.width;
            _h = jsonObj.height;
            _orientation = jsonObj.orientation;
            _properties = jsonObj.properties;
            _tilewidth = jsonObj.tilewidth;
            _tileheight = jsonObj.tileheight;
            _version = jsonObj.version;
            
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


    }
}