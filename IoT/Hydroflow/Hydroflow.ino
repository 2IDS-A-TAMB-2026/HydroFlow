// ============================================================
// HYDROFLOW
// ESP32 + DHT11 + Sensor de Umidade do Solo + RELÉ/BOMBA
// SEM NTP / SEM DATA E HORA
// DDS_STATUS: 0 = SEM FALHA | 1 = FALHA
// ============================================================

#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include "DHT.h"


// ============================================================
// WI-FI
// ============================================================

const char* ssid = "WIFI-EDUC";
const char* password = "ac3ce7ss0-EDUC";


// ============================================================
// API
// ============================================================

const char* serverUrl =
  "http://10.141.131.69/HydroFlow/public/api/dados_sensores";


// ============================================================
// SENSOR DE SOLO
// ============================================================

#define PINO_HIGROMETRO 34

#define SENSOR_ID 1

#define VALOR_SECO 4095
#define VALOR_MOLHADO 1639


// ============================================================
// RELÉ / BOMBA
// ============================================================

#define PINO_RELE 33

#define LIMITE_UMIDADE 70.0


// ============================================================
// DHT11
// ============================================================

#define DHTPIN 4
#define DHTTYPE DHT11

DHT dht(DHTPIN, DHTTYPE);


// ============================================================
// STATUS
// ============================================================

// 0 = nenhuma falha identificada
// 1 = falha identificada

int DDS_STATUS = 0;


// ============================================================
// CONECTAR AO WI-FI
// ============================================================

void conectarWiFi() {

  Serial.println();
  Serial.println("Conectando ao Wi-Fi...");

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  int tentativas = 0;

  while (WiFi.status() != WL_CONNECTED &&
         tentativas < 30) {

    delay(500);

    Serial.print(".");

    tentativas++;
  }

  Serial.println();

  if (WiFi.status() == WL_CONNECTED) {

    Serial.println("Wi-Fi conectado!");

    Serial.print("IP: ");
    Serial.println(WiFi.localIP());

  } else {

    Serial.println(
      "ERRO: Nao foi possivel conectar ao Wi-Fi."
    );

    Serial.print("Status Wi-Fi: ");
    Serial.println(WiFi.status());
  }
}


// ============================================================
// LER UMIDADE DO SOLO
// ============================================================

float lerUmidadeSolo() {

  int valorAnalogico = analogRead(PINO_HIGROMETRO);

  float umidade =
    (VALOR_SECO - valorAnalogico) * 100.0 /
    (VALOR_SECO - VALOR_MOLHADO);


  // Limitar entre 0 e 100

  if (umidade < 0) {
    umidade = 0;
  }

  if (umidade > 100) {
    umidade = 100;
  }


  Serial.print("Valor analogico: ");
  Serial.println(valorAnalogico);

  Serial.print("Umidade do solo: ");
  Serial.print(umidade, 1);
  Serial.println(" %");


  return umidade;
}


// ============================================================
// CONTROLE DA BOMBA
// ============================================================

void controlarBomba(float umidadeSolo) {

  Serial.println();
  Serial.println("CONTROLE DA BOMBA");


  // Verificar se a leitura do solo e valida

  if (isnan(umidadeSolo) ||
      umidadeSolo < 0 ||
      umidadeSolo > 100) {

    Serial.println("FALHA: Leitura do solo invalida.");

    DDS_STATUS = 1;

    // Desligar a bomba por seguranca
    digitalWrite(PINO_RELE, HIGH);

    return;
  }


  // Solo seco: solicitar acionamento da bomba

  if (umidadeSolo < LIMITE_UMIDADE) {

    digitalWrite(PINO_RELE, LOW);

    Serial.println("SOLO SECO");
    Serial.println("COMANDO DE BOMBA LIGADA ENVIADO.");

    // IMPORTANTE:
    // digitalWrite() nao confirma que a bomba
    // realmente ligou.
    //
    // Para detectar falha fisica de acionamento,
    // sera necessario um sensor de retorno.

  } else {

    digitalWrite(PINO_RELE, HIGH);

    Serial.println("SOLO UMIDO");
    Serial.println("BOMBA DESLIGADA");
  }
}


// ============================================================
// ENVIAR DADOS PARA API
// ============================================================

