package inoah.game.ro.modules.main.view.mediator
{
    import inoah.core.Global;
    import inoah.game.ro.modules.main.model.UserModel;
    import inoah.game.ro.modules.main.view.AlertView;
    import inoah.game.ro.modules.main.view.ChatView;
    import inoah.game.ro.modules.main.view.ItemView;
    import inoah.game.ro.modules.main.view.JoyStickView;
    import inoah.game.ro.modules.main.view.MainView;
    import inoah.game.ro.modules.main.view.SkillBarView;
    import inoah.game.ro.modules.main.view.StatusView;
    import inoah.game.ro.modules.main.view.events.GameEvent;
    import inoah.game.ro.modules.main.view.events.JoyStickEvent;
    import inoah.interfaces.IAssetMgr;
    import inoah.interfaces.IDisplayMgr;
    import inoah.interfaces.ILoader;
    import inoah.interfaces.ITickable;
    import inoah.interfaces.IUserModel;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.extensions.viewManager.api.IViewManager;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.ILogger;
    
    public class MainViewMediator extends Mediator implements ITickable
    {
        [Inject]
        public var userModel:IUserModel;
        
        [Inject]
        public var displayMgr:IDisplayMgr;
        
        [Inject]
        public var view:MainView;
        
        [Inject]
        public var context:IContext;
        
        [Inject]
        public var assetMgr:IAssetMgr;
        
        [Inject]
        public var viewManager:IViewManager;
        
        [Inject]
        public var contextView:ContextView;
        
        [Inject]
        public var logger:ILogger;
        
        private var _alertView:AlertView;
        private var _chatView:ChatView;
        
        public function MainViewMediator() 
        {
            super();
        }
        
        override public function initialize():void 
        {
            assetMgr.getRes( "map/1s.jpg" , onLoadMiniMap );
            
            _alertView = new AlertView();
            _alertView.x = 480 - _alertView.width / 2;
            _alertView.y = 280 - _alertView.height / 2;
            
            view.joyStick.remove();
            //
            if( !Global.IS_MOBILE )
            {
                //chatView
                _chatView = new ChatView( view.chatView , userModel as UserModel );
                _chatView.addEventListener( GameEvent.SEND_CHAT , onSendChat );
                addContextListener( GameEvent.RECV_CHAT , onRecvChat , GameEvent );
                var skillView:SkillBarView = new SkillBarView ( view.skillBarView );
            }
            else
            {
                view.chatView.remove();
                view.skillBarView.remove();
                assetMgr.getRes( "ui/joyStickDirMain.png", onLoadJoyStick );
            }
            
            view.updateInfo( userModel as UserModel );
            
            addViewListener( GameEvent.OPEN_STATUS  , onStatus , GameEvent );
            addViewListener( GameEvent.OPEN_SKILL  , onSkill , GameEvent );
            addViewListener( GameEvent.OPEN_ITEM  , onItem , GameEvent );
            addViewListener( GameEvent.OPEN_MAP  , onMap , GameEvent );
            addViewListener( GameEvent.OPEN_TASK  , onTask , GameEvent );
            addViewListener( GameEvent.OPEN_OPTION  , onOption , GameEvent );
            addViewListener( GameEvent.UPDATE_HP  , handleNotification , GameEvent );
            addViewListener( GameEvent.UPDATE_SP  , handleNotification , GameEvent );
            addViewListener( GameEvent.UPDATE_EXP  , handleNotification , GameEvent );
            addViewListener( GameEvent.UPDATE_LV  , handleNotification , GameEvent );
            addViewListener( GameEvent.UPDATE_STATUS_POINT  , handleNotification , GameEvent );
            //alertView
            addContextListener( GameEvent.SHOW_ALERT , onShowAlert , GameEvent );
            
//            dispatch( new GameEvent( GameEvent.SHOW_ALERT , "test" ) );
        }
        
        private function onRecvChat( e:GameEvent ):void
        {
            _chatView.addChat( e.msg );
        }
        
        private function onSendChat( e:GameEvent ):void
        {
            dispatch( e );
            onRecvChat( e );
        }
        
        private function onLoadMiniMap( loader:ILoader ):void
        {
            view.initializeMap( loader );           
        }
        
        private function onLoadJoyStick( loader:ILoader ):void
        {
            var joyStickView:JoyStickView = view.initializeJoystick( loader );
            context.injector.injectInto( joyStickView );
            displayMgr.joyStickLevel.addChild( joyStickView );
            
            addViewListener( JoyStickEvent.JOY_STICK_ATTACK , dispatch );
            addViewListener( JoyStickEvent.JOY_STICK_DOWN , dispatch );
            addViewListener( JoyStickEvent.JOY_STICK_DOWN_LEFT , dispatch );
            addViewListener( JoyStickEvent.JOY_STICK_DOWN_RIGHT , dispatch );
            addViewListener( JoyStickEvent.JOY_STICK_LEFT , dispatch );
            addViewListener( JoyStickEvent.JOY_STICK_RIGHT , dispatch );
            addViewListener( JoyStickEvent.JOY_STICK_UP , dispatch );
            addViewListener( JoyStickEvent.JOY_STICK_UP_LEFT , dispatch );
            addViewListener( JoyStickEvent.JOY_STICK_UP_RIGHT , dispatch );
        }
        
        public function tick(delta:Number):void
        {
            
        }
        
        public function handleNotification( e:GameEvent ):void
        {
            switch( e.type )
            {
                
                case GameEvent.UPDATE_HP:
                {
                    view.updateHp( userModel as UserModel );
                    break;
                }
                case GameEvent.UPDATE_SP:
                {
                    view.updateSp( userModel as UserModel );
                    break;
                }
                case GameEvent.UPDATE_EXP:
                {
                    view.updateExp( userModel as UserModel );
                    break;
                }
                case GameEvent.UPDATE_LV:
                {
                    view.updateLv( userModel as UserModel );
                    break;
                }
                case GameEvent.UPDATE_STATUS_POINT:
                {
                    view.updateStatusPoint( userModel as UserModel );
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        
        private function onShowAlert( e:GameEvent ):void
        {
            _alertView.onShowAlert( e );
            view.addChild( _alertView );
        }
        
        private function onOption( e:GameEvent ):void
        {
            dispatch( new GameEvent( GameEvent.RECV_CHAT , "<font color='#ffff00'>The module is not available!</font>" ) );
        }
        
        private function onTask( e:GameEvent ):void
        {
            dispatch( new GameEvent( GameEvent.RECV_CHAT , "<font color='#ffff00'>The module is not available!</font>" ) );
        }
        
        private function onMap( e:GameEvent ):void
        {
            dispatch( new GameEvent( GameEvent.RECV_CHAT , "<font color='#ffff00'>The module is not available!</font>" ) );
        }
        
        private function onItem( e:GameEvent ):void
        {
            var itemView:ItemView = context.injector.getOrCreateNewInstance(ItemView) as ItemView;
            itemView.x = 480 - itemView.width / 2;
            itemView.y = 280 - itemView.height / 2;
            displayMgr.uiLevel.addChild( itemView );
        }
        
        private function onSkill( e:GameEvent ):void
        {
            dispatch( new GameEvent( GameEvent.RECV_CHAT , "<font color='#ffff00'>The module is not available!</font>" ) );
        }
        
        private function onStatus( e:GameEvent ):void
        {
            var statusView:StatusView = context.injector.getOrCreateNewInstance(StatusView) as StatusView;
            statusView.x = 480 - statusView.width / 2;
            statusView.y = 280 - statusView.height / 2;
            displayMgr.uiLevel.addChild( statusView );
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
        
        override public function destroy():void 
        {
            
        }
    }
}