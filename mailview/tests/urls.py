from django.conf.urls.defaults import patterns, url

from mailview.tests.views import preview


urlpatterns = patterns('',
    url(regex=r'^$', view=preview),
)
