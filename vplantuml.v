module main
//import json (maybe for some parsing later)
import net.http
import compress.zlib
import cli { Command, Flag }
import os


fn main() {
	mut cmd := Command{
		name: 'V-Plantuml!'
		description: 'Generate plantuml diagram links from string using plantuml server'
		version: '0.1.0'
		execute: get_url
	}	
	cmd.add_flag(Flag{
		flag: .string
		required: true
		name: 'Plantuml string'
		abbrev: 's'
		description: 'Plantuml text'
	})

	cmd.setup()
	cmd.parse(os.args)
}

fn get_url(cmd Command) ? {
	plantuml_text := cmd.flags.get_string('Plantuml string') or { panic('Failed to get `Plantuml string` flag: $err') }
	
	config := http.FetchConfig{
		user_agent: 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0'
	}
	url := get_deflate_url(plantuml_text)
		
	_ := http.fetch(http.FetchConfig{ ...config, url: url}) or {
		println('Failed to connect the server')
		return 
	}
	println(url)

}

fn get_hex_url (plantuml_text string) string {


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
	zlibbed_str := zlib.compress(plantuml_text.bytes()) or {
		return 'Failed to comrpess with Zlib'
	}
	// See https://github.com/dougn/python-plantuml
	truncated_string := zlibbed_str#[2..-4]

	encoded := encode_plantuml(truncated_string)

	return 'http://www.plantuml.com/plantuml/svg/' + encoded
}

// 3 above functions are converted from Javascript:
// https://plantuml.com/code-javascript-synchronous
fn encode_plantuml(data []byte) string{
	mut r := ""
	for i := 0; i < data.len; i += 3 {
		if i+2 == data.len {
			r += append_3_bytes(data[i], data[i+1], 0)
		} else if i+1 == data.len {
			r += append_3_bytes(data[i], 0, 0)
		} else {
			r += append_3_bytes(data[i], data[i+1], data[i+2])
		}
	}
	return r
}

fn append_3_bytes(b1 byte, b2 byte, b3 byte) string {
	c1 := b1 >> 2
	c2 := ((b1 & 0x3) << 4) | (b2 >> 4)
	c3 := ((b2 & 0xF) << 2) | (b3 >> 6)
	c4 := b3 & 0x3F

	mut r := ""
	r += encode_6_bit(c1 & 0x3F)
	r += encode_6_bit(c2 & 0x3F)
	r += encode_6_bit(c3 & 0x3F)
	r += encode_6_bit(c4 & 0x3F)

	return r
}

fn encode_6_bit(b byte) string{
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