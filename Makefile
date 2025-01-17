
BIN=go
# BIN=go1.18beta1

go1.18beta1:
	go install golang.org/dl/go1.18beta1@latest
	go1.18beta1 download

build:
	${BIN} build -v .

test:
	go test -v .
watch-test: tools
	reflex -R assets.go -t 50ms -s -- sh -c 'gotest -v .'

bench:
	gotest -benchmem -bench .

coverage:
	${BIN} test -v -coverprofile cover.out .
	${BIN} tool cover -html=cover.out -o cover.html

# tools
tools:
	${BIN} install github.com/cespare/reflex@latest
	${BIN} install github.com/rakyll/gotest@latest
	${BIN} install github.com/psampaz/go-mod-outdated@latest
	${BIN} install github.com/jondot/goweight@latest
	${BIN} install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	${BIN} install golang.org/x/tools/cmd/cover
	${BIN} get -t -u github.com/sonatype-nexus-community/nancy@latest
	go mod tidy

lint:
	golangci-lint run --timeout 60s --max-same-issues 50 ./...
lint-fix:
	golangci-lint run --timeout 60s --max-same-issues 50 --fix ./...

audit: tools
	${BIN} mod tidy
	${BIN} list -json -m all | nancy sleuth

outdated: tools
	${BIN} mod tidy
	${BIN} list -u -m -json all | go-mod-outdated -update -direct

weight: tools
	goweight
