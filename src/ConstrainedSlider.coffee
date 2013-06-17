ConstrainedSlider = (model, solver) ->
    @variable = model.variable

    @slider = $('<div class="control"/>').slider
        min: model.min
        max: model.max
        value: @variable.value
        start: (event, ui) =>
            solver.addEditVar(@variable, c.Strength.strong).beginEdit()
        stop: (event, ui) =>
            solver.endEdit()
        slide: (event, ui) =>
            solver.suggestValue(@variable, ui.value).resolve()

    @valueContainer = $("<div class=value>#{@variable.value}</div>")

    @control = $('<div class=slider-container clearfix></div>')
        .append("<div class=label>#{@variable.name}</div>")
        .append(@valueContainer)
        .append(@slider)

    return @

window.ConstrainedSlider = ConstrainedSlider