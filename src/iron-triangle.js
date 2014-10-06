var COST, FEATURES, TIME, balance, controlList, formula, models, solver;

var __bind = function (fn, me) {
    return function () {
        return fn.apply(me, arguments);
    };
};

COST = 'Cost';
TIME = 'Time';
FEATURES = 'Features';

controlList = [];
solver = new c.SimplexSolver();
solver.onsolved = __bind(function () {
    return _.each(controlList, function (meta) {
        meta.slider.slider('value', meta.variable.value);
        return meta.valueContainer.text(meta.variable.value);
    });
}, this);

models = new ModelList(solver);
models.add(COST, 0, -100, 100);
models.add(TIME, 0, -100, 100);
models.add(FEATURES, 0, 0, 100);

formula = c.minus(models.getVariable(FEATURES), c.plus(models.getVariable(COST), models.getVariable(TIME)));
balance = new c.Equation(formula, 0, c.Strength.required, 0);

solver.addConstraint(balance);
solver.resolve();

_.each(models.list, function (model) {
    var control;
    control = new ConstrainedSlider(model, solver);
    controlList.push(control);
    return $('#controls').append(control.control);
});