package inoah.game.ro.mediators.views
{
    import flash.events.Event;
    
    import inoah.game.ro.ui.sysView.StatusView;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class StatusViewMediator extends Mediator
    {
        public function StatusViewMediator( viewComponent:Object=null)
        {
//            addContextListener( GameCommands.CLOSE_STATUS , handleNotification , null );
//            addContextListener( GameCommands.UPDATE_LV , handleNotification , null );
//            addContextListener( GameCommands.UPDATE_STATUS_POINT , handleNotification , null );
        }
        
        public function handleNotification( e:Event ):void
        {
            //            switch( notification.getName() )
            //            {
            //                case GameCommands.CLOSE_STATUS:
            //                {
            //                    closeStatus();
            //                    break;
            //                }
            //                case GameCommands.UPDATE_LV:
            //                case GameCommands.UPDATE_STATUS_POINT:
            //                {
            //                    updateStatusPoint();
            //                    break;
            //                }
            //                default:
            //                {
            //                    break;
            //                }
            //            }
        }
        
        private function updateStatusPoint():void
        {
            mainView.refresh();
        }
        
        private function closeStatus():void
        {
            mainView.parent.removeChild( mainView );
            //            facade.removeMediator( ConstsGame .STATUS_VIEW );
        }
        
        public function get mainView():StatusView
        {
            return viewComponent as StatusView;
        }
    }
}