#!/bin/sh
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Jeffrey Hutchins
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

# enable debug mode
if [ "$DEBUG" = "yes" ]
then
	set -x
fi

BASE=$PWD
PATH=$PATH:$PWD
RESULT=0
SUCCESS=0
FAILURE=0

setup() {
    mkdir test
    cd test
}

assert_equal() {
    if [ "$1" != "$2" ]
    then
        echo "\"$1\" != \"$2\""
        return 1
    fi
}

teardown() {
    cd $BASE
    rm -rf test
}

init_setup() {
    git init
    touch a
    git add a
    git commit -am "Add a"
    git remote add origin git@github.com:jhutchins/test
}

test_init() {
    init_setup >> /dev/null
    git workspace init >> /dev/null <<INPUTS


INPUTS
    assert_equal "git@github.com:jhutchins" $(git config workspace.master.remote)
    assert_equal master $(git config branch.master.workspace)
    assert_equal test $(git config workspace.master.projects)
}

run_test() {
    setup
    $1
    if [ $? != 0 ]
    then
        echo "$1 failed"
        RESULT=1
        FAILURE=$[FAILURE + 1]
    else
        echo "$1 success"
        SUCCESS=$[SUCCESS + 1]
    fi
    teardown
}

run_test "test_init"

echo
echo "Testing finished"
echo "    successes=$SUCCESS"
echo "    failures=$FAILURE"

exit $RESULT
