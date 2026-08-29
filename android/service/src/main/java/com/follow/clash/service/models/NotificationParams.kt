package com.aurora.vpn.service.models

data class NotificationParams(
    val title: String = "Aurora",
    val stopText: String = "STOP",
    val onlyStatisticsProxy: Boolean = false,
)
