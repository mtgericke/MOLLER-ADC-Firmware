#include <string.h>
#include "discovery.h"

static uint8_t* create_beacon_in_mem(uint8_t* buffer, uint32_t buff_len, char* version_str, uint64_t uptime, uint64_t devID, uint64_t logicalID, const char*  hwRev, const char*  fwRev, const char* vendor, const char* product);

const uint8_t* discovery_create_beacon(tDiscoveryContext* ctx, uint64_t devID, uint64_t logicalID, const char*  hwRev, const char*  fwRev, const char* vendor, const char* product) {
    if(!ctx) {
        return 0;
    }

    ctx->last_uptime = 0;

    return create_beacon_in_mem(ctx->msg, DISCOVERY_BEACON_LEN, DISCOVERY_BEACON_STR, 0, devID, logicalID, hwRev, fwRev, vendor, product);
}

const uint8_t* discovery_create_request(uint8_t* buff, uint32_t buffLen, uint64_t devID, uint64_t logicalID, const char*  hwRev, const char*  fwRev, const char* vendor, const char* product) {
    if(!buff) {
        return 0;
    }

    return create_beacon_in_mem(buff, buffLen, DISCOVERY_REQUEST_STR, 0, devID, logicalID, hwRev, fwRev, vendor, product);
}

const uint8_t* discovery_process_request(tDiscoveryContext* ctx, const uint8_t* rx, uint32_t rx_len, uint64_t uptime) {
    tDiscoveryBeaconInfo beacon;
    tDiscoveryBeaconInfo request;

    if(!ctx) {
        return 0;
    }

    if(!rx) {
       return 0;
    }

    if(rx_len < DISCOVERY_BEACON_LEN) {
        return 0;
    }

    // Requests are pretty much beacons with a different 6 character code at the start
    if(!discovery_convert_mem_to_beacon(&request, rx, rx_len)) {
        return 0;
    }

    if(!request.isRequest) {
        return 0;
    }

    if(!discovery_convert_mem_to_beacon(&beacon, ctx->msg, DISCOVERY_BEACON_LEN)) {
        return 0;
    }

    if((uptime - ctx->last_uptime) < DISCOVERY_MIN_DELAY) {
        return 0;
    }

    ctx->last_uptime = uptime;

    if((request.deviceID != DISCOVERY_DONT_CARE) && (beacon.deviceID != request.deviceID)) {
        return 0;
    }

    if((request.logicalID != DISCOVERY_DONT_CARE) && (beacon.logicalID != request.logicalID)) {
        return 0;
    }

    if((request.hardwareRevision[0] != '\0') && ((strncasecmp(beacon.hardwareRevision,request.hardwareRevision, DISCOVERY_HW_REV_LEN) != 0))) {
        return 0;
    }

    if((request.firmwareRevision[0] != '\0') && ((strncasecmp(beacon.firmwareRevision,request.firmwareRevision, DISCOVERY_FW_REV_LEN) != 0))) {
        return 0;
    }

    if((request.vendorName[0] != '\0') && ((strncasecmp(beacon.vendorName,request.vendorName, DISCOVERY_VENDOR_LEN) != 0))) {
        return 0;
    }

    if((request.productName[0] != '\0') && ((strncasecmp(beacon.productName,request.productName, DISCOVERY_PRODUCT_LEN) != 0))) {
        return 0;
    }

    ctx->msg[8] = (uptime >> 0) & 0xFF;
    ctx->msg[9] = (uptime >> 8) & 0xFF;
    ctx->msg[10] = (uptime >> 16) & 0xFF;
    ctx->msg[11] = (uptime >> 24) & 0xFF;
    ctx->msg[12] = (uptime >> 32) & 0xFF;
    ctx->msg[13] = (uptime >> 40) & 0xFF;
    ctx->msg[14] = (uptime >> 48) & 0xFF;
    ctx->msg[15] = (uptime >> 56) & 0xFF;

    return ctx->msg;
}

