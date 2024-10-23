# Bad Parser

Bad Parser is a terrible JSON parser and tokenizer written in Swift. It probably shouldn't be used, but here it is anyway.

## Usage

### Parsing JSON

```swift
import BadParser

let jsonString = "{ \"name\": \"John\" }"
let nodes = BadParser().parse(jsonString)
```

### Tokenizing JSON

```swift
import BadParser

let tokens = BadTokenizer().tokenize(jsonString)
```

## License

Bad Parser is available under the MIT license. Use at your own risk.
