%% rules.pl — Rule influence analysis.
%%
%% For every MNN rule determines the possible human consequences,
%% providing a traceable chain from rule to hypothesised influence.

:- module(rules, [
    rule_influence/5,
    rules_for_condition/3,
    conflicting_rules/3,
    compatible_actions/2
]).

:- use_module(parser).

%% rule_influence(+Rule, +HumanActivity, -Trigger, -SystemBehaviour, -PossibleHumanEffect)
%%
%% Derives rule influence by pattern-matching on known action types.
rule_influence(rule(System,RuleID,Condition,Action),
               HumanActivity,
               Condition,
               Action,
               PossibleHumanEffect) :-
    rule(System, RuleID, Condition, Action),
    activity_matches(System, HumanActivity),
    action_to_human_effect(Action, PossibleHumanEffect).

%% activity_matches/2 — liberal matching: any activity is potentially relevant.
activity_matches(_, _).

%% action_to_human_effect/2 — pattern library mapping system actions to
%% possible (not certain) human effects.
action_to_human_effect(generate_answer,
    possible_reduced_information_search_by_human).
action_to_human_effect(produce_complete_solution,
    possible_reduced_intermediate_reasoning_steps_by_human).
action_to_human_effect(ask_for_more_information,
    encourages_clarification_rather_than_immediate_acceptance).
action_to_human_effect(provide_hint,
    retains_problem_solving_opportunity_for_human).
action_to_human_effect(refuse_request,
    limits_available_interaction_paths_for_human).
action_to_human_effect(ask_follow_up_question,
    increases_human_engagement_and_reflection).
action_to_human_effect(summarise,
    reduces_reading_burden_for_human).
action_to_human_effect(expand_explanation,
    increases_information_available_to_human).
action_to_human_effect(automate_task,
    delegates_task_execution_to_system).
action_to_human_effect(provide_options,
    retains_decision_for_human).
action_to_human_effect(_, possible_influence_not_classified).

%% rules_for_condition(+System, +Condition, -MatchingRules)
rules_for_condition(System, Condition, MatchingRules) :-
    findall(rule(System,ID,Condition,Action),
            rule(System,ID,Condition,Action),
            MatchingRules).

%% conflicting_rules(+System, -Rule1, -Rule2)
%% Detects two rules with the same condition whose actions cannot both be
%% taken. Each pair is reported once (in rule-identifier order), and actions
%% that can go together, such as giving a hint and asking a follow-up
%% question, are not a conflict.
conflicting_rules(System, Rule1, Rule2) :-
    rule(System, ID1, Condition, Action1),
    rule(System, ID2, Condition, Action2),
    ID1 @< ID2,
    Action1 \= Action2,
    \+ compatible_actions(Action1, Action2),
    Rule1 = rule(System,ID1,Condition,Action1),
    Rule2 = rule(System,ID2,Condition,Action2).

%% compatible_actions(?Action1, ?Action2)
%% Actions that can both be taken for the same trigger (either order).
compatible_actions(A, B) :- compatible_pair(A, B), !.
compatible_actions(A, B) :- compatible_pair(B, A), !.

compatible_pair(provide_hint, ask_follow_up_question).
compatible_pair(generate_answer, provide_source).
compatible_pair(generate_answer, ask_follow_up_question).
compatible_pair(log_interaction, _).
