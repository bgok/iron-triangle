c.debug = true
c.trace = true

solver = new c.SimplexSolver()

cost = new c.Variable
    name: 'cost'
quality = new c.Variable
    name: 'quality'
time = new c.Variable
    name: 'time'

formula = c.plus(cost, c.plus(quality, time))

balance = new c.Equation formula, 1, c.Strength.required, 0

solver.addConstraint(balance)

#solver.addEditVar(sum, c.Strength.high).beginEdit()
#solver.suggestValue(sum, 1).resolve()
#
#solver.endEdit()

results = $ '#results'
$("<p>cost: #{cost.value}</p>").appendTo results
$("<p>quality: #{quality.value}</p>").appendTo results
$("<p>time: #{time.value}</p>").appendTo results


controls = $ '#controls'
$('<p>hello controls</p>').appendTo controls