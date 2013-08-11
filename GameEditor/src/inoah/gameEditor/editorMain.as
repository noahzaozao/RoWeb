package inoah.gameEditor
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import inoah.data.map.MapInfo;
    import inoah.game.ro.modules.map.view.BaseScene;
    import inoah.gameEditor.consts.GameConsts;
    import inoah.gameEditor.panels.BasePanel;
    import inoah.gameEditor.panels.CharacterEditorPanel;
    
    import robotlegs.bender.extensions.localEventMap.api.IEventMap;
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;
    import robotlegs.bender.framework.api.IInjector;
    
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    
    public class editorMain extends Sprite implements IMediator
    {
        [Inject]
        public var injector:IInjector;
        
        [Inject]
        public var eventMap:IEventMap;
        
        [Inject]
        public var eventDispatcher:IEventDispatcher;
        
        private var _panelRoot:DisplayObjectContainer;
        private var _currentPanel:BasePanel;
        private var _currentPanelName:String;
        private var _w:int, _h:int;
        
        private var _viewComponent:Object;
        private var _scene:BaseScene;
        
        public function set viewComponent(view:Object):void
        {
            _viewComponent = view;
        }
        
        public function editorMain( mediatorName:String=null, viewComponent:Object=null )
        {
            super();
            addEventListener( starling.events.Event.ADDED_TO_STAGE, onAddedToStage ); 
        }
        
        private function onAddedToStage( e:starling.events.Event ):void
        {
            _panelRoot = Starling.current.nativeOverlay;
            
            _w = stage.stageWidth;
            _h = stage.stageHeight;
        }
        
        public function initialize():void
        {
            addContextListener( EditorEvent.OPEN_EDITOR , onOpenPanel , EditorEvent );
        }
        
        public function destroy():void
        {
            
        }
        
        public function tick( delta:Number ):void
        {
            if(_scene)
            {
                _scene.tick( delta );
            }
        }
        
        public function onResize( w:int , h:int ):void
        {
            _w = w;
            _h = h;
            if( _currentPanel )
            {
                _currentPanel.setSize( _w, _h );
            }
        }
        
        private function onOpenPanel( e:EditorEvent ):void
        {
            if( _currentPanelName == e.panelName )
            {
                return;
            }
            if( _currentPanel )
            {
                _currentPanel.dispose();
                _currentPanel = null;
                _currentPanelName = "";
            }
            else
            {
                switch( e.panelName )
                {
                    case GameConsts.MAP_VIEWER:
                    {
                        loadMap();
                        break;
                    }
                    case GameConsts.CHARACTER_EDITOR:
                    {
                        _currentPanel = new CharacterEditorPanel( _panelRoot , 0, 0 , e.panelName );
                        break;
                    }
                }
                if( _currentPanel )
                {
                    injector.map(BasePanel,"currenPanel").toValue(_currentPanel);
                    _currentPanelName = e.panelName;
                    _currentPanel.setSize( _w, _h );
                }
            }
        }
        
        private function loadMap():void
        {
            var loader:URLLoader = new URLLoader();
            loader.addEventListener( flash.events.Event.COMPLETE , onLoadMap );
            loader.load( new URLRequest( "map/map002.json" ));
        }
        
        protected function onLoadMap( e:flash.events.Event):void
        {
            var loader:URLLoader = e.currentTarget as URLLoader;
            loader.removeEventListener( flash.events.Event.COMPLETE , onLoadMap );
            var jsonStr:String = loader.data as String;
            var jsonObj:Object = JSON.parse( jsonStr );
            jsonObj;
            
            var mapInfo:MapInfo = new MapInfo( jsonObj );
            _scene = new BaseScene();
            injector.injectInto(_scene);
            _scene.initScene( this, mapInfo );
        }
        
        public function postDestroy():void
        {
            eventMap.unmapListeners();
        }
        
        /*============================================================================*/
        /* Protected Functions                                                        */
        /*============================================================================*/
        
        protected function addViewListener(eventString:String, listener:Function, eventClass:Class = null):void
        {
            eventMap.mapListener(IEventDispatcher(_viewComponent), eventString, listener, eventClass);
        }
        
        protected function addContextListener(eventString:String, listener:Function, eventClass:Class = null):void
        {
            eventMap.mapListener(eventDispatcher, eventString, listener, eventClass);
        }
        
        protected function removeViewListener(eventString:String, listener:Function, eventClass:Class = null):void
        {
            eventMap.unmapListener(IEventDispatcher(_viewComponent), eventString, listener, eventClass);
        }
        
        protected function removeContextListener(eventString:String, listener:Function, eventClass:Class = null):void
        {
            eventMap.unmapListener(eventDispatcher, eventString, listener, eventClass);
        }
        
        protected function dispatch(event:flash.events.Event):void
        {
            if (eventDispatcher.hasEventListener(event.type))
                eventDispatcher.dispatchEvent(event);
        }
    }
}