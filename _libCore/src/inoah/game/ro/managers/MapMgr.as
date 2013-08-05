package inoah.game.ro.managers
{
    import flash.display.DisplayObjectContainer;
    
    import inoah.core.interfaces.IMgr;
    import inoah.core.interfaces.ITickable;
    import inoah.game.ro.GameCamera;
    import inoah.game.ro.Global;
    import inoah.game.ro.characters.gpu.PlayerViewGpu;
    import inoah.game.ro.consts.ConstsGame;
    import inoah.game.ro.consts.commands.GameCommands;
    import inoah.game.ro.controllers.PlayerController;
    import inoah.game.ro.mediators.maps.BaseMapMediator;
    import inoah.game.ro.mediators.maps.BattleMapMediator;
    import inoah.game.ro.objects.PlayerObject;
    
    import pureMVC.interfaces.INotification;
    import pureMVC.patterns.mediator.Mediator;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.Sprite;
    
    /**
     *  地图管理器
     * @author inoah
     */    
    public class MapMgr extends Mediator implements ITickable, IMgr
    {
        protected var _mapId:uint;
        protected var _map:BaseMapMediator;
        protected var _camera:GameCamera;
        
        protected var _playerController:PlayerController;
        protected var _player:PlayerObject;
        
        protected var _unitLevel:starling.display.Sprite;
        protected var _mapLevel:starling.display.Sprite;
        
        public function MapMgr( unitLevel:starling.display.Sprite , mapLevel:starling.display.Sprite )
        {
            super(ConstsGame.MAP_MEDIATOR);
            _unitLevel = unitLevel;
            _mapLevel = mapLevel;
        }
        
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            arr.push( GameCommands.CHANGE_MAP );
            return arr;
        }
        
        override public function handleNotification(notification:INotification):void
        {
            var arr:Array;
            switch( notification.getName() )
            {
                case GameCommands.CHANGE_MAP:
                {
                    arr = notification.getBody() as Array;
                    onChangeMap( arr[0] );
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        
        protected function onChangeMap( mapId:uint ):void
        {
            _mapId = mapId;
            if( !_map )
            {
                _map = new BattleMapMediator( _unitLevel as starling.display.DisplayObjectContainer , _mapLevel as starling.display.DisplayObjectContainer );
                facade.registerMediator( _map );
                _camera = new GameCamera( _map );
                facade.registerMediator( _map );
            }
            _map.init( _mapId );
            
            //创建用户
            _playerController = new PlayerController();
            facade.registerMediator( _playerController );
            var playerView:PlayerViewGpu = new PlayerViewGpu( Global.userInfo );
            _player = new PlayerObject();
            _player.controller = _playerController;
            _player.viewObject = playerView;
            _player.posX = 400;
            _player.posY = 400;
            _player.info = Global.userInfo;
            _map.addObject( _player );
            _camera.focus( _player );
            
            var count:int = 0;
            while( count < 50 )
            {
                (_map as BattleMapMediator).createMonser( 1800 * Math.random() + 200, 1800 * Math.random() + 200  );
                count++;
            }
        }
        
        public function tick( delta:Number ):void
        {
            _playerController.tick( delta ); //unit pos change
            _camera.update(); //camera zero
            _map.offsetX = -_camera.zeroX;
            _map.offsetY = -_camera.zeroY;
            _map.tick( delta ); //unit offset
            _player.tick( delta ); 
        }
        
        public function get scene():BaseMapMediator
        {
            return _map;
        }
        
        public function get mapContainer():starling.display.DisplayObjectContainer
        {
            return _mapLevel as starling.display.DisplayObjectContainer;
        }
        
        public function get unitContainer():flash.display.DisplayObjectContainer
        {
            return _unitLevel as flash.display.DisplayObjectContainer;
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