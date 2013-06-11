#c.debug = true
#c.trace = true

controlList = []

solver = new c.SimplexSolver

solver.onsolved = =>
    _.each controlList, (meta) ->
        meta.control.slider 'value', meta.variable.value


cost = new c.Variable
    name: 'Cost'
    value: 0
solver.addConstraint new c.Inequality(cost, c.GEQ, -100)
solver.addConstraint new c.Inequality(cost, c.LEQ, 100)

quality = new c.Variable
    name: 'Features'
    value: 0
solver.addConstraint new c.Inequality(quality, c.GEQ, -100)
solver.addConstraint new c.Inequality(quality, c.LEQ, 100)

time = new c.Variable
    name: 'Time'
    value: 0
solver.addConstraint new c.Inequality(time, c.GEQ, -100)
solver.addConstraint new c.Inequality(time, c.LEQ, 100)

formula = c.plus(cost, c.plus(quality, time))

balance = new c.Equation formula, 0, c.Strength.required, 0

solver.addConstraint balance

solver.addEditVar(cost, c.Strength.strong).beginEdit()
solver.addEditVar(quality, c.Strength.strong).beginEdit()
solver.addEditVar(time, c.Strength.strong).beginEdit()
solver.suggestValue(cost, 0)
solver.suggestValue(quality, 0)
solver.suggestValue(time, 0)

solver.endEdit()

#results = $ '#results'
#$("<p>cost: #{cost.value}</p>").appendTo results
#$("<p>quality: #{quality.value}</p>").appendTo results
#$("<p>time: #{time.value}</p>").appendTo results


controls = $ '#controls'
createSlider = (model) ->
    slider = $('<span class="slider-control"/>').slider
        min: -100
        max: 100
        value: model.value
        start: (event, ui) =>
            solver.addEditVar(model, c.Strength.high).beginEdit()
        stop: (event, ui) =>
            solver.endEdit();
        slide: (event, ui) =>
            solver.suggestValue(model, ui.value).resolve()

    controlList.push
        variable: model
        control: slider

    $("<div class='slider-container clearfix'><span class='slider-label'>#{model.name}</span></div>").append(slider);

createSlider(cost).appendTo controls
createSlider(quality).appendTo controls
createSlider(time).appendTo controls
