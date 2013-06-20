COST = 'Cost'
TIME = 'Time'
STORY_POINTS = 'Story Points'
TIME_PER_STORY_POINT = 'Time per Story Point'

ConstrainedSlider = (model, solver, initialValues) ->
    value = initialValues?[model.name]

    @slider = $("<div class='control' data-name='#{model.name}'/>").slider
        min: model.min
        max: model.max
        value: value
#        start: (event, ui) =>
#            solver.eq(@variable).beginEdit()
#        stop: (event, ui) =>
#            solver.endEdit()
        slide: (event, ui) =>
            S = solver.clone()
            S
                .eq(model.name, S.const(ui.value))
                .propagate()
#                .done()

    @valueContainer = $("<div class=value>#{value}</div>")

    @control = $('<div class=slider-container clearfix></div>')
        .append("<div class=label>#{model.name}</div>")
        .append(@valueContainer)
        .append(@slider)

    return @

window.ConstrainedSlider = ConstrainedSlider