tDiscoveryBeaconInfo* discovery_convert_mem_to_beacon(tDiscoveryBeaconInfo* beacon, const uint8_t* buffer, uint32_t buff_len) {

    if((!beacon) || (!buffer) || (buff_len < DISCOVERY_BEACON_LEN)) {
        return 0;
    }

    // Check version
    if((strncasecmp(&buffer[6], DISCOVERY_VERSION, 2) != 0)) {
        return 0;
    }

    // Is memory request or beacon
    beacon->isRequest = 0;
    if(strncasecmp(buffer, DISCOVERY_REQUEST_STR, strlen(DISCOVERY_REQUEST_STR)) == 0) {
        beacon->isRequest = 1;
    } else if (strncasecmp(buffer, DISCOVERY_BEACON_STR, strlen(DISCOVERY_BEACON_STR)) != 0)  {
        return 0;
    }

    // Convert various parameters
    beacon->uptime =
        ((uint64_t)buffer[8] <<  0) | ((uint64_t)buffer[9] <<  8) | ((uint64_t)buffer[10] << 16) | ((uint64_t)buffer[11] << 24) |
        ((uint64_t)buffer[12] << 32) | ((uint64_t)buffer[13] << 40) | ((uint64_t)buffer[14] << 48) | ((uint64_t)buffer[15] << 56);

    beacon->deviceID =
        ((uint64_t)buffer[16] <<  0) | ((uint64_t)buffer[17] <<  8) | ((uint64_t)buffer[18] << 16) | ((uint64_t)buffer[19] << 24) |
        ((uint64_t)buffer[20] << 32) | ((uint64_t)buffer[21] << 40) | ((uint64_t)buffer[22] << 48) | ((uint64_t)buffer[23] << 56);

    beacon->logicalID =
        ((uint64_t)buffer[24] <<  0) | ((uint64_t)buffer[25] <<  8) | ((uint64_t)buffer[26] << 16) | ((uint64_t)buffer[27] << 24) |
        ((uint64_t)buffer[28] << 32) | ((uint64_t)buffer[29] << 40) | ((uint64_t)buffer[30] << 48) | ((uint64_t)buffer[31] << 56);

    memcpy(beacon->hardwareRevision, &buffer[32], DISCOVERY_HW_REV_LEN);
    beacon->hardwareRevision[DISCOVERY_HW_REV_LEN] = '\0';

    memcpy(beacon->firmwareRevision, &buffer[32+DISCOVERY_HW_REV_LEN], DISCOVERY_FW_REV_LEN);
    beacon->firmwareRevision[DISCOVERY_FW_REV_LEN] = '\0';

    memcpy(beacon->vendorName, &buffer[32+DISCOVERY_HW_REV_LEN+DISCOVERY_FW_REV_LEN], DISCOVERY_VENDOR_LEN);
    beacon->vendorName[DISCOVERY_VENDOR_LEN] = '\0';

    memcpy(beacon->productName, &buffer[32+DISCOVERY_HW_REV_LEN+DISCOVERY_FW_REV_LEN+DISCOVERY_VENDOR_LEN], DISCOVERY_PRODUCT_LEN);
    beacon->productName[DISCOVERY_PRODUCT_LEN] = '\0';

    return beacon;
}

static uint8_t* create_beacon_in_mem(uint8_t* buffer, uint32_t buff_len, char* version_str, uint64_t uptime, uint64_t devID, uint64_t logicalID, const char*  hwRev, const char*  fwRev, const char* vendor, const char* product) {
    if((!buffer) || (buff_len < DISCOVERY_BEACON_LEN)) {
        return 0;
    }

    memset(buffer, 0, DISCOVERY_BEACON_LEN);

    // Place version string into memory
    strncpy(buffer, version_str, 8);

    buffer[8] = (uptime >>  0) & 0xFF;
    buffer[9] = (uptime >>  8) & 0xFF;
    buffer[10] = (uptime >> 16) & 0xFF;
    buffer[11] = (uptime >> 24) & 0xFF;
    buffer[12] = (uptime >> 32) & 0xFF;
    buffer[13] = (uptime >> 40) & 0xFF;
    buffer[14] = (uptime >> 48) & 0xFF;
    buffer[15] = (uptime >> 56) & 0xFF;

    buffer[16] = (devID >>  0) & 0xFF;
    buffer[17] = (devID >>  8) & 0xFF;
    buffer[18] = (devID >> 16) & 0xFF;
    buffer[19] = (devID >> 24) & 0xFF;
    buffer[20] = (devID >> 32) & 0xFF;
    buffer[21] = (devID >> 40) & 0xFF;
    buffer[22] = (devID >> 48) & 0xFF;
    buffer[23] = (devID >> 56) & 0xFF;

    buffer[24] = (logicalID >>  0) & 0xFF;
    buffer[25] = (logicalID >>  8) & 0xFF;
    buffer[26] = (logicalID >> 16) & 0xFF;
    buffer[27] = (logicalID >> 24) & 0xFF;
    buffer[28] = (logicalID >> 32) & 0xFF;
    buffer[29] = (logicalID >> 40) & 0xFF;
    buffer[30] = (logicalID >> 48) & 0xFF;
    buffer[31] = (logicalID >> 56) & 0xFF;

    if(hwRev) {
        strncpy(&buffer[32], hwRev, DISCOVERY_HW_REV_LEN);
    }

    if(fwRev) {
        strncpy(&buffer[32+DISCOVERY_HW_REV_LEN], fwRev, DISCOVERY_FW_REV_LEN);
    }

    if(vendor) {
        strncpy(&buffer[32+DISCOVERY_HW_REV_LEN+DISCOVERY_FW_REV_LEN], vendor, DISCOVERY_VENDOR_LEN);
    }

    if(product) {
        strncpy(&buffer[32+DISCOVERY_HW_REV_LEN+DISCOVERY_FW_REV_LEN+DISCOVERY_VENDOR_LEN], product, DISCOVERY_PRODUCT_LEN);
    }

    return buffer;
}