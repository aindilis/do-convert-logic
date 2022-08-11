(now we want to go ahead and work on figuring out which of the
 four cases entries pertain to:)

(;; we saved a file ->
 ;;  get file's entries
 ;;  get file's previous entries
 ;;  for each entry in file's previous entries
 ;;   1) is it absent from file's entries?
 ;;  for each entry in file's entries
 ;;   1) is the entry the exact same as a previous entry?
 ;;   2) is it slightly different from a previous entry?
 ;;   3) is it completely different from any previous entry?
 )

(question, what happens when it reverts to a previous update?
 i.e. h('hi',a),h('ho',b),h('hi',c).)

(what does the B in h(A,B) correspond to if we don't have
 revisions?  would it be last modified times?)

(what happens if we move or delete a file, or something to do
 with symlinks or hardlinks?)

(what happens if we move an entry between files?)

(what about recurrent things like 'take out the trash'?)

;;;;;;;;;;;;;;;;;;;;;;;;;

(how should we save files?)

(should we save the first parse, and then incremental changes?
 i.e.
 ;; $dir/home_andrewdo_to.do-1
 ;; $dir/home_andrewdo_to.do-2
 ;; $dir/home_andrewdo_to.do-3
 ) 

(should we save them all in a git repo, and just checkout the
 various revisions as needed?)

(how does this mesh with QLF?)

(what about using Persistency:
 https://www.swi-prolog.org/pldoc/doc/_SWI_/library/persistency.pl)

(or MySQL?: https://github.com/aindilis/data-integration)

;;;;;;;;;;;;;;;;;;;;;;;;;

(Where do we store the updateDirectly (and depends/2) facts?)

(solution
 (how to mark an entry deleted?  do we say:
  updateDirectly(false,h(A,B)) or updateDirectly(h(false,B1)
  ,h(A,B))?)
 (No because that would ruin history for h(false) .  Figure out
  also what happens if there is not a unique history for a given
  mostrecent.))

(we should have predicates that take
 depends(hash(1DJSLFKJDLFJLKDKFLDF),hash(3URGJLGKDJGLGDLGKF)). ->
 depends('take out the trash and recyclables and
 returnables','gather the trash').)

(look more at free-life-planner/projects/spse2-export)

(the natural language in a given entry will naturally sometimes
 have context, for instance: the containing file or previous
 entries in the file)

(we haven't even begun to broach how to handle complex nested
 statements, i.e. (progn (completed (solution (a) (b))) (c) (d)),
 although look to our Perl/Tk script for annotating those:
 /var/lib/myfrdcsa/codebases/releases/do-0.1/do-0.1/scripts/loading-system.sh)

(perhaps this issue that I'm trying to solve with
 do-convert-logic exists because I'm not meant to link such
 entries, because we could update an entry in such a way that it
 would legitimately break the task dependencies.  For instance if
 I said depends('take out trash','gather trash') and updated by
 for instance negating either task argument, the dependency
 wouldn't hold anymore.  I think automatically validating task
 dependencies wouldn't be feasible at this point even with ML,
 given that most task descriptions are underspecified.  Maybe I
 could posit the question doesRelationStillHold(depends('take out
 trash',not('gather trash')),TV), whenever an update takes place,
 but that would outsource the burden and create more time sinks.
 maybe I could have a necessary/1 operator that changes to
 possible/1 when a task is updated?  Lastly, maybe I could have a
 mechanism to assert relationNoLongHolds(depends(A,B)))
