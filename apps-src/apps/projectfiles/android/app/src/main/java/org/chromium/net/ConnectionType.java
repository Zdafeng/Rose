package org.chromium.net;

import android.support.annotation.IntDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@IntDef({
        ConnectionType.CONNECTION_UNKNOWN, ConnectionType.CONNECTION_ETHERNET,
        ConnectionType.CONNECTION_WIFI, ConnectionType.CONNECTION_2G, ConnectionType.CONNECTION_3G,
        ConnectionType.CONNECTION_4G, ConnectionType.CONNECTION_NONE,
        ConnectionType.CONNECTION_BLUETOOTH, ConnectionType.CONNECTION_LAST
})
@Retention(RetentionPolicy.SOURCE)
public @interface ConnectionType {
    int CONNECTION_UNKNOWN = 0;
    /**
     * Also used as a default value.
     */
    int CONNECTION_ETHERNET = 1;
    int CONNECTION_WIFI = 2;
    int CONNECTION_2G = 3;
    int CONNECTION_3G = 4;
    int CONNECTION_4G = 5;
    int CONNECTION_NONE = 6;
    int CONNECTION_BLUETOOTH = 7;
    int CONNECTION_LAST = CONNECTION_BLUETOOTH;
}