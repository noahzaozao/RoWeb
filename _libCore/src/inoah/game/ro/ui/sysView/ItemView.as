package inoah.game.ro.ui.sysView
{
    import flash.events.MouseEvent;
    
    import game.ui.sysViews.itemViewUI;
    
    import inoah.game.ro.consts.commands.GameCommands;
    
    import pureMVC.patterns.facade.Facade;
    
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