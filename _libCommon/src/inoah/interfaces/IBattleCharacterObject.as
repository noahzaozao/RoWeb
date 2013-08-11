package inoah.interfaces
{
    import flash.geom.Point;
    
    import inoah.interfaces.base.IBaseObject;
    
    public interface IBattleCharacterObject extends IBaseObject
    {
        function get atkCd():Number;
        function get moveCd():Number;
        function get recoverCd():Number;
        //        function set hpBar(bar:HSpbar):void;
        //        function set spBar(bar:HSpbar):void;
        function set hp(val:int):void;
        function get hp():int;
        function set sp(val:int):void;
        function get sp():int;
        function set isDead( value:Boolean ):void;
        function get isDead():Boolean;
        function get endTarget():Point;
        function set endTarget( value:Point ):void;
        //        function get battleCharacterInfo():BattleCharacterInfo;
    }
}