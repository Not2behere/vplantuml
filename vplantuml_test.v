module main

fn test_deflate() {
	plantuml_text := '@startuml\nJustin -> Bouboune: Kiss Request\nBouboune --> Justin: Kiss Response\n@enduml'
	assert get_deflate_url(plantuml_text) == 'http://www.plantuml.com/plantuml/svg/1K2n3O0W4EoPuXTW0GjZBA5Z0ubVaC2_Ud_xcmDnVS4rKo5YcEHTJcTtccvI1o1DNoeYdSxkD9MSTob43Dka3a2Qud63faFjvfe_'
}

fn test_hex() {
	plantuml_text := '@startuml\nJustin -> Bouboune: Kiss Request\nBouboune --> Justin: Kiss Response\n@enduml'
	assert get_hex_url(plantuml_text) == 'http://www.plantuml.com/plantuml/svg/~h407374617274756D6C0A4A757374696E202D3E20426F75626F756E653A204B69737320526571756573740A426F75626F756E65202D2D3E204A757374696E3A204B69737320526573706F6E73650A40656E64756D6C'
}
