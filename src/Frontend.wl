BeginPackage["Notebook`Editor`HTMLProcessor`", {
    "JerryI`Notebook`", 
    "JerryI`Notebook`Evaluator`", 
    "JerryI`Notebook`Kernel`", 
    "JerryI`Notebook`Transactions`",
    "JerryI`Misc`Events`"
}]

Begin["`Internal`"]

HTMLQ[t_Transaction] := (Print["Check pattern!"]; Echo[StringMatchQ[t["Data"], ".html\n"~~___]]; StringMatchQ[t["Data"], ".html"~~___] )


evaluator  = StandardEvaluator["Name" -> "HTML/WSP Evaluator", "InitKernel" -> init, "Pattern" -> (_?HTMLQ), "Priority"->(3)];

    StandardEvaluator`ReadyQ[evaluator, k_] := (
        If[! TrueQ[k["ReadyQ"] ] || ! TrueQ[k["ContainerReadyQ"] ],
            EventFire[t, "Error", "Kernel is not ready"];
            StandardEvaluator`Print[evaluator, "Kernel is not ready"];
            False
        ,
            True
        ]
    );

StandardEvaluator`Evaluate[evaluator, k_, t_] := Module[{list},
    t["Evaluator"] = Notebook`Editor`HTMLEvaluator;
    t["Data"] = StringDrop[t["Data"], 6];

    StandardEvaluator`Print[evaluator, "Kernel`Submit!"];
    Kernel`Submit[k, t];    
];  

init[k_] := Module[{},
    Print["Kernel init..."];
]


End[]

EndPackage[]