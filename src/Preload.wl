PacletRepositories[{
    Github -> "https://github.com/JerryI/wl-wsp"
}, "Directory" -> FileNameJoin[{Directory[], "__localkernel", "html-support"}] ];

BeginPackage["Notebook`Editor`HTMLTools`", {
    "JerryI`Notebook`Kernel`", 
    "JerryI`Notebook`Transactions`",
    "JerryI`Misc`Events`",
    "JerryI`WSP`"
}]

Begin["`Private`"]

Notebook`HTMLEvaluator = Function[t, 
            
            With[{result = LoadString[ t["Data"] ]},
                EventFire[Internal`Kernel`Stdout[ t["Hash"] ], "Result", <|"Data" -> result, "Meta" -> Sequence["Display"->"html"] |> ];
                EventFire[Internal`Kernel`Stdout[ t["Hash"] ], "Finished", True];
            ];
];

End[]

HTMLForm /: MakeBoxes[HTMLForm[txt_String], StandardForm] := With[{o = CreateFrontEndObject[HTMLForm[txt]]}, MakeBoxes[o, StandardForm]]
SVGForm[x_] := ExportString[x, "SVG"]//HTMLForm;

EndPackage[]



