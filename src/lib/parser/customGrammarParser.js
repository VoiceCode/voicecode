module.exports = (function() {
  "use strict";
  function cg$subclass(child, parent) {
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
  }

  function cg$SyntaxError(message, expected, found, location) {
    this.message  = message;
    this.expected = expected;
    this.found    = found;
    this.location = location;
    this.name     = "SyntaxError";

    if (typeof Error.captureStackTrace === "function") {
      Error.captureStackTrace(this, cg$SyntaxError);
    }
  }

  cg$subclass(cg$SyntaxError, Error);

  function cg$parse(input) {
    var options = arguments.length > 1 ? arguments[1] : {},
        parser  = this,

        cg$FAILED = {},

        cg$startRuleFunctions = { start: cg$parsestart },
        cg$startRuleFunction  = cg$parsestart,

        cg$c0 = function(includeName, tokens) {return {includeName: includeName, tokens: tokens};},
        cg$c1 = "<spoken>",
        cg$c2 = { type: "literal", value: "<spoken>", description: "\"<spoken>\"" },
        cg$c3 = function() {return true;},
        cg$c4 = "(",
        cg$c5 = { type: "literal", value: "(", description: "\"(\"" },
        cg$c6 = ")",
        cg$c7 = { type: "literal", value: ")", description: "\")\"" },
        cg$c8 = "*",
        cg$c9 = { type: "literal", value: "*", description: "\"*\"" },
        cg$c10 = function(listTokens, optional) {return {name: listTokens.join('').replace(/ /g, ''), list: listTokens, optional: !!optional};},
        cg$c11 = "/",
        cg$c12 = { type: "literal", value: "/", description: "\"/\"" },
        cg$c13 = function(name, separator) {return name.join(' ')},
        cg$c14 = function(words) {return {text: words.join(' ')};},
        cg$c15 = " ",
        cg$c16 = { type: "literal", value: " ", description: "\" \"" },
        cg$c17 = /^[a-z]/i,
        cg$c18 = { type: "class", value: "[a-z]i", description: "[a-z]i" },
        cg$c19 = function(letters) {return letters.join('');},

        cg$currPos          = 0,
        cg$savedPos         = 0,
        cg$posDetailsCache  = [{ line: 1, column: 1, seenCR: false }],
        cg$maxFailPos       = 0,
        cg$maxFailExpected  = [],
        cg$silentFails      = 0,

        cg$result;

    if ("startRule" in options) {
      if (!(options.startRule in cg$startRuleFunctions)) {
        throw new Error("Can't start parsing from rule \"" + options.startRule + "\".");
      }

      cg$startRuleFunction = cg$startRuleFunctions[options.startRule];
    }

    function text() {
      return input.substring(cg$savedPos, cg$currPos);
    }

    function location() {
      return cg$computeLocation(cg$savedPos, cg$currPos);
    }

    function expected(description) {
      throw cg$buildException(
        null,
        [{ type: "other", description: description }],
        input.substring(cg$savedPos, cg$currPos),
        cg$computeLocation(cg$savedPos, cg$currPos)
      );
    }

    function error(message) {
      throw cg$buildException(
        message,
        null,
        input.substring(cg$savedPos, cg$currPos),
        cg$computeLocation(cg$savedPos, cg$currPos)
      );
    }

    function cg$computePosDetails(pos) {
      var details = cg$posDetailsCache[pos],
          p, ch;

      if (details) {
        return details;
      } else {
        p = pos - 1;
        while (!cg$posDetailsCache[p]) {
          p--;
        }

        details = cg$posDetailsCache[p];
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

        cg$posDetailsCache[pos] = details;
        return details;
      }
    }

    function cg$computeLocation(startPos, endPos) {
      var startPosDetails = cg$computePosDetails(startPos),
          endPosDetails   = cg$computePosDetails(endPos);

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

    function cg$fail(expected) {
      if (cg$currPos < cg$maxFailPos) { return; }

      if (cg$currPos > cg$maxFailPos) {
        cg$maxFailPos = cg$currPos;
        cg$maxFailExpected = [];
      }

      cg$maxFailExpected.push(expected);
    }

    function cg$buildException(message, expected, found, location) {
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

      return new cg$SyntaxError(
        message !== null ? message : buildMessage(expected, found),
        expected,
        found,
        location
      );
    }

    function cg$parsestart() {
      var s0, s1, s2, s3;

      s0 = cg$currPos;
      s1 = cg$parseincludeName();
      if (s1 === cg$FAILED) {
        s1 = null;
      }
      if (s1 !== cg$FAILED) {
        s2 = [];
        s3 = cg$parsetoken();
        if (s3 !== cg$FAILED) {
          while (s3 !== cg$FAILED) {
            s2.push(s3);
            s3 = cg$parsetoken();
          }
        } else {
          s2 = cg$FAILED;
        }
        if (s2 !== cg$FAILED) {
          cg$savedPos = s0;
          s1 = cg$c0(s1, s2);
          s0 = s1;
        } else {
          cg$currPos = s0;
          s0 = cg$FAILED;
        }
      } else {
        cg$currPos = s0;
        s0 = cg$FAILED;
      }

      return s0;
    }

    function cg$parseincludeName() {
      var s0, s1, s2;

      s0 = cg$currPos;
      if (input.substr(cg$currPos, 8) === cg$c1) {
        s1 = cg$c1;
        cg$currPos += 8;
      } else {
        s1 = cg$FAILED;
        if (cg$silentFails === 0) { cg$fail(cg$c2); }
      }
      if (s1 !== cg$FAILED) {
        s2 = cg$parses();
        if (s2 !== cg$FAILED) {
          cg$savedPos = s0;
          s1 = cg$c3();
          s0 = s1;
        } else {
          cg$currPos = s0;
          s0 = cg$FAILED;
        }
      } else {
        cg$currPos = s0;
        s0 = cg$FAILED;
      }

      return s0;
    }

    function cg$parsetoken() {
      var s0;

      s0 = cg$parselist();
      if (s0 === cg$FAILED) {
        s0 = cg$parsetext();
      }

      return s0;
    }

    function cg$parselist() {
      var s0, s1, s2, s3, s4, s5;

      s0 = cg$currPos;
      if (input.charCodeAt(cg$currPos) === 40) {
        s1 = cg$c4;
        cg$currPos++;
      } else {
        s1 = cg$FAILED;
        if (cg$silentFails === 0) { cg$fail(cg$c5); }
      }
      if (s1 !== cg$FAILED) {
        s2 = [];
        s3 = cg$parselistToken();
        if (s3 !== cg$FAILED) {
          while (s3 !== cg$FAILED) {
            s2.push(s3);
            s3 = cg$parselistToken();
          }
        } else {
          s2 = cg$FAILED;
        }
        if (s2 !== cg$FAILED) {
          if (input.charCodeAt(cg$currPos) === 41) {
            s3 = cg$c6;
            cg$currPos++;
          } else {
            s3 = cg$FAILED;
            if (cg$silentFails === 0) { cg$fail(cg$c7); }
          }
          if (s3 !== cg$FAILED) {
            if (input.charCodeAt(cg$currPos) === 42) {
              s4 = cg$c8;
              cg$currPos++;
            } else {
              s4 = cg$FAILED;
              if (cg$silentFails === 0) { cg$fail(cg$c9); }
            }
            if (s4 === cg$FAILED) {
              s4 = null;
            }
            if (s4 !== cg$FAILED) {
              s5 = cg$parses();
              if (s5 !== cg$FAILED) {
                cg$savedPos = s0;
                s1 = cg$c10(s2, s4);
                s0 = s1;
              } else {
                cg$currPos = s0;
                s0 = cg$FAILED;
              }
            } else {
              cg$currPos = s0;
              s0 = cg$FAILED;
            }
          } else {
            cg$currPos = s0;
            s0 = cg$FAILED;
          }
        } else {
          cg$currPos = s0;
          s0 = cg$FAILED;
        }
      } else {
        cg$currPos = s0;
        s0 = cg$FAILED;
      }

      return s0;
    }

    function cg$parselistToken() {
      var s0, s1, s2, s3, s4, s5;

      s0 = cg$currPos;
      s1 = [];
      s2 = cg$parseword();
      if (s2 !== cg$FAILED) {
        while (s2 !== cg$FAILED) {
          s1.push(s2);
          s2 = cg$parseword();
        }
      } else {
        s1 = cg$FAILED;
      }
      if (s1 !== cg$FAILED) {
        s2 = cg$currPos;
        s3 = cg$parses();
        if (s3 !== cg$FAILED) {
          if (input.charCodeAt(cg$currPos) === 47) {
            s4 = cg$c11;
            cg$currPos++;
          } else {
            s4 = cg$FAILED;
            if (cg$silentFails === 0) { cg$fail(cg$c12); }
          }
          if (s4 !== cg$FAILED) {
            s5 = cg$parses();
            if (s5 !== cg$FAILED) {
              s3 = [s3, s4, s5];
              s2 = s3;
            } else {
              cg$currPos = s2;
              s2 = cg$FAILED;
            }
          } else {
            cg$currPos = s2;
            s2 = cg$FAILED;
          }
        } else {
          cg$currPos = s2;
          s2 = cg$FAILED;
        }
        if (s2 === cg$FAILED) {
          s2 = null;
        }
        if (s2 !== cg$FAILED) {
          cg$savedPos = s0;
          s1 = cg$c13(s1, s2);
          s0 = s1;
        } else {
          cg$currPos = s0;
          s0 = cg$FAILED;
        }
      } else {
        cg$currPos = s0;
        s0 = cg$FAILED;
      }

      return s0;
    }

    function cg$parsetext() {
      var s0, s1, s2;

      s0 = cg$currPos;
      s1 = [];
      s2 = cg$parseword();
      if (s2 !== cg$FAILED) {
        while (s2 !== cg$FAILED) {
          s1.push(s2);
          s2 = cg$parseword();
        }
      } else {
        s1 = cg$FAILED;
      }
      if (s1 !== cg$FAILED) {
        cg$savedPos = s0;
        s1 = cg$c14(s1);
      }
      s0 = s1;

      return s0;
    }

    function cg$parses() {
      var s0, s1;

      s0 = [];
      if (input.charCodeAt(cg$currPos) === 32) {
        s1 = cg$c15;
        cg$currPos++;
      } else {
        s1 = cg$FAILED;
        if (cg$silentFails === 0) { cg$fail(cg$c16); }
      }
      while (s1 !== cg$FAILED) {
        s0.push(s1);
        if (input.charCodeAt(cg$currPos) === 32) {
          s1 = cg$c15;
          cg$currPos++;
        } else {
          s1 = cg$FAILED;
          if (cg$silentFails === 0) { cg$fail(cg$c16); }
        }
      }

      return s0;
    }

    function cg$parseword() {
      var s0, s1, s2;

      s0 = cg$currPos;
      s1 = [];
      if (cg$c17.test(input.charAt(cg$currPos))) {
        s2 = input.charAt(cg$currPos);
        cg$currPos++;
      } else {
        s2 = cg$FAILED;
        if (cg$silentFails === 0) { cg$fail(cg$c18); }
      }
      if (s2 !== cg$FAILED) {
        while (s2 !== cg$FAILED) {
          s1.push(s2);
          if (cg$c17.test(input.charAt(cg$currPos))) {
            s2 = input.charAt(cg$currPos);
            cg$currPos++;
          } else {
            s2 = cg$FAILED;
            if (cg$silentFails === 0) { cg$fail(cg$c18); }
          }
        }
      } else {
        s1 = cg$FAILED;
      }
      if (s1 !== cg$FAILED) {
        s2 = cg$parses();
        if (s2 !== cg$FAILED) {
          cg$savedPos = s0;
          s1 = cg$c19(s1);
          s0 = s1;
        } else {
          cg$currPos = s0;
          s0 = cg$FAILED;
        }
      } else {
        cg$currPos = s0;
        s0 = cg$FAILED;
      }

      return s0;
    }

    cg$result = cg$startRuleFunction();

    if (cg$result !== cg$FAILED && cg$currPos === input.length) {
      return cg$result;
    } else {
      if (cg$result !== cg$FAILED && cg$currPos < input.length) {
        cg$fail({ type: "end", description: "end of input" });
      }

      throw cg$buildException(
        null,
        cg$maxFailExpected,
        cg$maxFailPos < input.length ? input.charAt(cg$maxFailPos) : null,
        cg$maxFailPos < input.length
          ? cg$computeLocation(cg$maxFailPos, cg$maxFailPos + 1)
          : cg$computeLocation(cg$maxFailPos, cg$maxFailPos)
      );
    }
  }

  return {
    SyntaxError: cg$SyntaxError,
    parse:       cg$parse
  };
})();
