package inoah.game.ro.viewModels.actSpr.structs.acth
{
    public interface IAnyPatSprV0205
    {
        function get xOffs():int; 
        function set xOffs( value:int ):void;
        function get yOffs():int; 
        function set yOffs( value:int ):void;
        function get sprNo():uint; 
        function set sprNo( value:uint ):void;
        function get mirrorOn():uint; 
        function set mirrorOn( value:uint ):void;

        function get color():uint; 
        function set color( value:uint ):void;
        function get xyMag():Number; 
        function set xyMag( value:Number ):void;
        function get rot():uint; 
        function set rot( value:uint ):void;
        function get spType():uint; 
        function set spType( value:uint ):void;

        function get xMag():Number; 
        function set xMag( value:Number ):void;
        function get yMag():Number; 
        function set yMag( value:Number ):void;

        function get sprW():uint; 
        function set sprW( value:uint ):void;
        function get sprH():uint; 
        function set sprH( value:uint ):void;
    }
}