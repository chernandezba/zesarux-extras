#!/usr/bin/env python3
"""Genera un TAP autocargable para medir la caché de CPU de TSConf."""

from pathlib import Path
import math
import struct


ORIGIN = 0x8000
RESULT_OFF = 0x8300
RESULT_ON = RESULT_OFF + 3
FRAMES = 0x5C78


class Code:
    def __init__(self):
        self.data = bytearray()
        self.labels = {}
        self.fixes = []

    def mark(self, name):
        self.labels[name] = ORIGIN + len(self.data)

    def emit(self, *values):
        self.data.extend(values)

    def word(self, value):
        self.data.extend(struct.pack("<H", value))

    def call(self, name):
        self.emit(0xCD, 0, 0)
        self.fixes.append((len(self.data) - 2, name, "word"))

    def jr(self, opcode, name):
        self.emit(opcode, 0)
        self.fixes.append((len(self.data) - 1, name, "relative"))

    def finish(self):
        for offset, name, kind in self.fixes:
            target = self.labels[name]
            if kind == "word":
                self.data[offset:offset + 2] = struct.pack("<H", target)
            else:
                delta = target - (ORIGIN + offset + 1)
                if not -128 <= delta <= 127:
                    raise ValueError(f"Salto JR fuera de rango: {name}")
                self.data[offset] = delta & 0xFF
        assert ORIGIN + len(self.data) < RESULT_OFF
        return bytes(self.data)


def machine_code():
    z = Code()
    for sysconfig, result in ((0x02, RESULT_OFF), (0x06, RESULT_ON)):
        # SysConfig #20AF: 14 MHz, primero sin caché y luego con ella.
        z.emit(0xF3, 0x01, 0xAF, 0x20, 0x3E, sysconfig, 0xED, 0x79, 0xFB)
        z.call("benchmark")
        z.emit(0x22)
        z.word(result)  # LD (result),HL: 16 bits bajos.
        z.emit(0x7A, 0x32)
        z.word(result + 2)  # LD (result+2),A: 8 bits altos.

    # Restaurar 3,5 MHz y devolver el control a BASIC.
    z.emit(0xF3, 0x01, 0xAF, 0x20, 0xAF, 0xED, 0x79, 0xFB, 0xC9)

    z.mark("benchmark")
    z.emit(0x3A)
    z.word(FRAMES)  # LD A,(FRAMES)
    z.emit(0x47)  # LD B,A
    z.mark("sync")
    z.emit(0x3A)
    z.word(FRAMES)
    z.emit(0xB8)  # CP B
    z.jr(0x28, "sync")  # Esperar el comienzo de un cuadro.
    z.emit(0xC6, 50, 0x4F, 0x21, 0, 0, 0x16, 0)  # Meta y contador 24 bits.
    z.mark("loop")
    z.emit(0x23, 0x7C, 0xB5)  # INC HL; detectar desbordamiento.
    z.jr(0x20, "poll")
    z.emit(0x14)  # INC D: byte alto del contador.
    z.mark("poll")
    z.emit(0x3A)
    z.word(FRAMES)
    z.emit(0xB9)  # CP C: ¿han pasado 50 cuadros?
    z.jr(0x20, "loop")
    z.emit(0xC9)
    return z.finish()


def number(value):
    # Literal decimal seguido de su representación numérica de Spectrum BASIC.
    fraction, exponent = math.frexp(value)
    mantissa = round((fraction * 2 - 1) * (1 << 31))
    encoded = bytes((0x80 + exponent,)) + mantissa.to_bytes(4, "big")
    return str(value).encode("ascii") + bytes((0x0E,)) + encoded


def basic_line(line_number, content):
    content += b"\r"
    return struct.pack(">H", line_number) + struct.pack("<H", len(content)) + content


def printed_result(label, address):
    # PRINT "etiqueta"; PEEK base + 256*PEEK(base+1) + 65536*PEEK(base+2)
    return (bytes((0xF5, 0x22)) + label.encode("ascii") + bytes((0x22, 0x3B, 0xBE, 0x20))
            + number(address) + b"+" + number(256) + b"*" + bytes((0xBE, 0x20))
            + number(address + 1) + b"+" + number(65536) + b"*"
            + bytes((0xBE, 0x20)) + number(address + 2))


def basic_program():
    return b"".join((
        basic_line(10, bytes((0xFD, 0x20)) + number(32767)),
        basic_line(20, bytes((0xEF, 0x20, 0x22, 0x22, 0x20, 0xAF))),
        basic_line(30, bytes((0xF9, 0x20, 0xC0, 0x20)) + number(ORIGIN)),
        basic_line(40, printed_result("SIN CACHE: ", RESULT_OFF)),
        basic_line(50, printed_result("CON CACHE: ", RESULT_ON)),
    ))


def tape_block(flag, payload):
    contents = bytes((flag,)) + payload
    checksum = 0
    for value in contents:
        checksum ^= value
    contents += bytes((checksum,))
    return struct.pack("<H", len(contents)) + contents


def header(file_type, name, size, field1, field2):
    payload = (bytes((file_type,)) + name.ljust(10)[:10]
               + struct.pack("<HHH", size, field1, field2))
    return tape_block(0, payload)


def main():
    program = basic_program()
    code = machine_code()
    tape = (header(0, b"TS CACHE", len(program), 10, len(program))
            + tape_block(255, program)
            + header(3, b"CACHE CODE", len(code), ORIGIN, 0x8000)
            + tape_block(255, code))
    output = Path(__file__).with_name("tsconf_cache_test.tap")
    output.write_bytes(tape)
    print(f"{output}: {len(code)} bytes de código, {len(program)} bytes de BASIC")


if __name__ == "__main__":
    main()
