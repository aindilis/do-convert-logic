%% If I have a Prolog file, and I reorder some facts and rules, and
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
