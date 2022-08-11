%% now we want to go ahead and work on figuring out which of the four
%% cases entries pertain to:

%% we saved a file ->
%%  get file's entries
%%  get file's previous entries
%%  for each entry in file's previous entries
%%   1) is it absent from file's entries?
%%  for each entry in file's entries
%%   1) is the entry the exact same as a previous entry?
%%   2) is it slightly different from a previous entry?
%%   3) is it completely different from any previous entry?

%% question, what happens when it reverts to a previous update?
%% i.e. h('hi',a),h('ho',b),h('hi',c).

%% what does the B in h(A,B) correspond to if we don't have revisions?
%% would it be last modified times?

%% what happens if we move or delete a file, or something to do with
%% symlinks or hardlinks?

%% what happens if we move an entry between files?

%% what about recurrent things like 'take out the trash'?

%%%%

%% how should we save files.

%% should we save the first parse, and then incremental changes, i.e.

%% $dir/home_andrewdo_to_do_1
%% $dir/home_andrewdo_to_do_2
%% $dir/home_andrewdo_to_do_3

%% should we save them all in a git repo, and just checkout the
%% various revisions as needed?

%% how does this mesh with QLF?

%% what about using Persistency:
%% https://www.swi-prolog.org/pldoc/doc/_SWI_/library/persistency.pl

%% or MySQL:
%% https://github.com/aindilis/data-integration
