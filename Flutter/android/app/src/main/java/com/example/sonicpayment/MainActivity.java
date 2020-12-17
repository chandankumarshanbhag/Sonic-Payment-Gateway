package com.example.sonicpayment;

import android.app.Activity;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.widget.Toast;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.nio.charset.Charset;

import io.chirp.chirpsdk.ChirpSDK;
import io.chirp.chirpsdk.models.ChirpError;
import io.chirp.chirpsdk.interfaces.ChirpEventListener;

import static io.flutter.embedding.engine.systemchannels.SettingsChannel.CHANNEL_NAME;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL_SONIC = "com.example.sonicpayment/sonic";
    String CHIRP_APP_KEY = "dDEdeeDCB0CEd690a22c1DCF9";
    String CHIRP_APP_SECRET = "e441133fAabc1A02fFBb1a85fCeF5D8FB5eFd7CAece2F9C46a";
    String CHIRP_APP_CONFIG = "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";
    private ChirpSDK chirpSdk;
    MethodChannel.Result parentResult;


    @Override
    protected void onPause() {
        super.onPause();
        chirpSdk.stop();
    }
    @Override
    public void onDestroy() {
        super.onDestroy();
        chirpSdk.stop();
        try {
            chirpSdk.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        chirpSdk = new ChirpSDK(getApplicationContext(), CHIRP_APP_KEY, CHIRP_APP_SECRET);
        ChirpError error = chirpSdk.setConfig(CHIRP_APP_CONFIG);
        if (error.getCode() == 0) {
            Log.v("ChirpSDK: ", "Configured ChirpSDK");
        } else {
            Log.e("ChirpError: ", error.getMessage());
        }


        new MethodChannel(getFlutterView(), CHANNEL_SONIC).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        parentResult = result;
                        if (call.method.equals("send_audio")) {
                            ChirpError error = chirpSdk.start(true, true);
                            if (error.getCode() > 0) {
                                Log.e("ChirpError: ", error.getMessage());
                            } else {
                                Log.v("ChirpSDK: ", "Started ChirpSDK");
                            }
                            String identifier = call.argument("text").toString();
                            //String identifier = call.argument("text").toString();
                            //Toast.makeText(getApplicationContext(),call.argument("text").toString(),Toast.LENGTH_LONG).show();
                            byte[] payload = identifier.getBytes(Charset.forName("UTF-8"));
                            error = chirpSdk.send(payload);
                            if (error.getCode() > 0) {
                                Log.e("ChirpError: ", error.getMessage());
                                //Toast.makeText(getApplicationContext(),error.getMessage(),Toast.LENGTH_LONG).show();
                            } else {
                                Log.v("ChirpSDK: ", "Sent " + identifier);
                            }
                            result.success("done");
                            //chirpSdk.stop();
                        }
                        else{
                            try{
                                ChirpError error = chirpSdk.start(true, true);
                                if (error.getCode() > 0) {
                                    Log.e("ChirpError: ", error.getMessage());
                                } else {
                                    Log.v("ChirpSDK: ", "Started ChirpSDK");
                                }
                                ChirpEventListener chirpEventListener = new ChirpEventListener() {
                                    @Override
                                    public void onSent(@NotNull byte[] bytes, int i) {}

                                    @Override
                                    public void onSending(@NotNull byte[] bytes, int i) {

                                    }

                                    @Override
                                    public void onReceived(byte[] data, int channel) {
                                        try {
                                            if (data != null) {
                                                final String identifier = new String(data);
                                                Log.v("ChirpSDK: ", "Received " + identifier);
                                                chirpSdk.stop();
                                                runOnUiThread(() -> {
                                                    result.success(identifier);
                                                });
                                            } else {
                                                Log.e("ChirpError: ", "Decode failed");
                                                Log.e("ChirpError: ", error.getMessage());

                                                //Toast.makeText(getApplicationContext(), error.getMessage(), Toast.LENGTH_LONG).show();
                                            }
                                        }catch(Exception e){
                                            Log.e("ChirpError: ", "Decode failed");
                                            Log.e("ChirpError: ", e.getMessage());
                                            Toast.makeText(getApplicationContext(), error.getMessage(), Toast.LENGTH_LONG).show();
                                            //result.success(identifier);
                                        }
                                    }

                                    @Override
                                    public void onReceiving(int i) {

                                    }

                                    @Override
                                    public void onStateChanged(int i, int i1) {

                                    }

                                    @Override
                                    public void onSystemVolumeChanged(float v, float v1) {

                                    }
                                };

                                chirpSdk.setListener(chirpEventListener);
                            }
                            catch(Exception e){
                                Log.e("ChirpError: ", error.getMessage());
                                Toast.makeText(getApplicationContext(),error.getMessage(),Toast.LENGTH_LONG).show();

                            }


                        }

                    }

                });





    }






}







