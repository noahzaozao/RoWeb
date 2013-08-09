package inoah.modules.core.model.event
{
    import flash.events.Event;
    
    import inoah.modules.core.model.vo.AnswerVO;
    
    public class ExampleModelUpdate extends Event {
        
        public static const MODEL_UPDATED:String = "modelUpdated";
        
        public var model:AnswerVO;
        
        public function ExampleModelUpdate(type:String, model:AnswerVO, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
            this.model = model;
        }
        
        override public function clone():Event {
            return new ExampleModelUpdate(type, model, bubbles, cancelable);
        }
    }
}