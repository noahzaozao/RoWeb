package com.inoah.ro.mediators.views
{
    import inoah.game.consts.GameConsts;
    
    import pureMVC.patterns.mediator.Mediator;
    
    public class SkillBarViewMediator extends Mediator
    {
        public function SkillBarViewMediator( viewComponent:Object=null)
        {
            super(GameConsts.SKILL_BAR_VIEW, viewComponent);
        }
    }
}