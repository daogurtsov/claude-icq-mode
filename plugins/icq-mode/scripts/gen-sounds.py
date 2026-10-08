#!/usr/bin/env python3
"""Synthesize the plugin's original retro chime sounds into ../sounds/*.wav."""

import math
import os
import struct
import wave

RATE = 22050
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "sounds")


def tone(freq, dur, vol=0.45):
    n = int(RATE * dur)
    out = []
    for i in range(n):
        t = i / RATE
        env = min(1.0, i / (RATE * 0.005)) * math.exp(-3.5 * t / dur)
        s = math.sin(2 * math.pi * freq * t) + 0.3 * math.sin(4 * math.pi * freq * t)
        out.append(vol * env * s / 1.3)
    return out


def glide(f0, f1, dur, vol=0.45):
    n = int(RATE * dur)
    out, phase = [], 0.0
    for i in range(n):
        p = i / n
        f = f0 + (f1 - f0) * p
        phase += 2 * math.pi * f / RATE
        env = min(1.0, i / (RATE * 0.01)) * (1 - p) ** 1.5
        out.append(vol * env * math.sin(phase))
    return out


def silence(dur):
    return [0.0] * int(RATE * dur)


def write(name, samples):
    os.makedirs(OUT, exist_ok=True)
    with wave.open(os.path.join(OUT, name), "w") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(b"".join(struct.pack("<h", int(max(-1, min(1, s)) * 32767)) for s in samples))


write("message.wav", tone(988, 0.09) + tone(1319, 0.16))
write("attention.wav", glide(700, 620, 0.16) + silence(0.05) + glide(560, 420, 0.28))
write("online.wav", tone(659, 0.08) + tone(784, 0.08) + tone(988, 0.08) + tone(1319, 0.22))
