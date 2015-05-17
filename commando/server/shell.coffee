@Shell = Meteor.npmRequire('shelljs')
@Execute = Meteor.wrapAsync(Shell.exec, Shell)
