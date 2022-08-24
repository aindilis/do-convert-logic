:- use_module(library(crypto)).

%% isub

%% :- use_module(library(apply)).

%% head([H|_], H).

%% search_terms(Search,FinalResults) :-
%% 	match_nearest_n_entries(Search,TmpFinalResults),
%% 	maplist(head,TmpFinalResults,FinalResults).

%% match_nearest_n_entries(Search,FinalResults) :-
%% 	setof([Entry,Distance],
%% 	      Item^Items^Search^(
%% 				  entry(Entry),
%% 				  not(var(Entry)),
%% 				  flatten_term(Entry,Items),
%% 				  member(Item,Items),
%% 				  %% view([item,Item]),
%% 				  isub(Item,Search,true,Distance),
%% 				  Distance > 0.85
%% 				 ),
%% 	      Results),
%% 	predsort(nthcompare(2),Results,Sorted),
%% 	reverse(Sorted,ReverseSorted),
%% 	sublist(ReverseSorted,1,10,FinalResults),
%% 	!.


%% isub

head_as_list([H|_], [H]).

search_terms_best_match(Search,BestMatch) :-
	search_terms(Search,[BestMatch|_]).

search_terms_individual_best_match(Search,Entries,[BestMatch,HashOfBestMatch]) :-
	search_terms_individual(Search,Entries,[[BestMatch]|_]),
	crypto_data_hash(BestMatch,HashOfBestMatch,[algorithm(md5)]),
	print_term([hashOfBestMatch,HashOfBestMatch],[]),nl.

search_terms_individual(Search,Entries,FinalResults) :-
	match_nearest_individual_entries(Search,Entries,TmpTmpFinalResults),
	setof(Item,member(Item,TmpTmpFinalResults),TmpFinalResults),
 	maplist(head_as_list,TmpFinalResults,FinalResults).

search_terms(Search,FinalResults) :-
	match_nearest_entries(Search,TmpTmpFinalResults),
	setof(Item,member(Item,TmpTmpFinalResults),TmpFinalResults),
 	maplist(head_as_list,TmpFinalResults,FinalResults).

match_nearest_entries(Search,FinalResults) :-
	findall([Entry,Distance],
		(
		 entry_bs(Entry),
		 not(var(Entry)),
		 flatten_term(Entry,Items),
		 member(Item,Items),
		 isub(Item,Search,true,Distance),
		 Distance > 0.5
		),
		Results),
	predsort(nthcompare(2),Results,Sorted),
	reverse(Sorted,ReverseSorted),
	sublist(ReverseSorted,1,10,FinalResults),
	!.

match_nearest_individual_entries(Search,Entries,FinalResults) :-
	%% findall(Entry,entry_bs(Entry),Entries),
	hasTruthValueSilent((member(X,Entries),nonvar(X),X = 'build the spse2 system and organize these notes'),TV),
	findall([Item,Distance],
		(
		 member(Entry,Entries),
		 not(var(Entry)),
		 try_flatten_term(Entry,Items),
		 member(Item,Items),
		 not(var(Item)),
		 isub(Item,Search,false,Distance),
		 Distance > 0.85,
		 view([matchingItem,Item])
		),
		Results),
	view([results,Results]),
	predsort(nthcompare(2),Results,Sorted),
	reverse(Sorted,ReverseSorted),
	sublist(ReverseSorted,1,10,FinalResults),
	!.

entry(X) :-
	my_get_all_instances_of_predicate_with_n_args(Results),
	try_flatten_term(Results,Flattened),
	member(X,Flattened).

entry_bs(X) :-
	my_get_all_instances_of_predicate_with_n_args(Results),
	length(Results,Num),
	print_term([numResults,Num],[]),
	flatten(Results,TmpFlattened),
	member(TmpResult,TmpFlattened),
	nonvar(TmpResult),
	findall(Flattened,try_flatten_term(TmpResult,Flattened),X),
	nonvar(X).

try_flatten_term(Term,Flattened) :-
	catch_with_backtrace(flatten_term(Term,Flattened),error(Err,_Context),(format('You done goofed! ~w\n', [Err]),fail)).

my_get_all_instances_of_predicate_with_n_args(Results) :-
	findall(MyTerm,(
			current_predicate(entries:Predicate/N),
			%% view([predicate,Predicate]),
			%% \+ predicate_property(entries:P,imported_from(_)),
			%% predicate_property(entries:P, number_of_clauses(_)),
			length(X,N),
			MyTerm =.. [Predicate|X],
			clause(entries:MyTerm,true),
			Term = MyTerm
		       ),Results).

hasTruthValueSilent(Expression,Value) :-
	(   Expression -> (Value = true) ; (Value = fail)).
