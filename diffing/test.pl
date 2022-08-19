%% %% This will compute the metadata diff between two versions of a given prolog exported todo

%% https://www.swi-prolog.org/pldoc/doc/_SWI_/library/git.pl

:- consult('/var/lib/myfrdcsa/codebases/minor/free-life-planner/lib/util/util.pl').

:- use_module(library(git)).

doConvertLogicGitRepoDir('/var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/').

%% get the git versions of that file
computeMetadataForFile(OriginalFileName) :-
	getGitShortLogForOriginalFileName(OriginalFileName,PrologFileName,ShortLog),
	member(git_log(Revision,_,_,_,_,TimeStamp,_,_),ShortLog),
	print_term([revision,Revision],[]),nl,
	fail.
computeMetadataForFile(_OriginalFileName).

getGitShortLogForOriginalFileName(OriginalFileName,PrologFileName,ShortLog) :-
	convertOriginalToPrologFileName(OriginalFileName,PrologFileName),
	view([prologFileName,PrologFileName]),
	doConvertLogicGitRepoDir(GitRepoDir),
	git_shortlog(GitRepoDir, ShortLog, [limit(10),git_path(PrologFileName)]).

convertOriginalToPrologFileName(OriginalFileName,PrologFileName) :-
	regex_replace(OriginalFileName,'[^0-9A-Za-z]','_',[],TmpPrologFileName),
	atomic_list_concat(['results/',TmpPrologFileName,'.pl'],'',PrologFileName).

delete_last(X,Y):-
	reverse(X,[_|X1]), reverse(X1,Y).

getPrologContentsForPrologFileNameAndRevision(OriginalFileName,Revision) :-
	convertOriginalToPrologFileName(OriginalFileName,PrologFileName),
	doConvertLogicGitRepoDir(GitRepoDir),
	view([git_open_file(GitRepoDir,PrologFileName,master,Stream)]),
	git_open_file(GitRepoDir,PrologFileName,master,Stream),
	read_stream_to_codes(Stream,Codes,_X),
	close(Stream),
	delete_last(Codes,NewCodes),
	atom_codes(A,NewCodes),
	view([a,A]).