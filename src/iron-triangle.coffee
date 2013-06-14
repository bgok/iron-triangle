#c.debug = true
#c.trace = true

controlList = []
ModelList = (solver) ->
    this.solver = solver
    this.list = []
    return

ModelList.prototype =
    addVariable: (name, value, min, max) ->
        variable = new c.Variable
            name: name
            value: value

        this.list[name] =
            variable: variable
            min: min
            max: max

        this.solver.addConstraint new c.Inequality(variable, c.GEQ, min)
        this.solver.addConstraint new c.Inequality(variable, c.LEQ, max)

        return variable

    getVariable: (name) ->
        this.list[name].variable

    getModel: (name) ->
        this.list[name]

solver = new c.SimplexSolver
solver.onsolved = =>
    _.each controlList, (meta) ->
        meta.control.slider 'value', meta.variable.value
        meta.valueContainer.text meta.variable.value

varList = new ModelList(solver)

feature = varList.addVariable 'Features', 0, 0, 100
cost = varList.addVariable 'Cost', 0, -100, 100
time = varList.addVariable 'Time', 0, -100, 100

#solver.addConstraint (new c.Equation c.minus(feature, c.divide(time, 2))), 0, c.Strength.weak, 0

formula = c.minus feature, c.plus(cost, time)
balance = new c.Equation formula, 0, c.Strength.required, 0
solver.addConstraint balance

solver.addEditVar(cost, c.Strength.strong).beginEdit()
solver.addEditVar(feature, c.Strength.strong).beginEdit()
solver.addEditVar(time, c.Strength.strong).beginEdit()
solver.suggestValue(cost, 0)
solver.suggestValue(feature, 0)
solver.suggestValue(time, 0)

solver.endEdit()

#results = $ '#results'
#$("<p>cost: #{cost.value}</p>").appendTo results
#$("<p>quality: #{quality.value}</p>").appendTo results
#$("<p>time: #{time.value}</p>").appendTo results


createSlider = (model) ->
    sliderControl = $('<div class="control"/>').slider
        min: model.min
        max: model.max
        value: model.value
        start: (event, ui) =>
            solver.addEditVar(model.variable, c.Strength.high).beginEdit()
        stop: (event, ui) =>
            solver.endEdit();
        slide: (event, ui) =>
            solver.suggestValue(model.variable, ui.value).resolve()

    valueContainer = $("<div class=value>#{model.value}</div>")

    controlList.push
        variable: model
        control: sliderControl
        valueContainer: valueContainer

    $('<div class=slider-container clearfix></div>')
        .append("<div class=label>#{model.name}</div>")
        .append(valueContainer)
        .append(sliderControl)

controls = $ '#controls'
createSlider(varList.getModel(cost.name)).appendTo controls
createSlider(varList.getModel(feature.name)).appendTo controls
createSlider(varList.getModel(time.name)).appendTo controls
