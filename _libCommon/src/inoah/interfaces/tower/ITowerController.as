package inoah.interfaces.tower
{
    import inoah.interfaces.base.IBaseController;
    import inoah.interfaces.character.IMonsterObject;

    public interface ITowerController extends IBaseController
    {
        function get towersList():Vector.<ITowerObject>;
        function set towersList( value:Vector.<ITowerObject> ):void;
        function set monsterList( value:Vector.<IMonsterObject> ):void
        function get monsterList():Vector.<IMonsterObject>
    }
}