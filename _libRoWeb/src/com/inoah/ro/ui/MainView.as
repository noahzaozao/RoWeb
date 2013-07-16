package com.inoah.ro.ui
{
    import com.inoah.ro.consts.GameCommands;
    
    import flash.events.MouseEvent;
    
    import as3.patterns.facade.Facade;
    
    import game.ui.mainViewUI;
    
    public class MainView extends mainViewUI
    {
        public function MainView()
        {
            super();
            this.btnStatus.addEventListener( MouseEvent.CLICK , onStatusHandler );
        }
        
        protected function onStatusHandler( e:MouseEvent):void
        {
            Facade.getInstance().sendNotification( GameCommands.OPEN_STATUS );
        }
    }
}