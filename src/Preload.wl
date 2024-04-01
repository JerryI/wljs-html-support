PacletRepositories[{
    Github -> "https://github.com/JerryI/wl-wsp"
}, "Directory" -> FileNameJoin[{Internal`Kernel`RootDirectory, "__localkernel", "html-support"}] ];

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

EndPackage[]



