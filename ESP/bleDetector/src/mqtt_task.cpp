#include <Arduino.h>
#include <esp_log.h>
#include "ble_task.h"
#include "mqtt_task.h"



// static variables
const char* ssid = "AIS 4G Hi-Speed Home WiFi_694284";
const char* password = "51694284";
//const char* ssid = "true_home5G_3F9";
//const char* password = "B44FA3F9";

const char* mqtt_broker = "broker.hivemq.com";
//const char* mqtt_broker = "192.168.1.168";
const int mqtt_port = 1883;
const char* mqtt_client_id = "Suradit-p";
const char* pub_topic = "ict720/suradit/data";
const char* sub_topic = "???";
WiFiClient espClient;
PubSubClient mqttClient(espClient);
DynamicJsonDocument doc(1024);

// static functions

// constant definitions
#define TAG             "MQTT TASK"

// callback function
void mqtt_callback(char* topic, byte* payload, unsigned int length) {
    char buf[256];
    memcpy(buf, payload, length);
    buf[length] = 0;
    deserializeJson(doc, buf);
    if (doc["led"] == "on") {
        //displayhere
        ESP_LOGW(TAG, "Got LED ON command");
    }
}

// MQTT task handler
void mqtt_task_handler(void *pvParameters) {
    // setup:
    // - connect to wifi

    WiFi.mode(WIFI_OFF);
    vTaskDelay(100 / portTICK_PERIOD_MS);
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        vTaskDelay(500 / portTICK_PERIOD_MS);
    }
    ESP_LOGW(TAG, "WiFi connected: %s", WiFi.localIP().toString().c_str());
    // - connect to mqtt broker
    mqttClient.setServer(mqtt_broker, mqtt_port);
    mqttClient.setCallback(mqtt_callback);
    mqttClient.connect(mqtt_client_id);
    // - subscribe to topics
    mqttClient.subscribe(sub_topic);
    // loop: 
    while(1) {
        // wait for message from BLE task
        // - if message received, publish to mqtt broker
        ble_msg_t ble_msg;
        char msg_buf[256];
        if (xQueueReceive(bleQueue, &ble_msg, 1000/portTICK_PERIOD_MS) == pdTRUE) {
            ESP_LOGW(TAG, "MQTT task running");
            ESP_LOGW(TAG, "Queue received %s: %d", ble_msg.addr.toString().c_str(), ble_msg.rssi);
            if (ble_msg.rssi > -50) {
                doc["addr"] = ble_msg.addr.toString().c_str();
                doc["rssi"] = ble_msg.rssi;
                serializeJson(doc, msg_buf);
                mqttClient.publish(pub_topic, msg_buf);
            }
        }
        mqttClient.loop();
    }
}