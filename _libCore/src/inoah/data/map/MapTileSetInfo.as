package inoah.data.map
{
    public class MapTileSetInfo
    {
        private var _firstgid:int;
        private var _image:String;
        private var _imageheight:int;
        private var _imagewidth:int;
        private var _margin:int;
        private var _name:String;
        private var _properties:Object;
        private var _spacing:int;
        private var _tileheight:int;
        private var _tilewidth:int;
        
        public function MapTileSetInfo( data:Object )
        {
            _firstgid = data.fistgid;
            _image = data.image;
            _imagewidth = data.imagewidth;
            _imageheight = data.imageheight;
            _margin = data.margin;
            _name = data.name;
            _properties = data.properties;
            _spacing = data.spacing;
            _tilewidth = data.tilewidth;
            _tileheight = data.tileheight;
        }

        public function get firstgid():int
        {
            return _firstgid;
        }

        public function get image():String
        {
            return _image;
        }

        public function get imageheight():int
        {
            return _imageheight;
        }

        public function get imagewidth():int
        {
            return _imagewidth;
        }

        public function get margin():int
        {
            return _margin;
        }

        public function get name():String
        {
            return _name;
        }

        public function get spacing():int
        {
            return _spacing;
        }

        public function get tileheight():int
        {
            return _tileheight;
        }

        public function get tilewidth():int
        {
            return _tilewidth;
        }

        public function get properties():Object
        {
            return _properties;
        }

    }
}