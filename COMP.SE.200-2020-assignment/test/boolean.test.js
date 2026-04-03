import chai from "chai"
const expect = chai.expect

// Boolean category modules
import add from "../src/add.js"
import eq from "../src/eq.js"
import isArgument from "../src/isArguments.js"
import isArrayLike from "../src/isArrayLike.js"
import isArrayLikeObject from "../src/isArrayLikeObject.js"
import isBoolean from "../src/isBoolean.js"
import isBuffer from "../src/isBuffer.js"
import isDate from "../src/isDate.js"
import isEmpty from "../src/isEmpty.js"
import isLength from "../src/isLength.js"
import isObject from "../src/isObject.js"
import isObjectLike from "../src/isObjectLike.js"
import isSymbol from "../src/isSymbol.js"
import isTypedArray from "../src/isTypedArray.js"

const modules = {
    functions: [
		{ func: isArgument, name: "isArgument" },
		{ func: isArrayLike, name: "isArrayLike"},
		{ func: isArrayLikeObject, name: "isArrayLikeObject"},
		{ func: isBoolean, name: "isBoolean"},
		{ func: isBuffer, name: "isBuffer"},
		{ func: isDate, name: "isDate"},
		{ func: isEmpty, name: "isEmpty"},
		{ func: isLength, name: "isLength"},
		{ func: isObject, name: "isObject"},
		{ func: isObjectLike, name: "isObjectLike"},
		{ func: isSymbol, name: "isSymbol"},
		{ func: isTypedArray, name: "isTypedArray"}
    ],
    params: [
		{ parameter: function() { return arguments}(), description: "Function arguments"},
		{ parameter: [-1, 0, 1], description: "Numeric array"},
		{ parameter: "abc", description: "String"},
		{ parameter: true, description: "True"},
		{ parameter: false, description: "False"},
		{ parameter: new Buffer(8), description: "Buffer(8)"},
		{ parameter: new Date, description: "New Date"},
		{ parameter: "11/9/2001", description: "Datelike string 11/9/2001"},
		{ parameter: null, description: "Null"},
		{ parameter: 1, description: "Numeric 1"},
		{ parameter: {"key": "value"}, description: "Basic object with one key and value"},
		{ parameter: Number.MAX_VALUE, description: "Number.MAX_VALUE"},
		{ parameter: Infinity, description: "Infinity"},
		{ parameter: "4", description: "String 4"},
		{ parameter: {}, description: "Empty object"},
		{ parameter: add, description: "Function"},
		{ parameter: Symbol.iterator, description: "Symbol"},
		{ parameter: new Float32Array, description: "Empty float array"},
		{ parameter: [], description: "Empty typeless array"}
	],
	results: [
		[true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false],
		[true,true,true,false,false,true,false,true,false,false,false,false,false,true,false,false,false,true,true],
		[true,true,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,true,true],
		[false,false,false,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false],
		[false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false],
		[false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false],
		[true,false,false,true,true,false,true,false,true,true,false,true,true,false,true,true,true,true,true],
		[false,false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false],
		[true,true,false,false,false,true,true,false,false,false,true,false,false,false,true,true,false,true,true],
		[true,true,false,false,false,true,true,false,false,false,true,false,false,false,true,false,false,true,true],
		[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false],
		[false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false]
	]
}

function runTests() {
	for(let f=0; f<modules.functions.length; f++){
		let testedfunc = modules.functions[f]

		describe(testedfunc.name, ()=> {

			for (let p=0; p<modules.params.length; p++) {   
				let testedparam = modules.params[p]
				let result = modules.results[f][p]

				it(testedparam.description + ", expected to be " + result, () => {
					expect(testedfunc.func(testedparam.parameter)).to.equal(result)
				})
			}
		})
	}
}

//console.log(modules.results[0][0])
runTests()