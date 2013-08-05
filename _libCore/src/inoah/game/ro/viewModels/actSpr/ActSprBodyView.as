package inoah.game.ro.viewModels.actSpr
{
    import inoah.game.ro.events.ActSprEvent;

    /**
     * body view 
     * @author inoah
     * 
     */    
    public class ActSprBodyView extends ActSprView
    {
        public function ActSprBodyView()
        {
            super();
        }
        
        override public function updateFrame():void
        {
            super.updateFrame();
            dispatchEvent( new ActSprEvent( ActSprEvent.NEXT_FRAME ) );
        }
    }
}