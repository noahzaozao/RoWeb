package inoah.gameEditor
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.geom.Point;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import inoah.core.characters.gpu.PlayerViewGpu;
    import inoah.core.infos.CharacterInfo;
    import inoah.core.infos.UserInfo;
    import inoah.data.map.MapInfo;
    import inoah.game.ro.modules.main.view.events.JoyStickEvent;
    import inoah.game.ro.modules.map.view.BaseScene;
    import inoah.gameEditor.consts.GameConsts;
    import inoah.gameEditor.panels.BasePanel;
    import inoah.gameEditor.panels.CharacterEditorPanel;
    import inoah.interfaces.ICamera;
    import inoah.interfaces.character.IPlayerObject;
    import inoah.interfaces.controller.IPlayerController;
    import inoah.interfaces.factory.IPlayerFactory;
    import inoah.interfaces.info.ICharacterInfo;
    import inoah.interfaces.managers.IKeyMgr;
    import inoah.interfaces.map.IMapFactory;
    import inoah.interfaces.map.IScene;
    import inoah.interfaces.map.ISceneMediator;
    
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
        
        [Inject]
        public var keyMgr:IKeyMgr;
        
        [Inject]
        public var mapFactory:IMapFactory;
        
        [Inject]
        public var playerFactory:IPlayerFactory;
        
        [Inject]
        public var playerController:IPlayerController;
        
        protected var _panelRoot:DisplayObjectContainer;
        protected var _currentPanel:BasePanel;
        protected var _currentPanelName:String;
        protected var _w:int, _h:int;
        
        protected var _viewComponent:Object;
        protected var _scene:IScene;
        protected var _sceneMediator:ISceneMediator;
        protected var _camera:ICamera;
        
        protected var _joyStickUp:Boolean;
        protected var _joyStickDown:Boolean;
        protected var _joyStickLeft:Boolean;
        protected var _joyStickRight:Boolean;
        protected var _joyStickAttack:Boolean;
        protected var _tempPoint:Point = new Point();
        protected var _player:IPlayerObject; 
        
        public function set viewComponent(view:Object):void
        {
            _viewComponent = view;
        }
        
        public function editorMain( mediatorName:String=null, viewComponent:Object=null )
        {
            super();
            addEventListener( starling.events.Event.ADDED_TO_STAGE, onAddedToStage ); 
        }
        
        protected function onAddedToStage( e:starling.events.Event ):void
        {
            _panelRoot = Starling.current.nativeOverlay;
            
            _w = stage.stageWidth;
            _h = stage.stageHeight;
        }
        
        public function initialize():void
        {
            addContextListener( EditorEvent.OPEN_EDITOR , onOpenPanel , EditorEvent );
            
            addContextListener( JoyStickEvent.JOY_STICK_ATTACK , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_DOWN , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_DOWN_LEFT , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_DOWN_RIGHT , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_LEFT , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_RIGHT , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_UP , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_UP_LEFT , onJoyStick , JoyStickEvent );
            addContextListener( JoyStickEvent.JOY_STICK_UP_RIGHT , onJoyStick , JoyStickEvent );
        }
        
        public function onJoyStick( e:JoyStickEvent ):void
        {
            _joyStickUp = false;
            _joyStickDown = false;
            _joyStickLeft = false;
            _joyStickRight = false;
            _joyStickAttack = false;
            switch( e.type )
            {
                case JoyStickEvent.JOY_STICK_ATTACK:
                {
                    _joyStickAttack = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_UP:
                {
                    _joyStickUp = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_DOWN:
                {
                    _joyStickDown = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_LEFT:
                {
                    _joyStickLeft = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_RIGHT:
                {
                    _joyStickRight = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_UP_LEFT:
                {
                    _joyStickUp = e.isDown;
                    _joyStickLeft = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_UP_RIGHT:
                {
                    _joyStickUp = e.isDown;
                    _joyStickRight = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_DOWN_LEFT:
                {
                    _joyStickDown = e.isDown;
                    _joyStickLeft = e.isDown;
                    break;
                }
                case JoyStickEvent.JOY_STICK_DOWN_RIGHT:
                {
                    _joyStickDown = e.isDown;
                    _joyStickRight = e.isDown;
                    break;
                }
            }
        }
        
        public function destroy():void
        {
            
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
        
        protected function onOpenPanel( e:EditorEvent ):void
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
        
        protected function loadMap():void
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
            
            var mapInfo:MapInfo = new MapInfo( jsonObj );
            _scene = mapFactory.newScene( 0 );
            _sceneMediator = mapFactory.newSceneMediator( 0 , 1 );

            _camera = mapFactory.newCamera();
            
            var userInfo:UserInfo = new UserInfo();
            userInfo.init( "data/sprite/characters/head/man/2_man.tpc", "data/sprite/characters/body/man/novice_man.tpc", true );
            userInfo.setWeaponRes( "data/sprite/characters/novice/weapon_man_knife.tpc" );
            userInfo.setWeaponShadowRes( "data/sprite/characters/novice/weapon_man_knife_ef.tpc" );
            
            var playerView:PlayerViewGpu = new PlayerViewGpu();
            injector.injectInto(playerView);
            playerView.initInfo( userInfo as CharacterInfo );
            
            playerController.initialize();
            _player = playerFactory.newPlayerObject();
            _player.controller = playerController;
            _player.viewObject = playerView;
            _player.posX = 2000;
            _player.posY = 1000;
            _player.info = userInfo as ICharacterInfo;
            _sceneMediator.addObject( _player );
            _camera.focus( _player );
        }
        
        public function tick( delta:Number ):void
        {
            if( playerController )
            {
                playerController.tick( delta ); 
            }
            if( _camera )
            {
                _camera.update(); 
            }
            if( _sceneMediator )
            {
                _sceneMediator.offsetX = -_camera.zeroX;
                _sceneMediator.offsetY = -_camera.zeroY;
                _sceneMediator.tick( delta );
            }
            if( _player )
            {
                _player.tick( delta ); 
            }
            if( _scene && (_scene as BaseScene).couldTick )
            {
                (_scene as BaseScene).updateMap();
            }
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