package com.inoah.ro.ui.sysView
{
    import com.inoah.ro.consts.GameCommands;
    
    import flash.events.MouseEvent;
    
    import as3.patterns.facade.Facade;
    
    import game.ui.sysViews.statusViewUI;
    
    public class StatusView extends statusViewUI
    {
        public function StatusView()
        {
            super();
            this.btnClose.addEventListener( MouseEvent.CLICK, onCloseHandler );
        }
        
        protected function onCloseHandler( e:MouseEvent):void
        {
            Facade.getInstance().sendNotification( GameCommands.CLOSE_STATUS );
        }
    }
}