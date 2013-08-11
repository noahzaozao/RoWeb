package inoah.interfaces.controller
{
    import inoah.interfaces.character.IMonsterObject;

    public interface IMonsterController
    {
        function tick( delta:Number ):void;
        function set monsterList( value:Vector.<IMonsterObject> ):void
        function get monsterList():Vector.<IMonsterObject>
    }
}