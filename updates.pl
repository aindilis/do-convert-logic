:- use_module(library(crypto)).

:- ensure_loaded('/var/lib/myfrdcsa/codebases/minor/free-life-planner/lib/util/util.pl').

%% FACTS

h('do good shit','dklsjfdsf').

h('take out the trash','fjkdjfds').
h('take out the trash and recyclables','djklsfljf').
h('take out the trash and recyclables and returnables','utweiopod').

updateDirectly(h('take out the trash and recyclables','djklsfljf'),h('take out the trash','fjkdjfds')).
updateDirectly(h('take out the trash and recyclables and returnables','utweiopod'),h('take out the trash and recyclables','djklsfljf')).

%% LOGIC

%% genls(Subclass,Superclass) :-
%% 	genlsDirectly(Midclass,Superclass),
%% 	genls(Subclass,Midclass).
%% genls(Subclass,Superclass) :-
%% 	genlsDirectly(Subclass,Superclass).
update(NewEntry,Entry) :-
	updateDirectly(MidEntry,Entry),
	update(NewEntry,MidEntry).
update(NewEntry,Entry) :-
	updateDirectly(NewEntry,Entry).

mostRecent(NewEntry,Hash) :-
	h(A,_B),
	NewEntry = h(A,_B),
	not(updateDirectly(_,NewEntry)),
	crypto_data_hash(A,Hash,[algorithm(md5)]).

getMostRecents(MostRecents) :-
	findall(mostRecent(Entry,Hash),mostRecent(Entry,Hash),MostRecents).

getHistoryForEntry(Entry,History) :-
	findall(OldEntry,update(Entry,OldEntry),TmpBackwardsHistory),
	append(TmpBackwardsHistory,[Entry],TmpBackwardsFullHistory),
	reverse(TmpBackwardsFullHistory,History).

getOrigin(Entry,OriginEntry) :-
	getHistoryForEntry(Entry,History),
	reverse(History,[OriginEntry|_]).

getHistories(Histories) :-
	getMostRecents(MostRecents),
	findall(History,
		(
		 member(mostRecent(Entry,Hash),MostRecents),
		 getHistoryForEntry(Entry,History)
		),Histories).

writeMostRecents :-
	writeln('Most Recent'),
	getMostRecents(MostRecents),
	write_list(MostRecents).

writeHistories :-
	writeln('Histories'),
	getHistories(Histories),
	write_list(Histories).

writeOrigins :-
	writeln('Origins'),
	getMostRecents(MostRecents),
	forall(member(mostRecent(MostRecent,Hash),MostRecents),
	       (
		getOrigin(MostRecent,Origin),
		tab(4),writeln([MostRecent,Origin])
	       )).

testDCL :-
	writeMostRecents,nl,
	writeOrigins,nl,
	writeHistories.
