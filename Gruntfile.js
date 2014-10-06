(function() {
    'use strict';

    var path = require('path');

    module.exports = function (grunt) {
        grunt.initConfig({
            pkg: grunt.file.readJSON('package.json'),
            uglify: {
                options: {
                    banner:
                        '/*! <%= pkg.name %>\n' +
                        ' *  <%= pkg.description %>\n' +
                        ' *  (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.company %>\n' +
                        ' *  MIT License\n' +
                        ' */\n'
                },
                build: {
                    src: ['src/**/*.js'],
                    dest: 'js/<%= pkg.name %>.min.js'
                }
            },
            clean: ['js'],
            jshint: {
                all: ['Gruntfile.js', 'src/**/*.js']
            },
            express: {
                dev: {
                    options: {
                        livereload: true,
                        port: 3456,
                        hostname: 'localhost', // '*',  change this to '0.0.0.0' to access the server from outside
                        bases: [ path.resolve('.') ]
                    }
                }
            }
        });
        grunt.loadNpmTasks('grunt-contrib-clean');
        grunt.loadNpmTasks('grunt-contrib-uglify');
        grunt.loadNpmTasks('grunt-contrib-jshint');
        grunt.loadNpmTasks('grunt-express');

        grunt.registerTask('build', ['clean', 'jshint', 'uglify']);
        grunt.registerTask('default', ['express', 'express-keepalive']);

        grunt.registerTask('start', ['build', 'default']);
    };
})();