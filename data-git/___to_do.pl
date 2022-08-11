hasSourceFile('../to.do').
hasLastParsedTimeStamp('../to.do',[['-',['-',2022,08],11],[':',[':',10,07],11]]).

'now we want to go ahead and work on figuring out which of the four cases entries pertain to:'().
.
'question, what happens when it reverts to a previous update? i.e.'('_SINGLEQUOTE_hi_SINGLEQUOTE_,a','_SINGLEQUOTE_ho_SINGLEQUOTE_,b','_SINGLEQUOTE_hi_SINGLEQUOTE_,c','.').
'what does the b in'('a,b','correspond to if we don_SINGLEQUOTE_t have revisions? would it be last modified times?').
'what happens if we move or delete a file, or something to do with symlinks or hardlinks?'().
'what happens if we move an entry between files?'().
'what about recurrent things like _SINGLEQUOTE_take out the trash_SINGLEQUOTE_?'().
'how should we save files?'().
'should we save the first parse, and then incremental changes? i.e.'().
'should we save them all in a git repo, and just checkout the various revisions as needed?'().
'how does this mesh with qlf?'().
'what about using persistency: https://www.swi-prolog.org/pldoc/doc/_swi_/library/persistency.pl'().
'or mysql?: https://github.com/aindilis/data-integration'().
'where do we store the updatedirectly'('and depends/2','facts?').
answer('how to mark an entry deleted? do we say:'(sarray('a,b'),or,sarray('false,b1','a,b'),'?'),'no because that would ruin history for'(false,'. figure out also what happens if there is not a unique history for a given mostrecent.')).
'we should have predicates that take'(sarray('1djslfkjdlfjlkdkfldf','3urgjlgkdjglgdlgkf'),'. ->','_SINGLEQUOTE_take out the trash and recyclables and returnables_SINGLEQUOTE_,_SINGLEQUOTE_gather the trash_SINGLEQUOTE_','.').
'look more at free-life-planner/projects/spse2-export'().
'the natural language in a given entry will naturally sometimes have context, for instance: the containing file or previous entries in the file'().
'we haven_SINGLEQUOTE_t even begun to broach how to handle complex nested statements, i.e.'(progn(completed(solution(a,b)),c,d),', although look to our perl/tk script for annotating those: /var/lib/myfrdcsa/codebases/releases/do-0.1/do-0.1/scripts/loading-system.sh').
'perhaps this issue that i_SINGLEQUOTE_m trying to solve with do-convert-logic exists because i_SINGLEQUOTE_m not meant to link such entries, because we could update an entry in such a way that it would legitimately break the task dependencies. for instance if i said'('_SINGLEQUOTE_take out trash_SINGLEQUOTE_,_SINGLEQUOTE_gather trash_SINGLEQUOTE_','and updated by for instance negating either task argument, the dependency wouldn_SINGLEQUOTE_t hold anymore. i think automatically validating task dependencies wouldn_SINGLEQUOTE_t be feasible at this point even with ml, given that most task descriptions are underspecified. maybe i could posit the question',sarray('_SINGLEQUOTE_take out'('_SINGLEQUOTE_gather trash_SINGLEQUOTE_'),',tv'),', whenever an update takes place, but that would outsource the burden and create more time sinks. maybe i could have a necessary/1 operator that changes to possible/1 when a task is updated? lastly, maybe i could have a mechanism to assert',sarray('a,b'),'. or given that updating an entry is seldom done, i could just query the user at do->prolog conversion time. or i could treat all update/2 and updatedirectly/2 as default/defeasible/nonmonotonic. perhaps recognizing textual entailment',rte,'/ natural language inference',nli,'could help, by checking whether a2 -> a1','or is it a2 -> a1, or both?',',','or a2 is consistent with a1, etc',', where we have',sarray('a1,_','a2,_'),'. or some combination of of the above measures. or maybe something similar to white_flame_SINGLEQUOTE_s suggestion',iiuc,', like factoring out the change to a1 and keeping all','a1,_',and,'_,a1','but separately determining all','a2\a1,_',and,'_,a2\a1',', or','a2,_','...').
'maybe i could use swipl assertion ids instead of md5 hashes of part or all of the h/2 fact'().
'another dubious approach would be to just look at the position of items in the files, which is unlikely to help since we often move entries around'().
'another big thing to anticipate is when we get around to assigning more semantics to predicates like'(_,', and doing inference with them. i.e.',task,':-',sarray(task),'. etc').
