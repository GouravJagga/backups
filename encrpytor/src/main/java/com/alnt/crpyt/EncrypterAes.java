package com.alnt.crpyt;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

public class EncrypterAes {

	Cipher ecipher;
	Cipher dcipher;

	private static final String DEFAULT_ENCRPYT_ALGO = "AES/GCM/NoPadding";
	private static final int DEFAULT_KEY_LENGTH = 128;
	private static final int DEFAULT_ITERATION_COUNT = 65536;
	private static final String PASSPHRASE = "In the middle of difficulty lies opportunity";
	private static final String PASSPHRASES = "In the middle of difficulty lies opportunity,this is the passphrase,this is a passphrase";
	private static final List<String> DECRYPT_PASSPHRASE = new ArrayList<>(Arrays.asList(PASSPHRASES.split(",")));
	private static final String keylengths = "256,128";
	private static final List<String> DECRYPT_KEYLENGTH = new ArrayList<>(Arrays.asList(keylengths.split(",")));
	private static final String encrypt_pass = "alert123";
	private static final String decrypt_password = "Osay034hP/exLPf90iPRTTk5eSgzmPjd";
	private static final String DEFAULT_KEY_ALGO = "PBKDF2WithHmacSHA256";
	private static final byte[] DEFAULT_SALT = { (byte) 0xA9, (byte) 0x9B, (byte) 0xC8, (byte) 0x32, (byte) 0x56, (byte) 0x34, (byte) 0xE3,(byte) 0x03 };
	private static final int AUTH_TAG_LENGTH = 128;
	private static boolean randomIv = true;
	private static byte[] salt;
	//private static final String DEFAULT_PASS_PHRASE = "In the middle of difficulty lies opportunity";

	public EncrypterAes(String passPhrase, int keyLength, int iterationCount) {
		init(passPhrase, keyLength, iterationCount);
	}

	public EncrypterAes(SecretKey key, String algorithm) {
		try {
			ecipher = Cipher.getInstance(algorithm);
			dcipher = Cipher.getInstance(algorithm);
			ecipher.init(Cipher.ENCRYPT_MODE, key);
			dcipher.init(Cipher.DECRYPT_MODE, key);
		} catch (NoSuchPaddingException e) {
			System.out.println("EXCEPTION: NoSuchPaddingException");
		} catch (NoSuchAlgorithmException e) {
			System.out.println("EXCEPTION: NoSuchAlgorithmException");
		} catch (InvalidKeyException e) {
			System.out.println("EXCEPTION: InvalidKeyException");
		}
	}
	
	public static void main(String[] args) {
		boolean decryption_found=false;
		String decrypt_pass=null;
		EncrypterAes desEncrypter = new EncrypterAes(PASSPHRASE, DEFAULT_KEY_LENGTH, DEFAULT_ITERATION_COUNT);
		String desEncrypted = desEncrypter.encrypt(encrypt_pass);
		System.out.println("encrypted pass :"+desEncrypted);
		for(String key : DECRYPT_KEYLENGTH) {
			if(decryption_found) {break;}
			for(String pass : DECRYPT_PASSPHRASE) {
				try {
				EncrypterAes desEncrypter1 = new EncrypterAes(pass, Integer.parseInt(key), DEFAULT_ITERATION_COUNT);
				 decrypt_pass=desEncrypter1.decrypt(decrypt_password);
				}
				catch(Exception e) {}
				if(decrypt_pass!=null) {
					decryption_found=true;
				System.out.println("decrypted password :"+decrypt_pass);
				System.out.println("passphrase :"+pass);
				System.out.println("keylength :"+key);
				break;
				}
			}
		}
	}

