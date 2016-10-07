require "gem_dependencies_visualizer/version"

module GemDependenciesVisualizer
  def self.produce_gems_graph(gem_file_content, gem_file_lock_content, graph_name = nil, options = {})
     if gem_file_lock_content.nil?
      puts 'Please insert both Gemfile and Gemfile.lock contents to proceed or just Gemfile.lock content.'
     else
      g = GraphViz::new( :G, :type => :digraph )
      g[:rankdir] = rankdir(options)

      data = populate_gem_data gem_file_content, gem_file_lock_content, options
      populate_gem_graph g, data, graph_name, options
  	 end
  end

  #########
  protected
  #########

  def self.rankdir(options = {})
    case options[:graph_direction]
      when 'top-bottom' then 'TB'
      when 'bottom-top' then 'BT'
      when 'right-left' then 'RL'
      else 'LR'
    end
  end

  def self.collect_gems_from_gemfile(gem_file_content, options = {})
    unless gem_file_content.nil?
      (gem_file_content.scan /.*gem ['"](\S*)['"]/).flatten.uniq.sort
    end
  end

  def self.collect_gems_from_gemfile_lock(gem_file_lock_content, options = {})
    string_array = gem_file_lock_content.gsub("\r\n", "\n").split("\n")
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

  def self.populate_gem_data(gem_file_content, gemfile_lock_content, options = {})
    gem_dependencies = collect_gems_from_gemfile_lock gemfile_lock_content, options
    gems = collect_gems_from_gemfile gem_file_content, options

    {
      :gems => gems,
      :gem_dependencies => gem_dependencies
    }
  end

  def self.populate_gem_graph(graph, data, graph_name = nil, options = {})
    unless data[:gems].empty?
       default_node = graph.add_nodes('Default', :label => "<<b>Default</b>>", :color => 'dodgerblue3')

      data[:gems].each do |gem|
        new_node = graph.add_nodes(gem, :shape => :msquare, :color => 'firebrick3')
        graph.add_edges(default_node, new_node, :color => 'dodgerblue3')
      end
    end

    data[:gem_dependencies].sort_by { |dependency_item| dependency_item[0] }.each do |dependency_item|
    	graph_parent_node = graph.add_nodes(dependency_item[0], :shape => :msquare, :color => 'firebrick3')

    	dependency_item[1].each do |child_gem|
	    	graph_child_node = graph.add_nodes(child_gem, :shape => :msquare)
    		graph.add_edges(graph_parent_node, graph_child_node, :color => 'firebrick3')
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
  private_class_method :rankdir
  private_class_method :collect_gems_from_gemfile
  private_class_method :collect_gems_from_gemfile_lock
end