package inoah.data.map
{
    public class MapLayerInfo
    {
        private var _x:int;
        private var _y:int;
        private var _w:int;
        private var _h:int;
        private var _name:String;
        private var _opacity:int;
        private var _type:String;
        private var _visible:Boolean;
        private var _data:Vector.<uint>;
        private var _objects:Vector.<MapObjectInfo>;
        
        public function MapLayerInfo( data:Object )
        {
            _x = data.x;
            _y = data.y;
            _w = data.width;
            _h = data.height;
            _name = data.name;
            _opacity = data.opacity;
            _visible = data.visible;
            _type = data.type;
            if( _type == "tilelayer" )
            {
                _data = new Vector.<uint>();
                var dataArr:Array = data.data;
                var len:int = dataArr.length;
                for( var i:int = 0;i<len;i++)
                {
                    _data[i] = dataArr[i];
                }
            }
            else if( _type == "objectgroup" )
            {
                _objects = new Vector.<MapObjectInfo>();
                var objectArr:Array = data.objects;
                len = objectArr.length;
                for( i = 0;i<len;i++)
                {
                    _objects[i] = new MapObjectInfo( objectArr[i] );
                }
            }
        }

        public function get x():int
        {
            return _x;
        }

        public function get y():int
        {
            return _y;
        }

        public function get width():int
        {
            return _w;
        }

        public function get height():int
        {
            return _h;
        }

        public function get name():String
        {
            return _name;
        }

        public function get opacity():int
        {
            return _opacity;
        }

        public function get type():String
        {
            return _type;
        }

        public function get visible():Boolean
        {
            return _visible;
        }

        public function get data():Vector.<uint>
        {
            return _data;
        }

        public function get objects():Vector.<MapObjectInfo>
        {
            return _objects;
        }

    }
}