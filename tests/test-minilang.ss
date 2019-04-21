(import
  (chezscheme)
  (minilang))

;; full form
(let [(r (parse-let '(let x : int = 1)))]
  (let [(tag (car r))
	(v (cadr r))
	(rest (caddr r))]
    (assert (eqv? 'succ tag))
    (assert (eqv? 'x (car v)))
    (assert (eqv? 'int (cadr v)))
    (assert (eqv? 1 (caddr v)))
    (assert (null? rest))))

;; only value
(let [(r (parse-let '(let x = 1)))]
  (let [(tag (car r))
	(v (cadr r))
	(rest (caddr r))]
    (assert (eqv? 'succ tag))
    (assert (eqv? 'x (car v)))
    (assert (null? (cadr v)))
    (assert (eqv? 1 (caddr v)))
    (assert (null? rest))))

;; only type
(let [(r (parse-let '(let x : int)))]
  (let [(tag (car r))
	(v (cadr r))
	(rest (caddr r))]
    (assert (eqv? 'succ tag))
    (assert (eqv? 'x (car v)))
    (assert (eqv? 'int (cadr v)))
    (assert (null? (caddr v)))
    (assert (null? rest))))

;; invalids
(assert (eqv? 'fail (car (parse-let '(let x)))))
(assert (eqv? 'fail (car (parse-let '()))))
(assert (eqv? 'fail (car (parse-let '(let)))))
(assert (eqv? 'fail (car (parse-let '(x)))))
(assert (eqv? 'fail (car (parse-let '(x a : y = z)))))
