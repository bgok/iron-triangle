#c.debug = true
#c.trace = true

COST = 'Cost'
TIME = 'Time'
FEATURES = 'Features'

controlList = []

# Set up the solver and attach a callback
solver = new c.SimplexSolver
solver.onsolved = =>
    _.each(controlList, (meta) ->
        meta.slider.slider('value', meta.variable.value)
        meta.valueContainer.text(meta.variable.value)
    )

# Set up the models which contain constrained variables
models = new ModelList(solver)
models.add COST, 0, -100, 100
models.add TIME, 0, -100, 100
models.add FEATURES, 0, 0, 100

# Build the relationships between variables
formula = c.minus(models.getVariable(FEATURES), c.plus(models.getVariable(COST), models.getVariable(TIME)))
balance = new c.Equation formula, 0, c.Strength.required, 0
solver.addConstraint balance
solver.resolve()

# Add a slider for each variable
_.each(models.list, (model) ->
    control = new ConstrainedSlider(model, solver)
    controlList.push(control)
    $('#controls').append(control.control)
)
