.PHONY: init
init:
	go get -tags 'postgres' -u github.com/golang-migrate/migrate/cmd/migrate
	#go get -u github.com/kyleconroy/sqlc/cmd/sqlc

.PHONY: stop_postgres
stop_postgres:
	docker stop dev-postgres && docker rm dev-postgres

.PHONY: postgres
postgres: stop_postgres
	docker run --name dev-postgres -p 5432:5432 -e POSTGRES_USER=root  -e POSTGRES_PASSWORD=P@ssw0rd -d postgres:12-alpine

.PHONY: createdb
createdb:
	docker exec -it dev-postgres createdb --username=root --owner=root simple_bank

.PHONY: dropdb
dropdb:
	docker exec -it dev-postgres dropdb simple_bank

.PHONY: migrateup
migrateup:
	migrate -path db/migration -database "postgresql://root:P@ssw0rd@localhost:5432/simple_bank?sslmode=disable" -verbose up

.PHONY: migratedown
migratedown:
	migrate -path db/migration -database "postgresql://root:P@ssw0rd@localhost:5432/simple_bank?sslmode=disable" -verbose down

.PHONY: sqlc
sqlc:
	@echo "generating code"
	sqlc generate