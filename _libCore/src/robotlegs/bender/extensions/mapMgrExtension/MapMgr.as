package robotlegs.bender.extensions.mapMgrExtension
{
    import inoah.core.characters.gpu.PlayerViewGpu;
    import inoah.core.infos.CharacterInfo;
    import inoah.interfaces.ICamera;
    import inoah.interfaces.IDisplayMgr;
    import inoah.interfaces.IMapFactory;
    import inoah.interfaces.IMapMgr;
    import inoah.interfaces.IPlayerController;
    import inoah.interfaces.IPlayerFactory;
    import inoah.interfaces.IScene;
    import inoah.interfaces.ISceneMediator;
    import inoah.interfaces.ITickable;
    import inoah.interfaces.IUserModel;
    
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
        
        protected var _scene:IScene;
        
        protected var _sceneMediator:ISceneMediator;
        
        protected var _camera:ICamera;

        protected var _unitLevel:starling.display.Sprite;

        protected var _mapLevel:starling.display.Sprite;
        
        protected var _mapId:uint;
        
        protected var _playerController:IPlayerController;
//        protected var _player:PlayerObject;
        
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
            if( !_scene)
            {
                _scene =  mapFactory.newMap( _mapId );
                _sceneMediator = mapFactory.newMapMediator( _mapId );
                _camera = mapFactory.newCamera();
            }

            //            //创建用户
            if( !_playerController )
            {
                _playerController = playerFactory.newTiledPlayerController();
            }
            
            var playerView:PlayerViewGpu = new PlayerViewGpu();
            injector.injectInto(playerView);
            playerView.initInfo( userModel.info as CharacterInfo );
            
            //            _player = new PlayerObject();
            //            _player.controller = _playerController;
            //            _player.viewObject = playerView;
            //            _player.posX = 400;
            //            _player.posY = 400;
            //            _player.info = Global.userInfo;
            //            _map.addObject( _player );
            //            _camera.focus( _player );
            //            
            //            var count:int = 0;
            //            while( count < 50 )
            //            {
            //                (_map as BattleMapMediator).createMonser( 1800 * Math.random() + 200, 1800 * Math.random() + 200  );
            //                count++;
            //            }
        }
        
        public function tick( delta:Number ):void
        {
            //            _playerController.tick( delta ); //unit pos change
            //            _camera.update(); //camera zero
            //            _map.offsetX = -_camera.zeroX;
            //            _map.offsetY = -_camera.zeroY;
            if( _scene )
            {
                _scene.tick( delta );
            }
            //            _player.tick( delta ); 
        }
        
        //        public function get scene():IMapMediator
        //        {
        //            return _map;
        //        }
        //        
        //        public function get mapContainer():starling.display.DisplayObjectContainer
        //        {
        //            return _mapLevel as starling.display.DisplayObjectContainer;
        //        }
        //        
        //        public function get unitContainer():flash.display.DisplayObjectContainer
        //        {
        //            return _unitLevel as flash.display.DisplayObjectContainer;
        //        }
        //        
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