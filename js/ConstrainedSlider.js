(function() {
  var ConstrainedSlider;

  ConstrainedSlider = function(model, solver) {
    var _this = this;
    this.variable = model.variable;
    this.slider = $('<div class="control"/>').slider({
      min: model.min,
      max: model.max,
      value: this.variable.value,
      start: function(event, ui) {
        return solver.addEditVar(_this.variable, c.Strength.strong).beginEdit();
      },
      stop: function(event, ui) {
        return solver.endEdit();
      },
      slide: function(event, ui) {
        return solver.suggestValue(_this.variable, ui.value).resolve();
      }
    });
    this.valueContainer = $("<div class=value>" + this.variable.value + "</div>");
    this.control = $('<div class=slider-container clearfix></div>').append("<div class=label>" + this.variable.name + "</div>").append(this.valueContainer).append(this.slider);
    return this;
  };

  window.ConstrainedSlider = ConstrainedSlider;

}).call(this);
