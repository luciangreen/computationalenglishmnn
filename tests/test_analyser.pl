:- begin_tests(analyser).

:- dynamic system/1, rule/4, priority/3, ethical_rule/2, function/2, time_complexity/3, interaction/3.
:- use_module('../parser').
:- use_module('../rules').
:- use_module('../ethics').
:- use_module('../priorities').

% The README's example chatbot.
example_system :-
    retractall(system(_)), retractall(rule(_, _, _, _)), retractall(priority(_, _, _)),
    retractall(ethical_rule(_, _)), retractall(function(_, _)),
    assertz(system(chatbot1)),
    assertz(rule(chatbot1, r_speed, user_asks_question, generate_answer)),
    assertz(rule(chatbot1, r_hint, user_asks_question, provide_hint)),
    assertz(rule(chatbot1, r_verify, user_asks_question, ask_follow_up_question)),
    assertz(priority(chatbot1, r_speed, 10)),
    assertz(priority(chatbot1, r_hint, 5)),
    assertz(priority(chatbot1, r_verify, 4)),
    assertz(ethical_rule(chatbot1, autonomy)),
    assertz(ethical_rule(chatbot1, truthfulness)),
    assertz(function(chatbot1, teach_reasoning)).

test(conflicts_reported_once_and_only_when_exclusive) :-
    example_system,
    findall(A-B, conflicting_rules(chatbot1, rule(_, A, _, _), rule(_, B, _, _)), Pairs),
    assertion(Pairs == [r_hint-r_speed]).

test(requirement_alias) :-
    example_system,
    findall(R-P, ethical_requirement(chatbot1, R, P, _), Reqs),
    findall(R-P, ethical_violation(chatbot1, R, P, _), Old),
    assertion(Reqs == Old),
    assertion(Reqs \== []).

test(missing_safeguards) :-
    example_system,
    findall(P, missing_safeguard(chatbot1, P, _), Ps),
    assertion(Ps == [privacy, accountability, human_oversight]).

:- end_tests(analyser).
