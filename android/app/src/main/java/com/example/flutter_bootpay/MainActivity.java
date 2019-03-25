package com.example.flutter_bootpay;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterView;


import android.content.Intent;
import android.util.Log;
import android.widget.Button;
import android.widget.TextView;

import io.flutter.plugin.common.StringCodec;
import io.flutter.view.FlutterMain;
import io.flutter.view.FlutterRunArguments;
import java.util.ArrayList;


import kr.co.bootpay.Bootpay;
import kr.co.bootpay.BootpayAnalytics;
import kr.co.bootpay.BootpayFlutterActivity;
import kr.co.bootpay.enums.Method;
import kr.co.bootpay.enums.PG;

public class MainActivity extends BootpayFlutterActivity {

  private FlutterView flutterView;
  private int counter;
  private static final String CHANNEL = "increment";
  private static final String EMPTY_MESSAGE = "";
  private static final String PING = "ping";
  private BasicMessageChannel<String> messageChannel;

  private String[] getArgsFromIntent(Intent intent) {
    // Before adding more entries to this list, consider that arbitrary
    // Android applications can generate intents with extra data and that
    // there are many security-sensitive args in the binary.
    ArrayList<String> args = new ArrayList<>();
    if (intent.getBooleanExtra("trace-startup", false)) {
      args.add("--trace-startup");
    }
    if (intent.getBooleanExtra("start-paused", false)) {
      args.add("--start-paused");
    }
    if (intent.getBooleanExtra("enable-dart-profiling", false)) {
      args.add("--enable-dart-profiling");
    }
    if (!args.isEmpty()) {
      String[] argsArray = new String[args.size()];
      return args.toArray(argsArray);
    }
    return null;
  }


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    String[] args = getArgsFromIntent(getIntent());
//    GeneratedPluginRegistrant.registerWith(this);
    FlutterMain.ensureInitializationComplete(getApplicationContext(), args);

    setContentView(R.layout.activity_main);

    FlutterRunArguments runArguments = new FlutterRunArguments();
    runArguments.bundlePath = FlutterMain.findAppBundlePath(getApplicationContext());
    runArguments.entrypoint = "main";

    flutterView = findViewById(R.id.flutter_view);
    flutterView.runFromBundle(runArguments);

    messageChannel = new BasicMessageChannel<>(flutterView, CHANNEL, StringCodec.INSTANCE);
    messageChannel.
            setMessageHandler((s, reply) -> {
                onFlutterIncrement();
              reply.reply(EMPTY_MESSAGE);
            });

    findViewById(R.id.button).setOnClickListener(v -> {
      sendAndroidIncrement();
    });
    findViewById(R.id.bp_button).setOnClickListener(v -> {
      bootpayRequest();
    });
  }



  private void sendAndroidIncrement() {
    messageChannel.send(PING);
  }

  private void onFlutterIncrement() {
    counter++;
    TextView textView = findViewById(R.id.button_tap);
    String value = "Flutter button tapped " + counter + (counter == 1 ? " time" : " times");
    textView.setText(value);
  }

  @Override
  protected void onDestroy() {
    if (flutterView != null) {
      flutterView.destroy();
    }
    super.onDestroy();
  }

  @Override
  protected void onPause() {
    super.onPause();
    flutterView.onPause();
  }

  @Override
  protected void onPostResume() {
    super.onPostResume();
    flutterView.onPostResume();
  }

  private void bootpayRequest() {
    BootpayAnalytics.init(this, "5b57f207396fa673f464f7bd");
    Bootpay.init(getFragmentManager())
            .setApplicationId("5b14c0ffb6d49c40cda92c4e") // 해당 프로젝트(안드로이드)의 application id 값
            .setPG(PG.DANAL) // 결제할 PG 사
//                .setUserPhone("010-1234-5678") // 구매자 전화번호
            .setMethod(Method.CARD) // 결제수단
            //.isShowAgree(true)
            .setName("맥북프로임다") // 결제할 상품명
            .setOrderId("1234") // 결제 고유번호
            .setPrice(1000) // 결제할 금액
            .addItem("마우스", 1, "ITEM_CODE_MOUSE", 100) // 주문정보에 담길 상품정보, 통계를 위해 사용
            .addItem("키보드", 1, "ITEM_CODE_KEYBOARD", 200, "패션", "여성상의", "블라우스") // 주문정보에 담길 상품정보, 통계를 위해 사용
            .onConfirm(this)
            .onDone(this)
            .onReady(this)
            .onCancel(this)
            .onError(this)
            .onClose(this)
            .request();
  }

  @Override
  public void onError(String message) {
    Log.d("bootpay  error", message);
  }

  @Override
  public void onCancel(String message) {
    Log.d("bootpay  cancel", message);
  }

  @Override
  public void onClose(String message) {
    Log.d("bootpay  close", "close");
  }

  @Override
  public void onReady(String message) {
    Log.d("bootpay  ready", message);
  }

  @Override
  public void onConfirm(String message) {
    Log.d("bootpay  confirm", message);
  }

  @Override
  public void onDone(String message) {
    Log.d("bootpay  done", message);
  }
}
