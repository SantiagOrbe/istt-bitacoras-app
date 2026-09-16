from django.db import migrations, models
from django.db.models import Q


def clear_duplicate_phones(apps, schema_editor):
    Usuario = apps.get_model('usuarios', 'Usuario')
    duplicated_phones = (
        Usuario.objects.exclude(telefono='')
        .values('telefono')
        .annotate(total=models.Count('id'))
        .filter(total__gt=1)
    )
    for item in duplicated_phones:
        users = Usuario.objects.filter(
            telefono=item['telefono']
        ).order_by('id')
        users.exclude(pk=users.first().pk).update(telefono='')


def restore_duplicate_phones(apps, schema_editor):
    pass


class Migration(migrations.Migration):

    dependencies = [
        ('usuarios', '0006_tutoracademico_carrera'),
    ]

    operations = [
        migrations.RunPython(clear_duplicate_phones, restore_duplicate_phones),
        migrations.AddConstraint(
            model_name='usuario',
            constraint=models.UniqueConstraint(
                condition=~Q(telefono=''),
                fields=('telefono',),
                name='unique_usuario_telefono',
            ),
        ),
    ]