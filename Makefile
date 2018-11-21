
NAMESPACE:=monitoring
.PHONY: gencerts
gencerts:
	@echo Generating certs
	cfssl gencert -ca=/etc/kubernetes/ssl/ca.pem \
           -ca-key=/etc/kubernetes/ssl/ca-key.pem  \
           -config=/opt/ssl/config.json  \
           -profile=kubernetes custom-metrics-apiserver-csr.json | cfssljson -bare serving

.PHONY: gensecret
gensecret: gencerts
	@echo Create secret on kubernetes
	kubectl create secret generic cm-adapter-serving-certs --from-file=serving.crt=./serving.pem --from-file=serving.key=./serving-key.pem -n $(NAMESPACE)
	
.PHONY: metrics-server
metrics-server:
	@echo Deploy metrics server
	kubectl apply -f ./metrics-server/


.PHONY: custom-metrics
custom-metrics:
	@echo Deploy custom metrics api server
	kubectl apply -f ./custom-metrics/

.PHONY: hpa
hpa:
	@echo Deploy demo deployment and demo hpa
	kubectl apply -f ./podinfo/podinfo-dep.yaml
	kubectl apply -f ./podinfo/podinfo-hpa.yaml

.PHONY: custom-hpa
custom-hpa:
	@echo Deploy demo deployment and custom hpa
	kubectl apply -f ./podinfo/podinfo-dep.yaml
	kubectl apply -f ./podinfo/podinfo-hpa-custom.yaml

