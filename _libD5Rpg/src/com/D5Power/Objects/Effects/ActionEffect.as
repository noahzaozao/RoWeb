package com.D5Power.Objects.Effects
{
    import com.D5Power.scene.BaseScene;
    
    import flash.display.BlendMode;
    
    /**
     * 动画效果
     */ 
    public class ActionEffect extends EffectObject
    {
        public function ActionEffect(scene:BaseScene)
        {
            super(scene);
            
            _renderPos = CENTER;
            blendMode = BlendMode.ADD;
        }
        
        /**
         * 渲染自己在屏幕上输出
         */
        override protected function enterFrame():Boolean
        {
            if(!super.enterFrame()) return false;
            
            if(_currentFrame==0 && _lastFrame!=0)
            {
                _scene.removeObject(this);
            }
            
            return true;
        }
    }
}