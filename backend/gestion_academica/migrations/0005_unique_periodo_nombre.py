from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gestion_academica', '0004_unique_academic_entities'),
    ]

    operations = [
        migrations.AddConstraint(
            model_name='periodo',
            constraint=models.UniqueConstraint(
                fields=('nombre',), name='unique_periodo_nombre'
            ),
        ),
    ]