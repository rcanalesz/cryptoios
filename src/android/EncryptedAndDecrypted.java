package com.outsystemsenterprise.entel.PEMiEntel.cordova.plugin;

import android.util.Base64;

import android.util.Log;
import java.io.IOException;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;


public class EncryptedAndDecrypted {

    public static String metodoPrivate(String ClavePrivadaFromService){

        String ClavePrivada = null;

        ClavePrivada = ClavePrivadaFromService.replaceAll("\\n", "").replace("-----BEGIN PRIVATE KEY-----", "").replace("-----END PRIVATE KEY-----", "");

        return ClavePrivada;
    }
    public static String metodoPublic(String ClavePublicaFromService){

        String ClavePublica = null;

        ClavePublica = ClavePublicaFromService.replaceAll("\\n", "").replace("-----BEGIN PUBLIC KEY-----", "").replace("-----END PUBLIC KEY-----", "");

        return ClavePublica;

    }

    public static String RequestEncrypted(String mensaje,String clavePublica) throws BadPaddingException, IllegalBlockSizeException, InvalidKeyException, NoSuchPaddingException, NoSuchAlgorithmException, InvalidAlgorithmParameterException, IOException {

        SecretKey key = null;
        try {
            key = AESUtil.generateKey();

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            throw e;
        } catch (Exception e){
            e.printStackTrace();
            throw e;
        }

        String keyBase64 = Base64.encodeToString(key.getEncoded(), Base64.NO_WRAP);
        String keyRSA = null;

        do {
            try {
                
                // Log.e("GENERATE_KEY_B64",keyBase64);
                keyRSA = Base64.encodeToString(RSAutil2.encrypt(keyBase64,metodoPublic(clavePublica)),Base64.NO_WRAP).replaceAll("\\n+", "");

            } catch (BadPaddingException e) {
                e.printStackTrace();
                throw e;
            } catch (IllegalBlockSizeException e) {
                e.printStackTrace();
                throw e;
            } catch (InvalidKeyException e) {
                e.printStackTrace();
                throw e;
            } catch (NoSuchPaddingException e) {
                e.printStackTrace();
                throw e;
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
                throw e;
            } catch (Exception e){
                e.printStackTrace();
                throw e;
            }

        } while (keyRSA == null);

        String encriptadoAES="";

        try {
            encriptadoAES = String.valueOf(AESUtil.encryptRequestContent(mensaje,key));

        } catch (IOException e) {
            e.printStackTrace();
            throw e;
        } catch (NoSuchPaddingException e) {
            e.printStackTrace();
            throw e;
        } catch (InvalidKeyException e) {
            e.printStackTrace();
            throw e;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            throw e;
        } catch (IllegalBlockSizeException e) {
            e.printStackTrace();
            throw e;
        } catch (BadPaddingException e) {
            e.printStackTrace();
            throw e;
        } catch (InvalidAlgorithmParameterException e) {
            e.printStackTrace();
            throw e;
        } catch (Exception e){
            e.printStackTrace();
            throw e;
        }

        String tramaCifradaEnvio = keyRSA+encriptadoAES;

        return tramaCifradaEnvio;

    }

    public static String responseDecrypteGeneral(String reponseEncrypt, String clavePrivada) throws BadPaddingException, IllegalBlockSizeException, InvalidKeyException, NoSuchPaddingException, NoSuchAlgorithmException,IOException {

        byte[] respuestaRSADes = null;

        String datoencriptado684 = reponseEncrypt.substring(0,684);
        byte[] keyencondeRSA = Base64.decode(datoencriptado684,Base64.NO_WRAP);
        try {
            respuestaRSADes = RSAutil2.decrypt(keyencondeRSA,metodoPrivate(clavePrivada).getBytes());

        
        } catch (BadPaddingException e) {
            e.printStackTrace();
            throw e;
        } catch (IllegalBlockSizeException e) {
            e.printStackTrace();
            throw e;
        } catch (InvalidKeyException e) {
            e.printStackTrace();
            throw e;
        } catch (NoSuchPaddingException e) {
            e.printStackTrace();
            throw e;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            throw e;
        } catch (Exception e){
            e.printStackTrace();
            throw e;
        }

        String generalclass = null;
        try {
            generalclass = AESUtil.decryptRequestContentEncrypt(reponseEncrypt.substring(684), respuestaRSADes);
        } catch (IOException e) {
            e.printStackTrace();
            throw e;
        } catch (Exception e){
            e.printStackTrace();
            throw e;
        }

        return generalclass;
    }

}
