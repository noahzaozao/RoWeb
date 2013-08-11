package inoah.interfaces
{
    import inoah.interfaces.info.IUserInfo;

    public interface IUserModel
    {
        function set info( value:IUserInfo ):void;
        function get info():IUserInfo;
    }
}