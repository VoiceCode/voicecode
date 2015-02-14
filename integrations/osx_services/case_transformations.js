var hasSpace = /\s/;
var hasSeparator = /[\W_]/;
var separatorSplitter = /[\W_]+(.|$)/g;
var camelSplitter = /(.)([A-Z]+)/g;

function unseparate (string) {
  return string.replace(separatorSplitter, function (m, next) {
    return next ? ' ' + next : '';
  });
}

function uncamelize (string) {
  return string.replace(camelSplitter, function (m, previous, uppers) {
    return previous + ' ' + uppers.toLowerCase().split('').join(' ');
  });
}

function toNoCase (string) {
  if (hasSpace.test(string)) return string.toLowerCase();
  if (hasSeparator.test(string)) return (unseparate(string) || string).toLowerCase();
  return uncamelize(string).toLowerCase();
}

function toSpaceCase (string) {
  return toNoCase(string).replace(/[\W_]+(.|$)/g, function (matches, match) {
    return match ? ' ' + match : '';
  });
}

function toSnakeCase (string) {
  return toSpaceCase(string).replace(/\s/g, '_');
}

function toCamelCase (string) {
  return toSpaceCase(string).replace(/\s(\w)/g, function (matches, letter) {
    return letter.toUpperCase();
  });
}

function toDotCase (string) {
  return toSpaceCase(string).replace(/\s/g, '.');
}

function toConstantCase (string) {
  return toSnakeCase(string).toUpperCase();
}

function toSentenceCase (string) {
  return toNoCase(string).replace(/[a-z]/i, function (letter) {
    return letter.toUpperCase();
  });
}

function toSlugCase (string) {
  return toSpaceCase(string).replace(/\s/g, '-');
}

function toCapitalCase (string) {
  return toNoCase(string).replace(/(^|\s)(\w)/g, function (matches, previous, letter) {
    return previous + letter.toUpperCase();
  });
}

function toPascalCase (string) {
  return toSpaceCase(string).replace(/(?:^|\s)(\w)/g, function (matches, letter) {
    return letter.toUpperCase();
  });
}

function toYellerCase (string) {
  return toSpaceCase(string).toUpperCase();
}

function toSmashCase (string) {
  return toSpaceCase(string).replace(/\s/g, '');
}

function toYellsmashCase (string) {
  return toSpaceCase(string).replace(/\s/g, '').toUpperCase();
}

function toTitleCase (string) {
	escape = function(str){
	  return String(str).replace(/([.*+?=^!:${}()|[\]\/\\])/g, '\\$1');
	};
	var minors = [
	  'a',
	  'an',
	  'and',
	  'as',
	  'at',
	  'but',
	  'by',
	  'en',
	  'for',
	  'from',
	  'how',
	  'if',
	  'in',
	  'neither',
	  'nor',
	  'of',
	  'on',
	  'only',
	  'onto',
	  'out',
	  'or',
	  'per',
	  'so',
	  'than',
	  'that',
	  'the',
	  'to',
	  'until',
	  'up',
	  'upon',
	  'v',
	  'v.',
	  'versus',
	  'vs',
	  'vs.',
	  'via',
	  'when',
	  'with',
	  'without',
	  'yet'
	];
	var escaped = minors.map(escape);
	var minorMatcher = new RegExp('[^^]\\b(' + escaped.join('|') + ')\\b', 'ig');
	var colonMatcher = /:\s*(\w)/g;

  return toCapitalCase(string)
    .replace(minorMatcher, function (minor) {
      return minor.toLowerCase();
    })
    .replace(colonMatcher, function (letter) {
      return letter.toUpperCase();
    });
}

function run(input, parameters) {
	return toDotCase(input[0]);
}
