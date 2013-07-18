package com.inoah.ro.mediators.views
{
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.consts.GameConsts;
    import com.inoah.ro.ui.mainViewChildren.ChatView;
    
    import as3.interfaces.INotification;
    import as3.patterns.mediator.Mediator;
    
    public class ChatViewMediator extends Mediator
    {
        public function ChatViewMediator( viewComponent:Object=null)
        {
            super(GameConsts.CHAT_VIEW, viewComponent);
        }
        
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            arr.push( GameCommands.SEND_CHAT  );
            arr.push( GameCommands.RECV_CHAT  );
            return arr;
        }
        
        override public function handleNotification(notification:INotification):void
        {
            var arr:Array;
            switch( notification.getName() )
            {
                case GameCommands.SEND_CHAT:
                {
                    arr = notification.getBody() as Array;
                    sendChat( arr[0] );
                    break;
                }
                case GameCommands.RECV_CHAT:
                {
                    arr = notification.getBody() as Array;
                    recvChat( arr[0] );
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        
        private function recvChat( chatMsg:String ):void
        {
            mainView.addChat( chatMsg );
        }
        
        private function sendChat( chatMsg:String ):void
        {
            facade.sendNotification( GameCommands.RECV_CHAT, [ chatMsg ] );
        }
        
        public function get mainView():ChatView
        {
            return viewComponent as ChatView;
        }
    }
}