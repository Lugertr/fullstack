package repository

import (
	"fmt"
	"hotel"
	"strings"

	"github.com/jmoiron/sqlx"
	"github.com/sirupsen/logrus"
)

type AppServicePostgres struct {
	db *sqlx.DB
}

func NewAppServicePostgres(db *sqlx.DB) *AppServicePostgres {
	return &AppServicePostgres{db: db}
}

func (r *AppServicePostgres) Create(appService hotel.AppService) (int, error) {
	tx, err := r.db.Begin()
	if err != nil {
		return 0, err
	}

	var id int
	createappServiceQuery := fmt.Sprintf("INSERT INTO %s (service_id, Client_id, Service_type_id, Days) VALUES ($1, $2, $3, $4) RETURNING id", appServiceTable)
	row := tx.QueryRow(createappServiceQuery,
		appService.Service_id,
		appService.Client_id,
		appService.Service_type_id,
		appService.Days,
	)
	if err := row.Scan(&id); err != nil {
		tx.Rollback()
		return 0, err
	}

	return id, tx.Commit()
}

func (r *AppServicePostgres) GetAll() ([]hotel.AppService, error) {
	var appServices []hotel.AppService
	query := fmt.Sprintf("SELECT * FROM %s", appServiceTable)
	err := r.db.Select(&appServices, query)

	return appServices, err
}

func (r *AppServicePostgres) GetById(appServiceId int) (hotel.AppService, error) {
	var appService hotel.AppService

	query := fmt.Sprintf(`SELECT * FROM %s tl WHERE tl.service_id = $1`,
		appServiceTable)
	err := r.db.Get(&appService, query, appServiceId)
	return appService, err
}

func (r *AppServicePostgres) Delete(appServiceId int) error {
	query := fmt.Sprintf(`DELETE FROM %s tl WHERE tl.service_id = $1`,
		appServiceTable)
	_, err := r.db.Exec(query, appServiceId)

	return err
}

func (r *AppServicePostgres) Update(appServiceId int, input hotel.AppServiceUpdate) error {
	setValues := make([]string, 0)
	args := make([]interface{}, 0)
	argId := 1

	if input.Client_id != nil {
		setValues = append(setValues, fmt.Sprintf("client_id=$%d", argId))
		args = append(args, *input.Client_id)
		argId++
	}

	if input.Service_type_id != nil {
		setValues = append(setValues, fmt.Sprintf("service_type_id=$%d", argId))
		args = append(args, *input.Service_type_id)
		argId++
	}

	if input.Days != nil {
		setValues = append(setValues, fmt.Sprintf("days=$%d", argId))
		args = append(args, *input.Days)
		argId++
	}

	setQuery := strings.Join(setValues, ", ")

	query := fmt.Sprintf("UPDATE %s tl SET %s WHERE tl.service_id = $%d",
		appServiceTable, setQuery, argId)

	args = append(args, appServiceId)

	logrus.Debugf("updateQuery: %s", query)
	logrus.Debugf("args: %s", args)

	_, err := r.db.Exec(query, args...)

	return err
}
