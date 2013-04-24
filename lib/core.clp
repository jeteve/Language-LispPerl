(defmacro ns [name & body]
  `(begin
     (namespace-begin ~name)
     ~@body
     (namespace-end)))

(defmacro defn [name args & body]
  `(def ~name
     (fn ~args ~@body)))

(defmacro defmulti [name dispatch-fn]
  `(def ^{} ~name (fn [dispatch-val & args]
     (apply ((~dispatch-fn dispatch-val) (meta ~name)) (cons dispatch-val args)))))

(defmacro defmethod [name dispatch-val args & body]
  `(~dispatch-val (meta ~name)
     (fn ~args ~@body)))

; Do not use recursive function,
; since we do not support optimazation of tail call.
(defn reduce [afn init alist]
  (def res init)
  (def i 0)
  (def l (length alist))
  (while (< i l)
    (set! res (afn (i alist) res))
    (set! i (+ i 1)))
  res)

(defn map [afn alist]
  (reduce (fn [a i]
    (append i 
      (list (afn a))))
    ()
    alist))

; file
(defn open [file cb]
  (. open file cb))

(defn >> [fh str]
  (. puts fh str))

(defn << [fh]
  (. readline fh))