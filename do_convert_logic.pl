:- ensure_loaded('/var/lib/myfrdcsa/codebases/minor/interactive-execution-monitor/frdcsa/sys/flp/autoload/args.pl').
:- ensure_loaded('/var/lib/myfrdcsa/codebases/minor/free-life-planner/lib/util/util.pl').

:- ensure_loaded('/var/lib/myfrdcsa/collaborative/git/do-convert-logic/updates.pl').
:- ensure_loaded('/var/lib/myfrdcsa/collaborative/git/do-convert-logic/diffing/diffing.pl').
:- ensure_loaded('/var/lib/myfrdcsa/collaborative/git/do-convert-logic/isub.pl').
:- ensure_loaded('/var/lib/myfrdcsa/collaborative/git/do-convert-logic/do_convert_logic_qlf_save.pl').

:- multifile h/2, updateDirectly/2, update/2.
:- dynamic h/2, updateDirectly/2, update/2.

%% call this on the file you are saving

processFile(OriginalFileName) :-
	getDiff(OriginalFileName,Changes),
	argt(Changes,revisionA(RevisionA)),
	argt(Changes,aLessB(ALessB)),
	%% findall(Assertion,(member(Assertion,ALessB),not(Assertion =.. [hasLastParsedTimeStamp|_])),ALessBCleaned),
	findall(Assertion,(member(Assertion,ALessB),not(my_pred_args(Assertion,hasLastParsedTimeStamp,_))),ALessBCleaned),
	view(ALessBCleaned),nl,
	argt(Changes,revisionB(RevisionB)),
	argt(Changes,bLessA(BLessA)),
	%% findall(Assertion,(member(Assertion,BLessA),not(Assertion =.. [hasLastParsedTimeStamp|_])),BLessACleaned),
	findall(Assertion,(member(Assertion,BLessA),not(my_pred_args(Assertion,hasLastParsedTimeStamp,_))),BLessACleaned),
	view(BLessACleaned),nl,

	findall([h(AssertionA,RevisionA),h(AssertionB,RevisionB)],
		(
		 member(AssertionA,BLessACleaned),
		 (   search_terms_individual_best_match(AssertionA,ALessBCleaned,[AssertionB,HashB]) -> true ; AssertionB = h('',''))
		),
		OurResults),
	
	print_term([ourResults,OurResults],[]),nl,
	updateMetadata([ourResults(OurResults),originalFileName(OriginalFileName)]).

updateMetadata(Arguments) :-
	argt(Arguments,originalFileName(OriginalFileName)),
	argt(Arguments,ourResults(OurResults)),
	foreach(member([EntryA,EntryB],OurResults),
		(   
		    Assertions = [EntryA,EntryB,updateDirectly(EntryB,EntryA)],
		    foreach(member(Assertion,Assertions),
			    (
			     print_term(Assertion,[]),nl,
			     doConvertEnsureAsserted(Assertion,OriginalFileName)
			    ))
		)).
