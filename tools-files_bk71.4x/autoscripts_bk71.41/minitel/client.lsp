; client connects to sender
(define message-from-server)
(if (not (set 'connection (net-connect "host.com" 123)))
    (println (net-error)))
; maximum bytes to receive
(constant 'max-bytes 1024)
; message send-receive loop
(while (not (net-error))
     (net-send connection (format "NICK %s \r\n" "FFFFF")
     (net-receive connection message-from-server max-bytes)
	(print message-from-server)
)
