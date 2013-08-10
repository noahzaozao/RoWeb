package inoah.interfaces
{
    public interface IPlayerFactory
    {
        function newPlayerController():IPlayerController;
        function newTiledPlayerController():IPlayerController;
    }
}