define(function(require, exports, module) {
  const name = "why"
  const age = 18
  function sum(num1, num2) {
    return num1 + num2
  }

  // exports.name = name
  // exports.age = age

  module.exports = {
    name,
    age,
    sum
  }
});