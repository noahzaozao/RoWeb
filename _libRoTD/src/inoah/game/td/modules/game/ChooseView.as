package inoah.game.td.modules.game
{
    import flash.events.MouseEvent;
    
    import game.ui.chooseViewUI;
    
    import inoah.game.ro.modules.main.view.events.GameEvent;
    
    public class ChooseView extends chooseViewUI
    {
        public function ChooseView()
        {
            super();
//            this.backBtn.addEventListener( MouseEvent.CLICK , onBack );
            this.startBtn.addEventListener( MouseEvent.CLICK , onStart );
        }
        
        protected function onBack( e:MouseEvent ):void
        {
            dispatchEvent( new GameEvent( GameEvent.BACK ));
            this.remove();
            e.stopImmediatePropagation();
        }
        
        protected function onStart( e:MouseEvent ):void
        {
            dispatchEvent( new GameEvent( GameEvent.CHOOSE ));
            this.remove();
            e.stopImmediatePropagation();
        }
    }
}