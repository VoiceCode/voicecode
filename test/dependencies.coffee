global.test = require "tape"

global._ = require 'lodash'
global.chalk = require 'chalk'
global.Events = require '../app/event_emitter'
global.Packages = require '../lib/packages/packages'
global.Scope = require '../lib/scope'

global.Commands = require '../lib/commands'
global.Command = require '../lib/command'
