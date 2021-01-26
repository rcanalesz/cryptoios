package com.outsystemsenterprise.entel.PEMiEntel.cordova.plugin;

import android.util.Base64;
import android.util.Log;

import org.apache.commons.lang3.CharEncoding;
import org.codehaus.jackson.map.ObjectMapper;

import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;


public final class EncryptUtils {
    //encrypt
    private static final String IV = "BAEAGAOANAIAAAAA";
    private static final String KEY = "V0A0L0E0R0I0A000";
    private static final String ALGORITHM = "AES";
    private static final String CYPHER_TRANSFORMATION = "AES/CBC/PKCS7Padding";
    //decrypt
    final static String VECTORINIT = "BAEAGAOANAIAAAAA";
    final static String ALGORITHM_DECRYPT = "AES/CBC/PKCS5Padding";
    final static String ENCRYPTIONKEY = "V0A0L0E0R0I0A000";

    public static String encryptPassword(String excrypted){
        return "ENC->" + excrypted;
    }

/*
    public static String encrypt(String plainText)
            throws IOException, NoSuchPaddingException,
            NoSuchAlgorithmException, InvalidAlgorithmParameterException, InvalidKeyException,
            BadPaddingException, IllegalBlockSizeException, NullPointerException {
        byte[] keyBytes = KEY.getBytes(CharEncoding.UTF_8);
        SecretKeySpec secretKeySpec = new SecretKeySpec(keyBytes, ALGORITHM);
        Cipher cipher = Cipher.getInstance(CYPHER_TRANSFORMATION);
        IvParameterSpec ivParameterSpec = new IvParameterSpec(IV.getBytes(CharEncoding.UTF_8));
        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);
        byte[] result = cipher.doFinal(plainText.getBytes(CharEncoding.UTF_8));
        return Base64.encodeToString(result, Base64.DEFAULT);
    }*/


}