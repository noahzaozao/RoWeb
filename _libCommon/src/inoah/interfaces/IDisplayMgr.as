package inoah.interfaces
{
    import flash.display.Sprite;
    
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;
    
    import starling.display.DisplayObject;

    public interface IDisplayMgr extends IMediator
    {
        function initStarling( starlingRoot:DisplayObject ):void;
        function get topLevel():flash.display.Sprite;
        function get uiLevel():flash.display.Sprite;
        function get joyStickLevel():starling.display.Sprite;
        function get unitLevel():starling.display.Sprite;
        function get mapLevel():starling.display.Sprite;
        function get bgLevel():starling.display.Sprite;
        function get displayList():Vector.<flash.display.Sprite>;
    }
}