void enviarDados(
  float temperatura,
  float umidadeAr,
  float umidadeSolo
) {

  if (WiFi.status() != WL_CONNECTED) {

    Serial.println("Wi-Fi desconectado!");

    conectarWiFi();

    if (WiFi.status() != WL_CONNECTED) {

      Serial.println(
        "Nao foi possivel reconectar ao Wi-Fi."
      );

      return;
    }
  }


  HTTPClient http;

  http.begin(serverUrl);

  http.addHeader(
    "Content-Type",
    "application/json"
  );


  // ==========================================================
  // CRIAR JSON
  // ==========================================================

  StaticJsonDocument<256> json;


  json["DDS_TEMP"] = temperatura;
  json["DDS_UMIDADE"] = umidadeAr;
  json["DDS_UMIDADE_SOLO"] = umidadeSolo;
  json["FK_SEN_ID"] = SENSOR_ID;

  // Enviar o status da medicao
  // 0 = sem falha identificada
  // 1 = falha identificada

  json["DDS_STATUS"] = DDS_STATUS;


  String dados;

  serializeJson(json, dados);


  // ==========================================================
  // MOSTRAR DADOS
  // ==========================================================

  Serial.println();
  Serial.println("Enviando para API:");
  Serial.println(dados);

  Serial.print("DDS_STATUS: ");
  Serial.println(DDS_STATUS);


  // ==========================================================
  // ENVIAR
  // ==========================================================

  int resposta = http.POST(dados);

  Serial.print("Codigo HTTP: ");
  Serial.println(resposta);

  String retorno = http.getString();

  Serial.println("Resposta da API:");
  Serial.println(retorno);


  if (resposta >= 200 && resposta < 300) {

    Serial.println("Dados enviados com sucesso!");

  } else {

    Serial.println("Erro ao enviar dados.");
  }


  http.end();
}


// ============================================================
// SETUP
// ============================================================

void setup() {

  Serial.begin(115200);

  Serial.println();
  Serial.println("================================");
  Serial.println("       HYDROFLOW INICIADO");
  Serial.println("================================");


  // SENSOR DE SOLO

  pinMode(PINO_HIGROMETRO, INPUT);

  analogReadResolution(12);


  // RELE

  pinMode(PINO_RELE, OUTPUT);

  // Bomba desligada ao iniciar
  digitalWrite(PINO_RELE, HIGH);


  // DHT11

  dht.begin();


  // WI-FI

  conectarWiFi();


  Serial.println();
  Serial.println("DHT11: GPIO 4");
  Serial.println("Sensor de solo: GPIO 34");
  Serial.println("Rele/Bomba: GPIO 33");
  Serial.println("Limite de umidade do solo: 70%");
  Serial.println("DDS_STATUS habilitado");

  Serial.println("================================");
}


// ============================================================
// LOOP
// ============================================================

void loop() {

  Serial.println();
  Serial.println("================================");
  Serial.println("          NOVA LEITURA");
  Serial.println("================================");


  // ==========================================================
  // REINICIAR STATUS PARA CADA NOVA LEITURA
  // ==========================================================

  DDS_STATUS = 0;


  // ==========================================================
  // DHT11
  // ==========================================================

  float temperatura = dht.readTemperature();
  float umidadeAr = dht.readHumidity();


  // ==========================================================
  // VERIFICAR MEDICOES DO DHT11
  // ==========================================================

  if (isnan(temperatura) || isnan(umidadeAr)) {

    Serial.println("FALHA: Erro na leitura do DHT11.");

    DDS_STATUS = 1;

  } else {

    Serial.print("Temperatura: ");
    Serial.print(temperatura, 1);
    Serial.println(" C");


    Serial.print("Umidade do ar: ");
    Serial.print(umidadeAr, 1);
    Serial.println(" %");


    // Verificar se a umidade do ar esta fora
    // do intervalo permitido de 0 a 100%.

    if (umidadeAr > 100 || umidadeAr < 0) {

      Serial.println(
        "FALHA: Umidade do ar fora do intervalo!"
      );

      DDS_STATUS = 1;
    }


    // Verificar se a temperatura e plausivel
    // para o DHT11 (- nao substitui diagnostico fisico).

    if (temperatura < 0 || temperatura > 50) {

      Serial.println(
        "FALHA: Temperatura fora do intervalo esperado."
      );

      DDS_STATUS = 1;
    }
  }


  // ==========================================================
  // SENSOR DE SOLO
  // ==========================================================

  float umidadeSolo = lerUmidadeSolo();


  // ==========================================================
  // CONTROLE DA BOMBA
  // ==========================================================

  controlarBomba(umidadeSolo);


  // ==========================================================
  // RESULTADO DO STATUS
  // ==========================================================

  Serial.println();
  Serial.println("================================");

  if (DDS_STATUS == 1) {

    Serial.println("STATUS: FALHA IDENTIFICADA");

  } else {

    Serial.println("STATUS: SEM FALHA IDENTIFICADA");
  }

  Serial.println("================================");


  // ==========================================================
  // ENVIAR DADOS PARA API
  // ==========================================================

  // Enviar os dados mesmo quando uma medicao
  // apresentar falha, desde que sejam numericamente
  // validos para o JSON.

  if (!isnan(temperatura) &&
      !isnan(umidadeAr) &&
      temperatura >= 0 &&
      temperatura <= 50 &&
      umidadeAr >= 0 &&
      umidadeAr <= 100) {

    enviarDados(
      temperatura,
      umidadeAr,
      umidadeSolo
    );

  } else {

    Serial.println(
      "Dados invalidos: envio para API cancelado."
    );

    Serial.println(
      "DDS_STATUS = 1 (falha na medicao)"
    );
  }


  // ==========================================================
  // ESPERAR 5 SEGUNDOS
  // ==========================================================

  Serial.println();
  Serial.println("Aguardando 5 segundos...");

  delay(5000);
} 



CODIGO CERTO DESSA PRR DE IOT KR