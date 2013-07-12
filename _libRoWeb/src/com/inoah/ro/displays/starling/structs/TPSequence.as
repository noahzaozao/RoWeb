package com.inoah.ro.displays.starling.structs
{
    import flash.geom.Point;
    
    import starling.textures.Texture;
    
    public class TPSequence
    {
        private var _texture:Texture;
        
        private var _offset:Point;
        
        public function TPSequence(texture:Texture, offset:Point)
        {
            _texture = texture;
            _offset = offset;
        }
        
        public function get texture():Texture
        {
            return _texture;
        }
        
        public function get offset():Point
        {
            return _offset;
        }
        
    }
}