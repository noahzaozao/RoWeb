package inoah.modules.core.model
{
    import inoah.modules.core.model.event.ExampleModelUpdate;
    import inoah.modules.core.model.vo.AnswerVO;
    
    public class ExampleModel extends BaseModel
    {
        public function ExampleModel() 
        {
        }
        
        public function createMessage(jsonObject:Object):void 
        {
            logger.debug("5. We're now in the model prepping the data::::::::");
            logger.debug("6. We are going to pass the answer object to the Example Model Update Event::::: " + jsonObject.data.answer);
            var valueObject:AnswerVO = new AnswerVO();
            valueObject.answer = jsonObject.data.answer;
            logger.debug("7. Dispatch event to let the ui know we've changed:::::::::::")
            dispatch(new ExampleModelUpdate(ExampleModelUpdate.MODEL_UPDATED, valueObject));
        }
    }
}