TextForm /: MakeBoxes[TextForm[txt_], StandardForm] := With[{o = CreateFrontEndObject[TextForm[txt]]}, MakeBoxes[o, StandardForm]]
HTMLForm /: MakeBoxes[HTMLForm[txt_], StandardForm] := With[{o = CreateFrontEndObject[HTMLForm[txt]]}, MakeBoxes[o, StandardForm]]


Global`SVGForm[x_] := ExportString[x, "SVG"]//HTMLForm;

JSRun[x_String, name_String:"JS"] := (StringTemplate["<div class=\"badge badge-danger\">``</div><script>``</script>"][name, x])//HTMLForm;

Options[WebExport] = {
    Popup -> False 
};

WebOpen[url_] := (
    WebSocketSend[client, FrontEndJSEval[StringTemplate["window.open('``', '_blank')"][url] ] ];
);



