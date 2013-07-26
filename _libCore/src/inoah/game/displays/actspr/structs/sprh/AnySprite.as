package inoah.game.displays.actspr.structs.sprh
{
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    
    public class AnySprite
    {
        public var w:int, h:int;
        public var  dat:Vector.<uint>;
        public var  paldat:Vector.<uint>;
        private var _bmd:BitmapData;
        
        public function AnySprite()
        {
        }
        
        public function drawbitmap():BitmapData
        {
            if(_bmd == null)
            {
                _bmd = new BitmapData( w, h , true)
                var i:int = 0
                var pixes:ByteArray = new ByteArray()
                for(var x:int = 0;x<w;x++)
                {
                    for(var y:int = 0;y<h;y++)
                    {
                        pixes.writeInt(dat[i])
                        i++
                    }
                }
                pixes.position = 0
                _bmd.setPixels(new Rectangle(0,0,w,h),pixes)
            }
            return _bmd;
        }
    }
}