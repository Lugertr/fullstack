package hotel

import "errors"

//----------------------------------------------------------------------------

type UsersList struct {
	Id     int
	UserId int
	ListId int
}

//клиент
type Client struct {
	Client_id   int    `json:"client_id" db:"client_id"`
	Client_name string `json:"client_name" db:"client_name"`
	Family_name string `json:"family_name" db:"family_name"`
	Surname     string `json:"surname" db:"surname"`
	Passport    string `json:"passport" db:"passport"`
	Gender      string `json:"gender" db:"gender"`
	App_id      int    `json:"app_id" db:"app_id"`
	Date_in     string `json:"date_in" db:"date_in"`
	Date_out    string `json:"date_out" db:"date_out"`
	Done        bool   `json:"done" db:"done"`
}

type ClientUpdate struct {
	Client_name *string `json:"client_name"`
	Family_name *string `json:"family_name"`
	Surname     *string `json:"surname"`
	Passport    *string `json:"passport"`
	Gender      *string `json:"gender"`
	App_id      *int    `json:"app_id"`
	Date_in     *string `json:"date_in"`
	Date_out    *string `json:"date_out"`
}

//номера отелей

type App struct {
	App_id      int     `json:"app_id" db:"app_id"`
	Rooms       int     `json:"rooms" db:"rooms"`
	App_type_id int     `json:"app_type_id" db:"app_type_id"`
	AppStatus   int     `json:"app_status" db:"app_status"`
	App_price   float64 `json:"app_price" db:"app_price"`
}

type AppUpdate struct {
	Rooms       *int     `json:"rooms"`
	App_type_id *int     `json:"app_type_id"`
	AppStatus   *int     `json:"app_status"`
	App_price   *float64 `json:"app_price"`
}

//виды номеров отелей
type AppType struct {
	App_type_id   int    `json:"app_type_id" db:"app_type_id"`
	App_type_name string `json:"app_type_name" db:"app_type_name"`
}

type AppTypeUpdate struct {
	App_type_name *string `json:"app_type_name"`
}

//Сервисы
type AppService struct {
	Service_id      int `json:"service_id" db:"service_id"`
	Client_id       int `json:"client_id" db:"client_id"`
	Service_type_id int `json:"service_type_id" db:"service_type_id"`
	Days_count      int `json:"days_count" db:"days_count"`
}

type AppServiceUpdate struct {
	Client_id       *int `json:"client_id"`
	Service_type_id *int `json:"service_type_id"`
	Days_count      *int `json:"days_count"`
}

//Типы сервисов
type AppServiceType struct {
	Service_type_id   int     `json:"service_type_id" db:"service_type_id"`
	Service_type_name string  `json:"service_type_name" db:"service_type_name"`
	Price             float64 `json:"price" db:"price"`
}

type AppServiceTypeUpdate struct {
	Service_type_name *string  `json:"service_type_name"`
	Price             *float64 `json:"price"`
}

//----------------------------------------------------------------------------

type UpdateListInput struct {
	Title       *string `json:"title"`
	Description *string `json:"description"`
}

func (i UpdateListInput) Validate() error {
	if i.Title == nil && i.Description == nil {
		return errors.New("update structure has no values")
	}

	return nil
}

type UpdateItemInput struct {
	Title       *string `json:"title"`
	Description *string `json:"description"`
	Done        *bool   `json:"done"`
}

func (i UpdateItemInput) Validate() error {
	if i.Title == nil && i.Description == nil && i.Done == nil {
		return errors.New("update structure has no values")
	}

	return nil
}
