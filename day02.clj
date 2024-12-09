;; Aoc day 2 clojure
(ns aoc24.day02)

;; Part 1/2 

;; Check if a value is of a given sign and is smaller than 3
(defn isSafe [sign x]
  (and (sign x) (<= (Math/abs x) 3)))

;; All elements should decrease or increase at a rate lower than 3
(defn getsafety [lst]
  (def diff (map (partial apply -) (partition 2 1 lst)))
  (def sign (if (pos? (first diff)) pos? neg?))
  (every? (partial isSafe sign) diff))

;; Get a list with out the item at idx
(defn dropidx [idx lst]
  (concat (take idx lst) (drop (+ 1 idx) lst)))

;; Get sub lists such that: (1 2 3) -> ((2 3) (1 3) (2 3))
(defn allbutone [lst]
  (map-indexed (fn [idx _] (dropidx idx lst)) lst))

;; Allow a single bad entry
(defn dampener [lst]
  (def sign 
    (if (pos? (- (first lst) (second lst)))
      pos? neg?))
  (reduce
    (fn [result [index value]]
      (if (false? result)
        (reduced 
          (some true? (map getsafety (allbutone lst))))
        (if (= (+ 1 index) (count lst))
          (reduced result)
          (isSafe sign (- value (nth lst (+ index 1)))))))
    true
    (map-indexed vector lst)))

;; Split a string by spaces and parse every element as int
(defn splitints [line]
  (map #(Integer/parseInt %) (clojure.string/split line #" ")))

(defn main []
  (with-open [rdr (clojure.java.io/reader "./inputs/input02.txt")]
    (def reports (map splitints (line-seq rdr)))
    ;; Part 1/2
    (def safereports (count (filter true? (map getsafety reports))))
    (printf "Safe reports: %s%n" safereports)

    ;; Part 2/2
    (def dampsafe (count (filter true? (map dampener reports))))
    (printf "Dampened safe reports: %s%n" dampsafe)))

(main)

