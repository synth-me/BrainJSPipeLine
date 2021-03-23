const brain = require('/Users/murie/node_modules/brain.js/dist/brain')
const javascript_binding = require('/Users/murie/OneDrive/Área de Trabalho/Conatus/bindings/javascript_binding.js')
const fs = require('fs')

function test(arg){
  const net = new brain.recurrent.RNN();
  net.fromJSON(JSON.parse(fs.readFileSync('models/model.json',enconding='utf-8')))
  console.log("for input [2,21,43] -> ",net.run([2,21,43]))
};

var y = setInterval(function(){
  javascript_binding.passInfo('plugs/plugBoard.json',["speaker2","speaker1"],"1","bejkpqrstw",test)
},4000)
