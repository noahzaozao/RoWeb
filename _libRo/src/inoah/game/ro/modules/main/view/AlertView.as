package inoah.game.ro.modules.main.view
{
    import flash.events.MouseEvent;
    
    import game.ui.sysViews.alertViewUI;
    
    import inoah.game.ro.modules.main.view.events.GameEvent;
    
    public class AlertView extends alertViewUI
    {
        public var msgList:Vector.<String>;
        
        public function AlertView()
        {
            super();
            msgList = new Vector.<String>();
            this.txtMsg.mouseChildren = false;
            this.txtMsg.mouseEnabled = false;
            this.btnOk.addEventListener( MouseEvent.CLICK , onOkHandler );
        }
        
        public function onShowAlert( e:GameEvent ):void
        {
            msgList.push( e.msg );
            txtMsg.text = msgList[0];
        }
        
        protected function onOkHandler( e:MouseEvent):void
        {
            dispatchEvent( new GameEvent( GameEvent.HIDE_ALERT ) );
        }
    }
}