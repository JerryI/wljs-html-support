BeginPackage["JerryI`WolframJSFrontend`HTMLSupport`"];

Begin["Private`"];

WSPProcessor[expr_String, signature_String, parent_String, callback_] := Module[{str = StringDrop[expr, StringLength[First[StringSplit[expr, "\n"]]] ]},
  Print["WSPProcessor!"];
  JerryI`WolframJSFrontend`Notebook`Notebooks[signature]["kernel"][JerryI`WolframJSFrontend`Evaluator`TemplateEvaluator[str, signature, "html", parent], callback, "Link"->"WSTP"];
];

WSPQ[str_]      := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.(html)$"]]] > 0;

JerryI`WolframJSFrontend`Notebook`NotebookAddEvaluator[(WSPQ      ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->WSPProcessor       |>), "HighestPriority"];

End[];

EndPackage[];