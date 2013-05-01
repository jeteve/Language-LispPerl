(ns quoi

  (require file)
  (require anyevent-httpd)

  (def routings {})

  (defn page [url file]
    (#:url routings (fn [req]
      (def S {})
      (if (eq (type file) "xml")
        file
        (if (eq (type file) "function")
          (file S)
          (read file))))))

  (defn start [opts]
    (let [s (anyevent-httpd#server opts)]
      (anyevent-httpd#reg-cb s
        {:request
          (fn [s req]
            (let [url (anyevent-httpd#url req)]
              (reduce (fn [k f]
                (if f
                  (let [m (match k url)]
                    (if (> (length m) 0)
                      (begin
                        (anyevent-httpd#respond req
                          {"content" ["text/html"
                                      (clj->string ((#:k routings) req))]})
                        (anyevent-httpd#stop-respond s)
                        false)
                      f))
                  f))
                true
                (keys routings))))})
      (anyevent-httpd#run s)))

  )