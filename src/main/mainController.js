var ironTriangleApp = angular.module('ironTriangleApp', ['ui.grid', 'ui.grid.edit', 'ui.grid.resizeColumns']);

ironTriangleApp.controller('mainController', function ($scope) {
    $scope.datastore = {
        developers: [
            {
                name: 'Ken',
                skills: {
                    css: {
                        ability: 2.0
                    },
                    js: {
                        ability: 1.2
                    },
                    groovy: {
                        ability: 0.5
                    }
                },
                daysAvailable: 50
            },
            {
                name: 'Jim',
                skills: {
                    css: {
                        ability: 0.7
                    },
                    js: {
                        ability: 1.0
                    },
                    groovy: {
                        ability: 2.0
                    },
                    mongo: {
                        ability: 0.9
                    }
                },
                daysAvailable: 45
            }
        ]
    }


    $scope.devGridOptions = {
        data: $scope.datastore.developers,
        enableColumnResizing: true,
        columnDefs: [
            { field: 'name', name: 'Developer', enableCellEdit: true },
            { field: 'skills.css.capacity', name: 'CSS', title: 'CSS', enableCellEdit: true, type: 'number'},
            { field: 'skills.js.capacity', name: 'Javascript', enableCellEdit: true, type: 'number'},
            { field: 'skills.groovy.capacity', name: 'Groovy', enableCellEdit: true, type: 'number'},
            { field: 'skills.mongo.capacity', name: 'Mongo', enableCellEdit: true, type: 'number'},
            { field: 'daysAvailable', name: 'Availability', enableCellEdit: true, type: 'number'}
        ]
    };

    $scope.storyGridOptions = {
        data: [
            {
                name: 'Add overallocated indicator',
                css: 5,
                js: 4,
                groovy: 3
            },
            {
                name: 'Add a visual cutline',
                css: 5,
                js: 4,
                groovy: 3
            }
        ],
        enableColumnResizing: true,
        columnDefs: [
            { name: 'name', enableCellEdit: true },
            { name: 'css', enableCellEdit: true, type: 'number'},
            { name: 'js', enableCellEdit: true, type: 'number'},
            { name: 'groovy', enableCellEdit: true, type: 'number'},
            { name: 'mongo', enableCellEdit: true, type: 'number'}
        ]
    };

    $scope.addDeveloper = function() {
        $scope.devGridOptions.data.push({name: "new developer"});
    };

    $scope.addStory = function() {
        $scope.storyGridOptions.data.push({name: "new story"});
    };

    $scope.cutlineIndex = 0;

    var variables = [];
    var registerVariable = function(name, value) {
        var variable = new c.Variable({
            name: name,
            value: value
        });
        variables.push({name: name, variable: variable});

        return variable;
    };
    var getVariable = function(name) {
        return _.find(variables, {name: name});
    };

    $scope.solve = function() {
        var solver = new c.SimplexSolver();
        solver.onsolved = function() {};

        _.each($scope.datastore.developers, function(dev) {
            _.each(dev.skills, function(skill, key) {
                skill.$capacity = dev.daysAvailable * skill.abilty;
                skill.allocated = 0;
                var variable = registerVariable([dev.name, key].join(':'), skill.$allocated);
                solver.addConstraint(new c.Inequality(variable, c.GEQ, 0, c.Strength.required, 0));
                solver.addConstraint(new c.Inequality(variable, c.LEQ, skill.$capacity, c.Strength.required, 0));
            });
        });

        formula = c.minus(models.getVariable(FEATURES), c.plus(models.getVariable(COST), models.getVariable(TIME)));
        balance = new c.Equation(formula, 0, c.Strength.required, 0);

        solver.addConstraint(balance);
        solver.resolve();



    };
});