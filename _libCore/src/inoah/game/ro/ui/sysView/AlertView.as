package inoah.game.ro.ui.sysView
{
    import flash.events.MouseEvent;
    
    import game.ui.sysViews.alertViewUI;
    
    import inoah.game.ro.consts.commands.GameCommands;
    
    import pureMVC.patterns.facade.Facade;
    
    public class AlertView extends alertViewUI
    {
        public function AlertView()
        {
            super();
            this.txtMsg.mouseChildren = false;
            this.txtMsg.mouseEnabled = false;
            this.btnOk.addEventListener( MouseEvent.CLICK , onOkHandler );
        }
        
        protected function onOkHandler( e:MouseEvent):void
        {
            Facade.getInstance().sendNotification( GameCommands.HIDE_ALERT );
        }
    }
}