package com.outsystemsenterprise.entel.PEMiEntel.cordova.plugin;

import org.apache.cordova.CordovaPlugin;

import com.outsystemsenterprise.entel.PEMiEntel.cordova.plugin.EncryptedAndDecrypted;

import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class EncryptionPlugin extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
      try {
      String mensaje = null;
      String clavePublica = null;
      String clavePrivada = null;
        if (action.equals("encrypt")) {
              
      try {
        //   JSONObject options = args.getJSONObject(0);
        mensaje = args.getString(0);
        clavePublica =  args.getString(1);
        } catch (JSONException e) {
            callbackContext.error("Error encountered: " + e.getMessage());
            return false;
        }
            String data =  EncryptedAndDecrypted.RequestEncrypted(mensaje, clavePublica);
            
            callbackContext.success(data);
            return true;
        } else if (action.equals("decrypt")){
                
      try {
        //   JSONObject options = args.getJSONObject(0);
        mensaje = args.getString(0);
        clavePrivada =  args.getString(1);
        } catch (JSONException e) {
            callbackContext.error("Error encountered: " + e.getMessage());
            return false;
        }
        String data = EncryptedAndDecrypted.responseDecrypteGeneral(mensaje, clavePrivada);
        callbackContext.success(data);
        return true;
        }else {
            
          callbackContext.error("\"" + action + "\" is not a recognized action.");
          return false;
        }
      } catch (Exception ex) {
        callbackContext.error("Error encountered: " + ex.getMessage());
        return false;
    }
      }
}
