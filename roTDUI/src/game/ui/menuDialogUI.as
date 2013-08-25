/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class menuDialogUI extends Dialog {
		public var chooseBtn:Button;
		public var continueBtn:Button;
		public var restartBtn:Button;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.td_interface.menuBg" x="0" y="0"/>
			  <Button skin="png.td_interface.btn_choose" x="78" y="230" var="chooseBtn" name="chooseBtn"/>
			  <Button skin="png.td_interface.btn_continue" x="78" y="50" var="continueBtn" name="continueBtn"/>
			  <Button skin="png.td_interface.btn_restart" x="78" y="140" var="restartBtn" name="restartBtn"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}