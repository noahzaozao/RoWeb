package com.inoah.ro.mediators.map
{
    import com.inoah.ro.RoCamera;
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.consts.GameConsts;
    import com.inoah.ro.consts.MgrTypeConsts;
    import com.inoah.ro.displays.BaseObject;
    import com.inoah.ro.managers.KeyMgr;
    import com.inoah.ro.managers.MainMgr;
    import com.inoah.ro.maps.BaseMap;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.ui.Keyboard;
    
    import as3.interfaces.INotification;
    import as3.patterns.mediator.Mediator;
    
    public class MapMediator extends Mediator
    {
        protected var _camera:RoCamera;
        protected var _map:BaseMap;
        protected var _mapId:uint;
        protected var _baseObj:BaseObject;
        
        public function MapMediator( viewComponent:Object=null)
        {
            super(GameConsts.MAP_MEDIATOR, viewComponent);
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
                _map = new BaseMap();
                _camera = new RoCamera( _map );
            }
            _map.init( _mapId );
            container.addChild( _map );
            
            _baseObj = new BaseObject();
            _baseObj.graphics.beginFill( 0xff0000 );
            _baseObj.graphics.drawRect( -2, -2 , 4 , 4);
            _baseObj.graphics.endFill();
            _baseObj.posX = 200;
            _baseObj.posY = 200;
            _map.addObject( _baseObj );
            
            _camera.focus( _baseObj );
        }
        
        public function tick( delta:Number ):void
        {
            var speed:Number = 600;
            var keyMgr:KeyMgr = MainMgr.instance.getMgr( MgrTypeConsts.KEY_MGR ) as KeyMgr;
            if( keyMgr.isDown( Keyboard.D ) )
            {
                _baseObj.posX +=speed * delta;
            }
            else if( keyMgr.isDown( Keyboard.A ) )
            {
                _baseObj.posX -=speed * delta;
            }
            if( keyMgr.isDown( Keyboard.W ) )
            {
                _baseObj.posY -=speed * delta;
            }
            else if( keyMgr.isDown( Keyboard.S ) )
            {
                _baseObj.posY +=speed * delta;
            }
            
            _camera.update();
            _map.posX = -_camera.zeroX;
            _map.posY = -_camera.zeroY;
            _map.tick( delta );
            _baseObj.tick( delta );
        }
        
        public function get container():DisplayObjectContainer
        {
            return viewComponent as DisplayObjectContainer;
        }
    }
}