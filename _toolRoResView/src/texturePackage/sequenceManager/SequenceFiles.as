package texturePackage.sequenceManager
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.system.ImageDecodingPolicy;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;

    public class SequenceFiles extends FileStream
    {
        public static const IMAGE_INITIALIZE:String = "imageInitialize";
        public static const FILE_TYPE_SWF:String = "swf";
        public static const FILE_TYPE_PNG:String = "png";
        
        private var _fileName:String;
        private var _fileExtension:String;
        
        private var _loader:Loader;

        private var _colorRect:Rectangle;

        private var _bitmapData:BitmapData;
        
        private var _realRect:Rectangle;
        
        public function SequenceFiles(name:String)
        {
            _fileName = name;
        }
        
        override public function open(file:File, fileMode:String):void
        {
            _fileExtension = file.extension;
            super.open(file, FileMode.READ);
        }
        
        public function get fileName():String
        {
            return _fileName;
        }
        
        public function get fileType():String
        {
            return _fileExtension.toLowerCase();
        }
        
        public function initialize():void
        {
            if(_loader != null)
            {
                return;
            }
            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
            
            var bytes:ByteArray = new ByteArray();
            position = 0;
            readBytes(bytes, 0, bytesAvailable);
            
            var loaderContext:LoaderContext = new LoaderContext();
            loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
            _loader.loadBytes(bytes, loaderContext);
            
        }
        
        protected function onCompleteLoad(event:Event):void
        {
            var sourceImage:BitmapData = (_loader.content as Bitmap).bitmapData;
            _colorRect = sourceImage.getColorBoundsRect(0xFF000000, 0x0,false);
            _realRect = sourceImage.rect;
            
            if(_colorRect.isEmpty() == true)
            {
                _colorRect = sourceImage.rect;
            }
            
            _bitmapData = new BitmapData(_colorRect.width, _colorRect.height);
            _bitmapData.copyPixels(sourceImage, _colorRect, new Point());
            
            dispatchEvent(new Event(IMAGE_INITIALIZE));
            
        }
        
        public function dispose():void
        {
            _loader.unloadAndStop();
            _loader = null;
            
            _bitmapData.dispose();
            _bitmapData = null;
            _colorRect = null;
            
            close();
            
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
        
    }
}