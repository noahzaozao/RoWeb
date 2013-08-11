package inoah.interfaces.map
{

    public interface IBattleSceneMediator extends ISceneMediator
    {
        function createMonser(posx:uint,posy:uint,camp:uint = 2):void;
    }
}