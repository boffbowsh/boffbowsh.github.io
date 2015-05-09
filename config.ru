require "pathname"
require "rack"

POST_ROOT = Pathname.getwd.join("_posts")

class App
  def call(env)
    return ['405', {}, ['']] if env["REQUEST_METHOD"] != "GET"
    path = env["PATH_INFO"].sub(/^\//, '')
    p path
    POST_ROOT.children.each do |file|
      p file.basename.to_s
      if file.basename.to_s =~ /^(\d{4})-(\d{2})-(\d{2})-#{path}\.md$/
        return p(["301", {"Location" => "http://www.boffbowsh.co.uk/#$1/#$2/#$3/#{path}"}, ['']])
      end
    end
    return ["301", {"Location" => "http://www.boffbowsh.co.uk/"}, ['']]
  end
end

run App.new