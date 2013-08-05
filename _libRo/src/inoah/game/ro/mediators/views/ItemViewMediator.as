package inoah.game.ro.mediators.views
{
    import inoah.core.consts.ConstsGame;
    import inoah.core.consts.commands.GameCommands;
    import inoah.game.ro.ui.sysView.ItemView;
    
    import pureMVC.interfaces.INotification;
    import pureMVC.patterns.mediator.Mediator;
    
    public class ItemViewMediator extends Mediator
    {
        public function ItemViewMediator( viewComponent:Object=null)
        {
            super( ConstsGame.ITEM_VIEW, viewComponent);
        }
        
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            arr.push( GameCommands.CLOSE_ITEM  );
            return arr;
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch( notification.getName() )
            {
                case GameCommands.CLOSE_ITEM:
                {
                    closeItem();
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        
        private function closeItem():void
        {
            mainView.parent.removeChild( mainView );
            facade.removeMediator( ConstsGame.ITEM_VIEW );
        }
        
        public function get mainView():ItemView
        {
            return viewComponent as ItemView;
        }
    }
}