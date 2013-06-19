ConstrainedSlider = (model, solver) ->
    value = solver.solution()?[model.name]

    @slider = $('<div class="control"/>').slider
        min: model.min
        max: model.max
        value: value
#        start: (event, ui) =>
#            solver.eq(@variable).beginEdit()
#        stop: (event, ui) =>
#            solver.endEdit()
        slide: (event, ui) =>
            S = solver.cloneWithoutPropagators()
            S.eq(model.name, solver.const(ui.value)).propagate()
#            S.done()

    @valueContainer = $("<div class=value>#{value}</div>")

    @control = $('<div class=slider-container clearfix></div>')
        .append("<div class=label>#{model.name}</div>")
        .append(@valueContainer)
        .append(@slider)

    return @

window.ConstrainedSlider = ConstrainedSlider