(ns cold-landscape.core
  (:require [clojure.string :as str]
            [clojure.set    :as set]))

;; ── Data ──────────────────────────────────────────────────────────────────────

(def palette
  {:backgrounds
   {:editor       "#1e1e1e"
    :sidebar      "#252526"
    :activity-bar "#2c2c2c"
    :title-bar    "#1a1a1a"
    :hover        "#2d2d30"
    :input        "#3c3c3c"}

   :accent
   {:keyword  "#7cb7d4"
    :string   "#a8c7a0"
    :function "#c8aee0"
    :type     "#9ecfd4"
    :number   "#d4b896"
    :comment  "#5c6370"
    :text     "#cdd1d4"
    :error    "#c17c7c"
    :warning  "#c4a76a"}})

;; ── Hex parsing ───────────────────────────────────────────────────────────────

(defn hex->rgb
  "Parse a #rrggbb hex string into a map {:r :g :b}."
  [hex]
  (let [s (str/replace hex #"^#" "")]
    {:r (Integer/parseInt (subs s 0 2) 16)
     :g (Integer/parseInt (subs s 2 4) 16)
     :b (Integer/parseInt (subs s 4 6) 16)}))

(defn rgb->luminance
  "Compute relative luminance (WCAG formula)."
  [{:keys [r g b]}]
  (let [linearise (fn [c]
                    (let [c' (/ c 255.0)]
                      (if (<= c' 0.04045)
                        (/ c' 12.92)
                        (Math/pow (/ (+ c' 0.055) 1.055) 2.4))))]
    (+ (* 0.2126 (linearise r))
       (* 0.7152 (linearise g))
       (* 0.0722 (linearise b)))))

(defn contrast-ratio
  "Return the WCAG contrast ratio between two hex colors."
  [fg bg]
  (let [l1 (rgb->luminance (hex->rgb fg))
        l2 (rgb->luminance (hex->rgb bg))
        [light dark] (if (> l1 l2) [l1 l2] [l2 l1])]
    (/ (+ light 0.05) (+ dark 0.05))))

(defn wcag-level
  "Return the WCAG compliance level for a given contrast ratio."
  [ratio]
  (cond
    (>= ratio 7.0) :AAA
    (>= ratio 4.5) :AA
    (>= ratio 3.0) :AA-large
    :else          :fail))

;; ── Reporting ─────────────────────────────────────────────────────────────────

(defn check-palette
  "Return a sequence of contrast reports for each accent color vs editor bg."
  [palette]
  (let [bg (get-in palette [:backgrounds :editor])]
    (for [[role hex] (:accent palette)]
      (let [ratio (contrast-ratio hex bg)]
        {:role  role
         :hex   hex
         :ratio (format "%.2f" ratio)
         :level (wcag-level ratio)}))))

(defn print-report [results]
  (println "Role         Hex       Ratio  Level")
  (println (str/join "" (repeat 42 "-")))
  (doseq [{:keys [role hex ratio level]} results]
    (printf "%-12s %-9s %-7s %s%n"
            (name role) hex ratio (name level))))

;; ── Main ──────────────────────────────────────────────────────────────────────

(defn -main [& _args]
  (println "Cold Landscape — WCAG Contrast Report")
  (println)
  (->> palette
       check-palette
       (sort-by :role)
       print-report))

(-main)
