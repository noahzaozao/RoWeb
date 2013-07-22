package com.inoah.ro.mediators.map
{
    import com.inoah.ro.RoCamera;
    import com.inoah.ro.RoGlobal;
    import com.inoah.ro.characters.PlayerView;
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.consts.GameConsts;
    import com.inoah.ro.controllers.PlayerController;
    import com.inoah.ro.interfaces.ITickable;
    import com.inoah.ro.maps.BaseMap;
    import com.inoah.ro.maps.BattleMap;
    import com.inoah.ro.objects.PlayerObject;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    
    import as3.interfaces.INotification;
    import as3.patterns.mediator.Mediator;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.Sprite;
    
    public class MapMediator extends Mediator implements ITickable
    {
        protected var _mapId:uint;
        protected var _map:BaseMap;
        protected var _camera:RoCamera;
        
        protected var _playerController:PlayerController;
        protected var _player:PlayerObject;
        
        protected var _unitLevel:flash.display.Sprite;
        protected var _mapLevel:starling.display.Sprite;
        
        public function MapMediator( unitLevel:flash.display.Sprite , mapLevel:starling.display.Sprite )
        {
            super(GameConsts.MAP_MEDIATOR);
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
                _map = new BattleMap( _unitLevel as flash.display.DisplayObjectContainer , _mapLevel as starling.display.DisplayObjectContainer );
                facade.registerMediator( _map );
                _camera = new RoCamera( _map );
                facade.registerMediator( _map );
            }
            _map.init( _mapId );
            
            //创建用户
            _playerController = new PlayerController();
            facade.registerMediator( _playerController );
            var playerView:PlayerView = new PlayerView( RoGlobal.userInfo );
            _player = new PlayerObject();
            _player.controller = _playerController;
            _player.viewObject = playerView;
            _player.posX = 400;
            _player.posY = 400;
            _player.info = RoGlobal.userInfo;
            _map.addObject( _player );
            _camera.focus( _player );
            
            var count:int = 0;
            while( count < 10 )
            {
                (_map as BattleMap).createMonser( 1200 * Math.random() + 100, 1200 * Math.random() + 100  );
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
        
        public function get scene():BaseMap
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
    }
}