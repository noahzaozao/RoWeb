package inoah.core.viewModels.actSpr.structs.acth
{
    import flash.utils.ByteArray;

    public class AnyPatSprV0201 extends AnyPatSprV0101
    {
        protected var _color:uint; //DWORD
        protected var _xyMag:Number; //float
        protected var _rot:uint; //DWORD
        protected var _spType:uint; //DWORD
        
        public function AnyPatSprV0201()
        {
        }
        
        override public function init( data:ByteArray ):void
        {
            _xOffs = data.readInt();
            _yOffs = data.readInt();
            _sprNo = data.readUnsignedInt();
            _mirrorOn = data.readUnsignedInt();
            _color = data.readUnsignedInt();
            _xyMag = data.readFloat();
            _rot = data.readUnsignedInt();
            _spType = data.readUnsignedInt();
        }
        
        override public function get color():uint
        {
            return _color;
        }
        override public function set color( value:uint ):void
        {
            _color = value;
        }
        override public function get xyMag():Number
        {
            return _xyMag;
        }
        override public function set xyMag( value:Number ):void
        {
            _xyMag = value;
        }
        override public function get rot():uint
        {
            return _rot;
        }
        override public function set rot( value:uint ):void
        {
            _rot = value;
        }
        override public function get spType():uint
        {
            return _sprNo;
        }
        override public function set spType( value:uint ):void
        {
            _sprNo = value;
        }
    }
}