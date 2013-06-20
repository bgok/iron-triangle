#c.debug = true
#c.trace = true

COST = 'Cost'
TIME = 'Time'
STORY_POINTS = 'Story Points'
TIME_PER_STORY_POINT = 'Time per Story Point'
IMPLIED_TIME = '_ImpliedTime'
COST_PLUS_TIME = '_CostPlusTime'

controlList = []

# Set up the solver and attach a callback
originalPropagate = FD.space.prototype.propagate

FD.space.prototype.propagate = ->
    originalPropagate.apply(this)

    solution = this.solution()
    _.each(controlList, (meta) ->
        variableName = meta.slider.data('name')
        meta.slider.slider('value', solution[variableName])
        meta.valueContainer.text(solution[variableName])
    , this)

solver = new FD.space()


#solver.cloneWithoutPropagators = () ->
#    C = new FD.space()
#    C.vars = _.each(@vars, (p) ->
#        new FD.VAR(p.dom, p.step)
#    , @)
#    C.clone_of = @
#
#    return C

# Set up the models which contain constrained variables
models = new ModelList(solver)
    .add(COST, [0, 1000])
    .add(TIME, [0, 1000])
    .add(STORY_POINTS, [0, 100])
    .add(TIME_PER_STORY_POINT, [5, 25])

# Build the relationships between variables
#formula = c.minus(models.getVariable(FEATURES), c.plus(models.getVariable(COST), models.getVariable(TIME)))
#balance = new c.Equation formula, 0, c.Strength.required, 0

solver
    .times(STORY_POINTS, TIME_PER_STORY_POINT, TIME)

clone = solver.clone()
clone
    .eq(COST, clone.const(500))
    .eq(TIME, clone.const(500))
    .eq(STORY_POINTS, clone.const(50))
    .propagate()
#    .done()

initialValues = clone.solution()

# Add a slider for each variable
_.each(models.list, (model) ->
    control = new ConstrainedSlider(model, solver, initialValues)
    controlList.push(control)
    $('#controls').append(control.control)
)
