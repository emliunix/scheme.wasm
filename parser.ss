(library (parser)
  (export
   p-pure
   p-fail
   p-bind
   p-take-one
   p-eqv?
   p-pred
   p-choice
   p-repeat
   p-multi)
  (import (chezscheme))

  (define (p-pure x)
    (lambda (input)
      (list 'succ x input)))

  (define (p-fail msg)
    (lambda (input)
      (list 'fail msg)))

  (define (p-bind p cont)
    (lambda (input)
      (let* [(r (p input))
	     (tag (car r))
	     (v (cadr r))]
	(case tag
	  [(succ)
	   (let [(input- (caddr r))]
	     ((cont v) input-))]
	  [(fail) r]))))

  (define (p-take-one input)
    (if (null? input)
	(list 'fail "no input")
	(list 'succ (car input) (cdr input))))

  (define (p-eqv? v)
    (p-bind
     p-take-one
     (lambda (v2)
       (if (eqv? v v2)
	   (p-pure v)
	   (p-fail "fail eqv?")))))

  (define (p-pred pred?)
    (p-bind
     p-take-one
     (lambda (v)
       (if (pred? v)
	   (p-pure v)
	   (p-fail "fail pred?")))))

  (define (p-choice p1 p2)
    (lambda (input)
      (let [(r1 (p1 input))]
	(case (car r1)
	  [(succ) r1]
	  [(fail) (p2 input)]))))

  (define (p-repeat p)
    (define (p-repeat-recur p acc)
      (p-bind
       p
       (lambda (v)
	 (p-choice
	  (p-repeat-recur p (cons v acc))
	  (p-pure (reverse acc))))))
    (p-repeat-recur p '()))

  ;; utilities

  (define (p-multi ps)
    (define (p-multi-recur ps acc)
      (if (null? ps)
	  (p-pure (reverse acc))
	  (p-bind (car ps)
		  (lambda (v)
		    (p-multi-recur (cdr ps) (cons v acc))))))
    (p-multi-recur ps '())))
