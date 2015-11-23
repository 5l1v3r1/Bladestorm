#Bladestorm

**Easily**
* create public/private RSA keypair
* push them to servers
* use your keys to login to your servers

###Install Dependencies

    bundle

###Push your generated keys

This will push your generated keys to your servers.

      ruby Bladestorm.rb pushkey --hosts admin@192.168.1.1

Pushing to multiple servers is also allowed

      ruby Bladestorm.rb pushkey --hosts admin@192.168.1.1,admin@192.168.1.2

If you have not yet generated your keypair, this will be done right before actually pushing them to the servers. You'll be prompted for a passphrase.

###Connect to a server

connecting to a server using your generated private key can be done like this:

    ruby Bladestorm.rb connect --host admin@192.168.1.1


###Regenerate your keys

If you'd like to regenerate your keys, simply call

    ruby Bladestorm.rb regenerate

**__warning__: this will irreversibly delete your old public and private key**
