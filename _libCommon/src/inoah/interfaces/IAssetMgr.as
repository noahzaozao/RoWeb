package inoah.interfaces
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;

    public interface IAssetMgr extends IMediator
    {
        function getResList( resPathList:Vector.<String>, callBack:Function, onProgress:Function = null ):void;
        function getRes( resPath:String, callBack:Function = null ):ILoader;
    }
}