;; Aoc day 2 clojure
(ns aoc24.day02)

;; Part 1/2 

;; Check if a value is of a given sign and is smaller than 3
(defn steadyrate [sign x]
  (and (sign x) (<= (Math/abs x) 3)))

;; All elements should decrease or increase at a rate lower than 3
(defn getsafety [lst]
  (def diff (map (partial apply -) (partition 2 1 lst)))
  (def sign (if (pos? (first diff)) pos? neg?))
  (every? (partial steadyrate sign) diff))

;(defn
;(defn getdampenedsafety [lst]
;  (def diff (map (partial apply -) (partition 2 1 lst)))
;  (def sign (if (pos? (first diff)) pos? neg?))
;  (diff))

(defn splitints [line]
  (map #(Integer/parseInt %) (clojure.string/split line #" ")))

(defn isSafe [lst]
  (for [x lst] (printf "xd %s%n"))
  nil)

(defn main []
  (with-open [rdr (clojure.java.io/reader "./inputs/input02test.txt")]
    (def reports (map splitints (line-seq rdr)))
    ;; Part 1/2
    (def safereports (count (filter true? (map getsafety reports))))
    (printf "Safe reports: %s%n" safereports)

    ;; Part 2/2
    (def testseq (list 1 2 3 3 4))
    (isSafe testseq)
    (println testseq)))

(main)

