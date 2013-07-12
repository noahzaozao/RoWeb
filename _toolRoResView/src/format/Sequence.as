package format
{
    import flash.display.BitmapData;
    import flash.geom.Rectangle;

    public class Sequence
    {
        private var _bitmapData:BitmapData;
        private var _colorRect:Rectangle;
        private var _sequenceName:String;
        private var _realRect:Rectangle;
        
        public function Sequence(bitmapData:BitmapData, realRect:Rectangle, colorRect:Rectangle, sequenceName:String)
        {
            _realRect = realRect.clone();
            _sequenceName = sequenceName;
            _bitmapData = bitmapData.clone();
            _colorRect = colorRect.clone();
        }
        
        public function get sequenceName():String
        {
            return _sequenceName;
        }
        
        public function get bitmapData():BitmapData
        {
            return _bitmapData;
        }
        
        public function get colorRect():Rectangle
        {
            return _colorRect;
        }
        
        public function get realRect():Rectangle
        {
            return _realRect;
        }
         
        public function dispose():void
        {
            _bitmapData.dispose();
            _bitmapData = null;
        }
        
        public function toString():String
        {
            return "{SequenceName:"+_sequenceName+", colorArea:+"+_colorRect+"assetSize:"+ _realRect +"}"
        }
    }
}