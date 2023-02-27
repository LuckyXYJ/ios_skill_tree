require.config({
  baseUrl: '',
  paths: {
    foo: "./src/foo",
    bar: "./src/bar"
  }
})

require(["foo", "bar"], function(foo) {
  console.log("main:", foo)
})
