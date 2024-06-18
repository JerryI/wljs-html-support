BeginPackage["Notebook`Editor`HTMLProcessor`", {
    "JerryI`Notebook`", 
    "JerryI`Notebook`Evaluator`", 
    "JerryI`Notebook`Kernel`", 
    "JerryI`Notebook`Transactions`",
    "JerryI`Misc`Events`"
}]

Begin["`Internal`"]

HTMLQ[t_Transaction] := (Print["Check pattern!"]; Echo[StringMatchQ[t["Data"], ".html\n"~~___]]; StringMatchQ[t["Data"], ".html"~~___] )

rootFolder = $InputFileName // DirectoryName;

evaluator  = StandardEvaluator["Name" -> "HTML/WSP Evaluator", "InitKernel" -> init, "Pattern" -> (_?HTMLQ), "Priority"->(3)];

    StandardEvaluator`ReadyQ[evaluator, k_] := (
        If[! TrueQ[k["ReadyQ"] ] || ! TrueQ[k["ContainerReadyQ"] ],
            EventFire[k, "Error", "Kernel is not ready"];
            StandardEvaluator`Print[evaluator, "Kernel is not ready"];
            False
        ,
            (* load kernels stuff. i.e. do it on demand, otherwise it takes too long on the startup *)
            With[{p = Import[FileNameJoin[{rootFolder, "Preload.wl"}], "String"]},
                Module[{monitor},
                
                    monitor["Start"] := With[{},
                        monitor["Spinner"] = Notifications`Spinner["Topic"->"Fetching WSP Packages", "Body"->"Please, wait"];
                        EventFire[k, monitor["Spinner"], Null];
                    ];

                    monitor["End"] := With[{},
                        EventFire[monitor["Spinner"]["Promise"], Resolve, Null];
                    ];

                    With[{cloned = EventClone[k]},
                        EventHandler[cloned, {
                            "Exit" -> Function[Null,
                                EventRemove[cloned];
                                monitor["End"];
                            ]
                        }];
                    ];

                    Kernel`Init[k,   ToExpression[p, InputForm]; , "Once"->True, "TrackingProgress" -> monitor];
                ];
            ];

            True
        ]
    );

StandardEvaluator`Evaluate[evaluator, k_, t_] := Module[{list},
    t["Evaluator"] = Notebook`HTMLEvaluator;
    t["Data"] = StringDrop[t["Data"], 6];

    StandardEvaluator`Print[evaluator, "Kernel`Submit!"];
    Kernel`Submit[k, t];    
];  

init[k_] := Module[{},
    Print["nothing to do..."];
]


End[]

EndPackage[]