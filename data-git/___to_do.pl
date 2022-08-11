hasSourceFile('../to.do').
hasLastParsedTimeStamp('../to.do',[['-',['-',2022,08],11],[':',[':',09,12],07]]).

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
solution('how to mark an entry deleted? do we say:'(sarray('a,b'),or,sarray('false,b1','a,b'),'?'),'no because that would ruin history for'(false,'. figure out also what happens if there is not a unique history for a given mostrecent.')).
'we should have predicates that take'(sarray('1djslfkjdlfjlkdkfldf','3urgjlgkdjglgdlgkf'),'. ->','_SINGLEQUOTE_take out the trash and recyclables and returnables_SINGLEQUOTE_,_SINGLEQUOTE_gather the trash_SINGLEQUOTE_','.').
'look more at free-life-planner/projects/spse2-export'().
'the natural language in a given entry with naturally sometimes have context, for instance: the containing file or previous entries in the file'().
'we haven_SINGLEQUOTE_t even begun to broach how to handle complex nested statements, i.e.'(progn(completed(solution(a,b)),c,d),', although look to our perl/tk script for annotating those: /var/lib/myfrdcsa/codebases/releases/do-0.1/do-0.1/scripts/loading-system.sh').
