#!/bin/bash

cfssl gencert -ca=/etc/kubernetes/ssl/ca.pem \
   -ca-key=/etc/kubernetes/ssl/ca-key.pem  \
   -config=/opt/ssl/config.json  \
   -profile=kubernetes custom-metrics-apiserver-csr.json | cfssljson -bare serving

kubectl create secret generic cm-adapter-serving-certs --from-file=serving.crt=./serving.pem --from-file=serving.key=./serving-key.pem -n monitoring 
