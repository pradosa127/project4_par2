import {Socket, LongPoller} from "phoenix"

class App {

  static init(){
    var nUsers=2
    // this is the mainsocket which acts as the simulator
    // let Miansocket = new Socket("/socket", {
    //   logger: ((kind, msg, data) => { console.log(`${kind}: ${msg}`, data) })
    // })
    // Miansocket.connect({user: "simulator"})
    // var  Mainchannel = Miansocket.channel("rooms:lobby", {nUsers: nUsers})
    // Mainchannel.join().receive("ignore", () => console.log("auth error"))
    // .receive("ok", () => console.log("join ok"))
    // .after(10000, () => console.log("Connection interruption"))
    // Mainchannel.push("msg:zipf", {msg:"hi"})
    // Mainchannel.send(":zipf")
    // socket1
    var socketArr = []
    var chan = []
    var $status    = $("#status")
    var $messages  = $("#messages")
    
    for(var i=0;i<nUsers;i++){
      let socket = new Socket("/socket", {
        logger: ((kind, msg, data) => { console.log(`${kind}: ${msg}`, data) })
      })
      socketArr.push(socket)
      // console.log(socket)
      // console.log(socketArr[0])
      console.log(i)
      socketArr[i].connect({user: 'user'+i})
      // socketArr[i].connect({userID: })
      
      socketArr[i].onOpen( ev => console.log("OPEN", ev) )
      socketArr[i].onError( ev => console.log("ERROR", ev) )
      socketArr[i].onClose( e => console.log("CLOSE", e))
  
      // chan[i] = socketArr[i].channel("rooms:lobby", {user: 'user'+i,userID:i,state:1})
      chan.push(socketArr[i].channel("rooms:lobby", {user: 'user'+i,userID:i,state:1})) 
      chan[i].join().receive("ignore", () => console.log("auth error"))
                 .receive("ok", () => console.log("join ok"))
                 .after(10000, () => console.log("Connection interruption"))
      chan[i].onError(e => console.log("something went wrong", e))
      chan[i].onClose(e => console.log("channel closed", e))
      var c=chan[i]
      // setInterval(function(c){c.push("new:msg", {user: "user"+i}) }, 300);
      chan[i].push("new:msg", {user: "user"+i})
      // chan[0].push("zipf", {nUsers:nUsers})
      

      chan[i].on("new:msg", msg => {
        console.log("#################"+msg.user)
        $messages.append(this.messageTemplate(msg))
        scrollTo(0, document.body.scrollHeight)
      })
      
      chan[i].on("user:entered", msg => {
        var username = this.sanitize(msg.user || "anonymous")
        $messages.append(`<br/><i>[${username} entered]</i>`)
      })
  
    }

    var $input     = $("#message-input")
    var $username  = $("#username")


    $input.off("keypress").on("keypress", e => {
      if (e.keyCode == 13) {
        $input.val("")
      }
    })

  }

  static sanitize(html){ return $("<div/>").text(html).html() }

  static messageTemplate(msg){
    let username = this.sanitize(msg.user || "anonymous")
    let body     = this.sanitize(msg.body)

    return(`<p><a href='#'>[${username}]</a>&nbsp; </p>`)
  }

}

$( () => App.init() )

export default App