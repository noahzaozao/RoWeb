package inoah.interfaces
{
    import inoah.interfaces.base.IBaseObject;

    public interface ICamera
    {
        function focus(o:IBaseObject=null):void;
        function update():void;
        function get zeroX():Number;
        function get zeroY():Number;
    }
}