import chai from "chai"
const expect = chai.expect

// Function category modules. Reduce is exluced from function
import memoize from "../src/memoize.js"

// Test related data
const test = {
    DESCRIPTION: "Memoize",
    BASIC: "Module's own examples",
    OTHER: "Change memoized data",
    THROW: "Pass a non-func parameter",
    THROW_RES: "Pass a non-func resolver"
}

// Return object values. For memoize
function testFunction(object) {
    return Object.values(object)
}

// Test suite as basic mocha and chai since only one module
describe(test.DESCRIPTION, ()=> {
    const object = { 'a': 1, 'b': 2 }
    const other = { 'c': 3, 'd': 4 }

    it(test.BASIC, ()=> {
        const test = memoize(testFunction)
        expect( test(object) ).to.deep.equal([1, 2])
        expect( test(other) ).to.deep.equal([3, 4])
    })

    it(test.OTHER, ()=> {
        const test = memoize(testFunction)
        expect( test(object) ).to.deep.equal([1, 2]) 
        object.a = 5 // Change shouldn't affect memoize since it's cached

        expect( test(object) ).to.deep.equal([1, 2])
        object.a = 2 // change back to normal

        test.cache.set(object, [3, 4]) // changing cache should affect
        expect( test(object) ).to.deep.equal([3, 4])
    })

    it(test.THROW, ()=> {
        expect( () =>  memoize("testString") ).to.throw(TypeError)
        expect( () => memoize(null) ).to.throw(TypeError)
        expect( () => memoize(Infinity) ).to.throw(TypeError)
        expect( () => memoize(NaN) ).to.throw(TypeError)
        expect( () => memoize(5) ).to.throw(TypeError)
    })

    it (test.THROW_RES, ()=> {
        const test = memoize(testFunction)
        expect( () =>  memoize(test(object), null) ).to.throw(TypeError)
        expect( () =>  memoize(test(object), Infinity) ).to.throw(TypeError)
        expect( () =>  memoize(test(object), "testString") ).to.throw(TypeError)
        expect( () =>  memoize(test(object), 2) ).to.throw(TypeError)
    })

})