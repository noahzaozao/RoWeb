package inoah.game.ro.mediators.views
{
    import flash.events.Event;
    
    import inoah.game.ro.ui.mainViewChildren.ChatView;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class ChatViewMediator extends Mediator
    {
        public function ChatViewMediator( viewComponent:Object=null)
        {
            //            addContextListener( GameCommands.SEND_CHAT , handleNotification , null );
            //            addContextListener( GameCommands.RECV_CHAT , handleNotification , null );
        }
        
        public function handleNotification( e:Event ):void
        {
            //            var arr:Array;
            //            switch( notification.getName() )
            //            {
            //                case GameCommands.SEND_CHAT:
            //                {
            //                    arr = notification.getBody() as Array;
            //                    sendChat( arr[0] );
            //                    break;
            //                }
            //                case GameCommands.RECV_CHAT:
            //                {
            //                    arr = notification.getBody() as Array;
            //                    recvChat( arr[0] );
            //                    break;
            //                }
            //                default:
            //                {
            //                    break;
            //                }
            //            }
        }
        
        private function recvChat( chatMsg:String ):void
        {
            mainView.addChat( chatMsg );
        }
        
        private function sendChat( chatMsg:String ):void
        {
            //            facade.sendNotification( GameCommands.RECV_CHAT, [ chatMsg ] );
        }
        
        public function get mainView():ChatView
        {
            return viewComponent as ChatView;
        }
    }
}