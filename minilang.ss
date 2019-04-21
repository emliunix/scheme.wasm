(library (minilang)
  (export
   parse-let)
  (import
    (chezscheme)
    (parser))

  (define parse-let
    (let [(p-type
	   (p-choice
	    (p-bind
	     (p-eqv? ':)
	     (lambda (_)
	       (p-bind
		p-take-one
		(lambda (type)
		  (p-pure type)))))
	    (p-pure '())))
	  (p-value
	   (p-choice
	    (p-bind
	     (p-eqv? '=)
	     (lambda (_)
	       (p-bind
		p-take-one
		(lambda (value)
		  (p-pure value)))))
	    (p-pure '())))]
      (p-bind
       (p-eqv? 'let)
       (lambda (_)
	 (p-bind
	  (p-pred symbol?)
	  (lambda (name)
	    (p-bind
	     p-type
	     (lambda (type)
	       (p-bind
		p-value
		(lambda (value)
		  (if (and (null? type) (null? value))
		      (p-fail "invalid let, either type or value is required")
		      (p-pure (list name type value)))))))))))))

  (define (tranx-statements env ins outs)
    (if (null? ins)
	outs
	(let* [(s (car ins))
	       (rest-ins (cdr ins))
	       (outs-
		(case (if (list? s) (car s) '())
		  [(let)
		   '()]
		  [(set!) '()]
		  ;;[(if)]
		  ;;[(while)]
		  ;;[(expr)]
		  [(return) '()]
		  [else '()] ;; plain expression
		  ))]
	  (tranx-statements env rest-ins (append outs outs-)))))

  (define (mk-env globals params) '())
  (define (globals-add globals name val) '())

  (define (tranx-function globals types name params body)
    (let [(globals (globals-add globals name 'partial-func))]
      (list 'fun
	    name params
	    (tranx-statements (mk-env globals params) body '()))))

  (define (tranx-expression) '())

  ;; expression :=
  ;;   (prime-op variables)
  (define (tranx-expression-simple expr env)
    '())
  )
