require "gem_dependencies_visualizer/version"

module GemDependenciesVisualizer
  def self.produce_gems_graph(string_input, graph_name = nil, options = {})
     unless string_input.nil?
      g = GraphViz::new( :G, :type => :digraph )
      g[:rankdir] ='LR'

      data = populate_gem_data string_input, options
      populate_gem_graph g, data, graph_name, options
  	 end
  end

  #########
  protected
  #########

  def self.populate_gem_data(gemfile_lock_content, options = {})
    string_array = gemfile_lock_content.gsub("\r\n", "\n").split("\n")
    gem_list_index = 0
    gem_list = {}

    string_array.each_with_index do |x, index|
      if /.*specs:.*/.match x
        gem_list_index = index + 1

        continue = true

        if options[:keep_gem_version]
          key = string_array[gem_list_index].strip
        else
          key = clear_gem_name_from_version string_array[gem_list_index]
        end
        
        values = []
        gem_list_index += 1

        while continue
          if /^    [\S]*( \(.*\))?$/.match string_array[gem_list_index]
            gem_list[key] = values

              if options[:keep_gem_version]
                key = string_array[gem_list_index].strip
              else
                key = clear_gem_name_from_version string_array[gem_list_index]
              end

            values = []
          elsif /^      [\S]*( \(.*\))?$/.match string_array[gem_list_index]
            if options[:keep_gem_version]
              value = string_array[gem_list_index].strip
            else
              value = clear_gem_name_from_version string_array[gem_list_index]
            end

            values << value
          else
            gem_list[key] = values
            continue = false
          end

          gem_list_index += 1
        end
      end
    end

    gem_list
  end

  def self.populate_gem_graph(graph, data, graph_name = nil, options = {})
    default_node = graph.add_nodes('Default', :label => "<<b>Default</b>>")

    data.each do |dependency_item|
    	graph_parent_node = graph.add_nodes(dependency_item[0], :shape => :msquare)
    	graph.add_edges(default_node, graph_parent_node)

    	dependency_item[1].each do |child_gem|
	    	graph_child_node = graph.add_nodes(child_gem, :shape => :msquare)
    		graph.add_edges(graph_parent_node, graph_child_node)
    	end
    end

    directory_name = options[:specific_directory].nil? ? 'app/assets/images/gem_dependencies_graphs' : "#{options[:specific_directory]}/gem_dependencies_graphs"

    full_path = nil
    directory_name.split('/').each do |namespace|
      if full_path.nil?
        full_path = namespace
      else
        full_path = [full_path, namespace].join('/')
      end

      FileUtils.mkdir_p(full_path) unless File.directory?(full_path)
    end

    graph.output(:png => "#{directory_name}/#{graph_name.nil? ? "graph_sample" : graph_name }.png" )
  end  

  def self.clear_gem_name_from_version(name)
    name.gsub(/ \(.*\)/, '').gsub(' ', '')
  end

  private_class_method :populate_gem_graph
  private_class_method :populate_gem_data
  private_class_method :clear_gem_name_from_version
end