package inoah.interfaces.managers
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;

    public interface IKeyMgr extends IMediator
    {
        function isDown( keyCode:uint ):Boolean;
        function isUp( keyCode:uint ):Boolean;
    }
}