package inoah.interfaces.controller
{
    import inoah.interfaces.base.IBaseController;
    import inoah.interfaces.character.IMonsterObject;

    public interface IMonsterController extends IBaseController
    {
        function set monsterList( value:Vector.<IMonsterObject> ):void
        function get monsterList():Vector.<IMonsterObject>
        function reset():void
    }
}