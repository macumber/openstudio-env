#start the measure
class TestGemEnv < OpenStudio::Ruleset::ModelUserScript

  #define the name that a user will see
  def name
    return "Test Gem Env."
  end
  
  def description
    return "Test Gem Env."
  end
    
  def modeler_description
    return "Test Gem Env."
  end
  
  #define the arguments that the user will input
  def arguments(model)
    args = OpenStudio::Ruleset::OSArgumentVector.new

    return args
  end #end the arguments method

  #define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)

    #use the built-in error checking
    if not runner.validateUserArguments(arguments(model), user_arguments)
      return false
    end

    puts 'Loading Gem Info'
    
    require_relative '../../../gem_env_info.rb'
    
    puts 'Loaded Gem Info'
    
    return true

  end #end the run method

end #end the measure

#this allows the measure to be used by the application
TestGemEnv.new.registerWithApplication
