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

(answer
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
 mechanism to assert relationNoLongerHolds(depends(A,B)).  Or
 given that updating an entry is seldom done, I could just query
 the user at do->prolog conversion time.  Or I could treat all
 update/2 and updateDirectly/2 as
 default/defeasible/nonmonotonic.  Perhaps recognizing textual
 entailment (RTE) / natural language inference (NLI) could help,
 by checking whether A2 -> A1 (or is it A2 -> A1, or both?), (or
 A2 is consistent with A1, etc), where we have
 update(h(A1,_),h(A2,_)).  Or some combination of of the above
 measures.  Or maybe something similar to White_Flame's
 suggestion (IIUC), like factoring out the change to A1 and
 keeping all depends(A1,_) and depends(_,A1) but separately
 determining all depends(A2\A1,_) and depends(_,A2\A1), or
 depends(A2,_)...)

(maybe I could use SWIPL assertion IDs instead of md5 hashes of
 part or all of the h/2 fact)

(another dubious approach would be to just look at the position
 of items in the files, which is unlikely to help since we often
 move entries around)

(Another big thing to anticipate is when we get around to
 assigning more semantics to predicates like completed(_), and
 doing inference with them.  I.e. currentTask(Task) :-
 not(completed(Task)), not(postponed(Task)), etc.)

(what happens if we copy an item to a different file, or even
 make multiple such copies)

(maybe some of this API is relevant:
 (https://www.swi-prolog.org/pldoc/man?section=persistency))

(completed
 (in progress
  (need to make a separate git repository for just these .pl
   files, and have it commit to that repo.  Then use the git API)))

(add some error handling stuff if parsecheck fails)

(;; 2022-08-10 10:10:33 <aindilis_> hey folks, I have a lot of to-do files with
 ;;       to-do items in a lisp-like syntax with balanced parentheses.  I've
 ;;       written something that converts that to Prolog.  So (completed (take out
 ;;       trash)) -> completed('take out trash').
 ;; 2022-08-10 10:10:38 <aindilis_> The problem with this is how to uniquely refer
 ;;       to such items, so that I can for instance say: depends('take out
 ;;       trash','gather trash').  If I then change it to 'take out trash and
 ;;       recycling', the dependency is broken.
 ;; 2022-08-10 10:10:43 <aindilis_> What I've done is write something using isub/4
 ;;       to get the original entry from the modified entry, and refer to it
 ;;       uniquely by the hash of the original entry.  so it becomes
 ;;       depends('3fdb452d76b5230753f8a78037ef5ea9','15144ad8d290facc41ece17586c02a8a').
 ;; 2022-08-10 10:10:47 <aindilis_> I wrote a save-hook so that whenever I edit a
 ;;       to-do file (.do extension) it converts it to Prolog.  But now I have
 ;;       multiple .pl files with some slight changes.  What would be the best way
 ;;       to ensure that any modified entries are able to be referred back to a
 ;;       unique ID?
 ;; 2022-08-10 10:11:54 <aindilis_> If I can solve this problem, I can release the
 ;;       FRDCSA/FLP within a year.
 ;; 2022-08-10 10:14:56 <aindilis_> I am thinking maybe make a temporary module
 ;;       and load all the assertions into the module, and then collect them into
 ;;       a List, and member/2 over the list and check if there is a match with
 ;;       isub/4, and if so, make some relation like changedFrom('take out trash
 ;;       and recyclables','take out trash').
 ;; 2022-08-10 10:15:37 <aindilis_> another design criteria is that I want
 ;;       everything to ultimately compile to one or more QLFs
 ;; 2022-08-10 10:17:39 <aindilis_> and if they match isub/4 assert the relation,
 ;;       if they match exactly, don't assert, and if neither, assert as a new
 ;;       entry
 ;; 2022-08-10 10:18:18 <aindilis_> another idea might be to relate them to git
 ;;       revisions
 ;; 2022-08-10 10:20:40 <aindilis_> if anyone wants to collab on this todo system
 ;;       I can probably create a standalone version of it and upload to github.
 ;; ##prolog>
 )

(%% If I have a Prolog file, and I reorder some facts and rules, and
 %% even change some of the atoms, whats the best way to...

 %% What is the best way to store dynamic rules and facts in a KB,
 %% seems like github.  Use Prolog's github API.  So overwrite the
 %% file, and then compute add/retract/change statements from the
 %% revisions and keep in a separate file or directory.

 %% removedFromFile(File,Assertion).
 %% addedToFile(File,Assertion).
 %% changedFromFile(File,Assertion1,Assertion2).

 %% how often should we be commiting?

 %% we can offload this task to a service process that does not hold up
 %% Emacs.

 %% work on the save-file-hook, which queues the file for conversion
 %% and commiting.
 )
