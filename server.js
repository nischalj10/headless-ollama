import ollama from 'ollama'

const response = await ollama.chat({
  model: 'llava:v1.6',
  messages: [{ role: 'user', content: 'Why is sky blue' }],
})

console.log(response.message.content)