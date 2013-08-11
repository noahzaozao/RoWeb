package inoah.interfaces.managers
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;
    import inoah.interfaces.base.ILoader;

    public interface IAssetMgr extends IMediator
    {
        function getResList( resPathList:Vector.<String>, callBack:Function, onProgress:Function = null ):void;
        function getRes( resPath:String, callBack:Function = null ):ILoader;
    }
}