import chai from "chai"
const expect = chai.expect

// Array category modules
// castArray static tested
import chunk from "../src/chunk.js"
import compact from "../src/compact.js"
import difference from "../src/difference.js"
import drop from "../src/drop.js"
import every from "../src/every.js"
import filter from "../src/filter.js"
import map from "../src/map.js"
import reduce from "../src/reduce.js" // Note: Reduce belongs also to function category

const testArrays = {
    NUMBER: [0, 1, 2, -1, 10, 0, 40, -10, -11, 9, -10, 5],
    STRING: ["a", "5.", "c", "d", "es", "nolla", "40", "es", "asd", "sana", "es", "5."],
    MIXED: [0, false, true, NaN, "stringa", "90", Infinity],
    DIFFERENCE: [0, -10, 5, 3, 4, NaN, false, Infinity, "90", 95]
}

function runTests() {
    testfChunk()
	testfCompact()
    testfDifference()
    testfDrop()
    testfEvery()
    testfFilter()
    testfMap()
    testfReduce()
}

function testfChunk(){
    describe("chunk", ()=> {
        it("Number array: Array divided even", () => {
            expect(chunk(testArrays.NUMBER, 2)).to.eql(
                [[0, 1], [2, -1], [10, 0], [40, -10], [-11, 9], [-10, 5]]
            )
        }),
        it("String array: Array not divided even", () => {
            expect(
                chunk(testArrays.STRING, 5)).to.eql(
                [[0, 1, 2, -1, 10], [0, 40, -10, -11, 9], [-10, 5]]
            )
        }),
        it("Empty array", () => {
            expect(
                chunk([], 5)).to.eql(
                []
            )
        }),
        // Bit philosophical
        it("Chunk by zero", () => {
            expect(
                chunk(testArrays.NUMBER, 0)).to.eql(
                []
            )
        })
    })
}

function testfCompact(){
    // This behaves in a very weird way
    describe("compact", ()=> {
        it("No falsey values", () => {
            expect(compact(testArrays.STRING))
                .to.eql(
                    testArrays.STRING
                )
        }),
        it("Falsey values", () => {
            expect(compact(
                    [true, false, null, 0, "", undefined, NaN, 1, "nice"]))
                .to.eql(
                    [true, 1, "nice"]
                )
        })
    })
}

function testfDifference(){
    describe("difference", ()=> {
        it("Number array", () => {
            expect(difference(testArrays.NUMBER, testArrays.DIFFERENCE))
                .to.eql(
                    [1, 2, -1, 10, 40, -11, 9]
                )
        }),
        it("Mixed array", () => {
            expect(difference(testArrays.MIXED, testArrays.DIFFERENCE))
                .to.eql(
                    [true, "stringa"]
                )
        }),
        it("Empty inputs", () => {
            expect(difference([], []))
                .to.eql(
                    []
                )
        })
    })
}

function testfDrop(){
    describe("drop", ()=> {
        it("Drop 0", () => {
            expect(drop(testArrays.NUMBER, 0))
                .to.eql(
                    testArrays.NUMBER
                )
        }),
        it("Drop n>array.length", () => {
            expect(drop(testArrays.STRING, 20))
                .to.eql(
                    []
                )
        }),
        it("Drop 0<n<array.length", () => {
            expect(drop(testArrays.MIXED, 3))
                .to.eql(
                    [NaN, "stringa", "90", Infinity]
                )
        }),
        it("Empty input", () => {
            expect(drop([], 20))
                .to.eql(
                    []
                )
        })
    })
}

function testfEvery() {
    var predicate = (value, index, array) =>{
        return (value < 100)
    }

    describe("every", ()=> {
        it("All true", () => {
            expect(every(testArrays.NUMBER, predicate))
                .to.equal(
                    true
                )
        }),
        it("Some false", () => {
            expect(every(testArrays.DIFFERENCE, predicate))
                .to.equal(
                    false
                )
        }),
        it("Empty input", () => {
            expect(every([], predicate))
                .to.equal(
                    true
                )
        })
    })
}

function testfFilter() {
    var predicate = (value, index, array) =>{
        return (value < 80 && index < 10)
    }

    describe("filter", ()=> {
        it("All true", () => {
            expect(filter(testArrays.NUMBER, predicate))
                .to.eql(
                    [0, 1, 2, -1, 10, 0, 40, -10, -11, 9]
                )
        }),
        it("Some false", () => {
            expect(filter(testArrays.DIFFERENCE, predicate))
                .to.eql(
                    [0, -10, 5, 3, 4, false]
                )
        }),
        it("Empty input", () => {
            expect(filter([], predicate))
                .to.eql(
                    []
                )
        })
    })
}

function testfMap() {
    var iteratee = (value, index, array) =>{
        return (value + 5 + index)
    }

    describe("map", ()=> {
        it("Positive case", () => {
            expect(map(testArrays.NUMBER, iteratee))
                .to.eql(
                    [5, 7, 9, 7, 19, 10, 51, 2, 2, 23, 5, 21]
                )
        }),
        it("Empty input", () => {
            expect(map([], iteratee))
                .to.eql(
                    []
                )
        })
    })
}

function testfReduce(){
    var iteratee = (accumulator, value, index, collection) =>{
        return (accumulator + value + index)
    }

    describe("reduce", ()=> {
        it("Number input", () => {
            expect(reduce(testArrays.NUMBER, iteratee))
                .to.equal(
                    35+66   // elements+indexes
                )
        }),
        it("Empty input with initial accumulator", () => {
            expect(reduce([], iteratee, 0))
                .to.eql(
                    0
                )
		}),
		// NOTE: maybe should throw error instead of returning undefined
		it("Empty input without initial accumulator", () => {
            expect(reduce([], iteratee))
                .to.eql(
                    undefined
                )
        }),
        it("Example test case", () => {
            expect(reduce({ 'a': 1, 'b': 2, 'c': 1 }, (result, value, key) => {
                (result[value] || (result[value] = [])).push(key)
                return result
              }, {}))
                .to.eql(
                    { '1': ['a', 'c'], '2': ['b'] }
                )
        })
    })
}

runTests()