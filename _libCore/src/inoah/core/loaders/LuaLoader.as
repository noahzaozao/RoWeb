package inoah.core.loaders
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import inoah.interfaces.base.ILoader;
    
    public class LuaLoader extends EventDispatcher implements ILoader
    {
        private var _url:String;
        private var _loader:URLLoader;
        
        public function LuaLoader( url:String )
        {
            _url = url;
        }
        
        public function load():void
        {
            _loader = new URLLoader();
            _loader.addEventListener( Event.COMPLETE, onLoaderComplete );
            _loader.load( new URLRequest( _url ) );
        }
        
        public function get url():String
        {
            return _url;
        }
        
        public function get content():String
        {
            return _loader.data;
        }

        protected function onLoaderComplete(event:Event):void
        {
            _loader.removeEventListener( Event.COMPLETE, onLoaderComplete );
            dispatchEvent( new Event( Event.COMPLETE ) );            
        }
    }
}