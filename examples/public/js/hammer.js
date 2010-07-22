//var descendant = function(parent, child) {
//  var F = function() {};
//  F.prototype = parent.prototype;
//  child.prototype = new F();
//  child._superClass = parent.prototype;
//  child.prototype.constructor = child;
//};

var Hammer = function() {
  this.sendLogBack = false;
  this.hashchange = true;
};

Hammer.prototype = {
  _safely: function(func, obj) {
    try {
      return func.call(obj);
    } catch (e) {
      Hammer.Logger.error(e.stack);
    }
  },

  callback: function(event) {
    return hammer._safely( function() {
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
        hammer._safely( function() {
          Hammer.Logger.debug("recieving: " + evt.data);
          hammer._recieve(JSON.parse(evt.data));
          if (hammer.bench) hammer.callRandomAction();
        });
      };

      this.websocket.onclose = function() {
        hammer._noConnection()
      };
      this.websocket.onerror = function() {
        hammer._noConnection()
      };

      this.websocket.onopen = function() {
        Hammer.Logger.debug("WebSocket connected...");
        hammer._requestContent();
      };
    }
  },

  //  callRandomAction: function() {
  //    var arr = $('a[data-action-id]');
  //    this.action( arr[Math.floor(Math.random()*arr.size())].getAttribute('data-action-id') );
  //  },

  _recieve: function(obj) {
    (new Hammer.Reciever(obj))._execute();
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
    Hammer.Logger.debug("sending: " + json);
    this.websocket.send(json);
  },

  _events: function() {

    var events = $([ 'blur', 'focus', 'focusin', 'focusout', 'load', 'resize', 'scroll', 'unload', 'click', 'dblclick',
      'mousedown', 'mouseup', 'mousemove', 'mouseover', 'mouseout', 'mouseenter', 'mouseleave', 'change', 'select',
      'submit', 'keydown', 'keypress', 'keyup', 'error'])

    events.each( function(i, event) {
      $('[data-callback-'+event+']').live(event, function(event) {
        hammer.callback(event)
      });
    });
    
    $(window).bind('hashchange', function(evt) {
      if (hammer.hashchange == true) {
        Hammer.Logger.warn("hashchange trigered")
        hammer._send(hammer._ids());
      }
    });
  },

  initialize: function() {
    this._events();
    this._checkVariables();
    this._setupWebsocket();
  }
}

var hammer = new Hammer();

Hammer.Logger = {
  error:  function(message) {
    console.error(message);
  //    if(hammer.sendLogBack == true) new Hammer.Log('error', message).send();
  },

  warn:  function(message) {
    console.warn(message);
  //    if(hammer.sendLogBack == true) new Hammer.Log('warn', message).send();
  },

  info:  function(message) {
    console.info(message);
  //    if(hammer.sendLogBack == true) new Hammer.Log('info', message).send();
  },

  debug:  function(message) {
    console.debug(message);
  //    if(hammer.sendLogBack == true) new Hammer.Log('debug', message).send();
  }
};


Hammer.Reciever = function(json) {
  this.json = json;  
}

Hammer.Reciever.prototype = {
  _execute: function() {
    if (this.json.html) this._replaceBody();
    if (this.json.js) this._evalJs();
    if (this.json.context_id) this._setContextId();
  //    if (this.json.hash) this._setHash();
  },

  _replaceBody: function() {    
    $("body").html(this.json.html);
    $(hammer).trigger('hammer.update')
  },

  _evalJs: function() {
    eval(this.json.js);
  },

  _setContextId: function() {
    hammer.contextId = this.json.context_id;
  },

  _setHash: function() {
    location.hash = this.json.hash;
  }
}


$(document).ready(function() {
  hammer.initialize();
});

