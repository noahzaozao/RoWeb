package com.inoah.ro.mediators.map
{
    import com.inoah.ro.RoCamera;
    import com.inoah.ro.RoGlobal;
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.consts.GameConsts;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.displays.BaseObject;
    import com.inoah.ro.interfaces.ITickable;
    import com.inoah.ro.managers.KeyMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.maps.BaseMap;
    import com.inoah.ro.utils.Counter;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.ui.Keyboard;
    
    import as3.interfaces.INotification;
    import as3.patterns.mediator.Mediator;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.Sprite;
    
    public class MapMediator extends Mediator implements ITickable
    {
        protected var _camera:RoCamera;
        protected var _map:BaseMap;
        protected var _mapId:uint;
        protected var _baseObj:BaseObject;
        protected var _unitLevel:flash.display.Sprite;
        protected var _mapLevel:starling.display.Sprite;
        protected var _drawCounter:Counter;
        
        public function MapMediator( unitLevel:flash.display.Sprite , mapLevel:starling.display.Sprite )
        {
            super(GameConsts.MAP_MEDIATOR);
            _unitLevel = unitLevel;
            _mapLevel = mapLevel;
            _drawCounter = new Counter();
            _drawCounter.initialize();
            _drawCounter.reset( 0.015 );
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
                _map = new BaseMap( _unitLevel as flash.display.DisplayObjectContainer );
                _camera = new RoCamera( _map );
            }
            _map.init( _mapId );
            mapContainer.addChild( _map );
            
            _baseObj = new BaseObject();
            _baseObj.graphics.beginFill( 0xff0000 );
            _baseObj.graphics.drawRect( -5, -5 , 10 , 10);
            _baseObj.graphics.endFill();
            _baseObj.posX = 200;
            _baseObj.posY = 200;
            _map.addObject( _baseObj );
            
            _camera.focus( _baseObj );
        }
        
        public function tick( delta:Number ):void
        {
            _drawCounter.tick( delta );
            if(_drawCounter.expired )
            {
                var speed:Number = 500;
                var keyMgr:KeyMgr = MainMgr.instance.getMgr( MgrTypeConsts.KEY_MGR ) as KeyMgr;
                if( keyMgr.isDown( Keyboard.D ) )
                {
                    _baseObj.posX +=speed * delta;
                    if( _baseObj.posX > RoGlobal.MAP_W )
                    {
                        _baseObj.posX = RoGlobal.MAP_W;
                    }
                }
                else if( keyMgr.isDown( Keyboard.A ) )
                {
                    _baseObj.posX -=speed * delta;
                    if( _baseObj.posX < 0 )
                    {
                        _baseObj.posX = 0;
                    }
                }
                if( keyMgr.isDown( Keyboard.W ) )
                {
                    _baseObj.posY -=speed * delta;
                    if( _baseObj.posY < 0 )
                    {
                        _baseObj.posY = 0;
                    }
                }
                else if( keyMgr.isDown( Keyboard.S ) )
                {
                    _baseObj.posY +=speed * delta;
                    if( _baseObj.posY > RoGlobal.MAP_H )
                    {
                        _baseObj.posY = RoGlobal.MAP_H;
                    }
                }
                
                _camera.update();
                _map.posX = -_camera.zeroX;
                _map.posY = -_camera.zeroY;
                _map.tick( delta );
                _baseObj.tick( delta );
                
                _drawCounter.reset( 0.015 );
            }
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