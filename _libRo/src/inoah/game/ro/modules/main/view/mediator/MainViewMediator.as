package inoah.game.ro.modules.main.view.mediator
{
    import flash.events.Event;
    
    import inoah.core.Global;
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.interfaces.ITickable;
    import inoah.core.managers.DisplayMgr;
    import inoah.core.managers.MainMgr;
    import inoah.game.ro.modules.main.view.MainView;
    import inoah.game.ro.ui.mainViewChildren.ChatView;
    import inoah.game.ro.ui.mainViewChildren.JoyStickView;
    import inoah.game.ro.ui.mainViewChildren.SkillBarView;
    import inoah.game.ro.ui.sysView.AlertView;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.extensions.viewManager.api.IViewManager;
    
    public class MainViewMediator extends Mediator implements ITickable
    {
        [Inject]
        public var view:MainView;
        
        [Inject]
        public var viewManager:IViewManager;
        
        public function MainViewMediator() 
        {
            super();
        }
        
        override public function initialize():void 
        {
            var alertView:AlertView = new AlertView();
            alertView.x = 480 - alertView.width / 2;
            alertView.y = 280 - alertView.height / 2;
            //            facade.registerMediator( new AlertViewMediator( view ) );
            
            view.joyStick.remove();
            //
            if( !Global.IS_MOBILE )
            {
                view.joyStick.remove();
                var chatView:ChatView = new ChatView( view.chatView );
                //                facade.registerMediator( new ChatViewMediator( chatView ) );
                var skillView:SkillBarView = new SkillBarView ( view.skillBarView );
                //                facade.registerMediator( new SkillBarViewMediator( skillView ) );
            }
            else
            {
                view.chatView.remove();
                view.skillBarView.remove();
                var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
                var joyStickview:JoyStickView = new JoyStickView();
                displayMgr.joyStickLevel.addChild( joyStickview );
                //                facade.registerMediator( new JoyStickViewMediator( joyStickview ) );
            }
            
            //            addContextListener( GameCommands.SHOW_ALERT , handleNotification , null );
            //            addContextListener( GameCommands.OPEN_STATUS  , handleNotification , null );
            //            addContextListener( GameCommands.OPEN_SKILL  , handleNotification , null );
            //            addContextListener( GameCommands.OPEN_ITEM  , handleNotification , null );
            //            addContextListener( GameCommands.OPEN_MAP  , handleNotification , null );
            //            addContextListener( GameCommands.OPEN_TASK  , handleNotification , null );
            //            addContextListener( GameCommands.OPEN_OPTION  , handleNotification , null );
            //            addContextListener( GameCommands.UPDATE_HP  , handleNotification , null );
            //            addContextListener( GameCommands.UPDATE_SP  , handleNotification , null );
            //            addContextListener( GameCommands.UPDATE_EXP  , handleNotification , null );
            //            addContextListener( GameCommands.UPDATE_LV  , handleNotification , null );
            //            addContextListener( GameCommands.UPDATE_STATUS_POINT  , handleNotification , null );
            
        }
        
        public function tick(delta:Number):void
        {
            
        }
        
        public function handleNotification( e:Event ):void
        {
            //            var arr:Array;
            //            switch( notification.getName() )
            //            {
            //                case GameCommands.SHOW_ALERT:
            //                {
            //                    arr = notification.getBody() as Array;
            //                    showAlert( arr[0] );
            //                    break;
            //                }
            //                case GameCommands.OPEN_STATUS:
            //                {
            //                    openStatus();
            //                    break;
            //                }
            //                case GameCommands.OPEN_SKILL:
            //                {
            //                    openSkill();
            //                    break;
            //                }
            //                case GameCommands.OPEN_ITEM:
            //                {
            //                    openItem();
            //                    break;
            //                }
            //                case GameCommands.OPEN_MAP:
            //                {
            //                    openMap();
            //                    break;
            //                }
            //                case GameCommands.OPEN_TASK:
            //                {
            //                    openTask();
            //                    break;
            //                }
            //                case GameCommands.OPEN_OPTION:
            //                {
            //                    openOption();
            //                    break;
            //                }
            //                case GameCommands.UPDATE_HP:
            //                {
            //                    mainView.updateHp();
            //                    break;
            //                }
            //                case GameCommands.UPDATE_SP:
            //                {
            //                    mainView.updateSp();
            //                    break;
            //                }
            //                case GameCommands.UPDATE_EXP:
            //                {
            //                    mainView.updateExp();
            //                    break;
            //                }
            //                case GameCommands.UPDATE_LV:
            //                {
            //                    mainView.updateLv();
            //                    break;
            //                }
            //                case GameCommands.UPDATE_STATUS_POINT:
            //                {
            //                    mainView.updateStatusPoint();
            //                    break;
            //                }
            //                default:
            //                {
            //                    break;
            //                }
            //            }
        }
        
        private function showAlert( msg:String ):void
        {
            //            var view:AlertView = (facade.retrieveMediator( ConstsGame.ALERT_VIEW ) as AlertViewMediator).mainView;
            //            mainView.addChild( view );
        }
        
        private function openOption():void
        {
            //            if( !facade.hasMediator( ConstsGame.OPTION_VIEW ) )
            //            {
            //                facade.sendNotification( GameCommands.RECV_CHAT , [ "<font color='#ffff00'>The module is not available!</font>" ] );
            //            }
        }
        
        private function openTask():void
        {
            //            if( !facade.hasMediator( ConstsGame.TASK_VIEW ) )
            //            {
            //                facade.sendNotification( GameCommands.RECV_CHAT , [ "<font color='#ffff00'>The module is not available!</font>" ] );
            //            }
        }
        
        private function openMap():void
        {
            //            if( !facade.hasMediator( ConstsGame.MAP_VIEW ) )
            //            {
            //                facade.sendNotification( GameCommands.RECV_CHAT , [ "<font color='#ffff00'>The module is not available!</font>" ] );
            //            }
        }
        
        private function openItem():void
        {
            //            if( !facade.hasMediator( ConstsGame.ITEM_VIEW ) )
            //            {
            //                var view:ItemView = new ItemView();
            //                view.x = 480 - view.width / 2;
            //                view.y = 280 - view.height / 2;
            //                mainView.addChild( view );
            //                facade.registerMediator( new ItemViewMediator( view ) );
            //            }
        }
        
        private function openSkill():void
        {
            //            if( !facade.hasMediator( ConstsGame.SKILL_VIEW ) )
            //            {
            //                facade.sendNotification( GameCommands.RECV_CHAT , [ "<font color='#ffff00'>The module is not available!</font>" ] );
            //            }
        }
        
        private function openStatus():void
        {
            //            if( !facade.hasMediator( ConstsGame.STATUS_VIEW ) )
            //            {
            //                var view:StatusView = new StatusView();
            //                view.x = 480 - view.width / 2;
            //                view.y = 280 - view.height / 2;
            //                mainView.addChild( view );
            //                facade.registerMediator( new StatusViewMediator( view ) );
            //            }
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