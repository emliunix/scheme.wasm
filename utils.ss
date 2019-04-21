(library (utility (1))
  (export
   member?)
  (import
    (chezscheme))

  (define (member? x xs)
    (let _iter [(xs xs)]
      (cond
       [(null? xs) #f]
       [(eqv? x (car xs)) #t]
       [else (_iter (cdr xs))])))

)
