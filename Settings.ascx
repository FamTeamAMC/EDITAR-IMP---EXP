<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Settings.ascx.cs" Inherits="FAMTEAMEditar_IMP_EXP.Settings" %>


<!-- uncomment the code below to start using the DNN Form pattern to create and update settings -->
<%@ Register TagName="label" TagPrefix="dnn" Src="~/controls/labelcontrol.ascx" %>

	<h2 id="dnnSitePanel-BasicSettings" class="dnnFormSectionHead"><a href="" class="dnnSectionExpanded"><%=LocalizeString("BasicSettings")%></a></h2>
	<fieldset>
        <div class="dnnFormItem">
            <dnn:label ID="lblConnection" runat="server" /> 
             <asp:TextBox ID="txtConnection" runat="server" />
        </div>
        <div class="dnnFormItem">
            <dnn:label ID="lblLINEA" runat="server" />
            <asp:TextBox ID="txtLINEA" runat="server" />
        </div>
        <div class="dnnFormItem">
            <dnn:label ID="lblPAIS" runat="server" />
            <asp:TextBox ID="txtPAIS" runat="server" />
        </div>
         <div class="dnnFormItem">
     <dnn:label ID="lblDIAS" runat="server" />
     <asp:TextBox ID="txtDIAS" runat="server" />
 </div>
    </fieldset>