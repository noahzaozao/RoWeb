package inoah.game.ro.mediators.views
{
    import inoah.core.consts.MgrTypeConsts;
    import inoah.core.interfaces.ITickable;
    import inoah.core.managers.MainMgr;
    import inoah.game.ro.Global;
    import inoah.game.ro.consts.ConstsGame;
    import inoah.game.ro.consts.commands.GameCommands;
    import inoah.game.ro.managers.DisplayMgr;
    import inoah.game.ro.ui.MainView;
    import inoah.game.ro.ui.mainViewChildren.ChatView;
    import inoah.game.ro.ui.mainViewChildren.JoyStickView;
    import inoah.game.ro.ui.mainViewChildren.SkillBarView;
    import inoah.game.ro.ui.sysView.AlertView;
    import inoah.game.ro.ui.sysView.ItemView;
    import inoah.game.ro.ui.sysView.StatusView;
    
    import pureMVC.interfaces.INotification;
    import pureMVC.patterns.mediator.Mediator;
    
    public class MainViewMediator extends Mediator implements ITickable
    {
        public function MainViewMediator( viewComponent:Object=null)
        {
            super(ConstsGame.MAIN_VIEW, viewComponent);
            
            var view:AlertView = new AlertView();
            view.x = 480 - view.width / 2;
            view.y = 280 - view.height / 2;
            facade.registerMediator( new AlertViewMediator( view ) );
            
            mainView.joyStick.remove();
            //
            if( !Global.IS_MOBILE )
            {
                mainView.joyStick.remove();
                var chatView:ChatView = new ChatView( mainView.chatView );
                facade.registerMediator( new ChatViewMediator( chatView ) );
                var skillView:SkillBarView = new SkillBarView ( mainView.skillBarView );
                facade.registerMediator( new SkillBarViewMediator( skillView ) );
            }
            else
            {
                mainView.chatView.remove();
                mainView.skillBarView.remove();
                var displayMgr:DisplayMgr = MainMgr.instance.getMgr( MgrTypeConsts.DISPLAY_MGR ) as DisplayMgr;
                var joyStickview:JoyStickView = new JoyStickView();
                displayMgr.joyStickLevel.addChild( joyStickview );
                facade.registerMediator( new JoyStickViewMediator( joyStickview ) );
            }
        }
        
        public function tick(delta:Number):void
        {
            
        }
        
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            arr.push( GameCommands.SHOW_ALERT );
            arr.push( GameCommands.OPEN_STATUS  );
            arr.push( GameCommands.OPEN_SKILL  );
            arr.push( GameCommands.OPEN_ITEM  );
            arr.push( GameCommands.OPEN_MAP  );
            arr.push( GameCommands.OPEN_TASK  );
            arr.push( GameCommands.OPEN_OPTION  );
            arr.push( GameCommands.UPDATE_HP  );
            arr.push( GameCommands.UPDATE_SP  );
            arr.push( GameCommands.UPDATE_EXP  );
            arr.push( GameCommands.UPDATE_LV  );
            arr.push( GameCommands.UPDATE_STATUS_POINT  );
            return arr;
        }
        
        override public function handleNotification(notification:INotification):void
        {
            var arr:Array;
            switch( notification.getName() )
            {
                case GameCommands.SHOW_ALERT:
                {
                    arr = notification.getBody() as Array;
                    showAlert( arr[0] );
                    break;
                }
                case GameCommands.OPEN_STATUS:
                {
                    openStatus();
                    break;
                }
                case GameCommands.OPEN_SKILL:
                {
                    openSkill();
                    break;
                }
                case GameCommands.OPEN_ITEM:
                {
                    openItem();
                    break;
                }
                case GameCommands.OPEN_MAP:
                {
                    openMap();
                    break;
                }
                case GameCommands.OPEN_TASK:
                {
                    openTask();
                    break;
                }
                case GameCommands.OPEN_OPTION:
                {
                    openOption();
                    break;
                }
                case GameCommands.UPDATE_HP:
                {
                    mainView.updateHp();
                    break;
                }
                case GameCommands.UPDATE_SP:
                {
                    mainView.updateSp();
                    break;
                }
                case GameCommands.UPDATE_EXP:
                {
                    mainView.updateExp();
                    break;
                }
                case GameCommands.UPDATE_LV:
                {
                    mainView.updateLv();
                    break;
                }
                case GameCommands.UPDATE_STATUS_POINT:
                {
                    mainView.updateStatusPoint();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        
        private function showAlert( msg:String ):void
        {
            var view:AlertView = (facade.retrieveMediator( ConstsGame.ALERT_VIEW ) as AlertViewMediator).mainView;
            mainView.addChild( view );
        }
        
        private function openOption():void
        {
            if( !facade.hasMediator( ConstsGame.OPTION_VIEW ) )
            {
                facade.sendNotification( GameCommands.RECV_CHAT , [ "<font color='#ffff00'>The module is not available!</font>" ] );
            }
        }
        
        private function openTask():void
        {
            if( !facade.hasMediator( ConstsGame.TASK_VIEW ) )
            {
                facade.sendNotification( GameCommands.RECV_CHAT , [ "<font color='#ffff00'>The module is not available!</font>" ] );
            }
        }
        
        private function openMap():void
        {
            if( !facade.hasMediator( ConstsGame.MAP_VIEW ) )
            {
                facade.sendNotification( GameCommands.RECV_CHAT , [ "<font color='#ffff00'>The module is not available!</font>" ] );
            }
        }
        
        private function openItem():void
        {
            if( !facade.hasMediator( ConstsGame.ITEM_VIEW ) )
            {
                var view:ItemView = new ItemView();
                view.x = 480 - view.width / 2;
                view.y = 280 - view.height / 2;
                mainView.addChild( view );
                facade.registerMediator( new ItemViewMediator( view ) );
            }
        }
        
        private function openSkill():void
        {
            if( !facade.hasMediator( ConstsGame.SKILL_VIEW ) )
            {
                facade.sendNotification( GameCommands.RECV_CHAT , [ "<font color='#ffff00'>The module is not available!</font>" ] );
            }
        }
        
        private function openStatus():void
        {
            if( !facade.hasMediator( ConstsGame.STATUS_VIEW ) )
            {
                var view:StatusView = new StatusView();
                view.x = 480 - view.width / 2;
                view.y = 280 - view.height / 2;
                mainView.addChild( view );
                facade.registerMediator( new StatusViewMediator( view ) );
            }
        }
        
        public function get mainView():MainView
        {
            return viewComponent as MainView;
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
    }
}