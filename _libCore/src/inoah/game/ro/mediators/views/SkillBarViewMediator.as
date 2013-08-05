package inoah.game.ro.mediators.views
{
    import inoah.game.ro.consts.ConstsGame;
    
    import pureMVC.patterns.mediator.Mediator;
    
    public class SkillBarViewMediator extends Mediator
    {
        public function SkillBarViewMediator( viewComponent:Object=null)
        {
            super(ConstsGame.SKILL_BAR_VIEW, viewComponent);
        }
    }
}