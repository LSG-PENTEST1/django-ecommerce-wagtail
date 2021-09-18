FROM python:3.6
LABEL maintainer="hello@wagtail.io"

ENV PYTHONUNBUFFERED 1
ENV DJANGO_ENV dev
ENV DJANGO_DB_NAME=default


COPY ./requirements.txt /code/requirements.txt
RUN pip install -r /code/requirements.txt
RUN pip install gunicorn

COPY . /code/
WORKDIR /code/

RUN python manage.py migrate
RUN python -c "import django; django.setup(); \
   from django.contrib.auth.management.commands.createsuperuser import get_user_model; \
   get_user_model()._default_manager.db_manager('$DJANGO_DB_NAME').create_superuser( \
   username='$DJANGO_SU_NAME', \
   email='$DJANGO_SU_EMAIL', \
   password='$DJANGO_SU_PASSWORD')"
RUN useradd wagtail
RUN chown -R wagtail /code
USER wagtail

EXPOSE 8000
CMD exec gunicorn snipcartwagtaildemo.wsgi:application --bind 0.0.0.0:8000 --workers 3
