package com.quadTrees {
    
    public interface INoder {
        
        function set x(value:Number):void;
        function get x():Number;
        function set y(value:Number):void;
        function get y():Number;
        function get node():Node;
        function set node(value:Node):void;
        function get vo():Vo;
        function insert():void;
        function unload():void;
        
    }
}//package com.quadTrees 