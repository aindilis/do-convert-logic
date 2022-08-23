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