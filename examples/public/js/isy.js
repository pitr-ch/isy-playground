var descendant = function(parent, child) {
  var F = function() {};
  F.prototype = parent.prototype;
  child.prototype = new F();
  child._superClass = parent.prototype;
  child.prototype.constructor = child;
};

var Isy = function() {
  this.contextId = undefined;
  this.server = undefined;
  this.port = undefined;
  this.sessionId = undefined;
  this.sendLogBack = undefined;
};

Isy.prototype = {
  error:  function(message) {
    console.error(message);
    if(isy.sendLogBack == true) new Isy.Log('error', message).send();
  },

  warn:  function(message) {
    console.warn(message);
    if(isy.sendLogBack == true) new Isy.Log('warn', message).send();
  },

  info:  function(message) {
    console.info(message);
    if(isy.sendLogBack == true) new Isy.Log('info', message).send();
  },

  debug:  function(message) {
    console.debug(message);
    if(isy.sendLogBack == true) new Isy.Log('debug', message).send();
  },

  safely: function(func) {
    try {
      func();
    } catch (e) {
      this.error(e.stack);
    }
  },

  action: function(id) {
    return new Isy.ExecuteAction(id).send();
  },

  noConnection: function() {
    this.safely(function() {
      throw Error('unconnected websocket');
    });
  },

  setVariables: function(obj) {
    var property;
    for (property in obj) {
      eval("this." + property + "=obj." + property, this);
    }
  }
}

var isy = new Isy;

Isy.Recieved = function(json) {
  this.json = json;
}

Isy.Recieved.prototype = {
  execute: function() {
    //    var commands = typeof this.json.command == "string" ? [this.json.command] : this.json.command;
    //    commands.forEach( function(command) {
    isy.debug("executing :" + this.json.command);
    var func = eval("this." + this.json.command);
    if(func) {
      func.call(this);
    } else {
      throw Error("undefined command: " + this.json.command);
    }
  //    }, this);
  },

  replaceBody: function() {
    $("body").empty();
    $("body").append(this.json.html);
  },

  evalJs: function() {
    eval(this.json.js);
  },

  setContextId: function() {
    isy.contextId = this.json.contextId;
  }
}

Isy.Message = function() {  
  this.sessionId = isy.sessionId;
  this.contextId = isy.contextId;
}

Isy.Message.prototype = {
  data: function() {
    return JSON.stringify(this);
  },

  send: function() {
    //    if(isy.websocket.readyState == isy.websocket.CONNECTED) {
    //    isy.debug("sending: " + json);
    return isy.websocket.send(this.data());
  //    } else {
  //      return isy.noConnection();
  //    }
  }
}

Isy.LoggedMessage = function() {
  Isy.Message.call(this);
}

Isy.LoggedMessage.prototype = {
  send: function() {
    Isy.LoggedMessage._superClass.send.call(this);    
    isy.debug("sending: " + this.data());
  }
}
descendant(Isy.Message, Isy.LoggedMessage);


Isy.ExecuteAction = function(id) {
  Isy.LoggedMessage.call(this);
  this.command = 'executeAction';
  this.actionId = id;
}
descendant(Isy.LoggedMessage, Isy.ExecuteAction);


Isy.GetContext = function() {
  Isy.LoggedMessage.call(this);
  this.command = 'getContext';
}
descendant(Isy.LoggedMessage, Isy.GetContext);


Isy.Log = function(severity, message) {
  Isy.Message.call(this);
  this.command = 'log';
  this.severity = severity;
  this.message = message;
}
descendant(Isy.Message, Isy.Log);


$(document).ready(function(){
  isy.websocket = new WebSocket("ws://" + isy.server + ":" + isy.port + "/");

  isy.websocket.onmessage = function(evt) {
    isy.safely( function() {
      isy.debug("recieving: " + evt.data);
      new Isy.Recieved(JSON.parse(evt.data)).execute();
    });
  };

  isy.websocket.onclose = function() {
    isy.noConnection()
  };
  isy.websocket.onerror = function() {
    isy.noConnection()
  };

  isy.websocket.onopen = function() {
    isy.debug("WebSocket connected...");
    new Isy.GetContext().send();
  };

  $('a[data-action]').live('click', function (event) {
        isy.action(event.currentTarget.getAttribute('data-action'));
    });
});

