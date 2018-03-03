#!/bin/bash

PATH_SAVED=`pwd`
cd ~/caffe2_deploy
export PYTHONPATH=$PYTHONPATH:`pwd`/caffe2/build
python2 -c 'from caffe2.python import core' 2>/dev/null && echo "Success" || echo "Failure"
python2 -c 'from caffe2.python import workspace; print(workspace.NumCudaDevices())'
cd $PATH_SAVED

python2 ~/caffe2_deploy/detectron/tests/test_spatial_narrow_as_op.py
