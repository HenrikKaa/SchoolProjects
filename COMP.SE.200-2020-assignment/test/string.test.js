import chai from "chai"
const expect = chai.expect

// String category modules
import capitalize from "../src/capitalize.js"
import camelCase from "../src/camelCase.js"
import endsWith from "../src/endsWith.js"
import upperFirst from "../src/upperFirst.js"
import words from "../src/words.js"

// The test cases
const tests = {
    NAN: "NaN and null values",
    BASIC: "A basic string",
    BLANK: "A white-spaced string",
    NON_ALPH: "A non-alphabet first letter string",

    CAMEL: {
        CHAR: "A string with different kind of characters on it"
    },
    ENDS: {
        BASIC: "A basic string ending with",
        MIDDLE: "A basic string ending with on some position"
    },
    WORDS: {
        BASIC: "Module's own example",
        REGEX_AS_STRING: "Regex parameter given as a string",
        REGEX: "Valid regex"
    }
}

// Test modules and their data
const modules = {

    CAPITALIZE: {
        DESCRIPTION: "Capitalize",
        BASIC: "Convert a basic string", 
        func: capitalize,
        MODEL: new Map([
            [tests.BASIC, ["string","NIRVA"] ],
            [tests.BLANK, [" string", "  sTRas"]],
            [tests.NON_ALPH, ["8string", "?divergence"] ],
            [tests.NAN, [null, NaN, Infinity] ]
        ]),
        EXPECTED: new Map([
            [tests.BASIC, ["String", "Nirva"] ],
            [tests.BLANK, ["String", "Stras"] ],
            [tests.NON_ALPH, ["8string", "?divergence"] ],
            [tests.NAN, ["Null", "Nan", "Infinity"]]
        ])
    },
    CAMEL: {
        DESCRIPTION: "CamelCase",
        func: camelCase,
        MODEL: new Map([
            [tests.BASIC, ["string","NIRVA"] ],
            [tests.BLANK, [" stringComes", "  sTRas dink"]],
            [tests.NON_ALPH, ["8string", "?divergence"] ],
            [tests.CAMEL.CHAR, ["__FOO_BAR__", "?foo?foo", "*fir*ma"]],
            [tests.NAN, [null, NaN, Infinity] ]
        ]),
        EXPECTED: new Map([
            [tests.BASIC, ["string","nirva"] ],
            [tests.BLANK, ["stringComes", "strasDink"]],
            [tests.NON_ALPH, ["8string", "?divergence"] ],
            [tests.CAMEL.CHAR, ["fooBar", "fooFoo", "firMa"]],
            [tests.NAN, ["null", "Nan", "Infinity"] ]
        ])
    },
    ENDS: {
        DESCRIPTION: "EndsWith",
        func: endsWith,
        MODEL: new Map([
            [tests.ENDS.BASIC, [["Nirva", "a"], ["String?", "?"], ["apina", "p"] ]],
            [tests.ENDS.MIDDLE, [["Nirva", "r", 3] ], ["**dkasmkdmsakl**", "*", 4] ],
            [tests.NAN, [[Infinity, "a"], , [null, "b"], [NaN, "b"], [NaN, "N", 3] ] ]
        ]),
        EXPECTED: new Map([
            [tests.ENDS.BASIC, [true, true, false]],
            [tests.ENDS.MIDDLE, [true, false] ],
            [tests.NAN, [false, false, false] ]
        ])
    },
    UPPER: {
        DESCRIPTION: "UpperFirst",
        func: upperFirst,
        MODEL: new Map([
            [tests.BASIC, ["string","NIRVA"] ],
            [tests.BLANK, [" stringComes", "  sTRas dink"]],
            [tests.NON_ALPH, ["8string", "?divergence"] ],
        ]),
        EXPECTED: new Map([
            [tests.BASIC, ["String","NIRVA"] ],
            [tests.BLANK, ["StringComes", "STRas dink"]],
            [tests.NON_ALPH, ["8string", "?divergence"] ],
        ])
    },
    WORDS: {
        DESCRIPTION: "Words",
        func: words,
        MODEL: new Map([
            [tests.WORDS.BASIC, ["fred, barney, & pebbles", ["fred, barney, & pebbles", /[^, ]+/g] ]],
            [tests.WORDS.REGEX_AS_STRING, [["fred, barney, & pebbles", "/[^, ]+/g"] ]],
            [tests.WORDS.REGEX, [ ["//my//string//to//be//found", /[^, //]+/g ] ] ]
        ]),
        EXPECTED: new Map([
            [tests.WORDS.BASIC, [ ['fred', 'barney', 'pebbles'], ['fred', 'barney', '&', 'pebbles'] ]],
            [tests.WORDS.REGEX_AS_STRING, [ ['fred', 'barney', '&', 'pebbles'] ] ],
            [tests.WORDS.REGEX, [ ["my", "string", "to",  "be",  "found"] ] ]
        ])
    }
}

// Test order when executed
const testProcess = [modules.CAPITALIZE,
                     modules.CAMEL,
                     modules.ENDS,
                     modules.UPPER,
                     modules.WORDS
                    ]

// Execute tests
function runTests() {

    for (let i in testProcess) {
        let module = testProcess[i]
        
        describe(module.DESCRIPTION, ()=> {
            // Define tests
            for (let testCase of module.MODEL.keys() ) {
                it(testCase, () => {
                    let currentDataArray = module.MODEL.get(testCase)
                    let expectedData = module.EXPECTED.get(testCase)
                    let dataLength = currentDataArray.length

                    for (let pos = 0; pos < dataLength; pos++ ) {

                        if (currentDataArray[pos].length == 3) {
                            let param1 = currentDataArray[pos][0]
                            let param2 = currentDataArray[pos][1]
                            let param3 = currentDataArray[pos][2]
                                
                            expect(module.func(param1, param2, param3)).to.equal(
                                expectedData[pos]
                            )

                        } else if (currentDataArray[pos].length == 2) {
                            let param1 = currentDataArray[pos][0]
                            let param2 = currentDataArray[pos][1]
                            
                            if (module == modules.WORDS) {
                                // Required the deep equal since JS arrays are objects
                                expect(module.func(param1, param2)).to.deep.equal(
                                    expectedData[pos])
                            } else {
                                expect(module.func(param1, param2)).to.equal(
                                    expectedData[pos])
                            }
                        } else {
                            if (module == modules.WORDS) {
                                // Required the deep equal since JS arrays are objects
                                expect(module.func(currentDataArray[pos])).to.deep.equal(
                                    expectedData[pos])
                            } else {
                                expect(module.func(currentDataArray[pos])).to.equal(
                                    expectedData[pos])
                            }
                        }
                    }
                })
            }
        })
    }
} 

runTests()