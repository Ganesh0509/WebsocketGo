package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{}

func main() {

	http.HandleFunc("/echo", handler)
	http.HandleFunc("/", home)

	fmt.Println("Test MY App")
	log.Fatal(http.ListenAndServe(":8080", nil))

}

func handler(res http.ResponseWriter, req *http.Request) {

	Conn, err := upgrader.Upgrade(res, req, nil)

	if err != nil {
		log.Fatal("Done!!!!")
	}

	for {
		messageType, mess, err := Conn.ReadMessage()

		if err != nil {
			return
		}

		fmt.Printf("%s sent: %s\n", Conn.RemoteAddr(), string(mess))
		if err = Conn.WriteMessage(messageType, mess); err != nil {
			return
		}

	}

}

func home(res http.ResponseWriter, req *http.Request) {
	http.ServeFile(res, req, "webscoker.html")
}
