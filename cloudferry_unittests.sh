#http://stackoverflow.com/questions/5506110/is-it-possible-to-install-another-version-of-python-to-virtualenv

path=$PWD
py_path=$path/.python27

#install python2.7.2
if [ ! -d $py_path ]; then
	PY_VER=2.7.2
	if [ ! -d $path/src ]; then mkdir $path/src; fi
	if [ ! -d $py_path ]; then mkdir $py_path; fi
	cd ./src
	if [ ! -d Python-${PY_VER} ]; then
		wget http://www.python.org/ftp/python/${PY_VER}/Python-${PY_VER}.tgz
		tar -zxvf Python-${PY_VER}.tgz
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
cd $path/src
wget http://pypi.python.org/packages/source/v/virtualenv/virtualenv-${VENV_VER}.tar.gz
tar -zxvf virtualenv-${VENV_VER}.tar.gz
cd virtualenv-${VENV_VER}/
$py_path/bin/python setup.py install

#install pip
cd $path/src
wget https://bootstrap.pypa.io/get-pip.py
$py_path/bin/python get-pip.py


#create venv
cd $path
$py_path/bin/virtualenv venv --python=$py_path/bin/python2.7
#activate venv
source venv/bin/activate

#write some requirements.txt
cd $path
if [ ! -f requirements.txt ]; then 
    cat <<ENDOFREQ >requirements.txt
python-novaclient
python-cinderclient
python-glanceclient
python-keystoneclient
fabric>=1.8.2
paramiko>=1.8.0
oslo.config>=1.2.0
jinja2
oslotest
virtualenv
sqlalchemy
python-neutronclient>=2.3.0,<3
ipaddr
nose
ENDOFREQ
fi
pip install -r requirements.txt


#run tests
cd $path
#clear all pyc files so python have to create new ones.
find . -name "*.pyc" -exec rm -rf {} \;
venv/bin/python --version
venv/bin/python venv/bin/nosetests -v

#deactivate venv
deactivate
