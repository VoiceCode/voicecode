module.exports = (function() {

  function cgp$subclass(child, parent) {
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
  }

  function cgp$SyntaxError(message, expected, found, location) {
    this.message  = message;
    this.expected = expected;
    this.found    = found;
    this.location = location;
    this.name     = "SyntaxError";

    if (typeof Error.captureStackTrace === "function") {
      Error.captureStackTrace(this, cgp$SyntaxError);
    }
  }

  cgp$subclass(cgp$SyntaxError, Error);

  function cgp$parse(input) {
    var options = arguments.length > 1 ? arguments[1] : {},
        parser  = this,

        cgp$FAILED = {},

        cgp$startRuleFunctions = { start: cgp$parsestart },
        cgp$startRuleFunction  = cgp$parsestart,

        cgp$c0 = function(includeName, tokens) {return {includeName: includeName, tokens: tokens};},
        cgp$c1 = "<name>",
        cgp$c2 = { type: "literal", value: "<name>", description: "\"<name>\"" },
        cgp$c3 = function() {return true;},
        cgp$c4 = "(",
        cgp$c5 = { type: "literal", value: "(", description: "\"(\"" },
        cgp$c6 = ")",
        cgp$c7 = { type: "literal", value: ")", description: "\")\"" },
        cgp$c8 = "*",
        cgp$c9 = { type: "literal", value: "*", description: "\"*\"" },
        cgp$c10 = function(listTokens, optional) {return {name: listTokens.join('').replace(/ /g, ''), list: listTokens, optional: !!optional};},
        cgp$c11 = "/",
        cgp$c12 = { type: "literal", value: "/", description: "\"/\"" },
        cgp$c13 = function(name, separator) {return name.join(' ')},
        cgp$c14 = function(words) {return {text: words.join(' ')};},
        cgp$c15 = " ",
        cgp$c16 = { type: "literal", value: " ", description: "\" \"" },
        cgp$c17 = /^[a-z]/i,
        cgp$c18 = { type: "class", value: "[a-z]i", description: "[a-z]i" },
        cgp$c19 = function(letters) {return letters.join('');},

        cgp$currPos          = 0,
        cgp$savedPos         = 0,
        cgp$posDetailsCache  = [{ line: 1, column: 1, seenCR: false }],
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
      return input.substring(cgp$savedPos, cgp$currPos);
    }

    function location() {
      return cgp$computeLocation(cgp$savedPos, cgp$currPos);
    }

    function expected(description) {
      throw cgp$buildException(
        null,
        [{ type: "other", description: description }],
        input.substring(cgp$savedPos, cgp$currPos),
        cgp$computeLocation(cgp$savedPos, cgp$currPos)
      );
    }

    function error(message) {
      throw cgp$buildException(
        message,
        null,
        input.substring(cgp$savedPos, cgp$currPos),
        cgp$computeLocation(cgp$savedPos, cgp$currPos)
      );
    }

    function cgp$computePosDetails(pos) {
      var details = cgp$posDetailsCache[pos],
          p, ch;

      if (details) {
        return details;
      } else {
        p = pos - 1;
        while (!cgp$posDetailsCache[p]) {
          p--;
        }

        details = cgp$posDetailsCache[p];
        details = {
          line:   details.line,
          column: details.column,
          seenCR: details.seenCR
        };

        while (p < pos) {
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

          p++;
        }

        cgp$posDetailsCache[pos] = details;
        return details;
      }
    }

    function cgp$computeLocation(startPos, endPos) {
      var startPosDetails = cgp$computePosDetails(startPos),
          endPosDetails   = cgp$computePosDetails(endPos);

      return {
        start: {
          offset: startPos,
          line:   startPosDetails.line,
          column: startPosDetails.column
        },
        end: {
          offset: endPos,
          line:   endPosDetails.line,
          column: endPosDetails.column
        }
      };
    }

    function cgp$fail(expected) {
      if (cgp$currPos < cgp$maxFailPos) { return; }

      if (cgp$currPos > cgp$maxFailPos) {
        cgp$maxFailPos = cgp$currPos;
        cgp$maxFailExpected = [];
      }

      cgp$maxFailExpected.push(expected);
    }

    function cgp$buildException(message, expected, found, location) {
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
            .replace(/[\u0100-\u0FFF]/g,         function(ch) { return '\\u0' + hex(ch); })
            .replace(/[\u1000-\uFFFF]/g,         function(ch) { return '\\u'  + hex(ch); });
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

      if (expected !== null) {
        cleanupExpected(expected);
      }

      return new cgp$SyntaxError(
        message !== null ? message : buildMessage(expected, found),
        expected,
        found,
        location
      );
    }

    function cgp$parsestart() {
      var s0, s1, s2, s3;

      s0 = cgp$currPos;
      s1 = cgp$parseincludeName();
      if (s1 === cgp$FAILED) {
        s1 = null;
      }
      if (s1 !== cgp$FAILED) {
        s2 = [];
        s3 = cgp$parsetoken();
        if (s3 !== cgp$FAILED) {
          while (s3 !== cgp$FAILED) {
            s2.push(s3);
            s3 = cgp$parsetoken();
          }
        } else {
          s2 = cgp$FAILED;
        }
        if (s2 !== cgp$FAILED) {
          cgp$savedPos = s0;
          s1 = cgp$c0(s1, s2);
          s0 = s1;
        } else {
          cgp$currPos = s0;
          s0 = cgp$FAILED;
        }
      } else {
        cgp$currPos = s0;
        s0 = cgp$FAILED;
      }

      return s0;
    }

    function cgp$parseincludeName() {
      var s0, s1, s2;

      s0 = cgp$currPos;
      if (input.substr(cgp$currPos, 6) === cgp$c1) {
        s1 = cgp$c1;
        cgp$currPos += 6;
      } else {
        s1 = cgp$FAILED;
        if (cgp$silentFails === 0) { cgp$fail(cgp$c2); }
      }
      if (s1 !== cgp$FAILED) {
        s2 = cgp$parses();
        if (s2 !== cgp$FAILED) {
          cgp$savedPos = s0;
          s1 = cgp$c3();
          s0 = s1;
        } else {
          cgp$currPos = s0;
          s0 = cgp$FAILED;
        }
      } else {
        cgp$currPos = s0;
        s0 = cgp$FAILED;
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
        s1 = cgp$c4;
        cgp$currPos++;
      } else {
        s1 = cgp$FAILED;
        if (cgp$silentFails === 0) { cgp$fail(cgp$c5); }
      }
      if (s1 !== cgp$FAILED) {
        s2 = [];
        s3 = cgp$parselistToken();
        if (s3 !== cgp$FAILED) {
          while (s3 !== cgp$FAILED) {
            s2.push(s3);
            s3 = cgp$parselistToken();
          }
        } else {
          s2 = cgp$FAILED;
        }
        if (s2 !== cgp$FAILED) {
          if (input.charCodeAt(cgp$currPos) === 41) {
            s3 = cgp$c6;
            cgp$currPos++;
          } else {
            s3 = cgp$FAILED;
            if (cgp$silentFails === 0) { cgp$fail(cgp$c7); }
          }
          if (s3 !== cgp$FAILED) {
            if (input.charCodeAt(cgp$currPos) === 42) {
              s4 = cgp$c8;
              cgp$currPos++;
            } else {
              s4 = cgp$FAILED;
              if (cgp$silentFails === 0) { cgp$fail(cgp$c9); }
            }
            if (s4 === cgp$FAILED) {
              s4 = null;
            }
            if (s4 !== cgp$FAILED) {
              s5 = cgp$parses();
              if (s5 !== cgp$FAILED) {
                cgp$savedPos = s0;
                s1 = cgp$c10(s2, s4);
                s0 = s1;
              } else {
                cgp$currPos = s0;
                s0 = cgp$FAILED;
              }
            } else {
              cgp$currPos = s0;
              s0 = cgp$FAILED;
            }
          } else {
            cgp$currPos = s0;
            s0 = cgp$FAILED;
          }
        } else {
          cgp$currPos = s0;
          s0 = cgp$FAILED;
        }
      } else {
        cgp$currPos = s0;
        s0 = cgp$FAILED;
      }

      return s0;
    }

    function cgp$parselistToken() {
      var s0, s1, s2, s3, s4, s5;

      s0 = cgp$currPos;
      s1 = [];
      s2 = cgp$parseword();
      if (s2 !== cgp$FAILED) {
        while (s2 !== cgp$FAILED) {
          s1.push(s2);
          s2 = cgp$parseword();
        }
      } else {
        s1 = cgp$FAILED;
      }
      if (s1 !== cgp$FAILED) {
        s2 = cgp$currPos;
        s3 = cgp$parses();
        if (s3 !== cgp$FAILED) {
          if (input.charCodeAt(cgp$currPos) === 47) {
            s4 = cgp$c11;
            cgp$currPos++;
          } else {
            s4 = cgp$FAILED;
            if (cgp$silentFails === 0) { cgp$fail(cgp$c12); }
          }
          if (s4 !== cgp$FAILED) {
            s5 = cgp$parses();
            if (s5 !== cgp$FAILED) {
              s3 = [s3, s4, s5];
              s2 = s3;
            } else {
              cgp$currPos = s2;
              s2 = cgp$FAILED;
            }
          } else {
            cgp$currPos = s2;
            s2 = cgp$FAILED;
          }
        } else {
          cgp$currPos = s2;
          s2 = cgp$FAILED;
        }
        if (s2 === cgp$FAILED) {
          s2 = null;
        }
        if (s2 !== cgp$FAILED) {
          cgp$savedPos = s0;
          s1 = cgp$c13(s1, s2);
          s0 = s1;
        } else {
          cgp$currPos = s0;
          s0 = cgp$FAILED;
        }
      } else {
        cgp$currPos = s0;
        s0 = cgp$FAILED;
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
        s1 = cgp$FAILED;
      }
      if (s1 !== cgp$FAILED) {
        cgp$savedPos = s0;
        s1 = cgp$c14(s1);
      }
      s0 = s1;

      return s0;
    }

    function cgp$parses() {
      var s0, s1;

      s0 = [];
      if (input.charCodeAt(cgp$currPos) === 32) {
        s1 = cgp$c15;
        cgp$currPos++;
      } else {
        s1 = cgp$FAILED;
        if (cgp$silentFails === 0) { cgp$fail(cgp$c16); }
      }
      while (s1 !== cgp$FAILED) {
        s0.push(s1);
        if (input.charCodeAt(cgp$currPos) === 32) {
          s1 = cgp$c15;
          cgp$currPos++;
        } else {
          s1 = cgp$FAILED;
          if (cgp$silentFails === 0) { cgp$fail(cgp$c16); }
        }
      }

      return s0;
    }

    function cgp$parseword() {
      var s0, s1, s2;

      s0 = cgp$currPos;
      s1 = [];
      if (cgp$c17.test(input.charAt(cgp$currPos))) {
        s2 = input.charAt(cgp$currPos);
        cgp$currPos++;
      } else {
        s2 = cgp$FAILED;
        if (cgp$silentFails === 0) { cgp$fail(cgp$c18); }
      }
      if (s2 !== cgp$FAILED) {
        while (s2 !== cgp$FAILED) {
          s1.push(s2);
          if (cgp$c17.test(input.charAt(cgp$currPos))) {
            s2 = input.charAt(cgp$currPos);
            cgp$currPos++;
          } else {
            s2 = cgp$FAILED;
            if (cgp$silentFails === 0) { cgp$fail(cgp$c18); }
          }
        }
      } else {
        s1 = cgp$FAILED;
      }
      if (s1 !== cgp$FAILED) {
        s2 = cgp$parses();
        if (s2 !== cgp$FAILED) {
          cgp$savedPos = s0;
          s1 = cgp$c19(s1);
          s0 = s1;
        } else {
          cgp$currPos = s0;
          s0 = cgp$FAILED;
        }
      } else {
        cgp$currPos = s0;
        s0 = cgp$FAILED;
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

      throw cgp$buildException(
        null,
        cgp$maxFailExpected,
        cgp$maxFailPos < input.length ? input.charAt(cgp$maxFailPos) : null,
        cgp$maxFailPos < input.length
          ? cgp$computeLocation(cgp$maxFailPos, cgp$maxFailPos + 1)
          : cgp$computeLocation(cgp$maxFailPos, cgp$maxFailPos)
      );
    }
  }

  return {
    SyntaxError: cgp$SyntaxError,
    parse:       cgp$parse
  };
})();
