; sender listens
(constant 'max-bytes 1024)
(if (not (set 'listen (net-listen 123)))
    (print (net-error)))
(while true 
    (set 'connection (net-accept listen)) ; blocking here
    (while (not (net-error))
         (net-receive connection message-from-client max-bytes)
            (print  message-from-client)
            ("")
            )
         (net-send connection "fff")) 
