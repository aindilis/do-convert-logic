# do-convert-logic
Logic applied to to-do entries from do-todo-list-mode files converted to Prolog files.

```
2022-08-10 10:10:33 <aindilis_> hey folks, I have a lot of to-do files with
      to-do items in a lisp-like syntax with balanced parentheses.  I've
      written something that converts that to Prolog.  So (completed (take out
      trash)) -> completed('take out trash').
2022-08-10 10:10:38 <aindilis_> The problem with this is how to uniquely refer
      to such items, so that I can for instance say: depends('take out
      trash','gather trash').  If I then change it to 'take out trash and
      recycling', the dependency is broken.
2022-08-10 10:10:43 <aindilis_> What I've done is write something using isub/4
      to get the original entry from the modified entry, and refer to it
      uniquely by the hash of the original entry.  so it becomes
      depends('3fdb452d76b5230753f8a78037ef5ea9','15144ad8d290facc41ece17586c02a8a').
2022-08-10 10:10:47 <aindilis_> I wrote a save-hook so that whenever I edit a
      to-do file (.do extension) it converts it to Prolog.  But now I have
      multiple .pl files with some slight changes.  What would be the best way
      to ensure that any modified entries are able to be referred back to a
      unique ID?
2022-08-10 10:11:54 <aindilis_> If I can solve this problem, I can release the
      FRDCSA/FLP within a year.
2022-08-10 10:14:56 <aindilis_> I am thinking maybe make a temporary module
      and load all the assertions into the module, and then collect them into
      a List, and member/2 over the list and check if there is a match with
      isub/4, and if so, make some relation like changedFrom('take out trash
      and recyclables','take out trash').
2022-08-10 10:15:37 <aindilis_> another design criteria is that I want
      everything to ultimately compile to one or more QLFs
2022-08-10 10:17:39 <aindilis_> and if they match isub/4 assert the relation,
      if they match exactly, don't assert, and if neither, assert as a new
      entry
2022-08-10 10:18:18 <aindilis_> another idea might be to relate them to git
      revisions
2022-08-10 10:20:40 <aindilis_> if anyone wants to collab on this todo system
      I can probably create a standalone version of it and upload to github.
##prolog>
```
