;; Task 1
;; Описать функцию, которая создавала бы список только из числовых элементов
;; списка-аргумента. Список может содержать подсписки произвольной глубины

(defun onlyNumbs (list)
      (cond
            ((null list) nil)
            ((numberp (car list)) (cons (car list) (onlyNumbs (cdr list))))
            (t (onlyNumbs (cdr list)))
      )
)

; (print
;  (onlyNumbs '(1 3 '(2) 12 A))
; )
; (terpri)

;; Task 2
;; Написать программу сортировки списка методом Шелла. Вычисление последовательности
;; шагов сортировки производится в соответствии с вариантом в Таблице 2.

;; Методом предложенным Дональдом Кнутом: h(k-1) = 3 * h(k) + 1, h(t) = 1, где
;; h(i) - шаг сортировки. t = log(3, n)-1 - число шагов сортировки, n - длина списка

;; flag: 0 - task1, task4; 1,2 - task5

(defun shellSort (list flag)
      (iterSteps list
                 (car (getSteps (countSteps (list-length list))))
                 (cdr (getSteps (countSteps (list-length list))))
                 flag
      )
      list
)

(defun getSteps (iters)
      (cond
            ((< iters 1) '(1) )
            (t (cons (+ (* 3 (car (getSteps (- iters 1)))) 1) (getSteps (- iters 1))))
      )
)

(defun countSteps (n)
      (- (log n 3) 1)
)

(defun iterSteps (list currStep steps flag)
      (cond
            ((null currStep) list)
            (t (iterGroup list currStep currStep flag)
               (iterSteps list (car steps) (cdr steps) flag)
            )
      )
)

(defun iterGroup (list i step flag)
      (cond
            ((>= i (list-length list)) list)
            (t (cond
                 ((= flag 0) (iterGroup (sortNeighbours list i step nil) (+ i 1) step flag))
                 ((= flag 1) (iterGroup (sortNeighbours2 list i step nil) (+ i 1) step flag))
                 (t (iterGroup (sortNeighbours3 list i step nil) (+ i 1) step flag))
                )
            )
      )
)

(defun sortNeighbours (list i step fn)
      (cond
            ((< i step) list)
            ((> (nth i list) (nth (- i step) list)) (sortNeighbours list (- i step) step nil))
            (t (sortNeighbours list (- i step) step (rotatef (nth i list) (nth (- i step) list))))
      )
)

(defun sortNeighbours2 (list i step fn)
      (cond
            ((< i step) list)
            ((> (car (nth i list)) (car (nth (- i step) list))) (sortNeighbours2 list (- i step) step nil))
            (t (sortNeighbours2 list (- i step) step (rotatef (nth i list) (nth (- i step) list))))
      )
)

(defun sortNeighbours3 (list i step fn)
      (cond
            ((< i step) list)
            ((and (= (car (nth i list)) (car (nth (- i step) list)))
                  (< (cdr (nth i list)) (cdr (nth (- i step) list)))
             ) (sortNeighbours3 list (- i step) step (rotatef (nth i list) (nth (- i step) list))))
            (t (sortNeighbours3 list (- i step) step nil))
      )
)

; (print
;       (shellSort '(12 5 2 6 0 53 46 19 3 4 14 57 495 49 95 6 4 85 3 93) 0)
; )
; (terpri)

;; Task 3
;; Сортировка бинарными включениями

(defun binarySearch (list item low high)
      (cond
            ((<= high low) (if (> item (nth low list)) (+ low 1) low))
            ((= item (nth (floor (/ (+ low high) 2)) list))
                (floor (+ (/ (+ low high) 2)) 1)
            )

            ((> item (nth (floor (/ (+ low high) 2)) list))
                (binarySearch list item (+ (floor (/ (+ low high) 2)) 1) high)
            )
            (t
                (binarySearch list item low (- (floor (/ (+ low high) 2)) 1))
            )
      )
)

(defun moveElems (list i insPlace)
      (cond
            ((<= i insPlace) list)
            (t (rotatef (nth (- i 1) list) (nth i list)) (moveElems list (- i 1) insPlace))
      )
)

(defun insertion (list i)
      (cond
            ((>= i (list-length list)) list)
            (t (insertion (moveElems list i (binarySearch list (nth i list) 0 (- i 1))) (+ i 1)))
      )
)

(defun insertionSort (list)
      (if (not (null list)) (insertion list 1) nil)
)

; (print
;       (insertionSort '(12 5 2 6 0 53 46 19 3 4 14 57 495 49 95 6 4 85 3 93))
; )
; (terpri)


;; Task 4
;; Написать программу объединения двух отсортированных списков в один. При этом порядок
;; сортировки в списке-результате должен сохраняться

(defun concatWithOrder (l1 l2)
      (cond
            ((or (and (< (first l1) (second l1)) (> (first l2) (second l2)))
             (and (> (first l1) (second l1)) (< (first l2) (second l2)))
             ) nil)
            ((< (first l1) (second l1)) (shellSort (append l1 l2) 0))
            (t (reverse (shellSort (append l1 l2) 0)))
      )
)

; (print
;     (concatWithOrder '(1 2 5 9 13) '(1 3 5 6 10 45))
; )
; (terpri)

;; Task 5
;; Написать функцию, вычисляющую сумму элементов-чисел на каждом уровне
;; исходного списка. Рекомендуется следующая форма результата :
;; (( 1 <сумма числовых элементов на первом уровне>)(2 <на втором>)..)
;; Пример : для списка (a (b (4 (2 e (3) k 15) e 5) 7)) результатом будет список : ((1
;; 0)(2 7)(3 9)(4 17) (5 3)).

;; a
;; |  b
;; |  |  4
;; |  |  |  2
;; |  |  |  e
;; |  |  |  |  3
;; |  |  |  k
;; |  |  |  15
;; |  |  e
;; |  |  5
;; |  7

(defun sumLevels (list)
      (removeExtra (shellSort (shellSort (recoursiveSum list 1 0 0 '()) 1) 2) 0 ())
)

(defun recoursiveSum (list lvl i sum res)
      (cond
            ((null (nth i list)) res)
            ((listp (nth i list)) (recoursiveSum list lvl (+ i 1) 0 res) (recoursiveSum (nth i list) (+ lvl 1) 0 0 res))
            ((atom (nth i list)) (recoursiveSum list lvl (+ i 1) (getSum res lvl) (nconc res (countLvl lvl (nth i list) (getSum res lvl)))))
            (t (recoursiveSum list lvl (+ i 1) sum res))
      )
)

(defun countLvl (lvl elem prev)
      (cond
            ((null elem) nil)
            ((numberp elem) (list (cons lvl (+ elem prev))))
            (t (list (cons lvl 0)))
      )
)

(defun getSum (list ind)
      (cond
            ((null list) 0)
            ((equal ind (car (car list))) (cdr (car list)))
            (t (getSum (cdr list) ind))
      )
)

(defun removeExtra (list i res)
      (cond
            ((null (nth (+ i 1) list)) (nconc res (list (nth i list))))
            ((< (car (nth i list)) (car (nth (+ i 1) list))) (removeExtra list (+ i 1) (nconc res (list (nth i list)))))
            (t (removeExtra list (+ i 1) res))
      )
)

; (print
;       (sumLevels '(a (b (4 (2 e (3) k 15) e 5) 7)))
;       ; (sumLevels '(3 a 3 (14 t (0 5 (a 8) ((15)) f) 8)))
; )
; (terpri)
