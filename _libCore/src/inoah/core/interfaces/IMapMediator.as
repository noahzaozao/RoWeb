package inoah.core.interfaces
{
    import inoah.core.objects.BaseObject;

    public interface IMapMediator
    {
        function init( mapId:uint ):void;
        function ReCut(update:Boolean=true):void;
        function addObject( o:BaseObject ):void;
        function removeObject( o:BaseObject):void;
        function set offsetX( value:Number ):void;
        function set offsetY( value:Number ):void;
        function tick(delta:Number):void;
    }
}