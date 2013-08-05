package inoah.core.loaders
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import inoah.core.interfaces.ILoader;

    public class ActSprLoader extends EventDispatcher implements ILoader
    {
        private var _actUrl:String;
        private var _sprUrl:String;
        private var _actLoader:URLLoader;
        private var _sprLoader:URLLoader;
        
        public function ActSprLoader( actPath:String )
        {
            _actUrl = actPath;
            _sprUrl = _actUrl.replace( "act", "spr" );
        }
        
        public function load():void
        {
            _actLoader = new URLLoader();
            _actLoader.dataFormat = URLLoaderDataFormat.BINARY;
            _actLoader.addEventListener( Event.COMPLETE, onActLoaderComplete );
            _actLoader.load( new URLRequest( _actUrl ) );
        }
        
        public function get url():String
        {
            return _actUrl;
        }

        public function get sprUrl():String
        {
            return _sprUrl;
        }
        
        public function get actData():ByteArray
        {
            return _actLoader.data;
        }
        
        public function get sprData():ByteArray
        {
            return _sprLoader.data;
        }
        
        protected function onActLoaderComplete( e:Event):void
        {
            _actLoader.removeEventListener( Event.COMPLETE, onActLoaderComplete );
            
            _sprLoader = new URLLoader();
            _sprLoader.dataFormat = URLLoaderDataFormat.BINARY;
            _sprLoader.addEventListener( Event.COMPLETE, onSprLoaderComplete );
            _sprLoader.load( new URLRequest( _sprUrl ) );
        }
        
        protected function onSprLoaderComplete( e:Event):void
        {
            _sprLoader.removeEventListener( Event.COMPLETE, onSprLoaderComplete );
            dispatchEvent( new Event( Event.COMPLETE ) );
        }
    }
}