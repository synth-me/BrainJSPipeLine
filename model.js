const brain = require('/Users/murie/node_modules/brain.js/dist/brain')
const javascript_binding = require('/Users/murie/OneDrive/Área de Trabalho/Conatus/bindings/javascript_binding.js')
const fs = require('fs')

const net = new brain.recurrent.RNN();

function openErno(error) {
  var j = {"error":error}
  console.log(j['error'])
  fs.writeFile('plugs/error.json',JSON.stringify(j),function(err,data){
    if(err) console.log("not able to save the model");
  });
};

function executing(pipeline,save=true) {
  var data = [pipeline];
  net.train(data,{
    callback: data => openErno(data.error),
    iterations:500
  });
  if(save){
    var jnet = net.toJSON();
    fs.writeFile("models/model.json",JSON.stringify(jnet),function(err,data){
      if(err) console.log("not able to save the model");
    });
  };
  return "training...";
};

function* disk() {
  var index = 0;
  while (true) {
    let value = yield null ;
    console.log(executing(value),": ",value);
  };
};

var g = disk()

var y = setInterval(function(){
  javascript_binding.passInfo('plugs/plugBoard.json',["speaker0","speaker2"],"1","bejkpqrstw",g,true)
},3000)
