module Fastlane
  module Actions
    module SharedValues
    end

    class UpdateProjectTeamAction < Action
      def self.run(params)
        path = params[:path]
        path = File.join(path, "project.pbxproj")
        UI.user_error!("Could not find path to project config '#{path}'. Pass the path to your project (not workspace)!") unless File.exist?(path)

        UI.message("Updating development team (#{params[:teamid]}) for the given project '#{path}'")

        p = File.read(path)
        File.write(path, p.gsub(/DevelopmentTeam = .*;/, "DevelopmentTeam = #{params[:teamid]};"))

        UI.success("Successfully updated project settings to use Developer Team ID '#{params[:teamid]}'")
      end

      def self.description
        "Update Development Team ID"
      end

      def self.details
        "This action update the Developer Team ID of your Xcode Project."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :path,
                                       env_name: "FL_PROJECT_SIGNING_PROJECT_PATH",
                                       description: "Path to your Xcode project",
                                       verify_block: proc do |value|
                                         UI.user_error!("Path is invalid") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :teamid,
                                       env_name: "FL_PROJECT_TEAM_ID",
                                       description: "The Team ID  you want to use",
                                       default_value: ENV["TEAM_ID"])
        ]
      end

      def self.author
        "lgaches"
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
