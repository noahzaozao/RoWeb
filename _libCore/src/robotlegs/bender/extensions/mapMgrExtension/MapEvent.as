package robotlegs.bender.extensions.mapMgrExtension
{
    import flash.events.Event;
    
    public class MapEvent extends Event
    {
        public static const CHANGE_MAP:String = "MapEvent.CHANGE_MAP";
        
        public var mapId:int;
        
        public function MapEvent(type:String , mapId:int )
        {
            super(type);
            this.mapId = mapId;
        }
    }
}