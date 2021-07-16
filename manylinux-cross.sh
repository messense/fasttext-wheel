#!/bin/bash
set -e -x

sed -i "s/name='fasttext',/name='fasttext-wheel',/" fastText/setup.py
cd fastText

SYSROOT=`$TARGET_CC --print-sysroot`

# Compile wheels
python3.6 -m pip install crossenv
python3.6 -m crossenv /opt/python/cp36-cp36m/bin/python3 --cc $TARGET_CC --cxx $TARGET_CXX --sysroot $SYSROOT venv-py36
. venv-py36/bin/activate
pip install wheel
python setup.py bdist_wheel --plat-name "manylinux2014_$ARCH" --dist-dir ../dist/
deactivate

python3.7 -m pip install crossenv
python3.7 -m crossenv /opt/python/cp37-cp37m/bin/python3 --cc $TARGET_CC --cxx $TARGET_CXX --sysroot $SYSROOT venv-py37
. venv-py37/bin/activate
pip install wheel
python setup.py bdist_wheel --plat-name "manylinux2014_$ARCH" --dist-dir ../dist/
deactivate

python3.8 -m pip install crossenv
python3.8 -m crossenv /opt/python/cp38-cp38/bin/python3 --cc $TARGET_CC --cxx $TARGET_CXX --sysroot $SYSROOT venv-py38
. venv-py38/bin/activate
pip install wheel
python setup.py bdist_wheel --plat-name "manylinux2014_$ARCH" --dist-dir ../dist/
deactivate

python3.9 -m pip install crossenv
python3.9 -m crossenv /opt/python/cp39-cp39/bin/python3 --cc $TARGET_CC --cxx $TARGET_CXX --sysroot $SYSROOT venv-py39
. venv-py39/bin/activate
pip install wheel
python setup.py bdist_wheel --plat-name "manylinux2014_$ARCH" --dist-dir ../dist/
deactivate

cd ..

# auditwheel symbols
python3 -m pip install -U auditwheel-symbols
for whl in dist/fasttext*.whl; do
    auditwheel-symbols "$whl"
done

# Bundle external shared libraries into the wheels
# for whl in dist/fasttext*.whl; do
#     python3.9 -m auditwheel repair "$whl" -w /io/dist/
# done
