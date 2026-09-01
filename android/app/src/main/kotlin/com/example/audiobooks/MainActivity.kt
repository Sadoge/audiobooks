package com.example.audiobooks

import com.ryanheise.audioservice.AudioServiceActivity

/**
 * Hosts Flutter inside audio_service's activity, which is what lets a
 * notification or a lock-screen control reach a running player rather than
 * starting a second one.
 */
class MainActivity : AudioServiceActivity()
