from wagtail import hooks
# CHEMIN D'IMPORTATION CORRECT pour Wagtail 7.0+
from wagtail.admin.viewsets.user import UserViewSet

class CustomUserViewSet(UserViewSet):
    """
    Personnalise l'affichage de la liste des utilisateurs dans l'admin de Wagtail
    pour utiliser 'name' au lieu de 'first_name'/'last_name'.
    """
    list_display = ("username", "name", "email", "is_staff", "is_superuser")
    search_fields = ("username", "name", "email")
    ordering = ("username",)

@hooks.register("register_user_viewset")
def register_custom_user_viewset():
    return CustomUserViewSet
