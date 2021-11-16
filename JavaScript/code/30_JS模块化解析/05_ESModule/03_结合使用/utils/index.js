// 1.导出方式一:
// import { add, sub } from './math.js'
// import { timeFormat, priceFormat } from './format.js'

// export {
//   add,
//   sub,
//   timeFormat,
//   priceFormat
// }

// 2.导出方式二:
// export { add, sub } from './math.js'
// export { timeFormat, priceFormat } from './format.js'

// 3.导出方式三:
export * from './math.js'
export * from './format.js'
