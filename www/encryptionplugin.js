// Empty constructor
function EncryptionPlugin() {}

// The function that passes work along to native shells
EncryptionPlugin.prototype.encrypt = function(message, publicKey, successCallback, errorCallback) {
  var options = {};
  options.message = message;
  options.publicKey = publicKey;
  cordova.exec(successCallback, errorCallback, 'EncryptionPlugin', 'encrypt', [options]);
}

EncryptionPlugin.prototype.decrypt = function(message, privateKey, successCallback, errorCallback) {
    var options = {};
    options.message = message;
    options.privateKey = privateKey;
    cordova.exec(successCallback, errorCallback, 'EncryptionPlugin', 'decrypt', [options]);
  }

// Installation constructor that binds EncryptionPlugin to window
EncryptionPlugin.install = function() {
  if (!window.plugins) {
    window.plugins = {};
  }
  window.plugins.EncryptionPlugin = new EncryptionPlugin();
  return window.plugins.EncryptionPlugin;
};
cordova.addConstructor(EncryptionPlugin.install);