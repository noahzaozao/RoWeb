package robotlegs.bender.extensions.tdMapMgrExtension
{
    import flash.events.Event;
    
    public class MapEvent extends Event
    {
        public static const CHANGE_MAP:String = "MapEvent.CHANGE_MAP";
        public static const BUILD_TOWER:String = "MapEvent.BUILD_TOWER";
        
        public var mapId:int;
        public var mapType:int;
        
        public function MapEvent(type:String , mapId:int , mapType:int )
        {
            super(type);
            this.mapId = mapId;
            this.mapType = mapType;
        }
    }
}