#!/usr/bin/env python3
"""Genera una cinta TAP que prueba el scroll vertical del Scorpion GMX.

Arrancar GMX en 128 BASIC y cargar la cinta con LOAD "". La demostración
usa el modo 640x200 y avanza una línea tras una breve espera. Espacio sale.
"""

from pathlib import Path
import struct


class Code:
    """Emite el pequeño programa Z80 y resuelve sus saltos relativos."""

    def __init__(self):
        self.data = bytearray()
        self.labels = {}
        self.jumps = []

    def emit(self, *values):
        self.data.extend(values)

    def label(self, name):
        self.labels[name] = len(self.data)

    def jr(self, opcode, name):
        self.emit(opcode, 0)
        self.jumps.append((len(self.data) - 1, name))

    def finish(self):
        for position, name in self.jumps:
            distance = self.labels[name] - position - 1
            if not -128 <= distance <= 127:
                raise ValueError(f"Salto fuera de alcance: {name}")
            self.data[position] = distance & 255
        return bytes(self.data)


def out_port(code, port, value):
    """LD A,n; LD BC,puerto; OUT (C),A."""
    code.emit(0x3E, value, 0x01, port & 255, port >> 8, 0xED, 0x79)


def make_code():
    z = Code()
    z.emit(0xF3)  # DI

    # Página 39h en C000h: 7FFD=1, 1FFD.D4=1, DFFD=3.
    out_port(z, 0x1FFD, 0x10)
    out_port(z, 0x7FFD, 0x01)  # Conserva ROM 128; selecciona página baja 1.
    out_port(z, 0xDFFD, 3)
    z.emit(0x21, 0x00, 0xC0)  # LD HL,C000h
    z.emit(0x36, 0xFF)        # LD (HL),FFh
    z.emit(0x11, 0x01, 0xC0)  # LD DE,C001h
    z.emit(0x01, 0x7F, 0x3E)  # LD BC,15999
    z.emit(0xED, 0xB0)        # LDIR: píxeles blancos en las 200 líneas.

    # Página 79h: un color por línea, para ver el desplazamiento.
    out_port(z, 0xDFFD, 7)
    z.emit(0x21, 0x00, 0xC0)  # LD HL,C000h
    z.emit(0x06, 200)         # LD B,200 líneas
    z.emit(0x3E, 0x41)        # LD A,BRIGHT + INK azul
    z.label("linea")
    z.emit(0x0E, 80)          # LD C,80 bytes por línea
    z.label("atributo")
    z.emit(0x77, 0x23, 0x0D)  # LD (HL),A; INC HL; DEC C
    z.jr(0x20, "atributo")    # JR NZ
    z.emit(0x3C, 0xE6, 7, 0xF6, 0x40)  # INC A; AND 7; OR BRIGHT
    z.jr(0x10, "linea")       # DJNZ

    out_port(z, 0x7EFD, 8)   # Activa 640x200.
    z.emit(0x21, 0, 0)       # LD HL,0 (desplazamiento)
    z.label("cuadro")
    z.emit(0x7D, 0x01, 0xFD, 0x7A, 0xED, 0x79)  # L -> 7AFDh
    z.emit(0x7C, 0x01, 0xFD, 0x7C, 0xED, 0x79)  # H -> 7CFDh
    z.emit(0x01, 0x00, 0x18) # LD BC,1800h; espera sin depender de la ROM.
    z.label("espera")
    z.emit(0x0B, 0x78, 0xB1) # DEC BC; LD A,B; OR C
    z.jr(0x20, "espera")
    z.emit(0x3E, 0x7F, 0xDB, 0xFE, 0xE6, 1)  # Lee SPACE en 7FFEh.
    z.jr(0x28, "salida")      # JR Z
    z.emit(0x11, 80, 0, 0x19) # LD DE,80; ADD HL,DE
    z.emit(0x7C, 0xFE, 0x3E)  # LD A,H; CP 3Eh
    z.jr(0x20, "cuadro")      # JR NZ
    z.emit(0x7D, 0xFE, 0x80)  # CP L,80h (16000 = 3E80h)
    z.jr(0x20, "cuadro")
    z.emit(0x21, 0, 0)        # LD HL,0
    z.jr(0x18, "cuadro")      # JR

    z.label("salida")
    out_port(z, 0x7EFD, 0)   # Vuelve al vídeo Spectrum.
    out_port(z, 0x7AFD, 0)
    out_port(z, 0x7CFD, 0)
    out_port(z, 0xDFFD, 0)
    out_port(z, 0x1FFD, 0)
    out_port(z, 0x7FFD, 0)
    z.emit(0xFB, 0xC9)        # EI; RET al BASIC.
    return z.finish()


def number(value):
    """Literal BASIC entero con su representación numérica oculta."""
    return str(value).encode() + bytes((14, 0, 0, value & 255, value >> 8, 0))


def basic_line(line, body):
    data = body + b"\r"
    return struct.pack(">H", line) + struct.pack("<H", len(data)) + data


def tap_block(flag, data):
    payload = bytes((flag,)) + data
    checksum = 0
    for byte in payload:
        checksum ^= byte
    payload += bytes((checksum,))
    return struct.pack("<H", len(payload)) + payload


def header(kind, name, length, first, second):
    return bytes((kind,)) + name.ljust(10, b" ") + struct.pack("<HHH", length, first, second)


def main():
    code = make_code()
    program = b"".join((
        basic_line(10, bytes((0xFD, 32)) + number(32767)),
        basic_line(20, bytes((0xEF, 32, 34, 34, 32, 0xAF, 32)) + number(32768)),
        basic_line(30, bytes((0xF9, 32, 0xC0, 32)) + number(32768)),
    ))
    tape = b"".join((
        tap_block(0, header(0, b"GMX SCROLL", len(program), 10, len(program))),
        tap_block(255, program),
        tap_block(0, header(3, b"GMX CODE", len(code), 32768, 0)),
        tap_block(255, code),
    ))
    destination = Path(__file__).with_suffix(".tap")
    destination.write_bytes(tape)
    print(f"{destination}: {len(code)} bytes de código, {len(tape)} bytes TAP")


if __name__ == "__main__":
    main()
