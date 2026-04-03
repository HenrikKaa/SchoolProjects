import chai from "chai"
const expect = chai.expect

// Conversion category modules
import toFinite from "../src/toFinite.js"
import toInteger from "../src/toInteger.js"
import toNumber from "../src/toNumber.js"
import toString from "../src/toString.js"

// Reference constants
const MAX_INTEGER = 1.7976931348623157e+308
const zero = 0

const test = {
    NUMBER: "Convert a basic number",
    STRING: "Convert a string",
    LIMIT: "Convert limit values",
    NAN: "Convert NaN and null values"
}

const modules = {
    FINITE: {
        DESCRIPTION: "toFinite",
        func: toFinite,
        MODEL: new Map([
            [test.NUMBER, [9, 200] ],
            [test.STRING, ["3.2", "0", " 7.5 ", " 5"] ],
            [test.LIMIT, [Infinity, -Infinity, 0] ],
            [test.NAN, [null, NaN] ]
        ]),
        EXPECTED: new Map([
            [test.NUMBER, [9, 200] ],
            [test.STRING, [3.2, zero, 7.5, 5] ],
            [test.LIMIT, [MAX_INTEGER, -MAX_INTEGER, zero] ],
            [test.NAN, [zero, zero] ]
        ])
    }, 
    INTEGER: {
        DESCRIPTION: "toInteger",
        func: toInteger,
        MODEL: new Map([
            [test.NUMBER, [9, 200] ],
            [test.STRING, ["3.2", "0"] ],
            [test.LIMIT, [Infinity, -Infinity, 0] ],
            [test.NAN, [null, NaN] ]
        ]),
        EXPECTED: new Map([
            [test.NUMBER, [9, 200] ],
            [test.STRING, [3, zero] ],
            [test.LIMIT, [MAX_INTEGER, -MAX_INTEGER, zero] ],
            [test.NAN, [zero, zero] ]
        ])
    }, 
    NUMBER: {
        DESCRIPTION: "toNumber",
        func: toNumber,
        MODEL: new Map([
            [test.NUMBER, [9, 200] ],
            [test.STRING, ["3.2", "0", " 70 "] ],
            [test.LIMIT, [Infinity, -Infinity, 0, -0] ],
            [test.NAN, [null] ] // NaN removed for equality reasons
        ]),
        EXPECTED: new Map([
            [test.NUMBER, [9, 200] ],
            [test.STRING, [3.2, zero, 70] ],
            [test.LIMIT, [Infinity, -Infinity, zero, zero] ],
            [test.NAN, [zero] ]
        ])
    }, 
    STRING: {
        DESCRIPTION: "toString",
        func: toString,
        MODEL: new Map([
            [test.NUMBER, [9, 200] ],
            [test.STRING, ["3.2", "0", [6,5,4], [9, 5, 4] ] ],
            [test.LIMIT, [Infinity, -Infinity, -0]],
            [test.NAN, [null, NaN] ]
        ]),
        EXPECTED: new Map([
            [test.NUMBER, ["9", "200"] ],
            [test.STRING, ["3.2", "0", "6,5,4", "9,5,4"] ],
            [test.LIMIT, ["Infinity", "-Infinity", "-0"]],
            [test.NAN, ["", "NaN"] ]
        ])
    }
};

const testProcess = [modules.FINITE,
                     modules.INTEGER,
                     modules.NUMBER,
                     modules.STRING
                    ]

// Execute test
function runTests() {

    for (let i in testProcess) {
        let module = testProcess[i]
        describe(module.DESCRIPTION, ()=> {

            for (let testCase of module.MODEL.keys()) {    
                it(testCase, () => {
                    let currentDataArray = module.MODEL.get(testCase)
                    let expectedData = module.EXPECTED.get(testCase)
                    let dataLength = currentDataArray.length

                    for (let pos = 0; pos < dataLength; pos++ ) {
                        expect(module.func(currentDataArray[pos])).to.equal(expectedData[pos])
                    }
                })
            }
        })
    }
}
runTests()