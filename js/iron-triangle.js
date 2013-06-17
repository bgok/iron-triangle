(function() {
  var ModelList, balance, controlList, controls, cost, createSlider, feature, formula, solver, time, varList,
    _this = this;

  controlList = [];

  ModelList = function(solver) {
    this.solver = solver;
    this.list = [];
  };

  ModelList.prototype = {
    addVariable: function(name, value, min, max) {
      var variable;
      variable = new c.Variable({
        name: name,
        value: value
      });
      this.list[name] = {
        variable: variable,
        min: min,
        max: max
      };
      this.solver.addConstraint(new c.Inequality(variable, c.GEQ, min, c.Strength.required, 0));
      this.solver.addConstraint(new c.Inequality(variable, c.LEQ, max, c.Strength.required, 0));
      this.solver.addConstraint(new c.StayConstraint(variable, c.Strength.medium, 0));
      return variable;
    },
    getVariable: function(name) {
      return this.list[name].variable;
    },
    getModel: function(name) {
      return this.list[name];
    }
  };

  solver = new c.SimplexSolver;

  solver.onsolved = function() {
    return _.each(controlList, function(meta) {
      meta.control.slider('value', meta.variable.value);
      return meta.valueContainer.text(meta.variable.value);
    });
  };

  varList = new ModelList(solver);

  cost = varList.addVariable('Cost', 0, -100, 100);

  time = varList.addVariable('Time', 0, -100, 100);

  feature = varList.addVariable('Features', 0, 0, 100);

  formula = c.minus(feature, c.plus(cost, time));

  balance = new c.Equation(formula, 0, c.Strength.required, 0);

  solver.addConstraint(balance);

  solver.addEditVar(cost, c.Strength.strong);

  solver.addEditVar(feature, c.Strength.strong);

  solver.addEditVar(time, c.Strength.strong).beginEdit();

  solver.suggestValue(cost, 0);

  solver.suggestValue(feature, 0);

  solver.suggestValue(time, 0);

  solver.endEdit();

  createSlider = function(model) {
    var sliderControl, valueContainer,
      _this = this;
    sliderControl = $('<div class="control"/>').slider({
      min: model.min,
      max: model.max,
      value: model.value,
      start: function(event, ui) {
        return solver.addEditVar(model.variable, c.Strength.strong).beginEdit();
      },
      stop: function(event, ui) {
        solver.suggestValue(model.variable, ui.value);
        return solver.endEdit();
      },
      slide: function(event, ui) {
        return solver.suggestValue(model.variable, ui.value).resolve();
      }
    });
    valueContainer = $("<div class=value>" + model.variable.value + "</div>");
    controlList.push({
      variable: model.variable,
      control: sliderControl,
      valueContainer: valueContainer
    });
    return $('<div class=slider-container clearfix></div>').append("<div class=label>" + model.variable.name + "</div>").append(valueContainer).append(sliderControl);
  };

  controls = $('#controls');

  createSlider(varList.getModel(cost.name)).appendTo(controls);

  createSlider(varList.getModel(feature.name)).appendTo(controls);

  createSlider(varList.getModel(time.name)).appendTo(controls);

}).call(this);
