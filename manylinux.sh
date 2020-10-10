#!/bin/bash
set -e -x

sed -i "s/name='fasttext',/name='fasttext-wheel',/" fastText/setup.py
cd fastText

# Compile wheels
for PYBIN in /opt/python/cp27*/bin; do
    "${PYBIN}/python" setup.py bdist_wheel
done

for PYBIN in /opt/python/cp3[56789]*/bin; do
    "${PYBIN}/python" setup.py bdist_wheel
done

# Bundle external shared libraries into the wheels
for whl in dist/fasttext*.whl; do
    auditwheel repair "$whl" -w /io/dist/
done
