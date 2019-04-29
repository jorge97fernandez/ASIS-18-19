#!/bin/bash
for i in $(ls as_tests_practicas/tests/test_practica"$1"_*.py) ; do
	python "$i"
done
