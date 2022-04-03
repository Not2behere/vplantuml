# Small and minimalist Plantuml cli written with V

Using the deflate algorythm.
Started with the hex encode at first, so it is also implemented but not used since it generates shorter links from deflate.


## Usage

Once built for your target, commands below are availables.

From string (do not forget the quotation mark):
```shell ignore
./vplantuml -s "@startuml
Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response
@enduml"
```
From File (.txt):
```shell ignore
./vplantuml -f plantuml_file.txt
```
From File with output saved as svg:
```shell ignore
./vplantuml -o -f plantuml_file.txt
```

Outputs using the same text:
```shell ignore
http://www.plantuml.com/plantuml/svg/1K313O0W3FmpHHTW0Hz67C4D42-n2RGgr_tDDba_nkYfT6sGlChkvo8bUCEehLBTvC0Rc4oxdvBpAgLhmo8bUCEehLBTvC1yt2RI1hjYz1y0
```

![PlantUML model](http://www.plantuml.com/plantuml/svg/1K313O0W3FmpHHTW0Hz67C4D42-n2RGgr_tDDba_nkYfT6sGlChkvo8bUCEehLBTvC0Rc4oxdvBpAgLhmo8bUCEehLBTvC1yt2RI1hjYz1y0)

Or else, use `v run` e.g.:
```shell ignore
v run . -f plantuml_file.txt
```

## Limitation

Output diagrams are saved as svg at root of the folder with the same name of file or ".svg" from string.
Only written and tested on Arch Linux(Manjaro).
