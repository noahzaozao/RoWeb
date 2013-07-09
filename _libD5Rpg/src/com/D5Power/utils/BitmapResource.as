package com.D5Power.utils
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.IBitmapDrawable;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.utils.ByteArray;
    
    public class BitmapResource implements IBitmapDrawable
    {
        private var _bitmapData:BitmapData;
        
        public var resName:String;
        
        public var zeroPointX:uint;
        public var zeroPointY:uint;
        
        public var p0X:uint;
        public var p0Y:uint;
        
        public var p1X:uint;
        public var p1Y:uint;
        
        public var p2X:uint;
        public var p2Y:uint;
        
        public var p3X:uint;
        public var p3Y:uint;
        
        private var _fun:Function;
        
        
        public function BitmapResource()
        {
        }
        
        /**
         * 获取位图数据
         */ 
        public function get bitmapData():BitmapData
        {
            return _bitmapData;
        }
        
        public function toString():String
        {
            var p:String='';
            for(var i:uint=0;i<4;i++) p+="p"+i+"X:"+this["p"+i+"X"]+",p"+i+"Y:"+this["p"+i+"Y"]+",";
            return "[BitmapResource] zeroPointX:"+zeroPointX+",zeroPointY:"+zeroPointY+","+p;
        }
        
        public function formatByteArray2BitmapData(data:ByteArray,callback:Function):void
        {
            _fun = callback;
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplate);
            loader.loadBytes(data);
        }
        
        public function formatBitmapData2BitmapData(data:BitmapData,isCopy:Boolean=false):void
        {
            _bitmapData = isCopy ? data.clone() : data;
        }
        
        private function onComplate(e:Event):void
        {
            (e.target as LoaderInfo).removeEventListener(Event.COMPLETE,onComplate);
            
            _bitmapData = ((e.target as LoaderInfo).content as Bitmap).bitmapData;
            (e.target as LoaderInfo).loader.unload();
            _fun(this);
            _fun = null;
        }
    }
}