# computationalenglishmnn
MNN Algorithmic Influence Analyser

## Example Commands

The following examples show how to load the system in SWI-Prolog and query it.
Each example assumes you have started a Prolog session in the repository root.

### 1. Load the system

```prolog
?- [parser, rules, ethics, function, priorities, complexity].
```

### 2. Define a system under analysis

```prolog
?- assert(system(chatbot1)).
?- assert(rule(chatbot1, r_speed, user_asks_question, generate_answer)).
?- assert(rule(chatbot1, r_hint,  user_asks_question, provide_hint)).
?- assert(rule(chatbot1, r_verify, user_asks_question, ask_follow_up_question)).
?- assert(priority(chatbot1, r_speed, 10)).
?- assert(priority(chatbot1, r_hint,  5)).
?- assert(priority(chatbot1, r_verify, 4)).
?- assert(ethical_rule(chatbot1, autonomy)).
?- assert(ethical_rule(chatbot1, truthfulness)).
?- assert(function(chatbot1, teach_reasoning)).
?- assert(time_complexity(chatbot1, user_asks_question, o_1)).
?- assert(interaction(chatbot1, user_asks_question, generate_answer)).
```

### 3. Analyse rule influence

Find all possible human effects of rules triggered by a user activity:

```prolog
?- rule_influence(rule(chatbot1, r_speed, user_asks_question, generate_answer),
                  user_asks_question, Trigger, Behaviour, Effect).
% Trigger   = user_asks_question
% Behaviour = generate_answer
% Effect    = possible_reduced_information_search_by_human
```

### 4. Detect conflicting rules

```prolog
?- conflicting_rules(chatbot1, Rule1, Rule2).
% Rule1 = rule(chatbot1, r_speed, user_asks_question, generate_answer)
% Rule2 = rule(chatbot1, r_hint,  user_asks_question, provide_hint)
```

### 5. Check for ethical violations

```prolog
?- ethical_violation(chatbot1, RuleID, Principle, Description).
% RuleID      = r_speed
% Principle   = truthfulness
% Description = 'generated answers must be accurate to preserve truthfulness'
```

### 6. Assess ethical coverage

```prolog
?- ethical_assessment(chatbot1, autonomy, Status, Evidence).
% Status   = declared
% Evidence = observed

?- missing_safeguard(chatbot1, Principle, MissingRule).
% Principle   = privacy
% MissingRule = missing_rule_for(privacy)
```

### 7. Assess function compatibility

```prolog
?- functional_assessment(chatbot1, produce_complete_solution, teach_reasoning, Assessment).
% Assessment = possibly_counterproductive
```

### 8. Detect priority conflicts

```prolog
?- priority_conflict(chatbot1, Rule1, Rule2, ConflictType).
% Rule1        = r_speed
% Rule2        = r_verify
% ConflictType = speed_over_verification
```

Find the dominant (highest-priority) rule:

```prolog
?- dominant_rule(chatbot1, Rule, Priority).
% Rule     = r_speed
% Priority = 10
```

### 9. Analyse time complexity influence

```prolog
?- time_influence(chatbot1, user_asks_question, Mechanism, Assessment).
% Mechanism  = minimal_waiting
% Assessment = low
```

### 10. List all registered systems

```prolog
?- all_systems(Systems).
% Systems = [chatbot1]
```
