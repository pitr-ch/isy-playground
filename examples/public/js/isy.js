//var descendant = function(parent, child) {
//  var F = function() {};
//  F.prototype = parent.prototype;
//  child.prototype = new F();
//  child._superClass = parent.prototype;
//  child.prototype.constructor = child;
//};

var Isy = function() {
  this.sendLogBack = false;
  this.hashchange = true;
};

Isy.prototype = {
  _safely: function(func, obj) {
    try {
      return func.call(obj);
    } catch (e) {
      Isy.Logger.error(e.stack);
    }
  },

  callback: function(event) {
    return isy._safely( function() {
      var data = this._ids();
      var json = JSON.parse(event.currentTarget.getAttribute("data-callback-" + event.type));

      if (json.action) data.action_id = json.action;
      if (json.form) {
        data.form = {};
        $("[data-form-id=" + json.form + "]").each(function(i, elem) {
          var componentId = elem.getAttribute('data-component-id');
          data.form[componentId] = {};
          $(elem).find("[data-value]").each(
            function(i,elem) {
              data.form[componentId][elem.getAttribute('data-value')] = $(elem).val();
            })
        })
      }
      event.preventDefault();
      return this._send(data);
    }, this);
  },

  _noConnection: function() {
    alert('Connection to server was lost, click OK to reload.');
    location.reload();
  },

  _setVariables: function(obj) {
    var property;
    for (property in obj) {
      this[property] = obj[property];
    }
  },

  _checkVariables: function() {
    if (!this.sessionId) throw Error('no sessionId')
    if (!this.server) throw Error('no server')
    if (!this.port) throw Error('no port')
  },

  _setupWebsocket: function() {
    if (!this.websocket) {
      this.websocket = new WebSocket("ws://" + this.server + ":" + this.port + "/");

      this.websocket.onmessage = function(evt) {
        isy._safely( function() {
          Isy.Logger.debug("recieving: " + evt.data);
          isy._recieve(JSON.parse(evt.data));
          if (isy.bench) isy.callRandomAction();
        });
      };

      this.websocket.onclose = function() {
        isy._noConnection()
      };
      this.websocket.onerror = function() {
        isy._noConnection()
      };

      this.websocket.onopen = function() {
        Isy.Logger.debug("WebSocket connected...");
        isy._requestContent();
      };
    }
  },

  //  callRandomAction: function() {
  //    var arr = $('a[data-action-id]');
  //    this.action( arr[Math.floor(Math.random()*arr.size())].getAttribute('data-action-id') );
  //  },

  _recieve: function(obj) {
    (new Isy.Reciever(obj))._execute();
  },

  _requestContent: function() {
    this._send(this._ids());
  },

  _ids: function() {
    return {
      session_id: this.sessionId,
      hash: location.hash.replace(/^#/, ''),
      context_id: this.contextId
    };
  },

  _send: function(obj) {
    var json = JSON.stringify(obj);
    Isy.Logger.debug("sending: " + json);
    this.websocket.send(json);
  },

  _events: function() {

    var events = $([ 'blur', 'focus', 'focusin', 'focusout', 'load', 'resize', 'scroll', 'unload', 'click', 'dblclick',
      'mousedown', 'mouseup', 'mousemove', 'mouseover', 'mouseout', 'mouseenter', 'mouseleave', 'change', 'select',
      'submit', 'keydown', 'keypress', 'keyup', 'error'])

    events.each( function(i, event) {
      $('[data-callback-'+event+']').live(event, function(event) {
        isy.callback(event)
      });
    });
    
    $(window).bind('hashchange', function(evt) {
      if (isy.hashchange == true) {
        Isy.Logger.warn("hashchange trigered")
        isy._send(isy._ids());
      }
    });
  },

  initialize: function() {
    this._events();
    this._checkVariables();
    this._setupWebsocket();
  }
}

var isy = new Isy();

Isy.Logger = {
  error:  function(message) {
    console.error(message);
  //    if(isy.sendLogBack == true) new Isy.Log('error', message).send();
  },

  warn:  function(message) {
    console.warn(message);
  //    if(isy.sendLogBack == true) new Isy.Log('warn', message).send();
  },

  info:  function(message) {
    console.info(message);
  //    if(isy.sendLogBack == true) new Isy.Log('info', message).send();
  },

  debug:  function(message) {
    console.debug(message);
  //    if(isy.sendLogBack == true) new Isy.Log('debug', message).send();
  }
};


Isy.Reciever = function(json) {
  this.json = json;  
}

Isy.Reciever.prototype = {
  _execute: function() {
    if (this.json.html) this._replaceBody();
    if (this.json.js) this._evalJs();
    if (this.json.context_id) this._setContextId();
  //    if (this.json.hash) this._setHash();
  },

  _replaceBody: function() {
    $("body").empty();
    $("body").append(this.json.html);
  },

  _evalJs: function() {
    eval(this.json.js);
  },

  _setContextId: function() {
    isy.contextId = this.json.context_id;
  },

  _setHash: function() {
    location.hash = this.json.hash;
  }
}


$(document).ready(function() {
  isy.initialize();
});

