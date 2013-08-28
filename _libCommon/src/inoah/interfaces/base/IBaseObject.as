package inoah.interfaces.base
{
    import flash.geom.Point;
    
    import inoah.interfaces.IViewObject;
    import inoah.interfaces.info.ICharacterInfo;
    import inoah.utils.QTree;
    
    public interface IBaseObject
    {
        function get gid():uint;
        function set qTree(q:QTree):void
        function get qTree():QTree;
        function tick(delta:Number):void;
        function set playRate( value:Number ):void;
        function set controller( ctrl:IBaseController ):void;
        function get controller():IBaseController;
        function set action(u:int):void;
        function get action():int;
        function set direction(u:int):void;
        function get direction():int;
        function set viewObject( value:IViewObject ):void;
        function get viewObject():IViewObject;
        function set offsetX( value:Number ):void;
        function set offsetY( value:Number ):void;
        function get POS():Point;
        function get posX():Number;
        function get posY():Number;
        function set posX( value:Number ):void;
        function set posY( value:Number ):void;
        function setTiledPos( tiledPos:Point ):void;
        function set isInScene( value:Boolean ):void;
        function get isInScene():Boolean;
        function set info( value:ICharacterInfo ):void;
        function get info():ICharacterInfo;
        function dispose():void;
    }
}