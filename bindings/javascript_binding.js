const fs = require('fs')

function passInfo(file,current_speaker,port,key,callback,generator=false) {
  let rawdata = fs.readFileSync(file);
  let plugBoard = JSON.parse(rawdata);
  var found = plugBoard[port][0][key];
  var round = plugBoard[port][0]["round"];

  var speaker = current_speaker[0];
  var the_other = current_speaker[1];

  if(round==speaker){
    if(generator==true){
      callback.next(found);
    }else{
      callback(found);
    };
    plugBoard[port][0]["round"] = the_other;
    let plugBoardString = JSON.stringify(plugBoard, null, 4);
    fs.writeFile(file,plugBoardString,function(err,data){
      if(err) console.log("oops! smth went wrong...");
    });
  };
};

function modifyInfo(file,current_speaker,port,key,ndata) {
  let rawdata = fs.readFileSync(file);
  let plugBoard = JSON.parse(rawdata);
  var round = plugBoard[port][0]["round"];

  var speaker = current_speaker[0];
  var the_other = current_speaker[1];

  if(round==speaker){
    plugBoard[port][0][key] = ndata;
    plugBoard[port][0]["round"] = the_other;
    let plugBoardString = JSON.stringify(plugBoard, null, 4);
    fs.writeFile(file,plugBoardString,function(err,data){
      if(err) console.log("damn it");
    });
    console.log("new string: ",ndata);
  };
};


module.exports = {
  passInfo:passInfo,
  modifyInfo:modifyInfo
}
