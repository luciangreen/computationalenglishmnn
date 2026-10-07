%% priorities.pl — Priority conflict analysis.
%%
%% Analyses which rules dominate others, detects priority conflicts,
%% and derives possible human consequences of priority ordering.

:- module(priorities, [
    priority_influence/5,
    dominant_rule/3,
    priority_conflict/4,
    inferred_priority/3
]).

:- use_module(parser).
:- use_module(library(lists), [max_member/2, nth1/3]).

%% priority_influence(+System, +HigherPriority, +LowerPriority,
%%                    +Situation, -HumanConsequence)
%%
%% Derives consequences from known priority conflicts.
priority_influence(System, HighRule, LowRule, Situation, Consequence) :-
    priority(System, HighRule, HP),
    priority(System, LowRule,  LP),
    HP > LP,
    priority_conflict_consequence(HighRule, LowRule, Situation, Consequence).

%% Library of known consequence patterns for priority pairs.
priority_conflict_consequence(r_safety, r_speed, _, safety_constraint_limits_speed).
priority_conflict_consequence(r_safety, r_convenience, _, safety_constraint_limits_convenience).
priority_conflict_consequence(r_speed,  r_verification, _, verification_may_be_skipped_for_speed).
priority_conflict_consequence(r_convenience, r_learning, _, convenience_may_reduce_learning_opportunity).
priority_conflict_consequence(r_automation, r_autonomy, _, automation_may_reduce_user_autonomy).
priority_conflict_consequence(r_engagement, r_task_completion, _, engagement_objective_may_prolong_interaction).
priority_conflict_consequence(_High, _Low, _, higher_priority_rule_dominates_lower_priority_rule).

%% dominant_rule(+System, -Rule, -Priority)
dominant_rule(System, Rule, MaxP) :-
    findall(P-R, priority(System,R,P), Pairs),
    Pairs \= [],
    max_member(MaxP-Rule, Pairs).

%% priority_conflict(+System, -Rule1, -Rule2, -ConflictType)
%% Detects pairs where higher-priority rule suppresses desirable lower one.
priority_conflict(System, Rule1, Rule2, speed_over_verification) :-
    priority(System, Rule1, P1),
    priority(System, Rule2, P2),
    P1 > P2,
    rule(System, Rule1, _, Action1),
    rule(System, Rule2, _, Action2),
    speed_action(Action1),
    verification_action(Action2).
priority_conflict(System, Rule1, Rule2, automation_over_autonomy) :-
    priority(System, Rule1, P1),
    priority(System, Rule2, P2),
    P1 > P2,
    rule(System, Rule1, _, Action1),
    rule(System, Rule2, _, Action2),
    automation_action(Action1),
    autonomy_preserving_action(Action2).

speed_action(generate_answer).
speed_action(produce_complete_solution).
speed_action(automate_task).
verification_action(ask_for_more_information).
verification_action(ask_follow_up_question).
automation_action(produce_complete_solution).
automation_action(automate_task).
autonomy_preserving_action(provide_hint).
autonomy_preserving_action(provide_options).

%% inferred_priority(+System, -Rule, -InferredPriority)
%% Infers implicit priority from rule ordering when explicit priority absent.
inferred_priority(System, Rule, inferred(Index)) :-
    \+ priority(System, Rule, _),
    rule(System, Rule, _, _),
    findall(ID, rule(System,ID,_,_), IDs),
    nth1(Index, IDs, Rule).
