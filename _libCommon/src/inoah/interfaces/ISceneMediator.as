package inoah.interfaces
{
    import inoah.interfaces.base.IBaseObject;
    
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;
    
    public interface ISceneMediator extends IMediator
    {
        function ReCut(update:Boolean=true):void;
        function addObject( o:IBaseObject ):void;
        function removeObject( o:IBaseObject):void;
        function set offsetX( value:Number ):void;
        function set offsetY( value:Number ):void;
        function tick(delta:Number):void;
    }
}