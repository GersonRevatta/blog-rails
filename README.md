## Email verification (Devise) in Rails using Sendgrid/Gmail and Heroku
Esta guia supone que ya hayas instalado e inicializado devise.

Hacemos una migracion , para agregar los campos necesarios que devise  utilizara 
enviar la confirmacion al correo
Editamos el archivo user.rb en folder app/models, agregamos el modulo confirmable
```

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
end
```

Luego hacemos la migracion
``` 

rails g migration add_confirmable_to_devise
```
Agregamos esto a la migracion

```

class AddConfirmableToDevise < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :confirmation_token,   :string
    add_column :users, :confirmed_at,         :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email,    :string
    add_index  :users, :confirmation_token, :unique => true
  end

  def self.down
    remove_index  :users, :confirmation_token
    remove_column :users, :unconfirmed_email
    remove_column :users, :confirmation_sent_at
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_token
  end
end
```
Luego
```

rake db:migrate

```

Agregamos al entorno de desarrollo
```
config.action_mailer.perform_deliveries = true
config.action_mailer.raise_delivery_errors = true
```
Y esto a  config/initializers/devise.rb
```
config.reconfirmable = false
```

Creamos  config/initializers/email_setup.rb y agregamos
```
if Rails.env.development?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'localhost:3000',
    user_name:            'email',
    password:             'passwor',
    authentication:       'plain',
    enable_starttls_auto: true 
  }
elsif Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address:              'smtp.sendgrid.net',
    port:                 587,
    domain:               'heroku.com',
    user_name:            ENV["SENDGRID_USERNAME"],
    password:             ENV["SENDGRID_PASSWORD"],
    authentication:       'plain',
    enable_starttls_auto: true 
  }
end 
```
## Confirmación de correos electrónicos usando Sendgrid

Envíe correos electrónicos de confirmación en su entorno de producción a través de Sendgrid
Es muy fácil aprovisionar los complementos en heroku. Comience escribiendo el siguiente 
comando en su terminal
```
heroku addons:create sendgrid:starter
```

Por ultimo solo export los valores 
```
export SENDMAIL_PASSWORD=password
export SENDMAIL_USERNAME=xxx@gmail.com
```