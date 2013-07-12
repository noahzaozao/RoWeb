package com.inoah.ro.displays.actspr.structs.acth
{
    import flash.utils.ByteArray;

    public class AnyPatSprV0204 extends AnyPatSprV0201
    {
        protected var _xMag:Number; //float
        protected var _yMag:Number; //float
        
        public function AnyPatSprV0204()
        {
        }
        
        override public function init( data:ByteArray ):void
        {
            _xOffs = data.readInt();
            _yOffs = data.readInt();
            _sprNo = data.readUnsignedInt();
            _mirrorOn = data.readUnsignedInt();
            _color = data.readUnsignedInt();
            _xMag = data.readFloat();
            _yMag = data.readFloat();
            _rot = data.readUnsignedInt();
            _spType = data.readUnsignedInt();
        }
        
        override public function get xMag():Number
        {
            return _xMag;
        }
        override public function set xMag( value:Number ):void
        {
            _xMag = value;
        }
        override public function get yMag():Number
        {
            return _yMag;
        } 
        override public function set yMag( value:Number ):void
        {
            _yMag = value;
        }
    }
}