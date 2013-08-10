package inoah.game.ro.modules.map.view.events
{
    import flash.events.Event;
    
    public class SceneEvent extends Event
    {
        public function SceneEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}