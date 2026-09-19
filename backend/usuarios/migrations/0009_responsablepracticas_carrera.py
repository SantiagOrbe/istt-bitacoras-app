from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('gestion_academica', '0005_unique_periodo_nombre'),
        ('usuarios', '0008_responsablepracticas'),
    ]

    operations = [
        migrations.AddField(
            model_name='responsablepracticas',
            name='carrera',
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=models.SET_NULL,
                to='gestion_academica.carrera',
            ),
        ),
    ]