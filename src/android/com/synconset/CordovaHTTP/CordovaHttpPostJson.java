/**
 * A HTTP plugin for Cordova / Phonegap
 */
package com.synconset;

import java.net.UnknownHostException;
import java.util.Map;

import org.apache.cordova.CallbackContext;
import org.json.JSONException;
import org.json.JSONObject;

import javax.net.ssl.SSLHandshakeException;

import android.util.Log;

import com.github.kevinsawicki.http.HttpRequest;
import com.github.kevinsawicki.http.HttpRequest.HttpRequestException;
 
public class CordovaHttpPostJson extends CordovaHttp implements Runnable {
    
    public CordovaHttpPostJson(String urlString, JSONObject jsonObj, Map<String, String> headers, CallbackContext callbackContext) {
        super(urlString, jsonObj, headers, callbackContext);
    }
    
    @Override
    public void run() {
        try {
            HttpRequest request = HttpRequest.post(this.getUrlString());
            this.setupSecurity(request);
            request.headers(this.getHeaders());
            request.acceptJson();
            request.contentType(HttpRequest.CONTENT_TYPE_JSON);
            request.send(getJsonObject().toString());
            int code = request.code();
            String body = request.body(CHARSET);
            JSONObject response = new JSONObject();
            response.put("status", code);
			JSONObject intestazioni = new JSONObject();
			for (Map.Entry entry: request.headers().entrySet()) {
				if (entry.getKey() != null) {
					if(entry.getValue()!=null){
						String valore = entry.getValue().toString();
						intestazioni.put(entry.getKey().toString(), valore.substring(1, valore.length()-1));
					}
					else
						intestazioni.put(entry.getKey().toString(), null);
				} 
			}
			response.put("headersJSON", intestazioni);
			response.put("headers", request.headers());
			
            if (code >= 200 && code < 300) {
                response.put("data", body);
                this.getCallbackContext().success(response);
            } else {
                response.put("error", body);
                this.getCallbackContext().error(response);
            }
        } catch (JSONException e) {
            this.respondWithError("There was an error generating the response");
        }  catch (HttpRequestException e) {
            if (e.getCause() instanceof UnknownHostException) {
                this.respondWithError(0, "The host could not be resolved");
            } else if (e.getCause() instanceof SSLHandshakeException) {
                this.respondWithError("SSL handshake failed");
            } else {
                this.respondWithError("There was an error with the request");
            }
        }
    }
}
