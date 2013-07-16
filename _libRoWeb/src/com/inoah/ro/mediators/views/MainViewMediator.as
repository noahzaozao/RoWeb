package com.inoah.ro.mediators.views
{
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.consts.GameConsts;
    import com.inoah.ro.ui.MainView;
    
    import as3.interfaces.INotification;
    import as3.patterns.mediator.Mediator;
    
    import game.ui.statusViewUI;
    
    public class MainViewMediator extends Mediator
    {
        public function MainViewMediator( viewComponent:Object=null)
        {
            super(GameConsts.MAIN_VIEW, viewComponent);
        }
        
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            arr.push( GameCommands.OPEN_STATUS  );
            return arr;
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch( notification.getName() )
            {
                case GameCommands.OPEN_STATUS:
                {
                    openStatus();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        
        private function openStatus():void
        {
            var statusView:statusViewUI = new statusViewUI();
            statusView.x = 400;
            statusView.y = 200;
            mainView.addChild( statusView );
        }
        
        public function get mainView():MainView
        {
            return viewComponent as MainView;
        }
    }
}