#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

module.exports = (grunt) ->
  grunt.initConfig {
    codo: {
      options: {
        inputs: ['lib']
      }
    }
  }

  grunt.loadNpmTasks('grunt-codo')
