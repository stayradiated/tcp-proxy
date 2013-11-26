(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  (function(files) {
    var cache, module, req;
    cache = {};
    req = function(id) {
      var file;
      if (cache[id] == null) {
        if (files[id] == null) {
          if ((typeof require !== "undefined" && require !== null)) {
            return require(id);
          }
          console.error("Cannot find module '" + id + "'");
          return null;
        }
        file = cache[id] = {
          exports: {}
        };
        files[id][1].call(file.exports, (function(name) {
          var realId;
          realId = files[id][0][name];
          return req(realId != null ? realId : name);
        }), file, file.exports);
      }
      return cache[id].exports;
    };
    if (typeof module === 'undefined') {
      module = {};
    }
    return module.exports = req(0);
  })([
    [
      {
        /*
          /Volumes/Home/Projects/TCP-Proxy/client/source/index.coffee
        */

        './socket': 1,
        './views/message': 2
      }, function(require, module, exports) {
        var Message, Socket;
        Socket = require('./socket');
        Message = require('./views/message');
        return document.addEventListener('DOMContentLoaded', function() {
          var buttonStart, buttonStop, inputHost, inputTarget, logEl, render, socket;
          socket = new Socket();
          socket.on('connect', function() {
            if (inputHost.value) {
              socket.emit('set-host', inputHost.value);
            }
            if (inputTarget.value) {
              return socket.emit('set-target', inputTarget.value);
            }
          });
          inputHost = document.getElementById('input-host');
          inputTarget = document.getElementById('input-target');
          if (localStorage.host) {
            inputHost.value = localStorage.host;
          }
          if (localStorage.target) {
            inputTarget.value = localStorage.target;
          }
          inputHost.addEventListener('input', function() {
            localStorage.host = inputHost.value;
            return socket.emit('set-host', inputHost.value);
          });
          inputTarget.addEventListener('input', function() {
            localStorage.target = inputTarget.value;
            return socket.emit('set-target', inputTarget.value);
          });
          buttonStart = document.getElementById('button-start');
          buttonStop = document.getElementById('button-stop');
          buttonStart.addEventListener('click', function() {
            return socket.emit('start');
          });
          buttonStop.addEventListener('click', function() {
            return socket.emit('stop');
          });
          logEl = document.querySelector('.log ul');
          logEl.addEventListener('click', function(event) {
            var target;
            target = event.target;
            while (target !== logEl) {
              if (target.classList.contains('message')) {
                target.classList.toggle('expanded');
                return;
              }
              target = target.parentElement;
            }
          });
          render = function(message) {
            return logEl.innerHTML += message.render();
          };
          socket.on('upstream', function(data) {
            var msg;
            msg = new Message('upstream', data);
            return render(msg);
          });
          return socket.on('downstream', function(data) {
            var msg;
            msg = new Message('downstream', data);
            return render(msg);
          });
        });
      }
    ], [
      {
        /*
          /Volumes/Home/Projects/TCP-Proxy/client/source/socket.coffee
        */

      }, function(require, module, exports) {
        var Socket;
        Socket = (function() {
          function Socket(fn) {
            this.on = __bind(this.on, this);
            this.emit = __bind(this.emit, this);
            this.onConnect = __bind(this.onConnect, this);
            this.socket = io.connect('http://localhost:8090');
          }

          Socket.prototype.onConnect = function() {
            return console.log('Successfully connected to server');
          };

          Socket.prototype.emit = function() {
            return this.socket.emit.apply(this.socket, arguments);
          };

          Socket.prototype.on = function() {
            return this.socket.on.apply(this.socket, arguments);
          };

          return Socket;

        })();
        return module.exports = Socket;
      }
    ], [
      {
        /*
          /Volumes/Home/Projects/TCP-Proxy/client/source/views/message.coffee
        */

        '../template': 3
      }, function(require, module, exports) {
        var Message, createTemplate, template, templates;
        createTemplate = function(template) {
          template = template.join('');
          return function(obj) {
            var html, name, regex, value;
            html = template;
            for (name in obj) {
              value = obj[name];
              regex = new RegExp("\\{\\{\\s*" + name + "\\s*\\}\\}", 'gi');
              html = html.replace(regex, value);
            }
            return html;
          };
        };
        templates = require('../template');
        template = createTemplate(templates.message);
        Message = (function() {
          Message.index = 0;

          Message.prototype.getId = function() {
            return Message.index++;
          };

          function Message(type, content) {
            this.type = type;
            this.content = content;
            this.render = __bind(this.render, this);
            this.escape = __bind(this.escape, this);
            this.id = this.getId();
          }

          Message.prototype.escape = function() {
            return this.content.replace(/\</gi, '&lt').replace(/\>/gi, '&gt');
          };

          Message.prototype.render = function() {
            return template({
              id: this.id,
              type: this.type,
              content: this.escape()
            });
          };

          return Message;

        })();
        return module.exports = Message;
      }
    ], [
      {
        /*
          /Volumes/Home/Projects/TCP-Proxy/client/source/template.json
        */

      }, function(require, module, exports) {
        return module.exports = {
          "message": ["<li class=\"message {{ type }}\">", "<span class=\"id\">{{ id }}</span>", "<div class=\"content\">{{ content }}</div>", "</li>"]
        };
      }
    ]
  ]);

}).call(this);
