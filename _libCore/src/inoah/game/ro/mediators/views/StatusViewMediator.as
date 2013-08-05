package inoah.game.ro.mediators.views
{
    import inoah.game.ro.consts.ConstsGame;
    import inoah.game.ro.consts.commands.GameCommands;
    import inoah.game.ro.ui.sysView.StatusView;
    
    import pureMVC.interfaces.INotification;
    import pureMVC.patterns.mediator.Mediator;
    
    public class StatusViewMediator extends Mediator
    {
        public function StatusViewMediator( viewComponent:Object=null)
        {
            super(ConstsGame.STATUS_VIEW, viewComponent);
        }
        
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            arr.push( GameCommands.CLOSE_STATUS  );
            arr.push( GameCommands.UPDATE_LV  );
            arr.push( GameCommands.UPDATE_STATUS_POINT  );
            return arr;
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch( notification.getName() )
            {
                case GameCommands.CLOSE_STATUS:
                {
                    closeStatus();
                    break;
                }
                case GameCommands.UPDATE_LV:
                case GameCommands.UPDATE_STATUS_POINT:
                {
                    updateStatusPoint();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        
        private function updateStatusPoint():void
        {
            mainView.refresh();
        }
        
        private function closeStatus():void
        {
            mainView.parent.removeChild( mainView );
            facade.removeMediator( ConstsGame.STATUS_VIEW );
        }
        
        public function get mainView():StatusView
        {
            return viewComponent as StatusView;
        }
    }
}