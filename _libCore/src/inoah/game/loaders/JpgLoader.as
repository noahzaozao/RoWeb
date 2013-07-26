package inoah.game.loaders
{
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLRequest;
    
    public class JpgLoader extends EventDispatcher implements ILoader
    {
        private var _url:String;
        private var _loader:Loader;
        
        public function JpgLoader( url:String )
        {
            _url = url;
        }
        
        public function load():void
        {
            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaderComplete );
            _loader.load( new URLRequest( _url ) );
        }
        
        public function get url():String
        {
            return _url;
        }
        
        public function get content():DisplayObject
        {
            return _loader.content;
        }
        
        protected function onLoaderComplete( e:Event):void
        {
            _loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoaderComplete );
            dispatchEvent( new Event( Event.COMPLETE ) );
        }
    }
}