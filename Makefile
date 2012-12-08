install-less:
	npm install .

bootstrap: install-less
	git submodule update --init
	./node_modules/.bin/lessc vendor/bootstrap/less/bootstrap.less > mailviews/static/mailviews/css/bootstrap.css
	cp vendor/bootstrap/js/bootstrap-*.js mailviews/static/mailviews/javascript

develop: bootstrap
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

sdist: bootstrap
	python setup.py sdist

publish: lint test-matrix sdist
	git tag $$(python setup.py --version)
	git push --tags
	python setup.py upload -r disqus

.PHONY: bootstrap clean develop lint test test-matrix test-server publish sdist
