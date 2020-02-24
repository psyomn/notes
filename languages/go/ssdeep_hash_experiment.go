package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/glaslos/ssdeep"
)

var (
	test_strings = []string{
		`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA this is error 1000`,
		`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA this is error 1001`,
		`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA this is error 1002`,
		`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA totally different thing that you would expect`,
		`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA totally different thing that you would not expect`,
		`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA totally different thing that you would maybe expect`,
		`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA totally different thing that you would never know about`,
		`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA pika pika`,
		`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA pika pika chu`,
		`AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA pika pikaaaa`,
	}
)

func main() {
	var testReaders []*strings.Reader

	for _, el := range test_strings {
		reader := strings.NewReader(el)
		testReaders = append(testReaders, reader)
	}

	// the lib has a global flag that will disallow you to
	// actually hash anything unless the input is of certain size.
	// we turn this safeguard off.
	ssdeep.Force = true

	for _, testReader := range testReaders {
		fmt.Println(testReader.Size())
		str, err := ssdeep.FuzzyReader(testReader, int(testReader.Size()))
		if err != nil {
			fmt.Println("problem processing test string:", err)
			os.Exit(1)
		}

		fmt.Println(str)
	}

}
