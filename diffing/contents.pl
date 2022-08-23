%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Contents Exporter

:- module('contents',[get_contents/1]).

list_modules :-
	findall(
		M,
		(
		 current_predicate(_,M:P),
		 \+ predicate_property(M:P,imported_from(_)),
		 predicate_property(M:P, number_of_clauses(_)),
		 clause(M:P,_)
		),
		IntoVar
	       ), see(IntoVar).

% %% the number_of_clauses/1 will avoid an error
pred_for_m(M,IntoVar) :-
	findall(
		%% (P :- B),
		P,
		(
		 current_predicate(_,M:P),
		 \+ predicate_property(M:P,imported_from(_)),
		 predicate_property(M:P, number_of_clauses(_)),
		 clause(M:P,B),
		 B = true
		),
		IntoVar
	       ).

get_contents(AllAssertedKnowledge) :-
	pred_for_m('contents',AllAssertedKnowledge).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hasSourceFile('/var/lib/myfrdcsa/collaborative/git/do-convert-logic/diffing/sample.do').
hasLastParsedTimeStamp('/var/lib/myfrdcsa/collaborative/git/do-convert-logic/diffing/sample.do',[['-',['-',2022,08],19],[':',[':',07,39],15]]).

'this is a test'().
'this is another test'().
'this is a new test'().
'test again'().