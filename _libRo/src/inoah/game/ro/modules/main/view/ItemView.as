package inoah.game.ro.modules.main.view
{
    import flash.events.MouseEvent;
    
    import game.ui.sysViews.itemViewUI;
    
    import inoah.game.ro.modules.main.view.events.GameEvent;
    
    public class ItemView extends itemViewUI
    {
        public function ItemView()
        {
            super();
            this.btnClose.addEventListener( MouseEvent.CLICK , onClickHandler );
        }
        
        protected function onClickHandler( e:MouseEvent):void
        {
            dispatchEvent( new GameEvent( GameEvent.CLOSE_ITEM ) );
        }
    }
}