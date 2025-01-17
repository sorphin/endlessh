FROM alpine:3.16 as builder
RUN apk add --no-cache build-base
ADD endlessh.c Makefile /
RUN make

FROM alpine:3.16
EXPOSE 2222/tcp
ENTRYPOINT ["/endlessh"]
CMD ["-4vs"]
COPY --from=builder /endlessh /
