# Web-Test3

## About
Simple bulletin board test project

## Obtaining
` $ cd ~/quicklisp/local-projects `  
` $ git clone --recurse-submodules https://github.com/tttuuu888/web-test3-server.git web-test3 `

## Running

### Server
Run for development  
` $ sbcl `

```
(ql:quickload :web-test3)

(in-package :web-test3)

(main)
```

### Client
` $ cd web-test3-client `  
` $ yarn serve `
