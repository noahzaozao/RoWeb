package com.inoah.ro.structs.acth
{
    import flash.utils.ByteArray;

    public class PatHeader
    {
        private var  pal1:uint; //DWORD
        private var  pal2:uint; //DWORD
        private var  xxx3:uint; //DWORD
        private var  xxx4:uint; //DWORD
        private var  xxx5:uint; //DWORD
        private var  xxx6:uint; //DWORD
        private var  xxx7:uint; //DWORD
        private var  xxx8:uint; //DWORD
        
        public function PatHeader()
        {
        }
        
        public function init(data:ByteArray):void
        {
            pal1 = data.readUnsignedInt();
            pal2 = data.readUnsignedInt();
            xxx3 = data.readUnsignedInt();
            xxx4 = data.readUnsignedInt();
            xxx5 = data.readUnsignedInt();
            xxx6 = data.readUnsignedInt();
            xxx7 = data.readUnsignedInt();
            xxx8 = data.readUnsignedInt();
        }
    }
}