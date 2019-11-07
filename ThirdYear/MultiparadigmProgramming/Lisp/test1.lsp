;; вариант 1
;; A U (B n (C / D))

(defun test (A B C D cond)
    (cond
        ((equal cond 1)
            (cond
                ((null B) nil)
                ((null (listp B)) nil)
                ((equal A (car B)) t)
                (t (test A (cdr B) nil nil 1))
            )
        )
        ((equal cond 2)
            (cond
                ((null A) B)
                ((null B) A)
                ((test (car B) A nil nil 1) (test A (cdr B) nil nil 2))
                (t (cons (car B) (test A (cdr B) nil nil 2)))
            )
        )
        ((equal cond 3)
            (cond
                ((null A) B)
                ((null B) nil)
                ((test (car B) A nil nil 1) (test (list (car B)) (test A (cdr B) nil nil 3) nil nil 2))
                (t (test A (cdr B) nil nil 3))
            )
        )
        ((equal cond 4)
            (cond
                ((null A) nil)
                ((null B) A)
                ((test (car A) B nil nil 1) (test (cdr A) B nil nil 4))
                (t (test (list (car A)) (test (cdr A) B nil nil 4) nil nil 2))
            )
        )
        ((null A) nil)
        ((null cond)
            (test A (test B (test C D nil nil 4) nil nil 3) nil nil 2)
        )
    )
)

;; 1 - member
;; 2 - union
;; 3 - intersect
;; 4 - except

(print
    (test '(1 2 3 4) '(6 7 8) '(7 8) '(8 9) nil)
);; 1 2 3 4 7
(terpri)
