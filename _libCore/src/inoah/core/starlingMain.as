package inoah.core
{
    import inoah.interfaces.base.ITickable;
    
    import starling.display.Sprite;
    import starling.events.Event;
    
    public class starlingMain extends Sprite implements ITickable
    {
        public function starlingMain()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
        }
        
        protected function addedToStageHandler( e:Event ):void
        {
            
        }
        
        public function tick( delta:Number ):void
        {
            
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
    }
}