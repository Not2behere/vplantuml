module main

fn test_deflate() {
	plantuml_text := '@startuml\nAlice -> Bob: Authentication Request\nBob --> Alice: Authentication Response\n@enduml'
	assert get_deflate_url(plantuml_text) == 'http://www.plantuml.com/plantuml/svg/1K313O0W3FmpHHTW0Hz67C4D42-n2RGgr_tDDba_nkYfT6sGlChkvo8bUCEehLBTvC0Rc4oxdvBpAgLhmo8bUCEehLBTvC1yt2RI1hjYz1y0'
}

fn test_hex() {
	plantuml_text := '@startuml\nAlice -> Bob: Authentication Request\nBob --> Alice: Authentication Response\n@enduml'
	assert get_hex_url(plantuml_text) == 'http://www.plantuml.com/plantuml/svg/~h407374617274756D6C0A416C696365202D3E20426F623A2041757468656E7469636174696F6E20526571756573740A426F62202D2D3E20416C6963653A2041757468656E7469636174696F6E20526573706F6E73650A40656E64756D6C'
}
