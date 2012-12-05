install-less:
	npm install .

bootstrap: install-less
	git submodule update --init
	./node_modules/.bin/lessc vendor/bootstrap/less/bootstrap.less > mailviews/static/mailviews/css/bootstrap.css

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

publish: lint test-matrix
	git tag $$(python setup.py --version)
	git push --tags
	python setup.py sdist upload -r disqus

.PHONY: bootstrap clean develop lint test test-matrix test-server publish
