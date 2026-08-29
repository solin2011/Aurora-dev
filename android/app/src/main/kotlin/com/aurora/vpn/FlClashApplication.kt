package com.aurora.vpn

import android.app.Application
import android.content.Context
import com.aurora.vpn.common.GlobalState

class AuroraApplication : Application() {
    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        GlobalState.init(this)
    }
}
