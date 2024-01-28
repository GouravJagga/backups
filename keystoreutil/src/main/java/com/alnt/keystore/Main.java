package com.alnt.keystore;

import java.io.FileInputStream;
import java.nio.charset.StandardCharsets;
import java.security.KeyStore;
import java.security.KeyStore.SecretKeyEntry;
import java.util.Iterator;
import java.util.Optional;

public class Main {
	private static String  keyStoreFileName="D:\\HSC_WORKSPACE\\BUILDS\\MAIN\\alert_keystore\\AlertKeystore";
	private static KeyStore.ProtectionParameter passwordParam;
	private static KeyStore keyStoreObj;
	private final static String KEYSTORE_INSTANCE_PKCS12_TYPE = "PKCS12";
	public static void main(String[] args) throws Exception {
		 char[] password = "alert123".toCharArray();
		passwordParam = new KeyStore.PasswordProtection(password);
		try (FileInputStream fis = new FileInputStream(keyStoreFileName)) {
			keyStoreObj = KeyStore.getInstance(KEYSTORE_INSTANCE_PKCS12_TYPE);
			keyStoreObj.load(fis, password);
			Iterator<String> a=keyStoreObj.aliases().asIterator();
			for(;a.hasNext();) {
				String key=a.next();
				Optional<String> value= getKeyStoreEntry(key);
				if(value.isPresent()) {
					 System.out.println(key+" : "+value.get());
				}
			}
		} catch (Exception e) {
			System.out.println("KeyStoreUtil():: "+ e);
		}
	}
	public static Optional<String> getKeyStoreEntry(String key) {
		SecretKeyEntry secretKeyEnt = null;
		try {
			if (keyStoreObj != null) {
				secretKeyEnt = (SecretKeyEntry) keyStoreObj.getEntry(key, passwordParam);
				if (secretKeyEnt == null) {
					return Optional.empty();
				}
			}
		} catch (Exception e) {
			return Optional.empty();
		}
		return Optional.of(new String(secretKeyEnt.getSecretKey().getEncoded(), StandardCharsets.UTF_8));
	}
}