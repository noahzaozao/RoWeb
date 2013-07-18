/**Created by Morn,Do not modify.*/
package game.ui.mainViewChildren {
	import morn.core.components.*;
	public class chatViewUI extends Dialog {
		public var labChat:Label;
		public var txtChat:TextInput;
		private var uiXML:XML =
			<Dialog width="600" height="160" dragArea="0,0,900,500">
			  <Image url="png.basic_interface.dialog_bg" x="0" y="129"/>
			  <Image url="png.comp.blank" x="1" y="27" width="600" height="100"/>
			  <Label text="label" x="1" y="27" width="600" height="100" multiline="true" align="left" mouseChildren="true" mouseEnabled="true" isHtml="true" wordWrap="false" var="labChat" name="labChat" color="0xffffff" size="12"/>
			  <TextInput text="TextInput" skin="png.comp.textinput" x="108" y="132" width="464" height="18" var="txtChat" name="txtChat"/>
			  <Tab labels="chat,battle" skin="png.comp.tab" x="0" y="0"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
    }
}