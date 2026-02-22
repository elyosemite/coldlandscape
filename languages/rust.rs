use std::collections::HashMap;
use std::fmt;
use std::str::FromStr;

#[derive(Debug, Clone, PartialEq)]
pub enum JsonValue {
    Null,
    Bool(bool),
    Number(f64),
    Str(String),
    Array(Vec<JsonValue>),
    Object(HashMap<String, JsonValue>),
}

impl fmt::Display for JsonValue {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            JsonValue::Null => write!(f, "null"),
            JsonValue::Bool(b) => write!(f, "{}", b),
            JsonValue::Number(n) => {
                if n.fract() == 0.0 {
                    write!(f, "{}", *n as i64)
                } else {
                    write!(f, "{}", n)
                }
            }
            JsonValue::Str(s) => write!(f, "\"{}\"", s.replace('"', "\\\"")),
            JsonValue::Array(arr) => {
                let items: Vec<String> = arr.iter().map(|v| v.to_string()).collect();
                write!(f, "[{}]", items.join(", "))
            }
            JsonValue::Object(map) => {
                let pairs: Vec<String> = map
                    .iter()
                    .map(|(k, v)| format!("\"{}\": {}", k, v))
                    .collect();
                write!(f, "{{{}}}", pairs.join(", "))
            }
        }
    }
}

#[derive(Debug)]
pub struct ParseError(String);

impl fmt::Display for ParseError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "parse error: {}", self.0)
    }
}

impl FromStr for JsonValue {
    type Err = ParseError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let s = s.trim();
        match s {
            "null"  => Ok(JsonValue::Null),
            "true"  => Ok(JsonValue::Bool(true)),
            "false" => Ok(JsonValue::Bool(false)),
            _ if s.starts_with('"') => {
                Ok(JsonValue::Str(s.trim_matches('"').to_string()))
            }
            _ => s
                .parse::<f64>()
                .map(JsonValue::Number)
                .map_err(|_| ParseError(format!("unknown token: {}", s))),
        }
    }
}

fn main() {
    let values: Vec<JsonValue> = vec![
        JsonValue::Null,
        JsonValue::Bool(true),
        JsonValue::Number(3.14),
        JsonValue::Str("cold landscape".to_string()),
        JsonValue::Array(vec![
            JsonValue::Number(1.0),
            JsonValue::Number(2.0),
            JsonValue::Number(3.0),
        ]),
    ];

    for v in &values {
        println!("{}", v);
    }

    let parsed: Result<JsonValue, _> = "42".parse();
    println!("parsed: {:?}", parsed);
}
