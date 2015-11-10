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
if [ "$DEBUG" = "yes" ]; then
	set -x
fi

PARAM=''
BRANCH=$(git rev-parse --abbrev-ref HEAD)
WORKPSACE_TMP=/tmp/workspace-$(date +%s)
WORKSPACE_CONF=.git/ref/workspace/$BRANCH

if [ -f $WORKSPACE_CONF ]
then
    cat $WORKSPACE_CONF | git cat-file -p --batch > $WORKPSACE_TMP
fi

get_param() {
    PARAM=$(git config --file $WORKPSACE_TMP $1)
}

set_param() {
    git config --file $WORKPSACE_TMP $1 "$2"
}

finalize() {
    if [ ! -d $(dirname $WORKSPACE_CONF) ]
    then
        mkdir -p $(dirname $WORKSPACE_CONF)
    fi
    git hash-object -w $WORKPSACE_TMP > $WORKSPACE_CONF
    rm $WORKPSACE_TMP
}

