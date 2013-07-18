package com.inoah.ro.mediators.views
{
    import com.inoah.ro.consts.GameConsts;
    
    import as3.patterns.mediator.Mediator;
    
    public class SkillBarViewMediator extends Mediator
    {
        public function SkillBarViewMediator( viewComponent:Object=null)
        {
            super(GameConsts.SKILL_BAR_VIEW, viewComponent);
        }
    }
}