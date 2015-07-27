this.customGrammarParser = (function() {

  function cgp$subclass(child, parent) {
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
  }

  function SyntaxError(message, expected, found, offset, line, column) {
    this.message  = message;
    this.expected = expected;
    this.found    = found;
    this.offset   = offset;
    this.line     = line;
    this.column   = column;

    this.name     = "SyntaxError";
  }

  cgp$subclass(SyntaxError, Error);

  function parse(input) {
    var options = arguments.length > 1 ? arguments[1] : {},

        cgp$FAILED = {},

        cgp$startRuleFunctions = { start: cgp$parsestart },
        cgp$startRuleFunction  = cgp$parsestart,

        cgp$c0 = [],
        cgp$c1 = cgp$FAILED,
        cgp$c2 = "(",
        cgp$c3 = { type: "literal", value: "(", description: "\"(\"" },
        cgp$c4 = ")",
        cgp$c5 = { type: "literal", value: ")", description: "\")\"" },
        cgp$c6 = null,
        cgp$c7 = "?",
        cgp$c8 = { type: "literal", value: "?", description: "\"?\"" },
        cgp$c9 = function(name, optional) {return {list: name, optional: !!optional};},
        cgp$c10 = function(words) {return {text: words.join(' ')};},
        cgp$c11 = " ",
        cgp$c12 = { type: "literal", value: " ", description: "\" \"" },
        cgp$c13 = /^[a-z]/i,
        cgp$c14 = { type: "class", value: "[a-z]i", description: "[a-z]i" },
        cgp$c15 = function(letters) {return letters.join('');},

        cgp$currPos          = 0,
        cgp$reportedPos      = 0,
        cgp$cachedPos        = 0,
        cgp$cachedPosDetails = { line: 1, column: 1, seenCR: false },
        cgp$maxFailPos       = 0,
        cgp$maxFailExpected  = [],
        cgp$silentFails      = 0,

        cgp$result;

    if ("startRule" in options) {
      if (!(options.startRule in cgp$startRuleFunctions)) {
        throw new Error("Can't start parsing from rule \"" + options.startRule + "\".");
      }

      cgp$startRuleFunction = cgp$startRuleFunctions[options.startRule];
    }

    function text() {
      return input.substring(cgp$reportedPos, cgp$currPos);
    }

    function offset() {
      return cgp$reportedPos;
    }

    function line() {
      return cgp$computePosDetails(cgp$reportedPos).line;
    }

    function column() {
      return cgp$computePosDetails(cgp$reportedPos).column;
    }

    function expected(description) {
      throw cgp$buildException(
        null,
        [{ type: "other", description: description }],
        cgp$reportedPos
      );
    }

    function error(message) {
      throw cgp$buildException(message, null, cgp$reportedPos);
    }

    function cgp$computePosDetails(pos) {
      function advance(details, startPos, endPos) {
        var p, ch;

        for (p = startPos; p < endPos; p++) {
          ch = input.charAt(p);
          if (ch === "\n") {
            if (!details.seenCR) { details.line++; }
            details.column = 1;
            details.seenCR = false;
          } else if (ch === "\r" || ch === "\u2028" || ch === "\u2029") {
            details.line++;
            details.column = 1;
            details.seenCR = true;
          } else {
            details.column++;
            details.seenCR = false;
          }
        }
      }

      if (cgp$cachedPos !== pos) {
        if (cgp$cachedPos > pos) {
          cgp$cachedPos = 0;
          cgp$cachedPosDetails = { line: 1, column: 1, seenCR: false };
        }
        advance(cgp$cachedPosDetails, cgp$cachedPos, pos);
        cgp$cachedPos = pos;
      }

      return cgp$cachedPosDetails;
    }

    function cgp$fail(expected) {
      if (cgp$currPos < cgp$maxFailPos) { return; }

      if (cgp$currPos > cgp$maxFailPos) {
        cgp$maxFailPos = cgp$currPos;
        cgp$maxFailExpected = [];
      }

      cgp$maxFailExpected.push(expected);
    }

    function cgp$buildException(message, expected, pos) {
      function cleanupExpected(expected) {
        var i = 1;

        expected.sort(function(a, b) {
          if (a.description < b.description) {
            return -1;
          } else if (a.description > b.description) {
            return 1;
          } else {
            return 0;
          }
        });

        while (i < expected.length) {
          if (expected[i - 1] === expected[i]) {
            expected.splice(i, 1);
          } else {
            i++;
          }
        }
      }

      function buildMessage(expected, found) {
        function stringEscape(s) {
          function hex(ch) { return ch.charCodeAt(0).toString(16).toUpperCase(); }

          return s
            .replace(/\\/g,   '\\\\')
            .replace(/"/g,    '\\"')
            .replace(/\x08/g, '\\b')
            .replace(/\t/g,   '\\t')
            .replace(/\n/g,   '\\n')
            .replace(/\f/g,   '\\f')
            .replace(/\r/g,   '\\r')
            .replace(/[\x00-\x07\x0B\x0E\x0F]/g, function(ch) { return '\\x0' + hex(ch); })
            .replace(/[\x10-\x1F\x80-\xFF]/g,    function(ch) { return '\\x'  + hex(ch); })
            .replace(/[\u0180-\u0FFF]/g,         function(ch) { return '\\u0' + hex(ch); })
            .replace(/[\u1080-\uFFFF]/g,         function(ch) { return '\\u'  + hex(ch); });
        }

        var expectedDescs = new Array(expected.length),
            expectedDesc, foundDesc, i;

        for (i = 0; i < expected.length; i++) {
          expectedDescs[i] = expected[i].description;
        }

        expectedDesc = expected.length > 1
          ? expectedDescs.slice(0, -1).join(", ")
              + " or "
              + expectedDescs[expected.length - 1]
          : expectedDescs[0];

        foundDesc = found ? "\"" + stringEscape(found) + "\"" : "end of input";

        return "Expected " + expectedDesc + " but " + foundDesc + " found.";
      }

      var posDetails = cgp$computePosDetails(pos),
          found      = pos < input.length ? input.charAt(pos) : null;

      if (expected !== null) {
        cleanupExpected(expected);
      }

      return new SyntaxError(
        message !== null ? message : buildMessage(expected, found),
        expected,
        found,
        pos,
        posDetails.line,
        posDetails.column
      );
    }

    function cgp$parsestart() {
      var s0, s1;

      s0 = [];
      s1 = cgp$parsetoken();
      if (s1 !== cgp$FAILED) {
        while (s1 !== cgp$FAILED) {
          s0.push(s1);
          s1 = cgp$parsetoken();
        }
      } else {
        s0 = cgp$c1;
      }

      return s0;
    }

    function cgp$parsetoken() {
      var s0;

      s0 = cgp$parselist();
      if (s0 === cgp$FAILED) {
        s0 = cgp$parsetext();
      }

      return s0;
    }

    function cgp$parselist() {
      var s0, s1, s2, s3, s4, s5;

      s0 = cgp$currPos;
      if (input.charCodeAt(cgp$currPos) === 40) {
        s1 = cgp$c2;
        cgp$currPos++;
      } else {
        s1 = cgp$FAILED;
        if (cgp$silentFails === 0) { cgp$fail(cgp$c3); }
      }
      if (s1 !== cgp$FAILED) {
        s2 = cgp$parseword();
        if (s2 !== cgp$FAILED) {
          if (input.charCodeAt(cgp$currPos) === 41) {
            s3 = cgp$c4;
            cgp$currPos++;
          } else {
            s3 = cgp$FAILED;
            if (cgp$silentFails === 0) { cgp$fail(cgp$c5); }
          }
          if (s3 !== cgp$FAILED) {
            if (input.charCodeAt(cgp$currPos) === 63) {
              s4 = cgp$c7;
              cgp$currPos++;
            } else {
              s4 = cgp$FAILED;
              if (cgp$silentFails === 0) { cgp$fail(cgp$c8); }
            }
            if (s4 === cgp$FAILED) {
              s4 = cgp$c6;
            }
            if (s4 !== cgp$FAILED) {
              s5 = cgp$parses();
              if (s5 !== cgp$FAILED) {
                cgp$reportedPos = s0;
                s1 = cgp$c9(s2, s4);
                s0 = s1;
              } else {
                cgp$currPos = s0;
                s0 = cgp$c1;
              }
            } else {
              cgp$currPos = s0;
              s0 = cgp$c1;
            }
          } else {
            cgp$currPos = s0;
            s0 = cgp$c1;
          }
        } else {
          cgp$currPos = s0;
          s0 = cgp$c1;
        }
      } else {
        cgp$currPos = s0;
        s0 = cgp$c1;
      }

      return s0;
    }

    function cgp$parsetext() {
      var s0, s1, s2;

      s0 = cgp$currPos;
      s1 = [];
      s2 = cgp$parseword();
      if (s2 !== cgp$FAILED) {
        while (s2 !== cgp$FAILED) {
          s1.push(s2);
          s2 = cgp$parseword();
        }
      } else {
        s1 = cgp$c1;
      }
      if (s1 !== cgp$FAILED) {
        cgp$reportedPos = s0;
        s1 = cgp$c10(s1);
      }
      s0 = s1;

      return s0;
    }

    function cgp$parses() {
      var s0, s1;

      s0 = [];
      if (input.charCodeAt(cgp$currPos) === 32) {
        s1 = cgp$c11;
        cgp$currPos++;
      } else {
        s1 = cgp$FAILED;
        if (cgp$silentFails === 0) { cgp$fail(cgp$c12); }
      }
      while (s1 !== cgp$FAILED) {
        s0.push(s1);
        if (input.charCodeAt(cgp$currPos) === 32) {
          s1 = cgp$c11;
          cgp$currPos++;
        } else {
          s1 = cgp$FAILED;
          if (cgp$silentFails === 0) { cgp$fail(cgp$c12); }
        }
      }

      return s0;
    }

    function cgp$parseword() {
      var s0, s1, s2;

      s0 = cgp$currPos;
      s1 = [];
      if (cgp$c13.test(input.charAt(cgp$currPos))) {
        s2 = input.charAt(cgp$currPos);
        cgp$currPos++;
      } else {
        s2 = cgp$FAILED;
        if (cgp$silentFails === 0) { cgp$fail(cgp$c14); }
      }
      if (s2 !== cgp$FAILED) {
        while (s2 !== cgp$FAILED) {
          s1.push(s2);
          if (cgp$c13.test(input.charAt(cgp$currPos))) {
            s2 = input.charAt(cgp$currPos);
            cgp$currPos++;
          } else {
            s2 = cgp$FAILED;
            if (cgp$silentFails === 0) { cgp$fail(cgp$c14); }
          }
        }
      } else {
        s1 = cgp$c1;
      }
      if (s1 !== cgp$FAILED) {
        s2 = cgp$parses();
        if (s2 !== cgp$FAILED) {
          cgp$reportedPos = s0;
          s1 = cgp$c15(s1);
          s0 = s1;
        } else {
          cgp$currPos = s0;
          s0 = cgp$c1;
        }
      } else {
        cgp$currPos = s0;
        s0 = cgp$c1;
      }

      return s0;
    }

    cgp$result = cgp$startRuleFunction();

    if (cgp$result !== cgp$FAILED && cgp$currPos === input.length) {
      return cgp$result;
    } else {
      if (cgp$result !== cgp$FAILED && cgp$currPos < input.length) {
        cgp$fail({ type: "end", description: "end of input" });
      }

      throw cgp$buildException(null, cgp$maxFailExpected, cgp$maxFailPos);
    }
  }

  return {
    SyntaxError: SyntaxError,
    parse:       parse
  };
})();
