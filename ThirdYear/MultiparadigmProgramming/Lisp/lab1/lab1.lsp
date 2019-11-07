;; Task 1

;; list1: (T (HJ (JK KL)) K)
;; list2: (67 54 (8 9 0) (4 6))
;; list3: (K F G H)
(print
  (
    (lambda (l1 l2 l3)
      (LIST (CAR l1) (CAR l2) (CAR l3) )
    ) '(T (HJ (JK KL)) K) '(67 54 (8 9 0) (4 6)) '(K F G H)
  )
)
;; Task 2

;; numbers of elements: 2 3 3

(defun myfunc (list1 num1 list2 num2 list3 num3)
  (list (nth num1 list1) (nth num2 list2) (nth num3 list3))
)

(print
  (myfunc '(T '(HJ '(JK KL)) K) 2
          '(67 54 '(8 9 0) '(4 6)) 3
          '(K F G H) 3
  )
)

;; Task 3

;; Есть три числа. Если все три числа нечетные - построить список из трех кубов
;; этих чисел, иначе - возвратить сумму чисел

(defun myfunc2 (num1 num2 num3)
  (if (and (= (rem num1 2) 1) (= (rem num2 2) 1) (= (rem num3 2) 1) )
    (list (expt num1 3) (expt num2 3) (expt num3 3) )
    (+ num1 (+ num2 num3) )
  )
)

(print
  (myfunc2 1 3 5)
)
(print
  (myfunc2 2 3 5)
)
