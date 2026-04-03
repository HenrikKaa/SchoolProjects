import chai from "chai"
const expect = chai.expect

// object category modules
import at from "../src/at.js"
import countBy from "../src/countBy.js"
import get from "../src/get.js"
import keys from "../src/keys.js"

const testObjects = {
    OBJECT: {
		'a': [
			{'e': 2},
			{'f': 3},
			{'g': 4}
		],
		'b': 5,
		'c': 6,
		'd': 7,
	},
	LIST: [
		{'name': 'cat', 'animal': true},
		{'name': 'table', 'animal': false},
		{'name': 'dog', 'animal': true},
		{'name': 'shoe', 'animal': false},
		{'name': 'pc', 'animal': false}
	]
}

// This is for keys
function testfunc(){
	this.first = 2
	this.second = 3
}

function runTests() {
	testfAt()
	testfCountBy()
	testfGet()
	testfKeys()
}

function testfAt(){
	describe("at", ()=> {
        it("Pick multiple values", () => {
            expect(at(testObjects.OBJECT, ['a[0].e', 'a[1]', 'b', 'c']))
                .to.eql(
                    [2, {'f': 3}, 5, 6]
                )
		}),
		// NOTE: maybe should throw error instead of returning undefined
		it("Incorrect path", () => {
            expect(at(testObjects.OBJECT, ['a[0].h', 'a[2].g']))
                .to.eql(
                    [undefined, 4]
                )
		}),
		it("Empty input object and paths", () => {
            expect(at({}, []))
                .to.eql(
                    []
                )
        })
    })
}

function testfCountBy(){
	var testarray = [0, 1, 2, 2, 1, 2, 10]

    describe("countBy", ()=> {
        it("Array of objects", () => {
            expect(countBy(testObjects.LIST, value => value.animal))
                .to.eql(
                    { 'true': 2, 'false': 3 }
                )
		}),
		it("Example test case", () => {
			expect(countBy([{ 'user': 'barney', 'active': true },
							{ 'user': 'betty', 'active': true },
							{ 'user': 'fred', 'active': false }], 
							value => value.active))
                .to.eql(
                    { 'true': 2, 'false': 1 }
                )
		}),
		it("Array input", () => {
            expect(countBy(testarray, value => value))
                .to.eql(
                    { 0: 1, 1: 2, 2: 3, 10: 1}
                )
		}),
		it("Empty array", () => {
            expect(countBy([], value => value.animal))
                .to.eql(
                    {}
                )
        })
    })
}

function testfGet(){
	describe("get", ()=> {
        it("Positive case, shallow", () => {
            expect(at(testObjects.OBJECT, 'b'))
                .to.equal(
                    5
                )
		}),
		it("Positive case, deep", () => {
            expect(get(testObjects.OBJECT, ['a', 0, 'e']))
                .to.equal(
                    2
                )
		}),
		it("Incorrect path", () => {
            expect(get(testObjects.OBJECT, 'a[0].h', "this is default value"))
                .to.equal(
                    "this is default value"
                )
		}),
		it("Empty input object and path", () => {
            expect(get({}, ''))
                .to.equal(
                    undefined
                )
        })
    })
}

function testfKeys(){
	describe("keys", ()=> {
        it("Object input", () => {
            expect(keys(testObjects.OBJECT))
                .to.eql(
                    ['a', 'b', 'c', 'd']
                )
		}),
		it("Function input", () => {
            expect(keys(new testfunc))
                .to.eql(
                    ["first", "second"]
                )
		}),
		it("String input", () => {
            expect(keys("test"))
                .to.eql(
                    ['0', '1', '2', '3']
                )
		}),
		it("Array input", () => {
            expect(keys([5,6,7]))
                .to.eql(
                    ['0', '1', '2']
                )
		}),
		it("Empty input", () => {
            expect(keys({}))
                .to.eql(
                    []
                )
		})
    })
}

runTests()