(set 'port 1234)
(set 'listen (net-listen port))
(unless listen (begin
    (print "listening failed\n")
    (exit)))

(print "Waiting for connection on: " port "\n")

(set 'connection (net-accept listen))
(if connection
    (while (net-receive connection buff 1024 "\n")
        (print buff)
        (if (= buff "\r\n") (exit)))
    (print "Could not connect\n"))
