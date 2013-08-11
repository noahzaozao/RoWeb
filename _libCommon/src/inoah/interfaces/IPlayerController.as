package inoah.interfaces
{
    import inoah.interfaces.base.IBaseController;

    public interface IPlayerController extends IBaseController
    {
        function tick( delta:Number ):void;
        
    }
}