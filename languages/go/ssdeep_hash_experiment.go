package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/glaslos/ssdeep"
)

var (
	test_strings = []string{
		`AAAAAAAAAAAAAAAAAAAAAA this is error 1000`,
		`AAAAAAAAAAAAAAAAAAAAAA this is error 1001`,
		`AAAAAAAAAAAAAAAAAAAAAA this is error 1002`,
		`AAAAAAAAAAAAAAAAAAAAAA totally different thing that you would expect`,
		`AAAAAAAAAAAAAAAAAAAAAA totally different thing that you would not expect`,
		`AAAAAAAAAAAAAAAAAAAAAA totally different thing that you would maybe expect`,
		`AAAAAAAAAAAAAAAAAAAAAA totally different thing that you would never know about`,
		`AAAAAAAAAAAAAAAAAAAAAA pika pika`,
		`AAAAAAAAAAAAAAAAAAAAAA pika pika chu`,
		`AAAAAAAAAAAAAAAAAAAAAA pika pikaaaa`,
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

	var hashes []string
	for _, testReader := range testReaders {
		str, err := ssdeep.FuzzyReader(testReader, int(testReader.Size()))
		if err != nil {
			fmt.Println("problem processing test string:", err)
			os.Exit(1)
		}

		hashes = append(hashes, str)
		fmt.Println(str)
	}

	fmt.Println("")

	fmt.Println("score of first and second hash: ")
	ret, _ := ssdeep.Distance(hashes[0], hashes[1])
	fmt.Println(ret)

	fmt.Println("score of first and last: ")
	ret, _ = ssdeep.Distance(hashes[0], hashes[len(hashes)-1])
	fmt.Println(ret)

	fmt.Println("score of first and fourth: ")
	ret, _ = ssdeep.Distance(hashes[0], hashes[3])
	fmt.Println(ret)
}
