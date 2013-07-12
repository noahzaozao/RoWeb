package com.inoah.ro.displays.actspr.structs.acth
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class ActHeader
    {
        public var magic:uint; //WORD
        public var version:uint; //WORD
        public var numOfAct:uint; //WORD //Number of animations encoded in this file 
        public var xxx4:uint; //WORD    // no use
        public var xxx5:uint; //DWORD
        public var xxx6:uint; //DWORD
        
        public function ActHeader()
        {
        }
        
        public function init( data:ByteArray ):void
        {
            data.endian = Endian.LITTLE_ENDIAN;
            magic = data.readUnsignedShort();
            version = data.readUnsignedShort();
            numOfAct = data.readUnsignedShort();
            xxx4 = data.readUnsignedShort();
            xxx5 = data.readUnsignedInt();
            xxx6 = data.readUnsignedInt();
        }
    }
}