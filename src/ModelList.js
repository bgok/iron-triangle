var ModelList = function(solver) {
    this.solver = solver;
    this.list = [];
    return this;
};
ModelList.prototype = {
    add: function(name, value, min, max) {
        var variable;
        variable = new c.Variable({
            name: name,
            value: value
        });
        this.list.push(this.list[name] = {
            variable: variable,
            min: min,
            max: max
        });
        this.solver.addConstraint(new c.Inequality(variable, c.GEQ, min, c.Strength.required, 0));
        this.solver.addConstraint(new c.Inequality(variable, c.LEQ, max, c.Strength.required, 0));
        this.solver.addConstraint(new c.StayConstraint(variable, c.Strength.medium, 0));

        return variable;
    },
    getVariable: function(name) {
        return this.get(name).variable;
    },
    get: function(name) {
        return this.list[name];
    }
};
window.ModelList = ModelList;