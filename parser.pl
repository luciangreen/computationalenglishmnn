%% parser.pl — Input representation and validation for MNN descriptions.
%%
%% Declares the dynamic predicates used to represent an MNN/chatbot system
%% and helper predicates for validating and querying the knowledge base.

:- module(parser, [
    system/1,
    rule/4,
    priority/3,
    function/2,
    ethical_rule/2,
    time_complexity/3,
    space_complexity/3,
    interaction/3,
    validate_system/1,
    system_rules/2,
    system_priorities/2,
    system_ethical_rules/2,
    system_functions/2,
    system_time_complexities/2,
    system_space_complexities/2,
    system_interactions/2,
    all_systems/1
]).

%% Dynamic predicates — populated by calling code or test fixtures.
:- dynamic system/1.
:- dynamic rule/4.            % rule(System, RuleID, Condition, Action)
:- dynamic priority/3.        % priority(System, RuleID, Priority)
:- dynamic function/2.        % function(System, Function)
:- dynamic ethical_rule/2.    % ethical_rule(System, Principle)
:- dynamic time_complexity/3. % time_complexity(System, Operation, Complexity)
:- dynamic space_complexity/3.% space_complexity(System, Operation, Complexity)
:- dynamic interaction/3.     % interaction(System, UserAction, SystemAction)
:- dynamic session/4.         % session(Session, System, Person, Context)
:- dynamic event/3.           % event(Session, Time, Event)

%% validate_system(+System) — succeeds when System has at least a system/1 fact.
validate_system(System) :-
    system(System).

%% system_rules(+System, -Rules)
system_rules(System, Rules) :-
    findall(rule(System,ID,Cond,Act), rule(System,ID,Cond,Act), Rules).

%% system_priorities(+System, -Priorities)
system_priorities(System, Priorities) :-
    findall(priority(System,ID,P), priority(System,ID,P), Priorities).

%% system_ethical_rules(+System, -Ethics)
system_ethical_rules(System, Ethics) :-
    findall(ethical_rule(System,E), ethical_rule(System,E), Ethics).

%% system_functions(+System, -Fns)
system_functions(System, Fns) :-
    findall(function(System,F), function(System,F), Fns).

%% system_time_complexities(+System, -TCs)
system_time_complexities(System, TCs) :-
    findall(time_complexity(System,Op,C), time_complexity(System,Op,C), TCs).

%% system_space_complexities(+System, -SCs)
system_space_complexities(System, SCs) :-
    findall(space_complexity(System,Op,C), space_complexity(System,Op,C), SCs).

%% system_interactions(+System, -Interactions)
system_interactions(System, Interactions) :-
    findall(interaction(System,UA,SA), interaction(System,UA,SA), Interactions).

%% all_systems(-Systems) — list of all registered systems.
all_systems(Systems) :-
    findall(S, system(S), Systems).
