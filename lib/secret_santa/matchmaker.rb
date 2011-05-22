module SecretSanta
  class Participant
    attr_reader :fname, :lname, :email
    attr_accessor :target

    def initialize(input)
      raw = input.squeeze(' ')
      @fname,@lname,raw_email = raw.split
      if @fname.nil? || @lname.nil? || raw_email.nil?
        raise SecretSantaInputError, "Participants must be entered in the following format: FIRST_NAME LAST_NAME <EMAIL_ADDRESS>"
      end
      @email = raw_email.match(/^<(.*)>$/)[1]
    end

    def matches_with?(other)
      lname != other.lname
    end

    def to_s
      "#{fname} #{lname} <#{email}> => #{target.fname} #{target.lname}"
    end
  end

  class Matchmaker
    def initialize(in_lines)
      @participants = process_input(in_lines)
      @shuffled = @participants.shuffle
      pick_matches
    end

    def results
      @participants
    end

    private
    def process_input(input)
      raise SecretSantaInputError, "Input needs to be an Array of Strings" unless input.instance_of?(Array)
      raise SecretSantaInputError, "Input needs to be an Array of Strings" unless input.reject { |line| line.instance_of?(String) }.empty?

      filtered = input.reject { |line| line =~/^\s*$/ }
      raise SecretSantaInputError, "Input needs at least 2 entries" if filtered.count < 2

      processed = filtered.map { |line| Participant.new(line) }
      names = processed.map { |p| p.fname + p.lname }.uniq
      raise SecretSantaInputError, "Each unique name may only be entered once" if processed.count > names.count 

      return processed
    end

    def pick_matches
      @participants.each_with_index { |p,i| p.target = @shuffled[i] }
      @participants.each do |p|
        unless p.target.matches_with? p
          potentials = @participants.select do |potential|
            potential.target.matches_with?(p) && p.target.matches_with?(potential)
          end
          raise SecretSantaInputError, "No potential matches found for #{p.fname} #{p.lname}" if potentials.empty?
          potentials.shuffle!
          swapper = potentials.first
          p.target, swapper.target = swapper.target, p.target
        end
      end
    end
  end
  
  class SecretSantaInputError < StandardError
  end
end
