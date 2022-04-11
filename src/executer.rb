require "io/console"
require_relative "./recorder.rb"

class Executer
  def initialize
    @commands = {
      list: ->(args) { list(args) },
      select: ->(args) { select(args) },
      add: ->(args) { add(args) },
      remove: ->(args) { remove(args) },
      clear: ->(args) { clear(args) },
      change: ->(args) { change_key(args) },
    }
  end

  def exec(args)
    if args.empty?
      desc = [
        "list [-f <db-file>]\n\tShow list of all records.",
        "select <index> [-f <db-file>]\n\tSelect record by the index and print the password.",
        "add <title> <user> [-p <password>] [-f <db-file>]\n\tAdd a new record.",
        "remove <index> [-f <db-file>]\n\tRemove a record specified by the index.",
        "change <new-key> [-f <db-file>]\n\tChange the secret key.",
      ].join("\n\n")

      puts desc
      return
    end

    com = args.first.to_sym
    @commands[com].call(args[1..])
  end

  def list(args)
    file = get_file(args)
    if !File.exist?(file)
      puts "File #{file} is empty."
      return
    end

    recorder = Recorder.new(get_file(args), "")
    recorder.list
  end

  def select(args)
    recorder = init_with_key_input(args)
    return if !is_valid_key?(recorder)

    idx = args[0].to_i
    return "Invalid index." if !(0..(recorder.count - 1)).include?(idx)

    begin
      recorder.select(idx)
    rescue => e
      puts "#{e} (Input key maybe wrong)."
    end
  end

  def add(args)
    recorder = init_with_key_input(args)
    return if !is_valid_key?(recorder)

    title = args[0].to_s
    user = args[1].to_s
    password = get_option(args, "-p") || get_input("Input password: ")

    begin
      recorder.add(title, user, password)
    rescue => e
      puts "#{e} (Input key maybe wrong)."
    end
  end

  def remove(args)
    recorder = init_with_key_input(args)
    return if !is_valid_key?(recorder)
    idx = args[0].to_i
    recorder.remove(idx)
  end

  def clear(args)
    recorder = Recorder.new(get_file(args), "")
    return if !is_valid_key?(recorder)
    recorder.clear
  end

  def change_key(args)
    recorder = init_with_key_input(args)
    return if !is_valid_key?(recorder)
    new_key = get_input("Input new key: ")
    recorder.change_key(new_key)
  end

  private

  def get_option(args, option)
    idx = args.index(option)
    idx.nil? ? nil : args[idx + 1]
  end

  def default_file
    Pathname(Dir::home).join(".karon/db.json")
  end

  def get_file(args)
    get_option(args, "-f") || default_file
  end

  def get_input(msg)
    print msg
    input = STDIN.noecho(&:gets).chomp
    puts ""
    input
  end

  def is_valid_key?(recorder)
    begin
      recorder.count
      return true
    rescue => e
      puts "#{e} (Input key maybe wrong)."
      return false
    end
  end

  def init_with_key_input(args)
    key = get_option(args, "-k") || get_input("Input key: ")
    Recorder.new(get_file(args), key)
  end
end
