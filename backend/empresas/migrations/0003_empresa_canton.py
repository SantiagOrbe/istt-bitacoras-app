from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('empresas', '0002_empresa_latitud_empresa_longitud_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='empresa',
            name='canton',
            field=models.CharField(blank=True, default='', max_length=100),
        ),                                                  
    ]
