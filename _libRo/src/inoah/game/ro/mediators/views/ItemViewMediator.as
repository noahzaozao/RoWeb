package inoah.game.ro.mediators.views
{
    import flash.events.Event;
    
    import inoah.game.ro.ui.sysView.ItemView;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class ItemViewMediator extends Mediator
    {
        public function ItemViewMediator( viewComponent:Object=null)
        {
            //            addContextListener( GameCommands.CLOSE_ITEM , handleNotification , null );
        }
        
        public function handleNotification( e:Event ):void
        {
            //            switch( notification.getName() )
            //            {
            //                case GameCommands.CLOSE_ITEM:
            //                {
            //                    closeItem();
            //                    break;
            //                }
            //                default:
            //                {
            //                    break;
            //                }
            //            }
        }
        
        private function closeItem():void
        {
            mainView.parent.removeChild( mainView );
            //            facade.removeMediator( ConstsGame.ITEM_VIEW );
        }
        
        public function get mainView():ItemView
        {
            return viewComponent as ItemView;
        }
    }
}