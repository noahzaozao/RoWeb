package inoah.game.ro.modules.main.view.mediator
{
    import inoah.game.ro.modules.main.view.events.GameEvent;
    import inoah.game.ro.ui.sysView.AlertView;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class AlertViewMediator extends Mediator
    {
        [Inject]
        public var view:AlertView;
        
        public function AlertViewMediator()
        {
        }
        
        override public function initialize():void
        {
            addViewListener( GameEvent.HIDE_ALERT , onHideAlert , GameEvent );
        }
        
        private function onHideAlert( e:GameEvent ):void
        {
            view.msgList.shift();
            if( view.msgList.length > 0 )
            {
                view.txtMsg.text = view.msgList[0];
            }
            else
            {
                view.parent.removeChild( view );
            }
        }
    }
}