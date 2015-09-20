app.js : app.coffee ./web/js/main.js ; coffee -c app.coffee 
./web/js/main.js : ./web/js/main.coffee ; coffee -c ./web/js/main.coffee
.PHONY: clean
clean: ; rm *.js
