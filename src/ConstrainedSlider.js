var ConstrainedSlider;

var __bind = function (fn, me) {
    return function () {
        return fn.apply(me, arguments);
    };
};

ConstrainedSlider = function (model, solver) {
    this.variable = model.variable;
    this.slider = $('<div class="control"/>').slider({
        min: model.min,
        max: model.max,
        value: this.variable.value,
        start: __bind(function (event, ui) {
            return solver.addEditVar(this.variable, c.Strength.strong).beginEdit();
        }, this),
        stop: __bind(function (event, ui) {
            return solver.endEdit();
        }, this),
        slide: __bind(function (event, ui) {
            return solver.suggestValue(this.variable, ui.value).resolve();
        }, this)
    });
    this.valueContainer = $("<div class=value>" + this.variable.value + "</div>");
    this.control = $('<div class=slider-container clearfix></div>').append("<div class=label>" + this.variable.name + "</div>").append(this.valueContainer).append(this.slider);
    return this;
};

window.ConstrainedSlider = ConstrainedSlider;