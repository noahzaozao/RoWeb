package inoah.game.ro.viewModels.actTpc
{
    import inoah.game.ro.events.ActTpcEvent;

    public class ActTpcBodyView extends ActTpcView
    {
        public function ActTpcBodyView()
        {
            super();
        }
        
        override public function updateFrame():void
        {
            super.updateFrame();
            dispatchEvent( new ActTpcEvent( ActTpcEvent.MOTION_NEXT_FRAME ) );
        }
    }
}