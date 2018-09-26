from alpine:3.8

copy bin/minibank/ bin/minibank

CMD ["/bin/minibank"]

