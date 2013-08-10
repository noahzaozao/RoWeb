package inoah.interfaces
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;

    public interface ISceneMediator extends IMediator
    {
        function ReCut(update:Boolean=true):void;
        //        function addObject( o:BaseObject ):void;
        //        function removeObject( o:BaseObject):void;
        function set offsetX( value:Number ):void;
        function set offsetY( value:Number ):void;
        function tick(delta:Number):void;
    }
}