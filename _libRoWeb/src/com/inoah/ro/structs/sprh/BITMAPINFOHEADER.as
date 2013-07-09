package com.inoah.ro.structs.sprh
{
    public class BITMAPINFOHEADER
    {
        public var  biSize:uint; //DWORD
        public var   biWidth:uint; //LONG
        public var   biHeight:uint; //LONG
        public var   biPlanes:uint; //WORD
        public var   biBitCount:uint; //WORD
        public var  biCompression:uint; //DWORD
        public var  biSizeImage:uint; //DWORD
        public var   biXPelsPerMeter:uint; //LONG
        public var   biYPelsPerMeter:uint; //LONG
        public var  biClrUsed:uint; //DWORD
        public var  biClrImportant:uint; //DWORD
        
        public function BITMAPINFOHEADER()
        {
        }
    }
}