module SecretSanta
  module CLI
    def self.run
      if ARGV.empty?
        interactive = true
        puts "Enter participants in the following format:"
        puts "  Luke Skywalker <luke@theforce.net>"
        puts "enter 'Done' on a line by itself when you are done"
      end

      input_lines = []
      while input = gets
        break if input.nil? || input.chomp.downcase == "done"
        input_lines << input.chomp
      end


      begin
        matchmaker = Matchmaker.new(input_lines)

        if interactive
          puts
          puts "SECRET SANTA <EMAIL_ADDRESS> => RECIPIENT"
        end

        matchmaker.results.each { |match| puts match }

      rescue SecretSantaInputError => e
        $stderr.puts "secret_santa: #{e.message}"
        exit false
      end
    end
  end
end
