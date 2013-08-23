package inoah.interfaces.base
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;

    public interface IBaseController extends IMediator
    {
        function tick( delta:Number ):void;
    }
}