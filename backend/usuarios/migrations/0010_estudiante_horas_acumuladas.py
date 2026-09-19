from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('usuarios', '0009_responsablepracticas_carrera'),
    ]

    operations = [
        migrations.AddField(
            model_name='estudiante',
            name='horas_acumuladas',
            field=models.FloatField(default=0.0),
        ),
    ]
