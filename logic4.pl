:- ensure_loaded('/var/lib/myfrdcsa/codebases/minor/interactive-execution-monitor/frdcsa/sys/flp/autoload/args.pl').
:- ensure_loaded('/var/lib/myfrdcsa/codebases/minor/free-life-planner/lib/util/util.pl').

:- ensure_loaded('/var/lib/myfrdcsa/collaborative/git/do-convert-logic/logic.pl').
:- ensure_loaded('/var/lib/myfrdcsa/collaborative/git/do-convert-logic/diffing/logic3.pl').
:- ensure_loaded('/var/lib/myfrdcsa/collaborative/git/do-convert-logic/isub.pl').

%% call this on the file you are saving

processFile(File) :-
	getDiff(File,Changes),
	argt(Changes,aLessB(ALessB)),
	findall(Assertion,(member(Assertion,ALessB),not(Assertion =.. [hasLastParsedTimeStamp|_])),ALessBCleaned),
	view(ALessBCleaned),
	argt(Changes,bLessA(BLessA)),
	findall(Assertion,(member(Assertion,BLessA),not(Assertion =.. [hasLastParsedTimeStamp|_])),BLessACleaned),
	view(BLessACleaned),

	findall([Assertion,Result],
		(
		 member(Assertion,BLessACleaned),
		 (   search_terms_individual_best_match(Assertion,ALessBCleaned,Result) -> true ; Result = newEntry)
		),
		OurResults),

	print_term([ourResults,OurResults],[]).
