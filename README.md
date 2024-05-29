# headless-ollama

the scripts here help you easily install [ollama](https://github.com/ollama/ollama) client on any device (mac/linux/windows).

building desktop apps that utilise local LLMs is awesome and ollama makes it wonderfully easy to do so by providing wonderful libraries in [js](https://github.com/ollama/ollama-js) and [python](https://github.com/ollama/ollama-python) to call local LLMs in OpenAI format. 

> however, the user's system needs to have ollama already installed for your desktop app to use ollama-js/ python libraires. Making users install ollama client separately isn't good UX tbh. thus, "headless-ollama"

this repo has pre-run scripts (see the "predev" command in [package.json](./package.json) that runs before `npm run dev`) which automatically utilises node runtime to check for the host OS and installs the ollama client and the models needed by your app before the server starts. 

this is really helpful while building electron apps where you want everything to be local and self contained within the system.

run the following commands to get started <br/>

```
git clone https://github.com/nischalj10/headless-ollama
npm i
npm run dev
```

it will automatically install ollama client and run the `llava:v1.6` model.

# llama.cpp support

it has come to my notice that adding llama.cpp support would be great (in some cases better than ollama from packaging pov). i would be picking this up soon as i get some free time. see [issue](https://github.com/nischalj10/headless-ollama/issues/1)
