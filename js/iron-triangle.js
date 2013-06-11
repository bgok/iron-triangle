(function() {
  var balance, controlList, controls, cost, createSlider, formula, quality, solver, time,
    _this = this;

  c.debug = true;

  c.trace = true;

  controlList = [];

  solver = new c.SimplexSolver;

  solver.onsolved = function() {
    return _.each(controlList, function(meta) {
      return meta.control.slider('value', meta.variable.value);
    });
  };

  cost = new c.Variable({
    name: 'cost',
    value: 0
  });

  solver.addConstraint(new c.Inequality(cost, c.GEQ, -100));

  solver.addConstraint(new c.Inequality(cost, c.LEQ, 100));

  quality = new c.Variable({
    name: 'quality',
    value: 0
  });

  solver.addConstraint(new c.Inequality(quality, c.GEQ, -100));

  solver.addConstraint(new c.Inequality(quality, c.LEQ, 100));

  time = new c.Variable({
    name: 'time',
    value: 0
  });

  solver.addConstraint(new c.Inequality(time, c.GEQ, -100));

  solver.addConstraint(new c.Inequality(time, c.LEQ, 100));

  formula = c.plus(cost, c.plus(quality, time));

  balance = new c.Equation(formula, 0, c.Strength.required, 0);

  solver.addConstraint(balance);

  solver.addEditVar(cost, c.Strength.strong).beginEdit();

  solver.addEditVar(quality, c.Strength.strong).beginEdit();

  solver.addEditVar(time, c.Strength.strong).beginEdit();

  solver.suggestValue(cost, 0);

  solver.suggestValue(quality, 0);

  solver.suggestValue(time, 0);

  solver.endEdit();

  controls = $('#controls');

  createSlider = function(model) {
    var slider,
      _this = this;
    slider = $('<span class="slider-control"/>').slider({
      min: -100,
      max: 100,
      value: model.value,
      start: function(event, ui) {
        return solver.addEditVar(model, c.Strength.high).beginEdit();
      },
      stop: function(event, ui) {
        return solver.endEdit();
      },
      slide: function(event, ui) {
        return solver.suggestValue(model, ui.value).resolve();
      }
    });
    controlList.push({
      variable: model,
      control: slider
    });
    return $("<div class='slider-container clearfix'><span class='slider-label'>" + model.name + "</span></div>").append(slider);
  };

  createSlider(cost).appendTo(controls);

  createSlider(quality).appendTo(controls);

  createSlider(time).appendTo(controls);

}).call(this);
