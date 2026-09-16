from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('gestion_academica', '0003_rename_ciclo_semestre_and_more'),
        ('usuarios', '0005_coordinador_carrera'),
    ]

    operations = [
        migrations.AddField(
            model_name='tutoracademico',
            name='carrera',
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.SET_NULL,
                to='gestion_academica.carrera',
            ),
        ),
    ]