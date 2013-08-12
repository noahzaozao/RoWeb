package inoah.interfaces
{
    import flash.utils.ByteArray;
    
    import inoah.core.viewModels.actSpr.structs.CSPR;
    
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;

    public interface ISprMgr extends IMediator
    {
        function getCSPR( resId:String , sprByte:ByteArray, loadAsync:Function=null):CSPR;
        function disposeTexture( texture:CSPR ):void;
    }
}