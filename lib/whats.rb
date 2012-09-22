require 'duck_duck_go'
require 'tempfile'
require 'paint'
require 'cgi'

module Whats
  def self.new(*params) 
    Whats::Main.new(*params) 
  end

  # Show an image using libcaca's img2txt.
  # TODO use the pure ruby API to libcaca
  # TODO use the pure ruby API to wget
  def Whats.show_image(url, options='')
    tmp = Tempfile.new('Whats-')
    `wget '#{url}' -q -O #{tmp.path}`
    output = `img2txt -f ansi #{options} #{tmp.path} 2>/dev/null`
    return output unless output.strip == '' 
    return ''
  end

  # Display a citation
  def Whats.cite(source, url)
    output += Paint["(via #{source})", :italic, :bold] unless source.nil?
    output += Paint["(#{url})", :italic]  unless url.nil?
    return output
  end

  # Create a new instance of something we want to learn more about
  class Main
    
    # Create a new instance.  You've gotta search for something
    def initialize(query)
      @info = DuckDuckGo.new.zeroclickinfo query
      if @info.heading.nil? then throw :unknown end
    end
    
    # Paint the heading
    def heading
      Paint[@info.heading, :bold, :underline]
    end

    # Is there an image?
    def image?
      return not(@info.image.nil?)
    end

    # Get the image
    def image
      Whats::show_image @info.image
    end

    # Is there an abstract? This may cause you to fight a bigger snake.
    def abstract?
      return not(@info.abstract_text.nil?)
    end

    # Get the abstract
    def abstract
      output = ''
      output += "#{@info.abstract_text} " unless @info.abstract_text.nil?
      output += Whats::cite(@info.abstract_source, @info.abstract_url)
      return output
    end

    # Is there an answer? Yes. 
    # You mean there is an answer; a simple answer; to life… the universe and… everything?  Yes…
    # …but I'm not sure you're going to like it.
    def answer?
      return not(@info.answer.nil?)
    end

    # BUT WE MUST KNOW! Okay…
    # …you're really not going to like it.
    # WE MUST KNOW. TELL US THE ANSWER.
    # …alright. The answer to life, the universe, and everything is… 
    # YES! is…
    # 42.
    def answer
      return CGI.unescapeHTML(@info.answer)
    end

    # Is there a definition?
    def definition?
      return not(@info.definition.nil?)
    end

    # Get the definition
    def definition
      output = ''
      output += "#{@info.definition} " unless @info.definition.nil?
      output += Whats::cite(@info.definition_source, @info.definition_url)
    end

    # Are there any related topics
    def related_topics?
      return @info.related_topics['_'].length > 0
    end

    # Get any related topics
    def related_topics
      output = ''
      @info.related_topics['_'].each do |topic|
        output += "#{topic.text} #{Whats::cite(nil, topic.first_url)}\n" unless topic.text.nil?
        output += Whats::show_image(topic.icon.url)
      end
      output += "\n\n"
      return output
    end

    # Are there any results
    def results?
      return @info.results.length > 0
    end

    # Get any results
    def results
      output = ''
      @info.results.each do |topic|
        output += "#{result.text} #{Whats::cite(nil, result.first_url)}\n" unless result.text.nil?
        output += Whats::show_image(result.icon.url)
      end
      output += "\n\n"
      return output
    end
  end
end
