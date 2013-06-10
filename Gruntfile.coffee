module.exports = (grunt) ->
  'use strict'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
#  grunt.loadNpmTasks 'grunt-contrib-jasmine'
#  grunt.loadNpmTasks 'grunt-contrib-clean'
#  grunt.loadNpmTasks 'grunt-express'
#  grunt.loadNpmTasks 'grunt-webdriver-jasmine-runner'
#  grunt.loadNpmTasks 'grunt-bower-task'

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
#      test:
#        expand: true
#        cwd: 'spec/src'
#        src: ['**/*.coffee']
#        dest: 'spec/dist'
#        ext: '.js'

      main:
        expand: true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'js'
        ext: '.js'

