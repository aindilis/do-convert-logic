%% %% This will compute the metadata diff between two versions of a given prolog exported todo

%% https://www.swi-prolog.org/pldoc/doc/_SWI_/library/git.pl

:- consult('/var/lib/myfrdcsa/codebases/minor/free-life-planner/lib/util/util.pl').

:- use_module(library(git)).

doConvertLogicGitRepoDir('/var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/').

%% get the git versions of that file
computeMetadataForFile(OriginalFileName,Revision) :-
	getGitShortLogForOriginalFileName(OriginalFileName,PrologFileName,ShortLog),
	member(git_log(Revision,_,_,_,_,TimeStamp,_,_),ShortLog),
	print_term([revision,Revision],[]),nl.

getGitShortLogForOriginalFileName(OriginalFileName,PrologFileName,ShortLog) :-
	convertOriginalToPrologFileName(OriginalFileName,PrologFileName),
	view([prologFileName,PrologFileName]),
	doConvertLogicGitRepoDir(GitRepoDir),
	git_shortlog(GitRepoDir, ShortLog, [limit(10),git_path(PrologFileName)]).

convertOriginalToPrologFileName(OriginalFileName,PrologFileName) :-
	regex_replace(OriginalFileName,'[^0-9A-Za-z]','_',[],TmpPrologFileName),
	atomic_list_concat(['results/',TmpPrologFileName,'.pl'],'',PrologFileName).

delete_last_list_element(X,Y):-
	reverse(X,[_|X1]), reverse(X1,Y).

get_last_two_list_elements(X,Y,[A,B]):-
	reverse(X,[A,B|X1]), reverse(X1,Y).
get_last_two_list_elements(X,Y,[A,B]):-
	reverse(X,[A,B]), Y = [].

getPrologContentsForPrologFileNameAndRevision(OriginalFileName,Revision,Contents) :-
	convertOriginalToPrologFileName(OriginalFileName,PrologFileName),
	doConvertLogicGitRepoDir(GitRepoDir),
	view([git_open_file(GitRepoDir,PrologFileName,Revision,Stream)]),
	git_open_file(GitRepoDir,PrologFileName,Revision,Stream),
	read_stream_to_codes(Stream,Codes,_X),
	close(Stream),
	delete_last_list_element(Codes,NewCodes),
	atom_codes(Contents,NewCodes),
	view([contents,Contents]).

getDiff :-
	OriginalFileName = '/var/lib/myfrdcsa/collaborative/git/do-convert-logic/diffing/sample.do',
	findall(Revision,computeMetadataForFile(OriginalFileName,Revision),Revisions),
	view([revisions,Revisions]),nl,
	get_last_two_list_elements(Revisions,_Rest,[RevisionA,RevisionB]),
	view([revisionA,RevisionA,revisionB,RevisionB]),nl,
	getPrologContentsForPrologFileNameAndRevision(OriginalFileName,RevisionA,ContentsA),
	getAssertionsFromFileContentsAsAtom(ContentsA,AssertionsA),
	getPrologContentsForPrologFileNameAndRevision(OriginalFileName,RevisionB,ContentsB),
	getAssertionsFromFileContentsAsAtom(ContentsB,AssertionsB),
	view([assertionsA,AssertionsA,assertionsB,AssertionsB]),nl,
	computeChangesToAssertions(AssertionsA,AssertionsB,Changes),
	view([changes,Changes]),nl.

getAssertionsFromFileContentsAsAtom(Contents,Assertions) :-
	read_data_from_file('header.pl',Header),
	atomic_list_concat([Header,Contents],"\n\n",Data),
	write_data_to_file(Data,'contents.pl'),
	[contents],
	contents:get_contents(Assertions),
	print_term(Assertions,[]),nl.	

getPrologContentsForPrologFileNameAndRevisionMaster(OriginalFileName,Revision,Contents) :-
	convertOriginalToPrologFileName(OriginalFileName,PrologFileName),
	doConvertLogicGitRepoDir(GitRepoDir),
	view([git_open_file(GitRepoDir,PrologFileName,master,Stream)]),nl,
	git_open_file(GitRepoDir,PrologFileName,master,Stream),
	read_stream_to_codes(Stream,Codes,_X),
	close(Stream),
	delete_last_list_element(Codes,NewCodes),
	atom_codes(Contents,NewCodes),
	print_term(Contents,[]),nl.

computeChangesToAssertions(AssertionsA,AssertionsB,Changes) :-
	findall(Assertion,
		(
		 member(Assertion,AssertionsA),member(Assertion,AssertionsB)
		),
		Same),
	findall(Assertion,
		(
		 member(Assertion,AssertionsA),not(member(Assertion,AssertionsB))
		),
		ALessB),
	findall(Assertion,
		(
		 member(Assertion,AssertionsB),not(member(Assertion,AssertionsA))
		),
		BLessA),
	Changes = [same(Same),aLessB(ALessB),bLessA(BLessA)].