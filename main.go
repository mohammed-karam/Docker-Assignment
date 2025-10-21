package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "Hello - this is a Dockerized Go app!")
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintln(w, "OK")
	})

    // FIX 1: Was %%s
	log.Printf("Starting server on :%s\n", port) 
	if err := http.ListenAndServe(":"+port, nil); err != nil {
        // FIX 2: Was %%v
		log.Fatalf("server failed: %v", err) 
	}
}