module main

fn test_deflate() {
	plantuml_text := "@startuml\nJustin -> Bouboune: Kiss Request\nBouboune --> Justin: Kiss Response\n@enduml"
	assert get_deflate_url(plantuml_text) == "http://www.plantuml.com/plantuml/svg/1K2n3O0W4EoPuXTW0GjZBA5Z0ubVaC2_Ud_xcmDnVS4rKo5YcEHTJcTtccvI1o1DNoeYdSxkD9MSTob43Dka3a2Qud63faFjvfe_"
}