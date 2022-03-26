module main
import json
import rand
import net.http



fn main() {
	println('Hello World!')

	config := http.FetchConfig{
		user_agent: 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:88.0) Gecko/20100101 Firefox/88.0'
	}

	url := 'http://www.plantuml.com/plantuml/img/'
	println(url)

	resp := http.fetch(http.FetchConfig{ ...config, url: url }) or {
		println('failed to fetch data from the server')
		return
	}
}
