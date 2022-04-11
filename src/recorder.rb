require "json"
require_relative "./record.rb"

class Recorder
  def initialize(json_file, key)
    @file = json_file
    @key = key
    @records = nil
  end

  def list
    puts to_table
  end

  def select(idx)
    puts record_at(idx).password
  end

  def add(title, user, password)
    new_records = records.append(Record.new({ title: title, user: user, password: password }))
    self.save(new_records)
  end

  def remove(idx)
    records.delete_at(idx)
    self.save(records)
  end

  def clear
    self.save([])
  end

  def change_key(new_key)
    tmp = records
    @key = new_key
    self.save(tmp)
  end

  def to_table
    title_width = records.map { |r| r.title.length }.max
    user_width = records.map { |r| r.user.length }.max

    records.each_with_index.map { |r, i| "(#{i})#{r.format(title_width, user_width)}" }.join("\n")
  end

  def count
    records.count
  end

  private

  def record_at(id)
    records.each_with_index
      .filter { |r, i| i == id }
      .first[0]
  end

  def records
    @records ||= load
  end

  def load
    if !File.exist?(@file)
      return []
    end

    JSON.load_file(@file, symbolize_names: true)
      .map { |hash| Record.load(hash, @key) }
  end

  def reload
    @records = load
  end

  def save(new_records)
    File.open(@file, "w") do |file|
      JSON.dump(new_records.map { |r| r.to_hash(@key) }, file)
    end
    reload
  end
end