	public void init(String passPhrase, int keyLength, int iterationCount) {
		randomIv = System.getProperty("randomiv") != null?Boolean.parseBoolean(System.getProperty("randomiv")):false ;
		// 8-bytes Salt
		salt = System.getProperty("salt") != null? System.getProperty("salt").getBytes():DEFAULT_SALT;

		//int iterationCount = 65536;
		//int keyLength = 128;

		try {

			SecretKeyFactory factory = SecretKeyFactory.getInstance(DEFAULT_KEY_ALGO);
			KeySpec spec = new PBEKeySpec(passPhrase.toCharArray(), salt, iterationCount, keyLength);
			SecretKey tmp = factory.generateSecret(spec);
			SecretKey key = new SecretKeySpec(tmp.getEncoded(), "AES");

			// Generating IV.
			byte[] IV = new byte[16];
			if(randomIv)
				new SecureRandom().nextBytes(IV);

			// Create SecretKeySpec
			SecretKeySpec keySpec = new SecretKeySpec(key.getEncoded(), "AES");

			// Create GCMParameterSpec
			GCMParameterSpec parameterSpec = new GCMParameterSpec(AUTH_TAG_LENGTH, IV);

			// Create an instance of cipher
			ecipher = Cipher.getInstance(DEFAULT_ENCRPYT_ALGO);
			dcipher = Cipher.getInstance(DEFAULT_ENCRPYT_ALGO);

			// Initialize the cipher with the key and IV
			ecipher.init(Cipher.ENCRYPT_MODE, keySpec, parameterSpec);
			dcipher.init(Cipher.DECRYPT_MODE, keySpec, parameterSpec);

		} catch (InvalidAlgorithmParameterException e) {
			e.printStackTrace();
		} catch (InvalidKeySpecException e) {
			e.printStackTrace();
		} catch (NoSuchPaddingException e) {
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (InvalidKeyException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Takes a single String as an argument and returns an Encrypted version of that
	 * String.
	 * 
	 * @param str String to be encrypted
	 * @return <code>String</code> Encrypted version of the provided String
	 */
	public String encrypt(String str) {
		if (str != null && str.length() > 0) {
			try {
				// Encode the string into bytes using utf-8
				byte[] utf8 = str.getBytes("UTF8");

				// Encrypt
				byte[] enc = ecipher.doFinal(utf8);

				// Encode bytes to base64 to get a string
				Base64.Encoder encoder = Base64.getEncoder();
				return encoder.encodeToString(enc);

			} catch (BadPaddingException e) {
				e.printStackTrace();
			} catch (IllegalBlockSizeException e) {
				e.printStackTrace();
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	/**
	 * Takes a encrypted String as an argument, decrypts and returns the decrypted
	 * String.
	 * 
	 * @param str Encrypted String to be decrypted
	 * @return <code>String</code> Decrypted version of the provided String
	 */
	public String decrypt(String str) {

		if (str != null && str.length() > 0) {
			try {

				Base64.Decoder decoder = Base64.getDecoder();
				// Decode base64 to get bytes
				byte[] dec = decoder.decode(str);

				// Decrypt
				byte[] utf8 = dcipher.doFinal(dec);

				// Decode using utf-8
				return new String(utf8, "UTF8");

			} catch (BadPaddingException e) {

			} catch (IllegalBlockSizeException e) {
			} catch (UnsupportedEncodingException e) {
			} catch (Exception e) {
			}
		}
		return null;
		
	}
	
	public static void doEncryption(String plaintext) {
		String passPhrase = System.getProperty("passphrase");
		String keyLength = System.getProperty("keylength");
		String iterationCount = System.getProperty("iterationcount");
		
		int keylen = DEFAULT_KEY_LENGTH;
		int itrcnt = DEFAULT_ITERATION_COUNT;
		

		if (passPhrase == null) {
			System.out.println("Please enter the passphrase with param -Dpassphrase");
			System.out.println("Example : java -jar -Dpassphrase=\"This is the passphrase\" crpyto-1.0.jar <plaintext>");
			System.exit(1);
		}
		
		try {
			keylen = Integer.parseInt(keyLength);			
		}catch (Exception e) {
			// TODO: handle exception
		}
		
		try {
			itrcnt = Integer.parseInt(iterationCount);			
		}catch (Exception e) {
			// TODO: handle exception
		}

		EncrypterAes desEncrypter = new EncrypterAes(passPhrase, keylen, itrcnt);

		String type = null;

		String desEncrypted = desEncrypter.encrypt(plaintext);
		System.out.println("    Original String		: " + plaintext);
		System.out.println("    Pass Phrase			: " + passPhrase);
		System.out.println("    Key Length			: " + keylen);
		System.out.println("    Iteration Count		: " + itrcnt);
		System.out.println("    Encrypted String		: " + desEncrypted);
		System.out.println("    Decrypted String		: " + desEncrypter.decrypt(desEncrypted));
	}
	
	public static char[] generatePassword(int length) {
		String capitalCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		String lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
		String specialCharacters = "!@#$";
		String numbers = "1234567890";
		String combinedChars = capitalCaseLetters + lowerCaseLetters + specialCharacters + numbers;
		SecureRandom random = new SecureRandom();
		char[] password = new char[length];

		password[0] = lowerCaseLetters.charAt(random.nextInt(lowerCaseLetters.length()));
		password[1] = capitalCaseLetters.charAt(random.nextInt(capitalCaseLetters.length()));
		password[2] = specialCharacters.charAt(random.nextInt(specialCharacters.length()));
		password[3] = numbers.charAt(random.nextInt(numbers.length()));

		for (int i = 4; i < length; i++) {
			password[i] = combinedChars.charAt(random.nextInt(combinedChars.length()));
		}
		return password;
	}
	
	/*public static void testEncryption() {

		System.out.println("+----------------------------------------+");
		System.out.println("|  -- Test Using Pass Phrase --   |");
		System.out.println("+----------------------------------------+");

		String secretString = "Alert1234";

		EncrypterAes desEncrypter = new EncrypterAes("This is the passphrase", DEFAULT_KEY_LENGTH, DEFAULT_ITERATION_COUNT);

		String desEncrypted = desEncrypter.encrypt(secretString);
		//desEncrypted = "x3xmLxu8qmlmt8yYQHlNLNHf3WEyICjfoQ==";
		String desDecrypted = desEncrypter.decrypt(desEncrypted);

		System.out.println("    Original String  : " + secretString);
		System.out.println("    Encrypted String : " + desEncrypted);
		System.out.println("    Decrypted String : " + desDecrypted);
		System.out.println();

	}*/

}
