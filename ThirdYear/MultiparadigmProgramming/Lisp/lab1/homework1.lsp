(defun memb (a s)
    (cond
        ((null (atom a)) nil)
        ((null (listp a)) nil)
        ((null s) nil)
        ((equal a (car s)) t)
        (t (memb a (cdr s)))
    )
)

(defun unio (s1 s2)
    (cond
        ((null s1) s2)
        ((null s2) s1)
        ((memb (car s2) s1) (unio s1 (cdr s2)))
        (t (cons (car s2) (unio s1 (cdr s2))))
    )
)

(defun minus (s1 s2)
    (cond
        ((null s1) nil)
        ((null s2) s1)
        ((memb (car s1) s2) (minus (cdr s1) s2) )
        (t (cons (car s1) (minus (cdr s1) s2)))
    )
)

(defun inter (s1 s2)
    (cond
        ((null s1) s1)
        ((null s2) nil)
        ((memb (car s1) s2) (cons (car s1) (inter (cdr s1) s2)))
        (t (inter (cdr s1) s2))
    )
)
