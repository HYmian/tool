#! /bin/sh

# Golang Enviroment
export GOROOT=/usr/lib/golang
export GOPATH=$HOME/workspace/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Java Environment
export JAVA_HOME=/usr/lib/jvm/java
export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
export PATH=$PATH:$JAVA_HOME/bin
