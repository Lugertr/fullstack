package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func handleRequest(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	if r.Method == "OPTIONS" {
		w.WriteHeader(http.StatusOK)
		return
	}

	if r.Method == "POST" {
		body, err := ioutil.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "Error reading request body", http.StatusInternalServerError)
		} else {
			fmt.Println("Request body:", string(body))
			w.Write([]byte("Data received"))
		}
	} else if r.Method == "GET" {
		body, err := ioutil.ReadAll(r.Body)
		if err != nil {
			http.Error(w, "Error reading request body", http.StatusInternalServerError)
		} else {
			fmt.Println("Request body:", string(body))
			w.Write([]byte("Data received"))
		}
	} else {
		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
	}
}

func main() {
	http.HandleFunc("/", handleRequest)
	fmt.Println("Starting server on port 8009")
	http.ListenAndServe(":8009", nil)
}
