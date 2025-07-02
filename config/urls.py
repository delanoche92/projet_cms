from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import include, path
from django.views import defaults as default_views
from django.views.generic import TemplateView

# --- NOUVELLES IMPORTATIONS POUR WAGTAIL ---
from wagtail.admin import urls as wagtailadmin_urls
from wagtail import urls as wagtail_urls
from wagtail.documents import urls as wagtaildocs_urls

urlpatterns = [
    # L'ancienne page "home" est supprimée car Wagtail va la gérer.
    # On garde la page "about" comme exemple de page statique.
    path(
        "about/",
        TemplateView.as_view(template_name="pages/about.html"),
        name="about",
    ),
    # Admin de Django
    path(settings.ADMIN_URL, admin.site.urls),
    # User management
    path("users/", include("monprojet.users.urls", namespace="users")),
    path("accounts/", include("allauth.urls")),
    
    # --- URLS WAGTAIL ---
    # On met l'admin de Wagtail sur /cms/ pour éviter un conflit avec l'admin de Django.
    path("cms/", include(wagtailadmin_urls)),
    path("documents/", include(wagtaildocs_urls)),
    
    # IMPORTANT : L'URL principale de Wagtail doit être la dernière.
    # Elle "attrape" toutes les autres URLs pour afficher les pages créées dans Wagtail.
    path("", include(wagtail_urls)),
]

# La gestion des fichiers MEDIA est ajoutée ici, à la fin.
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)


if settings.DEBUG:
    # This allows the error pages to be debugged during development, just visit
    # these url in browser to see how these error pages look like.
    urlpatterns += [
        path(
            "400/",
            default_views.bad_request,
            kwargs={"exception": Exception("Bad Request!")},
        ),
        path(
            "403/",
            default_views.permission_denied,
            kwargs={"exception": Exception("Permission Denied")},
        ),
        path(
            "404/",
            default_views.page_not_found,
            kwargs={"exception": Exception("Page not Found")},
        ),
        path("500/", default_views.server_error),
    ]
    if "debug_toolbar" in settings.INSTALLED_APPS:
        import debug_toolbar

        urlpatterns = [
            path("__debug__/", include(debug_toolbar.urls)),
            *urlpatterns,
        ]
