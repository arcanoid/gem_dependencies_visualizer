require "gem_dependencies_visualizer/version"

module GemDependenciesVisualizer
  def self.produce_gems_graph(string_input, graph_name = nil)
     unless string_input.nil?
      g = GraphViz::new( :G, :type => :digraph )

      data = populate_gem_data string_input
      populate_gem_graph g, data, graph_name
  	 end
  end

  #########
  protected
  #########

  def self.populate_gem_data(gemfile_lock_content)
    string_array = gemfile_lock_content.split("\n")
    gem_list_index = 0

    string_array.each_with_index do |x, index|
      if /.*GEM.*/.match x
        gem_list_index = index + 3
        break
      end
    end

    continue = true
    gem_list = {}
      key = string_array[gem_list_index].gsub(/ \(.*\)/, '').gsub(' ', '')
      values = []
      gem_list_index += 1

    while continue
      if /^    [\S]* \(.*\)$/.match string_array[gem_list_index]
        gem_list[key] = values
        key = string_array[gem_list_index].gsub(/ \(.*\)/, '').gsub(' ', '')
        values = []
      elsif /^      [\S]* \(.*\)$/.match string_array[gem_list_index]
        values << string_array[gem_list_index].gsub(/ \(.*\)/, '').gsub(' ', '')
      else
        continue = false
      end

      gem_list_index += 1
    end

    gem_list
  end

  def self.populate_gem_graph(graph, data, graph_name = nil)
    default_node = graph.add_nodes('Default', :label => "<<b>Default</b>>")

    data.each do |dependency_item|
    	graph_parent_node = graph.add_nodes(dependency_item[0], :shape => :msquare)
    	graph.add_edges(default_node, graph_parent_node)

    	dependency_item[1].each do |child_gem|
	    	graph_child_node = graph.add_nodes(child_gem, :shape => :msquare)
    		graph.add_edges(graph_parent_node, graph_child_node)
    	end
    end

    directory_name = 'app/assets/images/gem_dependencies_graphs'
    FileUtils.mkdir_p('app') unless File.directory?('app')
    FileUtils.mkdir_p('app/assets') unless File.directory?('app/assets')
    FileUtils.mkdir_p('app/assets/images') unless File.directory?('app/assets/images')
    FileUtils.mkdir_p(directory_name) unless File.directory?(directory_name)
    graph.output(:png => "#{directory_name}/#{graph_name.nil? ? "graph_sample" : graph_name }.png" )
  end  

  private_class_method :populate_gem_graph
  private_class_method :populate_gem_data
end