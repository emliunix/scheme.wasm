(import
  (chezscheme)
  (parser))
(define (expect-parser-succ p input fn)
  (let* [(r (p input))
	 (tag (car r))
	 (v (cadr r))]
    (assert (eqv? tag 'succ))
    (fn v (caddr r))))

(expect-parser-succ
 (p-pure "some val")
 '(a b c)
 (lambda (v rest)
   (assert (equal? v "some val"))
   (assert (equal? rest '(a b c)))))

(expect-parser-succ
 (p-bind
  (p-pure "some val")
  (lambda (v) (p-pure v)))
 '(a b c)
 (lambda (v rest)
   (assert (equal? v "some val"))
   (assert (equal? rest '(a b c)))))

(expect-parser-succ
 (p-eqv? 'a)
 '(a b c)
 (lambda (v rest)
   (assert (equal? v 'a))
   (assert (equal? rest '(b c)))))

(expect-parser-succ
 (p-choice
  (p-eqv? 'b)
  (p-pure 'test))
 '(a b c)
 (lambda (v rest)
   (assert (equal? v 'test))
   (assert (equal? rest '(a b c)))))

(expect-parser-succ
 (p-repeat number?)
 '(1 2 3 a b c)
 (lambda (v rest)
   (assert (equal? v '(1 2 3)))
   (assert (equal? rest '(a b c)))))

(expect-parser-succ
 (p-multi
  p-take-one
  p-take-one
  p-take-one)
 '(1 2 3 a b c)
 (lambda (v rest)
   (assert (equal? v '(1 2 3)))
   (assert (equal? rest '(a b c)))))
