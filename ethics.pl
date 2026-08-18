%% ethics.pl — Ethical analysis of MNN algorithmic behaviour.
%%
%% Evaluates algorithmic behaviour against ethical principles.
%% Identifies conflicts, missing safeguards, and priority inversions.
%% Does NOT assume ethical declarations guarantee ethical outcomes.

:- module(ethics, [
    ethical_conflict/3,
    missing_safeguard/3,
    ethical_assessment/4,
    known_ethical_principle/1,
    ethical_violation/4
]).

:- use_module(parser).

%% known_ethical_principle/1 — the nine dimensions under examination.
known_ethical_principle(autonomy).
known_ethical_principle(beneficence).
known_ethical_principle(non_maleficence).
known_ethical_principle(fairness).
known_ethical_principle(privacy).
known_ethical_principle(transparency).
known_ethical_principle(accountability).
known_ethical_principle(human_oversight).
known_ethical_principle(truthfulness).

%% ethical_conflict(+System, -Principle1, -Principle2)
%% Detects rules whose combined effect conflicts with declared ethical rules.
ethical_conflict(System, Principle1, Principle2) :-
    ethical_rule(System, Principle1),
    ethical_rule(System, Principle2),
    principle_conflict(Principle1, Principle2).

principle_conflict(maximise_engagement, preserve_user_autonomy).
principle_conflict(maximise_engagement, non_maleficence).
principle_conflict(automation,          autonomy).
principle_conflict(speed,               truthfulness).
principle_conflict(engagement_tracking, privacy).

%% ethical_violation(+System, +Rule, +Principle, -Description)
%% Identifies when a rule's action conflicts with a declared ethical principle.
ethical_violation(System, RuleID, Principle, Description) :-
    rule(System, RuleID, _, Action),
    ethical_rule(System, Principle),
    action_violates_principle(Action, Principle, Description).

action_violates_principle(produce_complete_solution, autonomy,
    'complete solutions may reduce opportunities for autonomous reasoning').
action_violates_principle(automate_task, autonomy,
    'task automation may reduce user agency').
action_violates_principle(generate_answer, truthfulness,
    'generated answers must be accurate to preserve truthfulness').
action_violates_principle(ask_follow_up_question, non_maleficence,
    'excessive follow-up questions may increase cognitive burden').

%% missing_safeguard(+System, +Principle, -MissingRule)
%% Reports known ethical principles that lack any supporting rule.
missing_safeguard(System, Principle, missing_rule_for(Principle)) :-
    known_ethical_principle(Principle),
    \+ ethical_rule(System, Principle),
    safeguard_required(Principle).

safeguard_required(privacy).
safeguard_required(human_oversight).
safeguard_required(accountability).
safeguard_required(truthfulness).

%% ethical_assessment(+System, +Principle, -Status, -EvidenceLevel)
%% Returns status: declared / missing / conflicted / unknown.
ethical_assessment(System, Principle, declared, observed) :-
    ethical_rule(System, Principle).
ethical_assessment(System, Principle, missing, inferred) :-
    \+ ethical_rule(System, Principle),
    known_ethical_principle(Principle).
ethical_assessment(System, Principle, conflicted, inferred) :-
    ethical_rule(System, Principle),
    ethical_conflict(System, Principle, _).
