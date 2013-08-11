package inoah.interfaces.factory
{
    import inoah.interfaces.character.IPlayerObject;

    public interface IPlayerFactory
    {
        function newPlayerObject():IPlayerObject;
    }
}