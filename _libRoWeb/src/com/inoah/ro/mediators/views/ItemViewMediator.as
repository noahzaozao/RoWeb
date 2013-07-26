package com.inoah.ro.mediators.views
{
    import com.inoah.ro.ui.sysView.ItemView;
    
    import inoah.game.consts.GameCommands;
    import inoah.game.consts.GameConsts;
    
    import pureMVC.interfaces.INotification;
    import pureMVC.patterns.mediator.Mediator;
    
    public class ItemViewMediator extends Mediator
    {
        public function ItemViewMediator( viewComponent:Object=null)
        {
            super( GameConsts.ITEM_VIEW, viewComponent);
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
            facade.removeMediator( GameConsts.ITEM_VIEW );
        }
        
        public function get mainView():ItemView
        {
            return viewComponent as ItemView;
        }
    }
}