#!/bin/bash
set -e -x

sed -i "s/name='fasttext',/name='fasttext-wheel',/" fastText/setup.py
cd fastText
cp ../pyproject.toml .

# Build a sdist
/opt/python/cp310-cp310/bin/python setup.py sdist
mv dist/*.tar.gz /io/dist/

# Compile wheels
for PYBIN in /opt/python/cp3{7..11}*/bin; do
    "${PYBIN}/python" setup.py bdist_wheel
done

# Bundle external shared libraries into the wheels
for whl in dist/fasttext*.whl; do
    auditwheel repair "$whl" -w /io/dist/
done
