fuelhost=${1-fuel-4.1}
envid=${2-3}
path=$PWD
py_path=$path/.python27
src_path=$path/.src
prj_path=$path/poke-ostf

#install python2.7.2
if [ ! -d "$py_path" ]; then
	PY_VER=2.7.2
	if [ ! -d "$src_path" ]; then mkdir "$src_path"; fi
	if [ ! -d "$py_path" ]; then mkdir "$py_path"; fi
	cd "$src_path"
	if [ ! -d Python-${PY_VER} ]; then
		wget http://www.python.org/ftp/python/${PY_VER}/Python-${PY_VER}.tgz
		tar -zxf Python-${PY_VER}.tgz
	fi
	cd "Python-${PY_VER}"
	if [ -d Python-${PY_VER} ]; then
		make clean 
	fi
	./configure --prefix="$py_path"
	make
	make install
fi

#install virtualenv
VENV_VER=1.11.6
VENV_NAME=virtualenv-${VENV_VER}.tar.gz
cd "$src_path"
if [ ! -f $VENV_NAME ]; then
	wget http://pypi.python.org/packages/source/v/virtualenv/$VENV_NAME
	tar -zxf $VENV_NAME
	cd virtualenv-${VENV_VER}/
	"$py_path/bin/python" setup.py install
fi

#install pip
cd "$src_path"
if [ ! -f get-pip.py ]; then
	wget https://bootstrap.pypa.io/get-pip.py
	"$py_path/bin/python" get-pip.py
fi

#create venv
cd "$prj_path"
"$py_path/bin/virtualenv" venv --python="$py_path/bin/python2.7"
#activate venv
source venv/bin/activate
# install requirements if it exists
[ -f requirements.txt ] && pip install -r requirements.txt

# run ostf tests
echo SERVER_ADDRESS: "$fuelhost" >config.yaml

count=0
cmd="venv/bin/python fuel health --env $envid --checktests 'fuel_health.tests.sanity.test_sanity_compute.SanityComputeTest.test_list_flavors'"
until ${cmd}; do
    if [[ "$count" != 5 ]]; then
        count=$((count+1))
        echo "sleep 1 sec..."
        sleep 1
    else
        echo "Env ${envid} at ${fuelhost} fails healthchecks... Exiting"
        exit 1
    fi
done


#deactivate venv
deactivate