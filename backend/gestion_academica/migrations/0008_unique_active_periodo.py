from django.db import migrations, models
from django.db.models import Q


def keep_only_latest_active_period(apps, schema_editor):
    Periodo = apps.get_model('gestion_academica', 'Periodo')
    active_ids = list(
        Periodo.objects.filter(estado=True)
        .order_by('-fecha_inicio', '-pk')
        .values_list('pk', flat=True)
    )
    if len(active_ids) > 1:
        Periodo.objects.filter(pk__in=active_ids[1:]).update(estado=False)


class Migration(migrations.Migration):

    dependencies = [
        ('gestion_academica', '0007_alter_periodo_options'),
    ]

    operations = [
        migrations.RunPython(
            keep_only_latest_active_period,
            migrations.RunPython.noop,
        ),
        migrations.AddConstraint(
            model_name='periodo',
            constraint=models.UniqueConstraint(
                fields=('estado',),
                condition=Q(estado=True),
                name='unique_active_periodo',
            ),
        ),
    ]
