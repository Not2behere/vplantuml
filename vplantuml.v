module main

import net.http
import compress.zlib
import cli { Command, Flag }
import os

fn main() {
	mut cmd := Command{
		name: 'V-Plantuml!'
		description: 'Generate plantuml diagram links from string using plantuml server'
		version: '0.1.0'
		execute: get_diagram
		required_args: 0
	}
	cmd.add_flag(Flag{
		flag: .string_array
		required: false
		name: 'string'
		abbrev: 's'
		description: 'Plantuml string'
	})
	cmd.add_flag(Flag{
		flag: .string
		required: false
		name: 'file'
		abbrev: 'f'
		description: 'Plantuml file'
	})
	cmd.add_flag(Flag{
		flag: .bool
		name: 'output'
		abbrev: 'o'
		description: 'Output file diagram'
	})

	cmd.setup()
	cmd.parse(os.args)
}

fn get_diagram(cmd Command) ? {
	plantuml_string := cmd.flags.get_strings('string') or {
		panic('Failed to get `Plantuml string` flag: $err')
	}
	plantuml_file := cmd.flags.get_string('file') or {
		panic('Failed to get `Plantuml file` flag: $err')
	}
	out_bool := cmd.flags.get_bool('output') ? // Optional for output file

	mut plantuml_text := ''
	if plantuml_string != [] {
		if plantuml_string == ['-f'] {
			println('Cannot combine "-s" and "-f" flags')
			return
		}
		plantuml_text = plantuml_string.join('')
	} else if plantuml_file != '' {
		if os.is_file(plantuml_file) {
			r := os.read_lines(plantuml_file) ?
			plantuml_text = r.join('\n')
		} else {
			println('No such file in your path')
			return
		}
	} else {
		println('You must provide a diagram as string("-s") OR filename.txt file("-f")')
		return
	}

	config := http.FetchConfig{
		user_agent: 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0'
	}

	url := get_deflate_url(plantuml_text)

	resp := http.fetch(http.FetchConfig{ ...config, url: url }) or {
		println('Failed to connect the server')
		return
	}

	if out_bool {
		process_out_file(plantuml_file, resp.text)
	}

	println(url)
}

fn get_hex_url(plantuml_text string) string {
	// Convert text to hex
	mut hex := []string{}
	for i, _ in plantuml_text {
		char_hex := '${plantuml_text[i]:02X}' // Padding with leading 0
		hex.insert(i, char_hex.str())
	}
	// '~h' to tell that's hex encoding format
	url := 'http://www.plantuml.com/plantuml/svg/~h' + hex.join('')

	return url
}

fn get_deflate_url(plantuml_text string) string {
	// Compress with zlib
	zlibbed_str := zlib.compress(plantuml_text.bytes()) or { return 'Failed to compress with Zlib' }
	// See https://github.com/dougn/python-plantuml
	truncated_string := zlibbed_str#[2..-4]

	encoded := encode_plantuml(truncated_string)

	return 'http://www.plantuml.com/plantuml/svg/' + encoded
}

// 3 below functions are converted from Javascript:
// https://plantuml.com/code-javascript-synchronous
fn encode_plantuml(data []byte) string {
	mut r := ''
	for i := 0; i < data.len; i += 3 {
		if i + 2 == data.len {
			r += append_3_bytes(data[i], data[i + 1], 0)
		} else if i + 1 == data.len {
			r += append_3_bytes(data[i], 0, 0)
		} else {
			r += append_3_bytes(data[i], data[i + 1], data[i + 2])
		}
	}
	return r
}

fn append_3_bytes(b1 byte, b2 byte, b3 byte) string {
	c1 := b1 >> 2
	c2 := ((b1 & 0x3) << 4) | (b2 >> 4)
	c3 := ((b2 & 0xF) << 2) | (b3 >> 6)
	c4 := b3 & 0x3F

	mut r := ''
	r += encode_6_bit(c1 & 0x3F)
	r += encode_6_bit(c2 & 0x3F)
	r += encode_6_bit(c3 & 0x3F)
	r += encode_6_bit(c4 & 0x3F)

	return r
}

fn encode_6_bit(b byte) string {
	mut c := b
	if c < 10 {
		return (48 + c).ascii_str()
	}
	c -= 10
	if c < 26 {
		return (65 + c).ascii_str()
	}
	c -= 26
	if c < 26 {
		return (97 + c).ascii_str()
	}
	c -= 26
	if c == 0 {
		return '-'
	}
	if c == 1 {
		return '_'
	}
	return '?'
}

fn process_out_file (fname string, t string) {
	out_file := fname#[0..-3] + 'svg'
	mut f := os.create(out_file) or {
		println(err)
		return
	}
	if os.is_file(out_file) {
		f.write_string(t) or { println(err) }
	}
	f.close()
}