// Empty constructor
function EncryptionPlugin() {}

// The function that passes work along to native shells
EncryptionPlugin.prototype.encrypt = function(message, publicKey, successCallback, errorCallback) {

  cordova.exec(successCallback, errorCallback, 'EncryptionPlugin', 'encrypt', [message,publicKey]);
}

EncryptionPlugin.prototype.decrypt = function(message, privateKey, successCallback, errorCallback) {

  cordova.exec(successCallback, errorCallback, 'EncryptionPlugin', 'decrypt', [message,privateKey]);
}

EncryptionPlugin.prototype.encryptPassword = function(message, successCallback, errorCallback) {

  cordova.exec(successCallback, errorCallback, 'EncryptionPlugin', 'encryptPassword', [message]);
}

EncryptionPlugin.prototype.encryptRSA = function(message, successCallback, errorCallback) {

  cordova.exec(successCallback, errorCallback, 'EncryptionPlugin', 'encryptRSA', [message]);
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