(* Cold Landscape — OCaml sample
   A small interpreter for a stack-based expression language. *)

(* ── Token types ─────────────────────────────────────────────────────────── *)

type token =
  | TInt   of int
  | TFloat of float
  | TPlus
  | TMinus
  | TMul
  | TDiv
  | TDup
  | TDrop
  | TPrint

(* ── Lexer ──────────────────────────────────────────────────────────────── *)

exception LexError of string

let lex (src : string) : token list =
  let words = String.split_on_char ' ' src
              |> List.filter (fun w -> String.length w > 0) in
  List.map (fun w ->
    match w with
    | "+"     -> TPlus
    | "-"     -> TMinus
    | "*"     -> TMul
    | "/"     -> TDiv
    | "dup"   -> TDup
    | "drop"  -> TDrop
    | "print" -> TPrint
    | _       ->
      (match int_of_string_opt w with
       | Some n -> TInt n
       | None   ->
         match float_of_string_opt w with
         | Some f -> TFloat f
         | None   -> raise (LexError ("unknown token: " ^ w)))
  ) words

(* ── Stack machine ──────────────────────────────────────────────────────── *)

type value = VInt of int | VFloat of float

let value_to_string = function
  | VInt n   -> string_of_int n
  | VFloat f -> Printf.sprintf "%.6g" f

let to_float = function
  | VInt n   -> float_of_int n
  | VFloat f -> f

exception RuntimeError of string

let arith op a b =
  match (a, b) with
  | (VInt x,   VInt y  ) -> VInt   (op x y)
  | (VFloat x, VFloat y) -> VFloat (op (int_of_float x) (int_of_float y) |> float_of_int)
  | _ ->
    let fx = to_float a and fy = to_float b in
    VFloat (float_of_int (op (int_of_float fx) (int_of_float fy)))

let eval (tokens : token list) : unit =
  let stack : value Stack.t = Stack.create () in
  let push v = Stack.push v stack in
  let pop () =
    if Stack.is_empty stack then raise (RuntimeError "stack underflow")
    else Stack.pop stack
  in
  List.iter (fun tok ->
    match tok with
    | TInt n   -> push (VInt n)
    | TFloat f -> push (VFloat f)
    | TPlus  -> let b = pop () in let a = pop () in push (arith ( + ) a b)
    | TMinus -> let b = pop () in let a = pop () in push (arith ( - ) a b)
    | TMul   -> let b = pop () in let a = pop () in push (arith ( * ) a b)
    | TDiv   ->
      let b = pop () in
      let a = pop () in
      (match b with
       | VInt 0 | VFloat 0.0 -> raise (RuntimeError "division by zero")
       | _ -> push (arith ( / ) a b))
    | TDup   -> let v = pop () in push v; push v
    | TDrop  -> ignore (pop ())
    | TPrint ->
      let v = pop () in
      print_endline (value_to_string v)
  ) tokens

(* ── Entry point ────────────────────────────────────────────────────────── *)

let () =
  let programs = [
    "3 4 + print";                  (* 7 *)
    "10 2 / dup * print";           (* 25 *)
    "1 2 3 + * print";              (* 5 *)
    "100 7 - 3 * print";            (* 279 *)
  ] in
  List.iter (fun src ->
    Printf.printf ">> %s\n" src;
    (try eval (lex src)
     with
     | LexError msg     -> Printf.eprintf "  lex error: %s\n" msg
     | RuntimeError msg -> Printf.eprintf "  runtime error: %s\n" msg)
  ) programs
