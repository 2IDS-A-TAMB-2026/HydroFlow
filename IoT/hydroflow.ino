// ============================================================
// HYDROFLOW
// ESP32 + DHT11 + Sensor de Umidade do Solo + RELÉ/BOMBA
// SEM NTP / SEM DATA E HORA
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
  "http://10.141.131.38/HydroFlow/public/api/dados_sensores";


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

// Abaixo de 70% = solo seco = liga bomba
#define LIMITE_UMIDADE 70.0


// ============================================================
// DHT11
// ============================================================

#define DHTPIN 4
#define DHTTYPE DHT11

DHT dht(DHTPIN, DHTTYPE);


// ============================================================
// CONECTAR AO WI-FI
// ============================================================

void conectarWiFi() {

  Serial.print("Conectando ao Wi-Fi");

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {

    delay(500);
    Serial.print(".");
  }

  Serial.println();
  Serial.println("Wi-Fi conectado!");

  Serial.print("IP: ");
  Serial.println(WiFi.localIP());
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
  Serial.println("----- CONTROLE DA BOMBA -----");


  // SOLO SECO
  if (umidadeSolo < LIMITE_UMIDADE) {

    // Relé ativo em LOW
    digitalWrite(PINO_RELE, LOW);

    Serial.println("SOLO SECO");
    Serial.println("BOMBA LIGADA");
    Serial.println("RELE: LOW");

  }


  // SOLO ÚMIDO
  else {

    // Relé desligado em HIGH
    digitalWrite(PINO_RELE, HIGH);

    Serial.println("SOLO UMIDO");
    Serial.println("BOMBA DESLIGADA");
    Serial.println("RELE: HIGH");
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

    // Tentar conectar novamente
    conectarWiFi();

    if (WiFi.status() != WL_CONNECTED) {
      Serial.println("Não foi possível reconectar ao Wi-Fi.");
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


  String dados;

  serializeJson(json, dados);


  // ==========================================================
  // MOSTRAR DADOS
  // ==========================================================

  Serial.println();
  Serial.println("Enviando para API:");
  Serial.println(dados);


  // ==========================================================
  // ENVIAR
  // ==========================================================

  int resposta = http.POST(dados);


  Serial.print("Codigo HTTP: ");
  Serial.println(resposta);


  if (resposta >= 200 && resposta < 300) {

    Serial.println("Dados enviados com sucesso!");

  } else {

    Serial.println("Erro ao enviar dados.");

    if (resposta > 0) {

      Serial.print("Resposta da API: ");
      Serial.println(http.getString());
    }
  }


  http.end();
}


// ============================================================
// SETUP
// ============================================================

void setup() {

  Serial.begin(115200);

  delay(1000);


  Serial.println();
  Serial.println("================================");
  Serial.println("       HYDROFLOW INICIADO");
  Serial.println("================================");


  // ==========================================================
  // SENSOR DE SOLO
  // ==========================================================

  pinMode(PINO_HIGROMETRO, INPUT);

  analogReadResolution(12);


  // ==========================================================
  // RELÉ
  // ==========================================================

  pinMode(PINO_RELE, OUTPUT);

  // Bomba desligada ao iniciar
  digitalWrite(PINO_RELE, HIGH);


  // ==========================================================
  // DHT11
  // ==========================================================

  dht.begin();


  // ==========================================================
  // WI-FI
  // ==========================================================

  conectarWiFi();


  Serial.println();
  Serial.println("DHT11: GPIO 4");
  Serial.println("Sensor de solo: GPIO 34");
  Serial.println("Rele/Bomba: GPIO 33");
  Serial.println("Limite: 70%");
  Serial.println("API: HydroFlow");

  Serial.println("================================");
}


// ============================================================
// LOOP
// ============================================================

void loop() {

  Serial.println();
  Serial.println("================================");
  Serial.println("       NOVA LEITURA");
  Serial.println("================================");


  // ==========================================================
  // DHT11
  // ==========================================================

  float temperatura = dht.readTemperature();
  float umidadeAr = dht.readHumidity();


  if (isnan(temperatura) || isnan(umidadeAr)) {

    Serial.println("Erro ao ler o DHT11.");

  } else {

    Serial.print("Temperatura: ");
    Serial.print(temperatura, 1);
    Serial.println(" C");

    Serial.print("Umidade do ar: ");
    Serial.print(umidadeAr, 1);
    Serial.println(" %");
  }


  // ==========================================================
  // SENSOR DE SOLO
  // ==========================================================

  float umidadeSolo = lerUmidadeSolo();


  // ==========================================================
  // BOMBA
  // ==========================================================

  controlarBomba(umidadeSolo);


  // ==========================================================
  // API
  // ==========================================================

  if (!isnan(temperatura) && !isnan(umidadeAr)) {

    enviarDados(
      temperatura,
      umidadeAr,
      umidadeSolo
    );
  }


  // ==========================================================
  // ESPERAR
  // ==========================================================

  Serial.println();
  Serial.println("Aguardando 20 segundos...");

  delay(20000);
}