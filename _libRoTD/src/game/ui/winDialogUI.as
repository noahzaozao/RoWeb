/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class winDialogUI extends Dialog {
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.td_interface.winBg" x="0" y="0" mouseChildren="false" mouseEnabled="false"/>
			  <Button skin="png.td_interface.btn_continue" x="127" y="168"/>
			  <Button skin="png.td_interface.btn_choose" x="127" y="88"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}