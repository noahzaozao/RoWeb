package com.inoah.ro.interfaces
{
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
        
        function set playRate( value:Number ):void;
        
        function dispose():void;
    }
}