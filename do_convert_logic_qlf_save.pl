doConvertMetadataDir('/var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/metadata/').

doConvertEnsureAsserted(Fact,OriginalFileName) :-
	(   not(Fact) -> (doConvertQLFSave(Fact,OriginalFileName),write_term([fact1,Fact],[quoted(true)]),nl) ; true).

doConvertQLFSave(Fact,OriginalFileName) :-
	doConvertMetadataDir(MetadataDir),
	convertOriginalToPrologFileName(OriginalFileName,PrologFileName),
	atom_concat(MetadataDir,PrologFileName,Filename),		
	with_output_to(atom(Data),(write_term(Fact,[quoted(true),fullstop(true)]),nl)),
	append_data_to_file(Data,Filename).

:- prolog_consult('/var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/metadata/_var_lib_myfrdcsa_collaborative_git_do_convert_logic_sample_to_dos_sample_do.pl').

%% doConvertQLFPersistenceLoad(OriginalFileName) :-

%% 	doConvertMetadataDir(MetadataDir),
%% 	convertOriginalToPrologFileName(OriginalFileName,PrologFileName),
%% 	atom_concat(MetadataDir,PrologFilename,Filename),

%% 	(   access_file(Filename,read) ->
%% 	    (	
%% 		nl,write('CONSULTING CONTEXT: '),write(Filename),nl,
%% 		prolog_consult(Filename),
%% 		consult(Filename)
%% 	    ) ; true).

