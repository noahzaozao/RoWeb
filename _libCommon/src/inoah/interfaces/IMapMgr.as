package inoah.interfaces
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;

    public interface IMapMgr extends IMediator
    {
        function tick( delta:Number ):void;
    }
}