//new MethodChannel(getFlutterView(), CHANNEL_SONIC).setMethodCallHandler(
//        new MethodChannel.MethodCallHandler() {
//@Override
//public void onMethodCall(MethodCall call, MethodChannel.Result result) {=
//        if (call.method.equals("send_audio")) {
//        ChirpError error = chirpSdk.start(true, true);
//        if (error.getCode() > 0) {
//        Log.e("ChirpError: ", error.getMessage());
//        } else {
//        Log.v("ChirpSDK: ", "Started ChirpSDK");
//        }
//        String identifier = "hello";
//        byte[] payload = identifier.getBytes(Charset.forName("UTF-8"));
//        error = chirpSdk.send(payload);
//        if (error.getCode() > 0) {
//        Log.e("ChirpError: ", error.getMessage());
//        Toast.makeText(getApplicationContext(),error.getMessage(),Toast.LENGTH_LONG).show();
//        } else {
//        Log.v("ChirpSDK: ", "Sent " + identifier);
//        }
//        result.success("done");
//        //chirpSdk.stop();
//        }
//        else{
//        try{
//        ChirpError error = chirpSdk.start(true, true);
//        if (error.getCode() > 0) {
//        Log.e("ChirpError: ", error.getMessage());
//        } else {
//        Log.v("ChirpSDK: ", "Started ChirpSDK");
//        }
//        ChirpEventListener chirpEventListener = new ChirpEventListener() {
//@Override
//public void onSent(@NotNull byte[] bytes, int i) {}
//
//@Override
//public void onSending(@NotNull byte[] bytes, int i) {
//
//        }
//
//@Override
//public void onReceived(byte[] data, int channel) {
//        String identifier = "";
//        try {
//        if (data != null) {
//        identifier = new String(data);
//        Log.v("ChirpSDK: ", "Received " + identifier);
//        result.success(identifier);
//        } else {
//        Log.e("ChirpError: ", "Decode failed");
//        Log.e("ChirpError: ", error.getMessage());
//        Toast.makeText(getApplicationContext(), error.getMessage(), Toast.LENGTH_LONG).show();
//        }
//        }catch(Exception e){
//        Log.e("ChirpError: ", "Decode failed");
//        Log.e("ChirpError: ", e.getMessage());
//        Toast.makeText(getApplicationContext(), error.getMessage(), Toast.LENGTH_LONG).show();
//        }
//        }
//
//@Override
//public void onReceiving(int i) {
//
//        }
//
//@Override
//public void onStateChanged(int i, int i1) {
//
//        }
//
//@Override
//public void onSystemVolumeChanged(float v, float v1) {
//
//        }
//        };
//
//        chirpSdk.setListener(chirpEventListener);
//        }
//        catch(Exception e){
//        Log.e("ChirpError: ", error.getMessage());
//        Toast.makeText(getApplicationContext(),error.getMessage(),Toast.LENGTH_LONG).show();
//
//        }
//
//
//        }
//        }});

