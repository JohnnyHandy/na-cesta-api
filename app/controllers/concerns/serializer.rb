module Serializer
  extend ActiveSupport::Concern

  protected
  def error_serializer(errors, *opts)
    return if errors.nil?

    json = {}
    new_hash = errors.to_hash(true).map do |k, v|
      v.map do |msg|
        { id: k, title: msg }
      end
    end.flatten
    json[:errors] = new_hash
    render json: json,  status: opts.first.dig(:status)
  end

  def serializer(resource, instance, *opts)
    # resource = ProductResource
    serializer = JSONAPI::ResourceSerializer.new(resource, include: opts&.first&.dig(:include)||[''])
    resource_instance = resource.new(instance, {})
    as_json = serializer.object_hash(resource_instance, {})
    render :json => { :data => as_json }, status: opts.first.dig(:status)
  end


  def json_resources(klass, records, ids, *opts)
    resources = []
    resource_set = get_resource_set(ids)
    resource_set.populate!(JSONAPI::ResourceSerializer.new(klass), nil, include: opts&.first&.dig(:include)||[''])
    if ids.is_a?(Array)
      p "PAGINATION \n #{opts&.first&.dig(:pagination)}"
      puts "RESOURCE SERIALIZER \n #{}"
      {**JSONAPI::ResourceSerializer.new(klass).serialize_resource_set_to_hash_plural(resource_set), pagination: opts&.first&.dig(:pagination)}
     else
      JSONAPI::ResourceSerializer.new(klass).serialize_resource_set_to_hash_single(resource_set)
     end
  end

  def get_resource_set(ids)
    id_tree = JSONAPI::PrimaryResourceIdTree.new
    directives = JSONAPI::IncludeDirectives.new(resource_klass, ['']).include_directives
    Array(ids).each do |id|
      identity = JSONAPI::ResourceIdentity.new(resource_klass, id)
      fragment = JSONAPI::ResourceFragment.new(identity)
       id_tree.add_resource_fragment(fragment, directives[:include_related])
     end
     JSONAPI::ResourceSet.new(id_tree)
   end
end