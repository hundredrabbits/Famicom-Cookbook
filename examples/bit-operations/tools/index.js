console.log('\n\nsin:')

const steps = 64
const amplitude = 64
const values = []

function toHex (int) {
  return '$' + int.toString(16).padStart(2, '0')
}

function format (acc, item, key) {
  return `${acc}${item}${key !== steps - 1 ? ',' : ''}${(key + 1) % 14 === 0 ? '\n  ' : ''}`
}

for (let i = 0; i < steps; i++) {
  const value = Math.sin(2 * Math.PI * i / steps) * amplitude
  const hex = toHex(parseInt(value) + amplitude)
  values.push(hex)
}

console.log('  ' + values.reduce(format, '') + '\n\n')
