#!/usr/bin/env ruby

module Bladestorm

  $KEYS_FOLDER = 'keys'
  $PUBLIC_KEY = 'keys/id_rsa.pub'
  $PRIVATE_KEY = 'keys/id_rsa'

  def generate
    puts 'Creating keypair now'
    new_key = SSHKey.generate(:passphrase => askpassword_for_certificate)
    IO.write("#{$PUBLIC_KEY}", new_key.ssh_public_key)
    puts "public key was written to #{$PUBLIC_KEY}"
    IO.write("#{$PRIVATE_KEY}", new_key.private_key)
    File.chmod(0700, "#{$PRIVATE_KEY}")
    puts "private key was written to #{$PRIVATE_KEY}"
  end

  def connect_with_ssh(host)
    exec("ssh -i #{$PRIVATE_KEY} #{host}")
  end

  private

  def askpassword_for_certificate
    puts "Please enter a passphrase for your certificate"
    STDIN.gets.chomp
  end

  def askpassword_for_ssh
    puts "Please enter the password for the ssh server"
    STDIN.gets.chomp
  end

  def askhost
    puts "Please enter a host to push your key to [example: admin@127.0.0.1]"
    split_hosts(STDIN.gets.chomp)
  end

  def split_hosts(hosts)
    hosts.split(",").map { |host|
       host.to_s
    }
  end

  def which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      exts.each { |ext|
        exe = File.join(path, "#{cmd}#{ext}")
        return exe if File.executable?(exe) && !File.directory?(exe)
      }
    end
    return nil
  end

  def command_exists?(cmd)
    which(cmd) != nil
  end


end
