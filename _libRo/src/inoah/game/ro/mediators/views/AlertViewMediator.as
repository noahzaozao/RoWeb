package inoah.game.ro.mediators.views
{
    import flash.events.Event;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class AlertViewMediator extends Mediator
    {
        private var _msgList:Vector.<String>;
        
        public function AlertViewMediator( viewComponent:Object=null)
        {
        }
        
        override public function initialize():void
        {
            //            super(ConstsGame.ALERT_VIEW, viewComponent);
            _msgList = new Vector.<String>();
            //            addContextListener( GameCommands.SHOW_ALERT , handleNotification , null );
            //            addContextListener( GameCommands.HIDE_ALERT , handleNotification , null );
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
            //                case GameCommands.HIDE_ALERT:
            //                {
            //                    hideAlert();
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
            _msgList.push( msg );
            //            mainView.txtMsg.text = msg;
        }
        
        private function hideAlert():void
        {
            _msgList.shift();
            if( _msgList.length > 0 )
            {
                //                mainView.txtMsg.text = _msgList[0];
            }
            else
            {
                //                mainView.parent.removeChild( mainView );
            }
        }
    }
}