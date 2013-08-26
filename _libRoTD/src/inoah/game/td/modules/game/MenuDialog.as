package inoah.game.td.modules.game
{
    import flash.events.MouseEvent;
    
    import game.ui.menuDialogUI;
    
    import inoah.game.ro.modules.main.view.events.GameEvent;
    
    public class MenuDialog extends menuDialogUI
    {
        public function MenuDialog()
        {
            super();
            this.continueBtn.addEventListener( MouseEvent.CLICK , onContinue );
            this.restartBtn.addEventListener( MouseEvent.CLICK , onRestart );
        }
        
        protected function onRestart( e:MouseEvent):void
        {
            e.stopImmediatePropagation();
            dispatchEvent( new GameEvent( GameEvent.RESTART ));
            this.remove();
        }
        
        protected function onContinue( e:MouseEvent):void
        {
            e.stopImmediatePropagation();
            dispatchEvent( new GameEvent( GameEvent.CONTINUE ));
        }
    }
}