// Cold Landscape — F# sample
// A small pipeline for processing CSV-like data using computation expressions.

open System
open System.Collections.Generic

// ── Types ─────────────────────────────────────────────────────────────────────

type Row = Map<string, string>

type PipelineError =
    | MissingColumn of string
    | InvalidValue  of string * string  // column * value
    | EmptyDataset

type Result<'T> = Ok of 'T | Err of PipelineError

// ── Computation expression for result chaining ────────────────────────────────

type ResultBuilder() =
    member _.Return(x)        = Ok x
    member _.ReturnFrom(r)    = r
    member _.Bind(m, f)       =
        match m with
        | Ok v  -> f v
        | Err e -> Err e

let result = ResultBuilder()

// ── Row helpers ───────────────────────────────────────────────────────────────

let getCol (col: string) (row: Row) : Result<string> =
    match Map.tryFind col row with
    | Some v -> Ok v
    | None   -> Err (MissingColumn col)

let parseInt (col: string) (s: string) : Result<int> =
    match Int32.TryParse(s) with
    | true, n -> Ok n
    | _       -> Err (InvalidValue(col, s))

let parseFloat (col: string) (s: string) : Result<float> =
    match Double.TryParse(s, Globalization.NumberStyles.Any,
                          Globalization.CultureInfo.InvariantCulture) with
    | true, n -> Ok n
    | _       -> Err (InvalidValue(col, s))

// ── CSV parsing ───────────────────────────────────────────────────────────────

let parseCsv (text: string) : Result<Row list> =
    let lines =
        text.Split('\n')
        |> Array.map (fun l -> l.Trim())
        |> Array.filter (fun l -> l.Length > 0)

    if lines.Length < 2 then
        Err EmptyDataset
    else
        let headers = lines[0].Split(',') |> Array.map (fun h -> h.Trim())
        let rows =
            lines[1..]
            |> Array.map (fun line ->
                let values = line.Split(',') |> Array.map (fun v -> v.Trim())
                Array.zip headers values
                |> Array.fold (fun m (k, v) -> Map.add k v m) Map.empty)
            |> Array.toList
        Ok rows

// ── Domain: temperature readings ──────────────────────────────────────────────

type Reading = { Station: string; Temp: float; Hour: int }

let parseReading (row: Row) : Result<Reading> =
    result {
        let! station = getCol "station" row
        let! tempStr = getCol "temp_c"  row
        let! hourStr = getCol "hour"    row
        let! temp    = parseFloat "temp_c" tempStr
        let! hour    = parseInt   "hour"   hourStr
        return { Station = station; Temp = temp; Hour = hour }
    }

let averageTemp (readings: Reading list) =
    if readings.IsEmpty then None
    else Some (readings |> List.averageBy (fun r -> r.Temp))

// ── Entry point ───────────────────────────────────────────────────────────────

let csv = """
station,temp_c,hour
north-peak,-4.2,6
north-peak,-3.8,7
north-peak,-2.1,8
valley-base,1.3,6
valley-base,2.0,7
valley-base,3.4,8
"""

match parseCsv csv with
| Err e -> printfn "CSV error: %A" e
| Ok rows ->
    let readings = rows |> List.choose (fun r ->
        match parseReading r with
        | Ok v  -> Some v
        | Err e -> eprintfn "Skipping row: %A" e; None)

    let byStation =
        readings
        |> List.groupBy (fun r -> r.Station)

    for (station, rs) in byStation do
        match averageTemp rs with
        | Some avg -> printfn "%s → avg %.2f°C" station avg
        | None     -> printfn "%s → no data" station
