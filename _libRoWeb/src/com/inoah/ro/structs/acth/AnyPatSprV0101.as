package com.inoah.ro.structs.acth
{
    import flash.utils.ByteArray;

    public class AnyPatSprV0101 implements IAnyPatSprV0205
    {
        protected var _xOffs:int;
        protected var _yOffs:int;
        protected var _sprNo:uint; //DWORD
        protected var _mirrorOn:uint; //DWORD
        
        public function AnyPatSprV0101()
        {
        }
        
        public function init( data:ByteArray ):void
        {
            _xOffs = data.readInt();
            _yOffs = data.readInt();
            _sprNo = data.readUnsignedInt();
            _mirrorOn = data.readUnsignedInt();
        }

        public function get xOffs():int
        {
            return _xOffs;
        }
        public function set xOffs( value:int ):void
        {
            _xOffs = value;
        }
        public function get yOffs():int
        {
            return _yOffs;
        }
        public function set yOffs( value:int ):void
        {
            _yOffs = value;
        }
        public function get sprNo():uint
        {
            return _sprNo;
        }
        public function set sprNo( value:uint ):void
        {
            _sprNo = value;
        }
        public function get mirrorOn():uint
        {
            return _mirrorOn;
        }
        public function set mirrorOn( value:uint ):void
        {
            _mirrorOn = value;
        }
        
        public function get color():uint
        {
            return 0;
        }
        public function set color( value:uint ):void
        {
            
        }
        public function get xyMag():Number
        {
            return 0;
        }
        public function set xyMag( value:Number ):void
        {
            
        }
        public function get rot():uint
        {
            return 0;
        }
        public function set rot( value:uint ):void
        {
            
        }
        public function get spType():uint
        {
            return 0;
        }
        public function set spType( value:uint ):void
        {
            
        }
        
        public function get xMag():Number
        {
            return 0;
        }
        public function set xMag( value:Number ):void
        {
            
        }
        public function get yMag():Number
        {
            return 0;
        } 
        public function set yMag( value:Number ):void
        {
            
        }
        
        public function get sprW():uint
        {
            return 0;
        }
        public function set sprW( value:uint ):void
        {
            
        }
        public function get sprH():uint
        {
            return 0;
        }
        public function set sprH( value:uint ):void
        {
            
        }
    }
}