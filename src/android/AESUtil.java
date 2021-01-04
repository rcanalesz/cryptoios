package com.outsystemsenterprise.entel.PEMiEntel.cordova.plugin;

import android.util.Base64;


import org.codehaus.jackson.map.ObjectMapper;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;

import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;


import javax.crypto.Cipher;

import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;


public class AESUtil {

    public static int AES_KEY_SIZE = 256 ;
    public static int IV_SIZE = 16 ;
    public static int TAG_BIT_LENGTH = 128 ;
    public static String INIT_VECTOR="PyrcyeOXUR2WVCP3v2sIkA==";
    public static String ALG_TRANSFORMATION_STRING = "AES/CBC/PKCS5Padding" ;

    public static SecretKey generateKey() throws NoSuchAlgorithmException {

        SecretKey key;

        try {

            SecureRandom rand = new SecureRandom();
            KeyGenerator generator = KeyGenerator.getInstance("AES");
            generator.init(AES_KEY_SIZE, rand);
            key = generator.generateKey();

            return key;

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return null;
    }

    public static byte[] generateIV() throws NoSuchAlgorithmException {
        byte[] initVector;
        try {
            initVector = new byte[IV_SIZE];
            SecureRandom random = new SecureRandom();
            random.nextBytes(initVector);

            return initVector;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public static String encrypt(String value,SecretKey key) {
        try {
            byte[] initVector = new byte[IV_SIZE];
            initVector = Base64.decode(INIT_VECTOR,Base64.NO_WRAP);
            IvParameterSpec ivParameterSpec = new IvParameterSpec(initVector);
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getEncoded(), "AES");
            Cipher cipher = Cipher.getInstance(ALG_TRANSFORMATION_STRING);
            cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec) ;

            byte[] encryptedText = cipher.doFinal(value.getBytes()) ;
            return Base64.encodeToString(encryptedText,Base64.NO_WRAP);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }


    public static String decrypt(String encrypted,byte[] key) {
        try {
            byte[] initVector = new byte[IV_SIZE];
            initVector = Base64.decode(INIT_VECTOR,Base64.NO_WRAP);
            IvParameterSpec ivParameterSpec = new IvParameterSpec(initVector);
            SecretKeySpec secretKeySpec = new SecretKeySpec(key, "AES");
            Cipher cipher = Cipher.getInstance(ALG_TRANSFORMATION_STRING);
            cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, ivParameterSpec);
            byte[] original = cipher.doFinal(Base64.decode(encrypted,Base64.NO_WRAP));

            return new String(original);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return null;
    }

    public static String encryptRequestContent(String json,SecretKey secretKey) throws IOException, NoSuchPaddingException, InvalidKeyException, NoSuchAlgorithmException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {
        String encrypt = AESUtil.encrypt(json,secretKey);
        return encrypt;
    }

    public static String decryptRequestContentEncrypt(String preResponse, byte[] secretKey) throws IOException {
        String decrypt = AESUtil.decrypt(preResponse,secretKey);
        return decrypt;

    }

}
