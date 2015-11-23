#!/usr/bin/env ruby

require "sshkey"
require "thor"
require 'ssh-copy-id'
require_relative 'lib/bladestormlib'

include Bladestorm


class BladestormApp < Thor

  desc 'pushkey', 'push your generated keys to a server'
  method_option :hosts, :desc => "specify the host [example: admin@127.0.0.1] (in case of multiple, delimit with ,)"
  method_option :password, :desc => "Specify password for hosts"
  def pushkey
    generate unless File.exists?("#{$PUBLIC_KEY}") && File.exists?("#{$PRIVATE_KEY}")
      SSHCopyID.grant({
          :hosts => options[:hosts] != nil ? split_hosts(options[:hosts]) : askhost,
          :password => options[:password] != nil ? options[:password] : askpassword_for_ssh,
          :output => STDOUT,
          :identity => "#{$PUBLIC_KEY}"
        })
  end

  desc 'regenerate', 'regenerate your keys'
  def regenerate
    File.delete("#{$PUBLIC_KEY}") if File.exists?("#{$PUBLIC_KEY}")
    File.delete("#{$PRIVATE_KEY}") if File.exists?("#{$PRIVATE_KEY}")
    generate
  end

  desc 'connect', 'ssh into a server using your private key'
  method_option :host, :desc => "Specify the host"
  def connect
    if File.exists?("#{$PUBLIC_KEY}") && File.exists?("#{$PRIVATE_KEY}")
      if options[:host] != nil
        puts "connecting through ssh now"
        connect_with_ssh options[:host]
      else
        puts "Please specify a host (--host=)"
      end
    else
        puts "it appears you haven't properly generated your private/public keys yet"
        generate
    end
  end
end

Dir.mkdir "#{$KEYS_FOLDER}" unless Dir.exists?("#{$KEYS_FOLDER}")
BladestormApp.start(ARGV)
