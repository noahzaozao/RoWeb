package com.inoah.ro.displays
{
    import flash.display.Sprite;
    import flash.geom.Point;
    
    public class BaseObject extends Sprite
    {
        protected var _posX:Number;
        protected var _posY:Number;
        protected var _offsetX:Number;
        protected var _offsetY:Number;
        protected var _pos:Point;
        
        public function get pos():Point
        {
            if( _pos.x != _posX - _offsetX )
            {
                _pos.x = _posX - _offsetX;
            }
            if( _pos.y != _posY - _offsetY )
            {
                _pos.x = _posY - _offsetY;
            }
            return _pos;
        }
        
        public function BaseObject()
        {
            super();
            _pos = new Point();
        }
        
        public function set offsetX( value:Number ):void
        {
            _offsetX = value;
        }
        
        public function set offsetY( value:Number ):void
        {
            _offsetY = value;
        }
        public function get posX():Number
        {
            return _posX;
        }
        
        public function get posY():Number
        {
            return _posY;
        }
        public function set posX( value:Number ):void
        {
            _posX = value;
        }
        
        public function set posY( value:Number ):void
        {
            _posY = value;
        }
        
        public function tick(delta:Number):void
        {
            this.x = int(_posX + _offsetX);
            this.y = int(_posY + _offsetY);
        }
    }
}