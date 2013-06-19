#c.debug = true
#c.trace = true

COST = 'Cost'
TIME = 'Time'
STORY_POINTS = 'Story Points'
TIME_PER_STORY_POINT = 'Time per Story Point'

controlList = []

# Set up the solver and attach a callback
solver = new FD.space()
originalPropagate = solver.propagate

solver.propagate = ->
    originalPropagate.apply(solver)
    _.each(controlList, (meta) ->
        meta.slider.slider('value', meta.variable.value)
        meta.valueContainer.text(meta.variable.value)
    )

solver.cloneWithoutPropagators = () ->
    C = new FD.space(@)
    C._propagators = []
    return C

# Set up the models which contain constrained variables
models = new ModelList(solver)
    .add(COST, 500, [0, 1000])
    .add(TIME, 0, [0, 1000])
    .add(STORY_POINTS, 100, [0, 100])
    .add(TIME_PER_STORY_POINT, [5, 25])

# Build the relationships between variables
#formula = c.minus(models.getVariable(FEATURES), c.plus(models.getVariable(COST), models.getVariable(TIME)))
#balance = new c.Equation formula, 0, c.Strength.required, 0

solver.plus(COST, TIME, solver.times(STORY_POINTS, TIME_PER_STORY_POINT))
solver.propagate()

# Add a slider for each variable
_.each(models.list, (model) ->
    control = new ConstrainedSlider(model, solver)
    controlList.push(control)
    $('#controls').append(control.control)
)
