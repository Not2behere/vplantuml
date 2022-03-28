# Small and minimalist Plantuml cli written with V

Using the deflate algorythm.
Started with the hex encode at first, so it is also implemented but not used for links length.


## Usage

From string:
```shell ignore
./vplantuml -s "@startuml
Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response
@enduml"
```
From File (only .txt):
```shell ignore
./vplantuml -f "plantuml_file.txt"
```

Outputs using the same text:
```shell ignore
http://www.plantuml.com/plantuml/svg/1K313O0W3FmpHHTW0Hz67C4D42-n2RGgr_tDDba_nkYfT6sGlChkvo8bUCEehLBTvC0Rc4oxdvBpAgLhmo8bUCEehLBTvC1yt2RI1hjYz1y0
```

## Limitation

Only provide the link from Plantuml default server and no saving of output diagrams.
Only written and tested on Arch Linux(Manjaro).