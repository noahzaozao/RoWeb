package com.inoah.ro.displays.starling
{
    import com.inoah.ro.displays.actspr.structs.acth.AnyPatSprV0101;
    import com.inoah.ro.displays.starling.structs.TPSequence;
    import com.inoah.ro.events.TPMovieClipEvent;
    
    import flash.geom.Point;
    
    public class TpcOtherView extends TpcView
    {
        private var _bodyView:TpcBodyView;
        
        public function TpcOtherView( bodyView:TpcBodyView )
        {
            super();
            _bodyView = bodyView;
        }
        
        override protected function updateFrame():void
        {
            if(_isDisposed == true)
            {
                return;
            }
            
            if(_currentActionFrames.length == 0 || _currentActionFrames[_currentFrame] == null)
            {
                _animationDisplay.texture = NULL_TEXTURE;
                _animationDisplay.x = 0;
                _animationDisplay.y = 0;
                dispatchEvent(new TPMovieClipEvent(TPMovieClipEvent.EMPTY_FRAME));
            }
            else
            {
                var apsv:AnyPatSprV0101 = _tpAnimation.getAspv(_currentFrame);
                var actionSequence:TPSequence =_currentActionFrames[_currentFrame];
                _animationDisplay.texture = actionSequence.texture;
                var w:int = _animationDisplay.texture.width;
                var h:int = _animationDisplay.texture.height;
                var offset:Point = new Point( apsv.xOffs , apsv.yOffs );
                if( apsv.mirrorOn == 0 )
                {
                    _animationDisplay.x = -int(w >> 1) + offset.x + _bodyView.tpAnimation.getAaap.ExtXoffs - _tpAnimation.getAaap( _currentFrame ).ExtXoffs;
                    _animationDisplay.y = -int(h >> 1) + offset.y + _bodyView.tpAnimation.getAaap.ExtYoffs - _tpAnimation.getAaap( _currentFrame ).ExtYoffs;
                    _animationDisplay.scaleX = 1;
                }
                else
                {
                    _animationDisplay.x = int(w >> 1) + offset.x + _bodyView.tpAnimation.getAaap.ExtXoffs - _tpAnimation.getAaap( _currentFrame ).ExtXoffs;
                    _animationDisplay.y = -int(h >> 1) + offset.y + _bodyView.tpAnimation.getAaap.ExtYoffs - _tpAnimation.getAaap( _currentFrame ).ExtYoffs;
                    _animationDisplay.scaleX = -1;
                }
            }
            
            dispatchEvent(new TPMovieClipEvent(TPMovieClipEvent.MOTION_NEXT_FRAME));
            _animationDisplay.readjustSize();
        }
    }
}