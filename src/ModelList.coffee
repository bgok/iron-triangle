ModelList = (solver) ->
    @solver = solver
    @list = []
    return @

ModelList.prototype =
    add: (name, value, min, max) ->
        variable = new c.Variable
            name: name
            value: value

        @list.push(@list[name] =
            variable: variable
            min: min
            max: max
        )

        this.solver.addConstraint(new c.Inequality(variable, c.GEQ, min, c.Strength.required, 0))
        this.solver.addConstraint(new c.Inequality(variable, c.LEQ, max, c.Strength.required, 0))
        this.solver.addConstraint(new c.StayConstraint(variable, c.Strength.medium, 0))

        return variable

    getVariable: (name) ->
        @get(name)?.variable

    get: (name) ->
        @list[name]

window.ModelList = ModelList