package inoah.game.ro.objects
{
    import inoah.interfaces.character.IPlayerObject;

    public class PlayerObject extends BattleCharacterObject implements IPlayerObject
    {
        public function PlayerObject()
        {
            super();
            _atkCd = 1;
            _recoverCd = 5;
        }
    }
}