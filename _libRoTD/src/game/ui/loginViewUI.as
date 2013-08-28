/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class loginViewUI extends View {
		public var txtID:TextInput;
		public var txtPass:TextInput;
		public var btnLogin:Button;
		public var btnReg:Button;
		protected var uiXML:XML =
			<View>
			  <Image url="png.login_interface.win_login" x="0" y="0" mouseChildren="false" mouseEnabled="false"/>
			  <CheckBox label="存档" skin="png.comp.checkbox" x="230" y="32"/>
			  <TextInput text="TextInput" skin="png.comp.textinput" x="91" y="28" var="txtID" name="txtID"/>
			  <TextInput text="TextInput" skin="png.comp.textinput" x="91" y="59" var="txtPass" name="txtPass" asPassword="true"/>
			  <Button skin="png.login_interface.btn_connect" x="233" y="96" var="btnLogin" name="btnLogin"/>
			  <Button skin="png.login_interface.btn_request" x="5" y="96" var="btnReg" name="btnReg"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}