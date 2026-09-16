from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gestion_academica', '0003_rename_ciclo_semestre_and_more'),
    ]

    operations = [
        migrations.AddConstraint(
            model_name='carrera',
            constraint=models.UniqueConstraint(
                fields=('nombre',), name='unique_carrera_nombre'
            ),
        ),
        migrations.AddConstraint(
            model_name='carrera',
            constraint=models.UniqueConstraint(
                fields=('codigo_carrera',), name='unique_carrera_codigo'
            ),
        ),
        migrations.AddConstraint(
            model_name='carrera',
            constraint=models.UniqueConstraint(
                fields=('sigla_carrera',), name='unique_carrera_sigla'
            ),
        ),
        migrations.AddConstraint(
            model_name='semestre',
            constraint=models.UniqueConstraint(
                fields=('carrera', 'nombre'),
                name='unique_semestre_nombre_carrera',
            ),
        ),
        migrations.AddConstraint(
            model_name='semestre',
            constraint=models.UniqueConstraint(
                fields=('carrera', 'nivel'),
                name='unique_semestre_nivel_carrera',
            ),
        ),
        migrations.AddConstraint(
            model_name='paralelo',
            constraint=models.UniqueConstraint(
                fields=('semestre', 'nombre', 'jornada'),
                name='unique_paralelo_semestre_nombre_jornada',
            ),
        ),
    ]