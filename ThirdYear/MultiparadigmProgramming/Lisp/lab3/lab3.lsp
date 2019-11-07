(defun make-elem (title price)
      (list :title title :price price)
)

(defvar *db* nil)
(defvar clst nil)

(defun prompt-read (prompt)
      (format *query-io* "~a: " prompt)
      (force-output *query-io*)
      (read-line *query-io*)
)

(defun add-record (elem)
      (push elem *db*)
)

(defun prompt-for-elem ()
      (make-elem
            (prompt-read "ProductName")
            (prompt-read "Price")
      )
)

(defun add-elems ()
      (loop (add-record (prompt-for-elem))
            (if (not (y-or-n-p "Добавить элемент? [y/n]: ")) (return))
      )
)

(defun dump (db)
      (dolist (elem db)
            (format t "~%~{~a:~10t~a~%~}" elem)
      )
)

(defun select (selector-fn)
      (remove-if-not selector-fn *db*)
)

(defun where (&key title price)
      (lambda (elem)
            (and
                  (if (not (equal title ""))   (equal (getf elem :title) title) t)
                  (if (not (equal price ""))   (equal (getf elem :price) price) t)
            )
      )
)

(defun whereTitle (&key title)
      (lambda (elem)
            (and
                  (if (not (equal title ""))   (equal (getf elem :title) title) t)
            )
      )
)

(defun update (selector-fn &key title price)
      (setf *db*
            (mapcar
                  (lambda (row)
                        (when (funcall selector-fn row)
                              (if (not (equal title ""))  (setf (getf row :title) title))
                              (if (not (equal price ""))  (setf (getf row :price) price))
                        )
                        row
                  ) *db*
            )
      )
)

(defun delete-rows (selector-fn)
      (setf *db* (remove-if selector-fn *db*))
)

(defun save-db (filename)
      (with-open-file (out filename
                       :direction :output
                       :if-exists :supersede)
                       (with-standard-io-syntax (print *db* out))
      )
)

(defun load-db (filename)
      (with-open-file (in filename) (with-standard-io-syntax (setf *db* (read in))))
)

(defun sort-db ()
      (setq clst (copy-list *db*))
      (sort clst (lambda (a b) (< (parse-integer (fourth a)) (parse-integer (fourth b)))))
)

(defun menu ()
      (print "1 - Добавить магнитопровод;")
      (print "2 - Вывести все данные из БД;")
      (print "3 - Удалить выбранный элемент;")
      (print "4 - Изменить элемент;")
      (print "5 - Найти элемент;")
      (print "6 - Сохранить БД на диск;")
      (print "7 - Загрузить БД с диска;")
      (print "8 - Сортировать данные по цене;")
      (print "9 - Выйти из СУБД;")
      (terpri)
)

(defun start-menu ()
      (loop (menu)
            (case (parse-integer (prompt-read "Выберите действие"))
                  (1 (add-elems))
                  (2 (dump *db*))
                  (3 (delete-rows (where :title (prompt-read "ProductName") :price (prompt-read "Price"))))
                  (4 (update (where :title (prompt-read "ProductName") :price (prompt-read "Price")) :title (prompt-read "New ProductName") :price (prompt-read "New price")))
                  (5 (dump (select (whereTitle :title (prompt-read "ProductName")))))
                  (6 (save-db (prompt-read "Введите название файла")))
                  (7 (load-db (prompt-read "Введите название файла")))
                  (8 (dump (sort-db)))
                  (9 (return))
            )
      )
)

(start-menu)
