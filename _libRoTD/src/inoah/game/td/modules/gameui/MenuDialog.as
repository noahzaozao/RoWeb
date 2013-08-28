package inoah.game.td.modules.gameui
{
    import flash.events.MouseEvent;
    
    import game.ui.menuDialogUI;
    
    import inoah.game.ro.modules.main.view.events.GameEvent;
    
    public class MenuDialog extends menuDialogUI
    {
        public function MenuDialog()
        {
            super();
            this.addEventListener( MouseEvent.MOUSE_DOWN , onDown );
            this.continueBtn.addEventListener( MouseEvent.MOUSE_DOWN , onContinue );
            this.restartBtn.addEventListener( MouseEvent.MOUSE_DOWN , onRestart );
        }
        
        protected function onDown( e:MouseEvent):void
        {
            e.stopImmediatePropagation();
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