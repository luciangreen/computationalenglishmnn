%% complexity.pl — Time and space complexity analysis.
%%
%% Analyses both machine computational complexity and human interaction
%% costs (waiting, reading, decision, correction, verification, repetition).
%% Lower machine complexity must not automatically mean lower human time cost.

:- module(complexity, [
    time_influence/4,
    space_influence/4,
    complexity_order/2,
    compare_complexities/3,
    human_time_cost/3
]).

:- use_module(parser).
:- use_module(evidence).

%% Ordering of complexity classes from lowest to highest.
complexity_order(o_1,     1).
complexity_order(o_log_n, 2).
complexity_order(o_n,     3).
complexity_order(o_n_log_n, 4).
complexity_order(o_n2,    5).
complexity_order(o_n3,    6).
complexity_order(o_exp,   7).

%% compare_complexities(+C1, +C2, -Result)
%% Result is lower, equal or higher (C1 relative to C2).
compare_complexities(C1, C2, Result) :-
    complexity_order(C1, O1),
    complexity_order(C2, O2),
    ( O1 < O2 -> Result = lower
    ; O1 =:= O2 -> Result = equal
    ; Result = higher
    ).
compare_complexities(C1, C2, unknown) :-
    ( \+ complexity_order(C1, _) ; \+ complexity_order(C2, _) ), !.

%% human_time_cost(+MachineComplexity, +Context, -HumanCost)
%% Maps machine complexity + context to the primary human time dimension.
human_time_cost(o_1,     _,                    waiting_time_minimal).
human_time_cost(o_log_n, _,                    waiting_time_low).
human_time_cost(o_n,     _,                    waiting_time_moderate).
human_time_cost(o_n2,    _,                    waiting_time_high).
human_time_cost(o_exp,   _,                    waiting_time_very_high).
%% Fast generation enables cheap repeated queries — additional human cost.
human_time_cost(o_1,     interactive,          repetition_time_risk).
human_time_cost(o_log_n, interactive,          repetition_time_risk).

%% time_influence(+System, +Activity, -Mechanism, -Assessment)
%%
%% Derives time-influence facts from the system's time_complexity declarations.
%% Assessment values: low / moderate / high / context_dependent.
time_influence(System, Activity, Mechanism, Assessment) :-
    time_complexity(System, Activity, Complexity),
    time_influence_from_complexity(Complexity, Mechanism, Assessment).
time_influence(System, Activity, fast_generation_enables_repetition, mixed) :-
    time_complexity(System, Activity, C),
    complexity_order(C, O),
    O =< 2,                          % fast
    interaction(System, _, _).       % interactive system

time_influence_from_complexity(o_1,       minimal_waiting, low).
time_influence_from_complexity(o_log_n,   low_waiting,     low).
time_influence_from_complexity(o_n,       linear_waiting,  moderate).
time_influence_from_complexity(o_n_log_n, moderate_waiting,moderate).
time_influence_from_complexity(o_n2,      high_waiting,    high).
time_influence_from_complexity(o_exp,     very_high_waiting, high).

%% space_influence(+System, +Operation, -Mechanism, -Assessment)
%%
%% Derives space-influence facts from space_complexity declarations.
space_influence(System, Operation, Mechanism, Assessment) :-
    space_complexity(System, Operation, Complexity),
    space_influence_from_complexity(Complexity, Mechanism, Assessment).

space_influence_from_complexity(o_1,   minimal_information_volume, low).
space_influence_from_complexity(o_n,   proportional_information_volume, moderate).
space_influence_from_complexity(o_n2,  large_information_volume,  high).
space_influence_from_complexity(o_exp, very_large_information_volume, high).
