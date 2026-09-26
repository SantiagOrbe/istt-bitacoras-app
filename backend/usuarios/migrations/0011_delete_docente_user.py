from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('usuarios', '0010_estudiante_horas_acumuladas'),
    ]

    operations = [
        migrations.DeleteModel(
            name='Docente',
        ),
    ]
