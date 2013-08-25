package robotlegs.bender.extensions.mapMgrExtension
{
    import inoah.core.Global;
    import inoah.core.characters.gpu.PlayerViewGpu;
    import inoah.core.infos.CharacterInfo;
    import inoah.interfaces.ICamera;
    import inoah.interfaces.IUserModel;
    import inoah.interfaces.base.ITickable;
    import inoah.interfaces.character.IPlayerObject;
    import inoah.interfaces.controller.IPlayerController;
    import inoah.interfaces.factory.IPlayerFactory;
    import inoah.interfaces.info.ICharacterInfo;
    import inoah.interfaces.managers.IDisplayMgr;
    import inoah.interfaces.managers.IMapMgr;
    import inoah.interfaces.map.IBattleSceneMediator;
    import inoah.interfaces.map.IMapFactory;
    import inoah.interfaces.map.IScene;
    import inoah.interfaces.map.ISceneMediator;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.framework.api.IInjector;
    
    import starling.display.Sprite;
    
    /**
     *  地图管理器
     * @author inoah
     */    
    public class MapMgr extends Mediator implements IMapMgr,ITickable
    {
        [Inject]
        public var injector:IInjector;
        
        [Inject]
        public var displayMgr:IDisplayMgr;
        
        [Inject]
        public var mapFactory:IMapFactory;
        
        [Inject]
        public var playerFactory:IPlayerFactory;
        
        [Inject]
        public var userModel:IUserModel;

        [Inject]
        public var playerController:IPlayerController;

        protected var _scene:IScene;
        
        protected var _sceneMediator:ISceneMediator;
        
        protected var _camera:ICamera;
        
        protected var _unitLevel:starling.display.Sprite;
        
        protected var _mapLevel:starling.display.Sprite;
        
        protected var _mapId:uint;
        
        protected var _mapType:uint;
        
        protected var _player:IPlayerObject;
        
        public function MapMgr()
        {
        }
        
        override public function initialize():void
        {
            _unitLevel = displayMgr.unitLevel;
            _mapLevel = displayMgr.mapLevel;
            
            addContextListener( MapEvent.CHANGE_MAP , onChangeMap , MapEvent );
        }
        
        protected function onChangeMap( e:MapEvent ):void
        {
            _mapId = e.mapId;
            _mapType = e.mapType;
            if( !_scene)
            {
                _scene =  mapFactory.newScene( _mapId );
                _sceneMediator = mapFactory.newSceneMediator( _mapId , _mapType );
                _camera = mapFactory.newCamera();
            }
            
            var playerView:PlayerViewGpu = new PlayerViewGpu();
            injector.injectInto(playerView);
            playerView.initInfo( userModel.info as CharacterInfo );
            
            playerController.initialize();
            _player = playerFactory.newPlayerObject();
            _player.controller = playerController;
            _player.viewObject = playerView;
            _player.posX = Global.PLAYER_POSX;
            _player.posY = Global.PLAYER_POSY;
            _player.info = userModel.info as ICharacterInfo;
            _sceneMediator.addObject( _player );
            _camera.focus( _player );
            
            var count:int = 0;
            while( count < 50 )
            {
                (_sceneMediator as IBattleSceneMediator).createMonser( 1800 * Math.random() + 200, 1800 * Math.random() + 200  );
                count++;
            }
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
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
        
        public function dispose():void
        {
        }
        
        public function get isDisposed():Boolean
        {
            return false;
        }
    }
}