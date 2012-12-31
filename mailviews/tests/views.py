

from mailviews.views import render_message_to_response
from mailviews.tests.emails import BasicEmailMessageView, BasicHTMLEmailMessageView


def preview(request):
    cls = BasicHTMLEmailMessageView if 'html' in request.GET else BasicEmailMessageView
    message = cls().render_to_message(extra_context={
    })
    return render_message_to_response(request, message)
