module RepoHelper
  attr_reader :all

  def find_by_id(id)
    all.find do |record|
      record.id == id
    end
  end

  def find_by_name(name)
    all.find do |record|
      record.name.casecmp?(name)
    end
  end

  def update(id, attributes)
    find_by_id(id)&.update(attributes)
  end

  def delete(id)
    all.delete(find_by_id(id))
  end

  def max_id
    all.max_by(&:id).id
  end

  def parameters
    { headers: true, header_converters: :symbol }
  end
end
