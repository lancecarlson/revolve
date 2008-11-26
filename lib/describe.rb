def describe(*args, &block)
  describe = Revolve::Describe.new(*args, &block)
  describe.evolve!
end

module Revolve
  class Instruction
    def initialize
      @instructions = []
    end
    
    def erk(*args)
      @instructions << Revolve::ERK.new(*args)
    end
  
    def methods(*args)
      args.map do |arg|
        @instructions << Revolve::Method.new(arg)
      end
    end
  
    def variables(*args)
      args.map do |arg|
        @instructions << Revolve::Variable.new(arg)
      end
    end
    alias :parameters :variables
    
    def all
      @instructions
    end
  end
  
  class Describe
    def initialize(*args, &block)
      raise ArgumentError if args.empty?
      raise ArgumentError unless block
      args << {} unless Hash === args.last
      @options = args.last
      
      @options[:population] ||= 200
      @options[:size_limit] ||= 20
      @options[:generations_limit] ||= 500
      @options[:fitness_cases] ||= cases(10, 6, 10, 34)
      @options[:error_function] ||= lambda{|cases| cases.inject{|x, y| x.abs + y.abs } }
      @options[:elitism_percent] ||= 0.35
      @options[:crossover_percent] ||= 0.45
      @options[:mutation_percent] ||= 0.1
      
      instance_eval(&block)
    end
    
    def instructions(&block)
      @instruction = Instruction.new
      @instruction.instance_eval(&block)
      @instructions = @instruction.all
    end
    
    def it(*args)
    end    
    
    def evolve!
      @population = Revolve::Population.initialized( @options[:population], {  
        :size_limit => @options[:size_limit],
        :instructions => @instructions,
        :generations_limit => @options[:generations_limit],                    
        :fitness_cases => @options[:fitness_cases],
        :error_function => @options[:error_function],
        :elitism_percent => @options[:elitism_percent],
        :crossover_percent => @options[:crossover_percent],
        :mutation_percent => @options[:mutation_percent]
      })
      
      @population.evolve!
      
      puts "Generations: #{@population.generation}"
      puts "Error: #{@population.error(@population.fittest)}"
      puts "Program:\n#{@population.fittest.inspect}"
      input = [Revolve::Argument.new(:x, 900), Revolve::Argument.new(:y, 367)]
      puts "Input: #{input}"
      puts "Output: #{@population.fittest.run(input)}"
    end
  end
end