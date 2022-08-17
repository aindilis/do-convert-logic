%% %% This will compute the metadata diff between two versions of a given prolog exported todo

%% https://www.swi-prolog.org/pldoc/doc/_SWI_/library/git.pl

:- consult('/var/lib/myfrdcsa/codebases/minor/free-life-planner/lib/util/util.pl').

:- use_module(library(git)).

%% get the git versions of that file
computeMetadataForFile(OriginalFileName) :-
	getGitShortLogForOriginalFileName(OriginalFileName,PrologFileName,ShortLog),
	member(git_log(Revision,_,_,_,_,TimeStamp,_,_),ShortLog),
	print_term([revision,Revision],[]),nl,
	fail.
computeMetadataForFile(_OriginalFileName).

	%% getPrologContentsForPrologFileNameAndRevision(
	%% print_term([shortLog,ShortLog],[]).

getGitShortLogForOriginalFileName(OriginalFileName,PrologFileName,ShortLog) :-
	convertOriginalToPrologFileName(OriginalFileName,PrologFileName),
	view([prologFileName,PrologFileName]),
	git_shortlog('/var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/results/', ShortLog, [limit(10),git_path(PrologFileName)]).


convertOriginalToPrologFileName(OriginalFileName,PrologFileName) :-
	regex_replace(OriginalFileName,'[^0-9A-Za-z]','_',[],TmpPrologFileName),
	atomic_list_concat([TmpPrologFileName,'pl'],'.',PrologFileName).