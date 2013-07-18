package com.inoah.ro.ui.sysView
{
    import com.inoah.ro.consts.GameCommands;
    
    import flash.events.MouseEvent;
    
    import as3.patterns.facade.Facade;
    
    import game.ui.sysViews.itemViewUI;
    
    public class ItemView extends itemViewUI
    {
        public function ItemView()
        {
            super();
            this.btnClose.addEventListener( MouseEvent.CLICK , onClickHandler );
        }
        
        protected function onClickHandler( e:MouseEvent):void
        {
            Facade.getInstance().sendNotification( GameCommands.CLOSE_ITEM );
        }
    }
}