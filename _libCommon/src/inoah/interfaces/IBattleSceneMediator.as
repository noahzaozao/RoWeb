package inoah.interfaces
{
    public interface IBattleSceneMediator extends ISceneMediator
    {
        function createMonser(posx:uint,posy:uint,camp:uint = 2):void;
    }
}