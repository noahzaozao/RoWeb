package inoah.game.ro.modules.map.view.events
{
    import flash.geom.Point;
    
    import starling.events.Event;
    
    public class SceneEvent extends starling.events.Event
    {
        public static const MAP_TOUCH:String = "SceneEvent.MAP_TOUCH";
        
        public var touchGrid:Point;
        
        public function SceneEvent(type:String, touchGrid:Point )
        {
            super(type);
            this.touchGrid = touchGrid;
        }
    }
}