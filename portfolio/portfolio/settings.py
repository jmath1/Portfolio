"""
Django settings for portfolio project.

Generated by 'django-admin startproject' using Django 4.2.5.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/4.2/ref/settings/
"""

from pathlib import Path
import os
import boto3

if os.getenv("CLOUD"):
    def get_secret(secret_name):
        client = boto3.client("secretsmanager", region_name="us-east-1")
        try:
            get_secret_value_response = client.get_secret_value(SecretId=secret_name)
            secret = get_secret_value_response.get("SecretString")
            if secret:
                return secret
            else:
                raise ValueError(f"{secret_name} not found")
        except Exception as e:
            print(f"Error retrieving secret {secret_name}: {e}")
            return None

    os.environ["DB_NAME"] = get_secret("DB_NAME")
    os.environ["DB_USER"] = get_secret("DB_USER")
    os.environ["DB_PASSWORD"] = get_secret("DB_PASSWORD")
    os.environ["DB_HOST"] = get_secret("DB_HOST")
    os.environ["DB_PORT"] = get_secret("DB_PORT")
    os.environ["DJANGO_SECRET_KEY"] = get_secret("SECRET_KEY")
    os.environ["AWS_STORAGE_BUCKET_ARN"] = get_secret("S3_BUCKET_ARN")

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/

if os.getenv("CLOUD"):
    SECRET_KEY = os.getenv("DJANGO_SECRET_KEY")
else:
    SECRET_KEY = "django-insecure-5xf)*@17^bugaadsfdf09m0)6sp!1_t-1ey^f$7j!52=ms3n*w"

if os.getenv("CLOUD"):
    #DEBUG = False
    DEBUG = True
else:
    DEBUG = True

if os.getenv("CLOUD"):
    ALLOWED_HOSTS = [get_secret("ALLOWED_HOST"), get_secret("PRIVATE_IP")]
    CSRF_TRUSTED_ORIGINS = [
        f"https://{get_secret('ALLOWED_HOST')}",
    ]
else:
    ALLOWED_HOSTS = ["web", "0.0.0.0", "localhost", "127.0.0.1"]


INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "core",
    "storages",
    "colorfield",
    "rest_framework",
    "corsheaders",
]

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "portfolio.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / "templates"],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "portfolio.wsgi.application"


# Database
# https://docs.djangoproject.com/en/4.2/ref/settings/#databases

if os.getenv("CLOUD"):
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.postgresql",
            "NAME": os.getenv("DB_NAME"),
            "USER": os.getenv("DB_USER"),
            "PASSWORD": os.getenv("DB_PASSWORD"),
            "HOST": os.getenv("DB_HOST"),
            "PORT": os.getenv("DB_PORT", "5432"),
        }
    }
    CORS_ALLOWED_ORIGINS = CSRF_TRUSTED_ORIGINS
    if DEBUG:
        CORS_ALLOWED_ORIGINS = [
            "http://localhost:3000",
            "http://0.0.0.0:3000",
        ]
else:
    CORS_ALLOWED_ORIGINS = [
        "http://localhost:3000",
        "http://0.0.0.0:3000",
    ]
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": BASE_DIR / "db.sqlite3",
        }
    }

# Password validation
# https://docs.djangoproject.com/en/4.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]


# Internationalization
# https://docs.djangoproject.com/en/4.2/topics/i18n/

LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.2/howto/static-files/


# Default primary key field type
# https://docs.djangoproject.com/en/4.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

if os.getenv("CLOUD"):
    AWS_S3_BUCKET_NAME = os.getenv("AWS_STORAGE_BUCKET_ARN").split(":")[-1]
    STORAGES = {
        "default": {
            "BACKEND": "storages.backends.s3.S3Storage",

        },
        "staticfiles": {
            "BACKEND": "storages.backends.s3boto3.S3Boto3Storage",
            "OPTIONS": {
                "bucket_name": AWS_S3_BUCKET_NAME,
                "region_name": 'us-east-1',
                "location": "static",
            },
        },
    }
    
    # Static files
    STATICFILES_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
    STATIC_URL = f'https://{AWS_S3_BUCKET_NAME}.s3.amazonaws.com/static/'

    # Media files
    DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
    MEDIA_URL = f'https://{AWS_S3_BUCKET_NAME}.s3.amazonaws.com/media/'
    
else:
    STATIC_ROOT = BASE_DIR / "static"
    STATIC_URL = "static/"
    MEDIA_URL = "media/"
    MEDIA_ROOT = BASE_DIR / "media"

