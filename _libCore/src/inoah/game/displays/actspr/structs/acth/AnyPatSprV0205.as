package inoah.game.displays.actspr.structs.acth
{
    import flash.utils.ByteArray;

    public class AnyPatSprV0205 extends AnyPatSprV0204
    {
        protected var _sprW:uint; //DWORD
        protected var _sprH:uint; //DWORD
        
        public function AnyPatSprV0205()
        {
        }
        
        override public function init( data:ByteArray ):void
        {
            try
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
                _sprW = data.readUnsignedInt();
                _sprH = data.readUnsignedInt();
            } 
            catch(e:Error) 
            {
                throw new Error( e.errorID );
            }
        }
        
        override public function get sprW():uint
        {
            return _sprW;
        }
        override public function set sprW( value:uint ):void
        {
            _sprW = value;
        }
        override public function get sprH():uint
        {
            return _sprH;
        }
        override public function set sprH( value:uint ):void
        {
            _sprH = value;
        }
    }
}