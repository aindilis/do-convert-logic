(completed
 (need to find-or-create the predicate that finds the
  origin text for a given text))

(need to make 'make' work with do-convert)

(need to have do-convert-logic load with or something do-convert)

(need to have something that when I select an entry with 'C-cdv.'
 it goes ahead and adds 'has-NL'('entry-fn'(do,<ID>),<TEXT>) to a
 metadata file somewhere, where Text is the origin text for
 whatever was selected by 'C-cdv.')

(need to have all C-cdpu and C-cdpp saves update the running
 instance of do-convert)

(("frdcsa-context-type" "SPSE")
 ("depends" ("entry-fn" "pse" <N>) ("entry-fn" "pse" <P>))
 ("has-source" ("entry-fn" "pse" <N>) ("entry-fn" "sayer-index" <M>))
 ("goal" ("entry-fn" "pse" <N>))
 ("asserter" ("entry-fn" "pse" <N>) <TEXT1>)
 ("has-NL" ("entry-fn" "pse" <N>) <TEXT2>)
 )

(so like
 ;; 'has-NL'('entry-fn'(do,'JD2385DFKSFHF902GFHJEFDIFEWJ'),'do this via making an update of our locate-all data')

 (depends (entry-fn do <ID1>) (entry-fn do <ID2>))

 ("depends" ("entry-fn" "do" var-ID1) ("entry-fn" "do" var-ID2))

 ;; 'depends'('entry-fn'(do,ID1),'entry-fn'(do,ID2)).

 ;; 'has-NL'('entry-fn'(do,MD5),Text) :-
 ;; 	entry(Text),
 ;; 	md5sum(Text,MD5).

 ;; updateNLEntries :-
 ;; 	entry(Text),
 ;; 	md5sum(Text,MD5),
 ;;     ensureAsserted('has-NL'('entry-fn'(do,MD5),Text)),
 ;;     fail.
 ;; updateNLEntries.

 ;; updateNLEntries :-
 ;; 	forall(entry(Text),
 ;; 	       (   
 ;; 		   md5sum(Text,MD5),
 ;; 		   ensureAsserted('has-NL'('entry-fn'(do,MD5),Text))
 ;; 	       )).

 ;; updateNLEntries :-
 ;; 	forall(entry(Text),
 ;; 	       (   
 ;; 		   not('has-NL'('entry-fn'(do,_MD5),Text)) ->
 ;; 		   (   
 ;; 		       md5sum(Text,MD5),
 ;; 		       ensureAsserted('has-NL'('entry-fn'(do,_MD5),Text))
 ;; 		   ) ;
 ;; 		   true
 ;; 	       )).

 ;; ;; although really what we want is only to generate MD5 sums for
 ;; ;; entries that have been (do-convert-get-id-for-entry-at-point)
 ;; ;; C-cdv. or something, and to record those

 )

((frdcsa-context-type SPSE)
 (depends (entry-fn pse <N>) (entry-fn pse <P>))
 (has-source (entry-fn pse <N>) (entry-fn sayer-index <M>))
 (goal (entry-fn pse <N>))
 (asserter (entry-fn pse <N>) <TEXT1>)
 (has-NL (entry-fn pse <N>) <TEXT2>)
 )

(record via a fact that a given metadata computation step between
 two adjacent git revisions has been completed, and possibly,
 what they were.)

(fix the prolog compilation errors like -
 (ERROR: /var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/temp/contents.pl:191:353: Syntax error: Operator expected
  ERROR: /var/lib/myfrdcsa/codebases/minor/do-convert/data/do-convert-git/temp/contents.pl:358:82: Syntax error: Illegal start of term))

(fix h(h('',''),bfaf455fd2f81dd2e4566ebf370d1acd63d7a0b2) bug)

(we already have depends/2 with actual entries, not pse-entry-s
 though)

(how do we deal with multiple similar or same copies of a
 .(do|notes) file?)

(get the depends/2 system going asap)

(given this system is incomplete, especially to how it treats
 complex assertions (i.e. assertions that are not simply atoms,
		     we are going to get frustrated at times when it acts
		     incorrectly.  Maybe we can take an ATP approach to all of this.
		     Maybe we can reverse engineer KBFS and/or IAEC from
		     DoConvertLogic))

(is there any reason to use a hash instead of just the original
 assertion?: yes, because if we change the original assertion
 contents, we don't want the original assertion to confuse
 things.  Note though we have to track in metadata
 hashFn(h(<ASSERTION1>,<REVISION1>),<MD5SUM>) or
 md5(<ASSERTION1>,<MD5SUM>). or something)

(track file movement histories, for instance, when we move a .do
 originalfilename, it's not necessarily going to move the
 prologfilename for that file, so we have to assert in metadata:
 mv(f(<NAME1>,<REVISION1>),f(<NAME2>,<REVISION2>)) or something)

(we really need IAEC/KBFS etc working for this[=do-convert-logic]
 to work properly)

(there needs to be some kind of audit/integrity check process,
 for when the system (metadata and data) get unsynced)

(solution
 (note, C-cdv. is not sorting properly
  (couples time tonight)
  [results,[['couples time',0.925]
	    ,[couples,0.8555555555555556]
	    ,['couples time tonight',1.0]
	    ,[couples,0.8555555555555556]]]
  )
 (use list_to_set instead of setof))

(start a new project for reasoning with complex assertions)

(deal with more than just atoms, but also facts with (nested)
 arguments)

(completed
 (solution
  (have to make this more efficient, it uses a naive n^2
   algorithm for detecting changes, pretty sure can speed that up
   with a hash table)
  (used intersection/subtract)))

(okay, so I have the basic infrastructure working, but what I
 have to do is to
 (get it to do the storage and diffing (e.g. contents.pl) in a
  different non-git dir)
 (write an intelligent auto-save-hook for only processing test
  .do files, so we don't accidentally release unredacted private
  info)
 (record the assertions in a separate metadatafile and then
  reason using updates.pl, possibly use qlf-persistence as
  implemented in FLP, include those source files?  but first,
  just generate the assertions)
 (deal with movements between files)
 (all the other stuff in this to.do)
 )

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

(related
 (question, what happens when it reverts to a previous update?
  i.e. h('hi',a),h('ho',b),h('hi',c).)
 (FIXME: we want to be sure that it only enumerates the latest
  version of an entry when searching for similar ones))

(what does the B in h(A,B) correspond to if we don't have
 revisions?  would it be last modified times?)

(what happens if we move or delete a file, or something to do
 with symlinks or hardlinks?)

(FIXME: what happens if we add an entry?)

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
