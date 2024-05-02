package main

import (
	"log/slog"
	"os"
)

var VERSION string = "development" // production builds have VERSION dynamically linked.

func main() {
	slog.Info("Main", slog.Group("environment", slog.String("key", "VERSION"), slog.String("value", os.Getenv("VERSION"))))
}

func init() {
	slog.SetLogLoggerLevel(slog.LevelDebug)
	slog.Debug("Initialization", slog.Group("variable", slog.String("name", "VERSION"), slog.String("value", VERSION)))
	if e := os.Setenv("VERSION", VERSION); e != nil {
		panic(e)
	}
}
