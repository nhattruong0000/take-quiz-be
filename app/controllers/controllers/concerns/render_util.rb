module RenderUtil

  def self.render_json_obj(msg, obj = {})
    return { message: msg } if obj.blank?
    return { message: msg, data: obj }
  end

end