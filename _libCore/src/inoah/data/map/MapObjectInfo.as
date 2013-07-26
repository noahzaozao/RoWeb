package inoah.data.map
{
    public class MapObjectInfo
    {
        private var _gid:int;
        private var _x:int;
        private var _y:int;
        private var _w:int;
        private var _h:int;
        private var _name:String;
        private var _type:String;
        private var _properties:Object;
        private var _visible:Boolean;
        
        public function MapObjectInfo( data:Object )
        {
            _gid = data.gid;
            _x = data.x;
            _y = data.y;
            _w = data.width;
            _h = data.height;
            _name = data.name;
            _type = data.type;
            _properties = data.properties;
            _visible = data.visible;
        }

        public function get gid():int
        {
            return _gid;
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

        public function get type():String
        {
            return _type;
        }

        public function get properties():Object
        {
            return _properties;
        }

        public function get visible():Boolean
        {
            return _visible;
        }
    }
}