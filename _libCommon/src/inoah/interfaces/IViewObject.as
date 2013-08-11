package inoah.interfaces
{
    import inoah.interfaces.base.ITickable;

    public interface IViewObject extends ITickable
    {
        function get x():Number;
        function get y():Number;
        function get action():int;
        function get direction():int;
        function get isPlayEnd():Boolean;
        function set x( value:Number ):void;
        function set y( value:Number ):void;
        function set action( value:int ):void;
        function set direction( value:int ):void;
        function set isPlayEnd( value:Boolean ):void;
        function set gid( value:uint ):void;
        
        function set playRate( value:Number ):void;
        function setChooseCircle( value:Boolean ):void;
        function dispose():void;
    }
}