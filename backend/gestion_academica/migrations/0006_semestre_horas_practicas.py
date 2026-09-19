from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gestion_academica', '0005_unique_periodo_nombre'),
    ]

    operations = [
        migrations.AddField(
            model_name='semestre',
            name='horas_practicas',
            field=models.PositiveIntegerField(default=0),
        ),
    ]
