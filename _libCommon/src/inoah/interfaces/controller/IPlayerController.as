package inoah.interfaces.controller
{
    import inoah.interfaces.base.IBaseController;

    public interface IPlayerController extends IBaseController
    {
        function tick( delta:Number ):void;
        
    }
}