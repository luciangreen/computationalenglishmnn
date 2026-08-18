%% function.pl — Function analysis module.
%%
%% Determines the intended function of the chatbot and makes
%% assessments function-relative. The same behaviour may be appropriate
%% in one function context and counterproductive in another.

:- module(function, [
    functional_assessment/4,
    function_conflict/4,
    function_label/2
]).

:- use_module(parser).

%% function_label/2 — human-readable descriptions of known functions.
function_label(teach,                    'Teach a subject to the user').
function_label(teach_reasoning,          'Teach the user how to reason').
function_label(advise,                   'Provide advice or recommendations').
function_label(retrieve_information,     'Retrieve factual information on demand').
function_label(brainstorm,               'Help generate ideas collaboratively').
function_label(automate_task,            'Automate a repetitive or complex task').
function_label(test_student,             'Test student knowledge').
function_label(support_human_reasoning,  'Support but not replace human reasoning').
function_label(entertain,                'Entertain the user').
function_label(moderate_content,         'Filter or moderate content').

%% functional_assessment(+System, +Action, +Function, -Assessment)
%% Assesses whether Action is appropriate for the stated Function.
functional_assessment(System, Action, Function, Assessment) :-
    function(System, Function),
    action_function_assessment(Action, Function, Assessment).

action_function_assessment(produce_complete_solution, retrieve_information, appropriate).
action_function_assessment(produce_complete_solution, teach,                context_dependent).
action_function_assessment(produce_complete_solution, teach_reasoning,      possibly_counterproductive).
action_function_assessment(produce_complete_solution, test_student,         counterproductive).
action_function_assessment(provide_hint,              teach_reasoning,      appropriate).
action_function_assessment(provide_hint,              retrieve_information, insufficient).
action_function_assessment(ask_follow_up_question,    teach,                appropriate).
action_function_assessment(ask_follow_up_question,    automate_task,        possibly_counterproductive).
action_function_assessment(generate_answer,           retrieve_information, appropriate).
action_function_assessment(generate_answer,           teach_reasoning,      context_dependent).
action_function_assessment(automate_task,             automate_task,        appropriate).
action_function_assessment(automate_task,             teach,                possibly_counterproductive).
action_function_assessment(summarise,                 support_human_reasoning, appropriate).
action_function_assessment(_,                         _,                    unknown).

%% function_conflict(+System, +Rule1, +Rule2, -ConflictDescription)
%% Detects when two rules serve conflicting function objectives.
function_conflict(System, RuleID1, RuleID2, Desc) :-
    rule(System, RuleID1, _, Action1),
    rule(System, RuleID2, _, Action2),
    RuleID1 \= RuleID2,
    function(System, F),
    action_function_assessment(Action1, F, A1),
    action_function_assessment(Action2, F, A2),
    assessment_conflict(A1, A2),
    Desc = function_conflict(F, Action1, A1, Action2, A2).

assessment_conflict(appropriate, possibly_counterproductive).
assessment_conflict(appropriate, counterproductive).
assessment_conflict(possibly_counterproductive, appropriate).
assessment_conflict(counterproductive, appropriate).
