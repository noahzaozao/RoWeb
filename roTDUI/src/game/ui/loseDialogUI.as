/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class loseDialogUI extends Dialog {
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.td_interface.loseBg" x="0" y="0"/>
			  <Button skin="png.td_interface.btn_again" x="128" y="168"/>
			  <Button skin="png.td_interface.btn_choose" x="128" y="88"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}