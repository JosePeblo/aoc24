;; Aoc day 1 lisp
;; sbcl --script day01.lsp
(require :uiop)

(defparameter list1 '())
(defparameter list2 '())

;; Read the file line and extract the lists 
(let ((in (open "./inputs/input01.txt" :if-does-not-exist nil)))
  (when in 
    (loop for line = (read-line in nil)
          while line do
          (let ((trimmed-line (string-trim '(#\Space #\Tab #\Newline #\Return) line)))
            (unless (string= trimmed-line "")
              (let* ((parts (uiop:split-string trimmed-line :separator " "))
                     (num1 (parse-integer (first parts)))
                     (num2 (parse-integer (car (last parts)))))
                (setf list1 (append list1 (list num1)))
                (setf list2 (append list2 (list num2)))))))

    (close in)))

;; Part 1/2

;; Subtract the two lists element by element
(defun difflst (list1 list2)
  (if list1
    (cons (abs (- (first list1) (first list2)))
          (difflst (rest list1) (rest list2)))
    nil))

;; Diff the two sorted lists and sum the distances
(defun getDistance (list1 list2)
  (reduce #'+ (difflst (sort list1 #'<) (sort list2 #'<))))

;; Copy the lists to avoid problems sorting in place
(defparameter lst1 (copy-list list1))
(defparameter lst2 (copy-list list2))

(format t"First distance: ~D~%" (getDistance lst1 lst2))

;; Part 2/2

(defparameter table (make-hash-table))

;; Iterate the list and increment by one every entry
(loop for value in list2 do
      (let ((hash (gethash value table)))
        (if hash
          (setf (gethash value table) (+ hash 1))
          (setf (gethash value table) 1))))

;; Multiply the chracter by the times it appeared on the original list
(defun multbytimes (value)
  (let ((hash (gethash value table)))
    (if hash (* value hash) 0)))

(format t"Similarity score: ~D~%" (reduce #'+ (mapcar #'multbytimes list1)))

