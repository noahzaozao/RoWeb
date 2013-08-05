package inoah.core.loaders
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import inoah.core.interfaces.ILoader;
    
    public class AtfLoader extends EventDispatcher implements ILoader
    {
        private var _url:String;
        private var _loader:URLLoader;
        
        public function AtfLoader( url:String )
        {
            _url = url;
        }
        
        public function load():void
        {
            _loader = new URLLoader();
            _loader.dataFormat = URLLoaderDataFormat.BINARY;
            _loader.addEventListener( Event.COMPLETE, onLoaderComplete );
            _loader.load( new URLRequest( _url ) );
        }
        
        public function get url():String
        {
            return _url;
        }
        
        public function get data():ByteArray
        {
            return _loader.data;
        }
        
        protected function onLoaderComplete( e:Event):void
        {
            _loader.removeEventListener( Event.COMPLETE, onLoaderComplete );
            dispatchEvent( new Event( Event.COMPLETE ) );
        }
    }
}