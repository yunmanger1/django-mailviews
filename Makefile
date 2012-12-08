STATIC_DIRECTORY = mailviews/static/mailviews


less:
	npm install .

bootstrap: less
	git submodule update --init
	./node_modules/.bin/lessc vendor/bootstrap/less/bootstrap.less > $(STATIC_DIRECTORY)/css/bootstrap.css
	cp vendor/bootstrap/js/bootstrap-*.js $(STATIC_DIRECTORY)/javascript

jquery:
	[[ -s $(STATIC_DIRECTORY)/javascript/jquery.js ]] || \
		curl http://code.jquery.com/jquery-1.8.3.js > $(STATIC_DIRECTORY)/javascript/jquery.js

static: bootstrap jquery


develop: static
	python setup.py develop

lint:
	pip install --use-mirrors flake8
	flake8 ./mailviews

clean:
	find . -name *.pyc -delete

test: clean
	python setup.py test

test-matrix: clean
	which tox >/dev/null || pip install --use-mirrors tox
	tox

test-server: develop
	python mailviews/tests/manage.py runserver

sdist: static
	python setup.py sdist

publish: lint test-matrix sdist
	git tag $$(python setup.py --version)
	git push --tags
	python setup.py upload -r disqus

.PHONY: less bootstrap jquery static develop lint clean test test-matrix test-server sdist publish
