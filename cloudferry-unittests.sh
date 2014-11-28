#http://stackoverflow.com/questions/5506110/is-it-possible-to-install-another-version-of-python-to-virtualenv

path=$PWD
py_path=$path/.python27
src_path=$path/src
cf_path=$path/cloudferry

#install python2.7.2
if [ ! -d $py_path ]; then
	PY_VER=2.7.2
	if [ ! -d $src_path ]; then mkdir $src_path; fi
	if [ ! -d $py_path ]; then mkdir $py_path; fi
	cd $src_path
	if [ ! -d Python-${PY_VER} ]; then
		wget http://www.python.org/ftp/python/${PY_VER}/Python-${PY_VER}.tgz
		tar -zxf Python-${PY_VER}.tgz
	fi
	cd Python-${PY_VER}
	if [ -d Python-${PY_VER} ]; then
		make clean 
	fi
	./configure --prefix=$py_path
	make
	make install
fi

#install virtualenv
VENV_VER=1.11.6
VENV_NAME=virtualenv-${VENV_VER}.tar.gz
cd $src_path
[ -f $VENV_NAME ] || wget http://pypi.python.org/packages/source/v/virtualenv/$VENV_NAME
tar -zxf $VENV_NAME
cd virtualenv-${VENV_VER}/
$py_path/bin/python setup.py install

#install pip
cd $src_path
[ -f get-pip.py ] || wget https://bootstrap.pypa.io/get-pip.py
$py_path/bin/python get-pip.py


#create venv
cd $cf_path
$py_path/bin/virtualenv venv --python=$py_path/bin/python2.7
#activate venv
source venv/bin/activate

#write some requirements.txt
cd $cf_path
[  -f requirements.txt ] || cat <<ENDOFREQ >requirements.txt
fabric>=1.8.2
flake8
ipaddr
jinja2
--allow-external mysql-connector-python
mysql-connector-python
nose
oslo.config>=1.2.0
oslotest
paramiko>=1.8.0
python-cinderclient
python-glanceclient<=0.13.0
python-keystoneclient
python-neutronclient>=2.3.0,<3
python-novaclient
rednose
sqlalchemy
virtualenv
ENDOFREQ

pip install -r requirements.txt


#run tests
cd $cf_path
#clear all pyc files so python have to create new ones.
find . -name "*.pyc" -exec rm -rf {} \;
venv/bin/python --version

#run pep checker
venv/bin/flake8 --statistics --show-source cloud/ cloudferrylib/ tests/

export NOSE_REDNOSE=1
venv/bin/python venv/bin/nosetests -v --force-color


#deactivate venv
deactivate
