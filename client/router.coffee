Router.configure
  layoutTemplate: 'Layout',
  loadingTemplate: 'Loading'

Router.route '/', ->
  this.render 'Home'
Router.route '/grammar', ->
  this.render 'Grammar'
Router.route '/interpreter', ->
  this.render 'Interpreter'
Router.route '/commands', ->
  this.render 'Commands'
Router.route '/utility', ->
  this.render 'Utility'
Router.route '/vocab', ->
  this.render 'Vocab'
Router.route '/mobile', ->
  this.render 'Mobile'
