package com.D5Power.graphics
{
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    
    public class D5BitmapData extends BitmapData
    {
        public function D5BitmapData(width:int=0, height:int=0, transparent:Boolean=true, fillColor:uint=4.294967295E9)
        {
            super(width, height, transparent, fillColor);
        }
        
        /**
         * 颜色替换
         * @param	findColor		要查找的颜色代码
         * @param	replaceColor	要替换的颜色代码
         * @param	workmode		工作模式 0-逐像素替换 1-采用阈值替换
         */ 
        public static function changeColor(source:BitmapData,findColor:uint,replaceColor:uint,workmode:uint = 0):void
        {
            
            switch(workmode)
            {
                case 0:
                    var byte:ByteArray = new ByteArray();
                    
                    byte.writeUnsignedInt(findColor);
                    var a1:uint = byte.readUnsignedByte();
                    var r1:uint = byte.readUnsignedByte();
                    var g1:uint = byte.readUnsignedByte();
                    var b1:uint = byte.readUnsignedByte();
                    
                    
                    var a2:uint;
                    var r2:uint;
                    var g2:uint;
                    var b2:uint;
                    
                    var char:uint;
                    var chag:uint;
                    var chab:uint;
                    
                    
                    source.lock();
                    
                    var py:uint,px:uint;
                    var h:uint = source.height,w:uint = source.height;
                    for(py=0;py<h;py++)
                    {
                        for(px;px<w;px++)
                        {
                            var color:uint = source.getPixel32(px,py);
                            byte.clear();
                            byte.writeUnsignedInt(color);
                            byte.position = 0;
                            a2 = byte.readUnsignedByte();
                            if(a2==0) continue;
                            r2 = byte.readUnsignedByte();
                            g2 = byte.readUnsignedByte();
                            b2 = byte.readUnsignedByte();
                            char = r1>r2 ? r1-r2 : r2-r1;
                            chag = g1>g2 ? g1-g2 : g2-g1;
                            chab = b1>b2 ? b1-b2 : b2-b1;
                            
                            var dis:uint = Math.pow(char*char+chag*chag+chab*chab,0.333333);
                            if(dis<=30)
                            {
                                source.setPixel(px,py,replaceColor);
                            }
                        }
                    }
                    source.unlock();
                    break;
            }
            
        }
    }
}