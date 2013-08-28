package inoah.game.td.modules.gameui
{
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    
    import game.ui.gameViewUI;
    
    import inoah.core.events.UserInfoEvent;
    import inoah.core.infos.UserInfo;
    import inoah.game.ro.modules.main.view.events.GameEvent;
    import inoah.interfaces.IUserModel;
    
    import robotlegs.bender.extensions.localEventMap.api.IEventMap;
    
    public class GameView extends gameViewUI
    {
        [Inject]
        public var eventMap:IEventMap;
        
        [Inject]
        public var eventDispatcher:IEventDispatcher;
        
        [Inject]
        public var userModel:IUserModel;
        
        public function GameView()
        {
            super();
            this.addEventListener( MouseEvent.MOUSE_DOWN , onDown );
            this.speedBtn.toggle = true;
            this.speedBtn.addEventListener( MouseEvent.CLICK , onSpeed );
            this.menuBtn.addEventListener( MouseEvent.CLICK , onMenu );
        }
        
        private function onChangeUserInfo( e:UserInfoEvent ):void
        {
            this.txtCoin.text = userModel.info.zeny.toString();
        }
        
        protected function onDown( e:MouseEvent):void
        {
            e.stopImmediatePropagation();
        }
        
        private function onRestart( e:GameEvent ):void
        {
            this.txtCoin.text = userModel.info.zeny.toString();
            this.speedBtn.selected = false;
        }
        
        protected function onSpeed( e:MouseEvent):void
        {
            dispatchEvent( new GameEvent( GameEvent.SPEED ));
            e.stopImmediatePropagation();
        }
        
        public function initialize():void
        {
            var userInfo:UserInfo = userModel.info as UserInfo;
            this.txtCoin.text = userInfo.zeny.toString();
            userModel.info.addEventListener( UserInfoEvent.USER_INFO_CHANGE , onChangeUserInfo );
            addContextListener( GameEvent.RESTART , onRestart );
        }
        
        protected function onMenu( e:MouseEvent):void
        {
            dispatchEvent( new GameEvent( GameEvent.OPEN_MENU ) );
            e.stopImmediatePropagation();
        }
        
        protected function addContextListener(eventString:String, listener:Function, eventClass:Class = null):void
        {
            eventMap.mapListener(eventDispatcher, eventString, listener, eventClass);
        }
        
        protected function removeContextListener(eventString:String, listener:Function, eventClass:Class = null):void
        {
            eventMap.unmapListener(eventDispatcher, eventString, listener, eventClass);
        }
    }
}