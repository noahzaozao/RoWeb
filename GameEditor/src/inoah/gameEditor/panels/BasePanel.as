package inoah.gameEditor.panels
{
    import com.bit101.components.List;
    import com.bit101.components.PushButton;
    import com.bit101.components.Window;
    
    import flash.display.DisplayObjectContainer;
    
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;
    
    public class BasePanel extends Window implements IMediator
    {
        protected var _sideBarMaxBtn:PushButton;
        protected var _sideBarList:List;
        
        public function BasePanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Window")
        {
            super(parent, xpos, ypos, title);
        }
        
        override protected function init():void
        {
            super.init();
            this.draggable = false;
            _sideBarList = new List( this );
            _sideBarMaxBtn = new PushButton( this , 0, 0, "更改最大值" );
        }
        
        public function initialize():void
        {
            
        }
        
        public function destroy():void
        {
            
        }
        
        override public function setSize(w:Number, h:Number):void
        {
            super.setSize( w, h );
            if( _sideBarList )
            {
                _sideBarList.setSize( 200 , h - 50 );
            }
            if( _sideBarMaxBtn )
            {
                _sideBarMaxBtn.x = 5;
                _sideBarMaxBtn.y = h - 48;
                _sideBarMaxBtn.setSize( 190 , 24 );
            }
        }
        
        public function listNotificationInterests():Array 
        {
            var arr:Array = [];
            return arr;
        }
        public function dispose():void
        {
            if( this.parent )
            {
                this.parent.removeChild( this );
            }
            //            if( Facade.getInstance().hasMediator( getMediatorName() ) )
            //            {
            //                Facade.getInstance().removeMediator( getMediatorName() );
            //            }
        }
        
        public function getMediatorName():String 
        {	
            throw new Error( "basePanel getMediatorName() must override!" );
        }
        public function setViewComponent( viewComponent:Object ):void  {}
        public function getViewComponent():Object
        {	
            return this;
        }
        public function onRegister( ):void {}
        public function onRemove( ):void {}
    }
}