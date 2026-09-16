from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('usuarios', '0007_unique_usuario_telefono'),
    ]

    operations = [
        migrations.CreateModel(
            name='ResponsablePracticas',
            fields=[
                (
                    'id',
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name='ID',
                    ),
                ),
                ('cedula', models.CharField(max_length=10)),
                (
                    'usuario',
                    models.OneToOneField(
                        on_delete=models.CASCADE,
                        to='usuarios.usuario',
                    ),
                ),
            ],
        ),
    ]