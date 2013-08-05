package inoah.core.viewModels.actSpr.structs.sprh
{
    public class BITMAPFILEHEADER
    {
        public var bfType:uint; //WORD
        public var bfSize:uint; //DWORD
        public var bfReserved1:uint; //WORD
        public var bfReserved2:uint; //WORD
        public var bfOffBits:uint;  //DWORD
        
        public function BITMAPFILEHEADER()
        {
        }
    }
}